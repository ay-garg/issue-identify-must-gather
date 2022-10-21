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
	elif ! [ -x "$(command -v jq)" ]
	then
		echo 'Error: jq command not found!' >&2
		echo 'Visit "https://stedolan.github.io/jq/download" for install instructions.'
		exit 1
	elif ! [ -x "$(command -v column)" ]
	then
		echo 'Error: column command not found!' >&2
		echo '"util-linux" package needs to be installed for Red Hat based Linux Distributions.'
		echo '"bsdmainutils" package needs to be installed for Debian based Linux Distributions.'
		exit 1
	else
		rm -f ~/.omgconfig && omg use ${MUSTGATHER}
		echo -e "\n"
	fi
}


### Degraded nodes status
function DegradedNodes {
    omg get nodes -o wide| grep -i 'NotReady\|SchedulingDisabled'
}

### Degraded node description
function DegradedNodesDescription {
	DegradedNodesName=$(omg get nodes | grep -i 'NotReady\|SchedulingDisabled' | awk '{ print $1 }' | tr '\n' ' ')
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
}


### machine-config-daemon pod status for degraded nodes
function MCDPodStatus {
	DegradedNodesName=$(omg get nodes | grep -i 'NotReady\|SchedulingDisabled' | awk '{ print "\\|" $1 }' | tr '\n' ' ' | sed "s/ //g" | sed 's/^.//' | sed 's/^.//')
		omg get pod -o wide -n openshift-machine-config-operator | grep -i $DegradedNodesName
}


### machine-config-daemon pod logs for degraded nodes
function MCDPodLogs {
	DegradedNodesName=$(omg get nodes | grep -i 'NotReady\|SchedulingDisabled' | awk '{ print $1 }' | tr '\n' ' ')
	for i in $(echo $DegradedNodesName); do
		MCDPods=$(omg get pod -o wide -n openshift-machine-config-operator | grep -i $i | awk '{ print $1 }')
		if [ -f $MUSTGATHER/*/namespaces/openshift-machine-config-operator/pods/$MCDPods/machine-config-daemon/machine-config-daemon/logs/current.log ];
		then
			echo -e "\n${PURPLE}***$MCDPods***\n${REGULAR}"
			cat $MUSTGATHER/*/namespaces/openshift-machine-config-operator/pods/$MCDPods/machine-config-daemon/machine-config-daemon/logs/current.log | tail -n 15
		else
			echo -e "\n***${BOLD}$MCDPods logs not found***\n${REGULAR}"
		fi
	done
}

function title {
	echo -e "\n${BOLD}${RED}----------${1}----------\n${REGULAR}"
}

function main {

	validate

	title "Degraded Nodes"
	DegradedNodes

	title "Description of Degraded Nodes"
	DegradedNodesDescription

	title "machine-config-daemon pod status for degraded nodes"
	MCDPodStatus

	title "machine-config-daemon pod logs for degraded nodes"
	MCDPodLogs

}

main