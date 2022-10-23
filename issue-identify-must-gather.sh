#!/bin/bash
#
# NAME
#    issue-identify script for cluster must-gather
#
#
# Description
#    This script analyze the must-gather to identify the issues.


BOLD=$(tput bold)
REGULAR=$(tput sgr0)
RED='\033[0;31m'
PURPLE='\033[0;35m'
MUSTGATHER=${1}
ARGS=${#}

function validate {

	if [ ${ARGS} -eq 0 ]
	then
		echo "No must-gather supplied!"
		echo "USAGE: $0 <must-gather-directory>"
		exit 1
	elif [ ${ARGS} -gt 1 ]
	then
		echo "Only must-gather should be provided!"
		echo "USAGE: $0 <must-gather-directory>"
		exit 1
	elif ! [ -x "$(command -v omg)" ]
	then
		echo 'Error: omg command not found!' >&2
		echo 'Visit "https://pypi.org/project/o-must-gather" for install instructions.'
		exit 1
	else
		rm -f ~/.omgconfig && omg use ${MUSTGATHER}
		echo -e "\n"
	fi

}


### fetch clusterversion details
function clusterversion {

	omg get clusterversion 2> /dev/null
}


### Degraded operators
function DegradedOperators {

	DegradedOperatorsNames=$(omg get co 2> /dev/null | awk '$3!="True"||$4!="False"||$5!="False"')
	LineCount=$(echo "$DegradedOperatorsNames" | wc -l)
	if [ $LineCount -eq 1 ];
	then
		echo -e "\n${PURPLE}All cluster operators are working fine!\n${REGULAR}"
	else
		echo "$DegradedOperatorsNames"
	fi

}


### Degraded operators description
function DegradedOperatorsDescription {

	DegradedOperatorsNamesOneLine=$(omg get co 2> /dev/null | awk '$3!="True"||$4!="False"||$5!="False"' | awk '{ print $1 }' | grep -Ev NAME)
	if [ -z "$DegradedOperatorsNamesOneLine" ]
	then
		echo -e "\n${PURPLE}Not required as all operators are available!\n${REGULAR}"
	else
		for i in $(echo $DegradedOperatorsNamesOneLine); do
			echo -e "\n${PURPLE}***$i operator description***\n${REGULAR}"
			omg get co $i -o yaml 2> /dev/null
		done
	fi

}


### Degraded MCPs
function DegradedMCP {

	DegradedMCP=$(omg get mcp 2> /dev/null | awk '$3!="True"||$4!="False"||$5!="False"')
	LineCount=$(echo "$DegradedMCP" | wc -l)
	if [ $LineCount -eq 1 ];
	then
		echo -e "\n${PURPLE}No machine-config-pool degraded!\n${REGULAR}"
	else
		echo "$DegradedMCP"
	fi

}


### Degraded MCPs description
function DegradedMCPDescription {

	DegradedMCPDescription=$(omg get mcp 2> /dev/null | awk '$3!="True"||$4!="False"||$5!="False"' | awk '{ print $1 }' | grep -Ev NAME)
	if [ -z "$DegradedMCPDescription" ]
	then
		echo -e "\n${PURPLE}Not required as all machine-config-pool are available!\n${REGULAR}"
	else
		for i in $(echo $DegradedMCPDescription); do
			echo -e "\n${PURPLE}***$i machine-config-pool description***\n${REGULAR}"
			omg get mcp $i -o yaml 2> /dev/null
		done
	fi

}


### Degraded nodes status
function DegradedNodes {

	DegradedNodesNames=$(omg get nodes -o wide 2> /dev/null | awk '$2!="Ready"')
	LineCount=$(echo "$DegradedNodesNames" | wc -l)
	if [ $LineCount -eq 1 ];
	then
		echo -e "\n${PURPLE}All nodes are in Ready state!\n${REGULAR}"
	else
		echo "$DegradedNodesNames"
	fi

}


### Degraded node description
function DegradedNodesDescription {

	DegradedNodesName=$(omg get nodes 2> /dev/null | grep -i 'NotReady\|SchedulingDisabled' | awk '{ print $1 }' | tr '\n' ' ')
	if [ -z "$DegradedNodesName" ];
	then
		echo -e "\n${PURPLE}Not required as all nodes are in Ready state!\n${REGULAR}"
	else
		for i in $(echo $DegradedNodesName); do
			if [ -f $MUSTGATHER/*/cluster-scoped-resources/core/nodes/$i.yaml ];
			then
				echo -e "\n${PURPLE}***$i***\n${REGULAR}"
				cat $MUSTGATHER/*/cluster-scoped-resources/core/nodes/$i.yaml | sed -n '/apiVersion/,/daemonEndpoints/{ //!p }'
				cat $MUSTGATHER/*/cluster-scoped-resources/core/nodes/$i.yaml | sed -n '/nodeInfo/,$p'
			else
				echo -e "\n***${BOLD}$i node description not found***\n${REGULAR}"
			fi
		done
	fi

}


### pods not in Running or Succeeded state
function pods {

	Pods=$(omg get pod -o wide -A 2> /dev/null | grep -Ev 'Running|Succeeded')
	LineCount=$(echo "$Pods" | wc -l)
	if [ $LineCount -eq 1 ];
	then
		echo -e "\n${PURPLE}All pods are in Running state!\n${REGULAR}"
	else
		echo "$Pods"
	fi

}


### machine-config-daemon pod logs for degraded nodes
function MCDPodLogs {

	DegradedNodesName=$(omg get nodes 2> /dev/null | grep -i 'NotReady\|SchedulingDisabled' | awk '{ print $1 }' | tr '\n' ' ')
	if [ -z "$DegradedNodesName" ];
	then
		echo -e "\n${PURPLE}Not required as all nodes are in Ready state!\n${REGULAR}"
	else
		for i in $(echo $DegradedNodesName); do
			MCDPods=$(omg get pod -o wide -n openshift-machine-config-operator 2> /dev/null | grep -i $i | awk '{ print $1 }')
			if [ -f $MUSTGATHER/*/namespaces/openshift-machine-config-operator/pods/$MCDPods/machine-config-daemon/machine-config-daemon/logs/current.log ] && [ -s $MUSTGATHER/*/namespaces/openshift-machine-config-operator/pods/$MCDPods/machine-config-daemon/machine-config-daemon/logs/current.log ];
			then
				echo -e "\n${PURPLE}***$MCDPods pod logs for degraded $i node***\n${REGULAR}"
				cat $MUSTGATHER/*/namespaces/openshift-machine-config-operator/pods/$MCDPods/machine-config-daemon/machine-config-daemon/logs/current.log | tail -n 15
			else
				echo -e "\n${PURPLE}***$MCDPods pod logs not found for degraded $i node***\n${REGULAR}"
			fi
		done
	fi

}


function title {

	echo -e "\n${BOLD}${RED}----------${1}----------\n${REGULAR}"

}


function main {

	validate

	title "ClusterVersion Details"
	clusterversion

	title "Degraded Operators"
	DegradedOperators

	title "Degraded Operators Description"
	DegradedOperatorsDescription

	title "Degraded machine-config-pool"
	DegradedMCP

	title "Degraded machine-config-pool description"
	DegradedMCPDescription

	title "Degraded Nodes"
	DegradedNodes

	title "Description of Degraded Nodes"
	DegradedNodesDescription

	title "Pods not in Running state"
	pods

	title "machine-config-daemon pod logs for degraded nodes"
	MCDPodLogs
	
}

main