# issue-identify-must-gather
This script analyze the OpenShift 4 must-gather to identify the issues.

## The shell script fetches following data from the must-gather.
- clusterversion
- Degraded Operators
- Description of Degraded Operators
- Degraded machine-config-pool
- Description of Degraded machine-config-pool
- Degraded Nodes
- Description of Degraded Nodes
- Pods not in Running state
- machine-config-daemon pod logs for degraded nodes

## Prerequisites
```
- Cluster must-gather
- "o-must-gather" python module installed for "omg" command.
```
## How to use the shell script?
```
// The below command download the shell script at path "/usr/local/bin/must-gather-analysis", sets the execute permission and reloads the current shell.
$ sudo curl -o /usr/local/bin/issue-identify-must-gather https://raw.githubusercontent.com/ayush-garg-github/issue-identify-must-gather/main/issue-identify-must-gather.sh && sudo chmod +x /usr/local/bin/issue-identify-must-gather && $SHELL

// Shell script can be executed by running "must-gather-analysis" for the specified must-gather.
$ issue-identify-must-gather.sh <path-to-must-gather-dir>
```
