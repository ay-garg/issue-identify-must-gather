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
$ sudo curl -o /usr/local/bin/issue-identify-must-gather https://raw.githubusercontent.com/ayush-garg-github/issue-identify-must-gather/main/issue-identify-must-gather.sh && sudo chmod +x /usr/local/bin/issue-identify-must-gather && $SHELL && exit

// Shell script can be executed by running "must-gather-analysis" for the specified must-gather.
$ issue-identify-must-gather.sh <path-to-must-gather-dir>

// All the sensitive data is masked in the below script output for security reasons.
$ issue-identify-must-gather ./must-gather/must-gather.local.39xxxxxxxxxxxx/
Using:  /home/root/test/must-gather/must-gather.local.39xxxxxxxxxxxx/quay-io-openshift-release-dev-ocp-v4-0-art-dev-sha256-4922dxxxxxxxxxxxxxxxxxxxxxxxxxxxxx



----------ClusterVersion Details----------

NAME     VERSION  AVAILABLE  PROGRESSING  SINCE  STATUS
version  4.8.36   True       False        30m    Error while reconciling 4.8.36: the cluster operator network is degraded

----------Degraded Operators----------

NAME                                      VERSION  AVAILABLE  PROGRESSING  DEGRADED  SINCE
dns                                       4.8.36   True       True         False     48m
machine-config                            4.8.36   False      False        True      38m
monitoring                                4.8.36   False      True         True      32m
network                                   4.8.36   True       True         True      37m

----------Degraded Operators Description----------


***dns operator description***

apiVersion: config.openshift.io/v1
kind: ClusterOperator
metadata:
  annotations:
    include.release.openshift.io/ibm-cloud-managed: 'true'
    include.release.openshift.io/self-managed-high-availability: 'true'
    include.release.openshift.io/single-node-developer: 'true'
  creationTimestamp: '2022-05-28T07:09:34Z'
  generation: 1
  name: dns
  resourceVersion: '83207385'
  uid: d696a62d-7e44-438f-a6ab-05df6eaca456
spec: {}
status:
  conditions:
  - lastTransitionTime: '2022-05-28T07:19:29Z'
    message: DNS "default" is available.
    reason: AsExpected
    status: 'True'
    type: Available
  - lastTransitionTime: '2022-09-26T09:54:55Z'
    message: 'DNS "default" reports Progressing=True: "Have 11 available node-resolver
      pods, want 12."'
    reason: DNSReportsProgressingIsTrue
    status: 'True'
    type: Progressing
  - lastTransitionTime: '2022-09-15T12:46:41Z'
    reason: DNSNotDegraded
    status: 'False'
    type: Degraded
  extension: null
  relatedObjects:
  - group: ''
    name: openshift-dns-operator
    resource: namespaces
  - group: operator.openshift.io
    name: default
    resource: dnses
  - group: ''
    name: openshift-dns
    resource: namespaces
  versions:
  - name: operator
    version: 4.8.36
  - name: coredns
    version: quay.io/openshift-release-dev/ocp-v4.0-art-dev@sha256:c9d9cf0ee2e1fa1312ebd0915e22bba0cc8e8d05852eba431d44ce1652355a34
  - name: openshift-cli
    version: quay.io/openshift-release-dev/ocp-v4.0-art-dev@sha256:7c06cfdba0ba61fa95e37483fe9ba62a71074dfe21b2aacfe983c781a4e963e7
  - name: kube-rbac-proxy
    version: quay.io/openshift-release-dev/ocp-v4.0-art-dev@sha256:7a8b4b60345cff84089835a561b4b65c5eccb4585283314c90ce2108c063c87d


***machine-config operator description***

apiVersion: config.openshift.io/v1
kind: ClusterOperator
metadata:
  annotations:
    exclude.release.openshift.io/internal-openshift-hosted: 'true'
    include.release.openshift.io/self-managed-high-availability: 'true'
    include.release.openshift.io/single-node-developer: 'true'
  creationTimestamp: '2022-05-28T07:09:34Z'
  generation: 1
  name: machine-config
  resourceVersion: '83225390'
  uid: a22ca94d-e992-46c6-bb93-ce76aa9febb0
spec: {}
status:
  conditions:
  - lastTransitionTime: '2022-05-28T16:42:40Z'
    message: Cluster version is 4.8.36
    status: 'False'
    type: Progressing
  - lastTransitionTime: '2022-09-26T10:04:55Z'
    message: One or more machine config pools are updating, please see `oc get mcp`
      for further details
    reason: PoolUpdating
    status: 'False'
    type: Upgradeable
  - lastTransitionTime: '2022-09-26T10:04:55Z'
    message: 'Failed to resync 4.8.36 because: timed out waiting for the condition
      during waitForDaemonsetRollout: Daemonset machine-config-daemon is not ready.
      status: (desired: 6, updated: 5, ready: 5, unavailable: 1)'
    reason: MachineConfigDaemonFailed
    status: 'True'
    type: Degraded
  - lastTransitionTime: '2022-09-26T10:04:55Z'
    message: Cluster not available for 4.8.36
    status: 'False'
    type: Available
  extension:
    master: all 3 nodes are at latest configuration rendered-master-14c6638170ed6f0d311838f401f24443
    infra: all 2 nodes are at latest configuration rendered-infra-df8db30df372d96b3f25157fe62b5f0f
    common: 1 (ready 0) out of 1 nodes are updating to latest configuration
      rendered-common-f0ddfcabd8b552f08bba0a145e4d003a
    worker: all 0 nodes are at latest configuration rendered-worker-7a64ab83d7601118377c78d512f83c96
  relatedObjects:
  - group: ''
    name: openshift-machine-config-operator
    resource: namespaces
  - group: machineconfiguration.openshift.io
    name: ''
    resource: machineconfigpools
  - group: machineconfiguration.openshift.io
    name: ''
    resource: controllerconfigs
  - group: machineconfiguration.openshift.io
    name: ''
    resource: kubeletconfigs
  - group: machineconfiguration.openshift.io
    name: ''
    resource: containerruntimeconfigs
  - group: machineconfiguration.openshift.io
    name: ''
    resource: machineconfigs
  - group: ''
    name: ''
    resource: nodes
  - group: ''
    name: openshift-kni-infra
    resource: namespaces
  - group: ''
    name: openshift-openstack-infra
    resource: namespaces
  - group: ''
    name: openshift-ovirt-infra
    resource: namespaces
  - group: ''
    name: openshift-vsphere-infra
    resource: namespaces
  versions:
  - name: operator
    version: 4.8.36


***monitoring operator description***

apiVersion: config.openshift.io/v1
kind: ClusterOperator
metadata:
  annotations:
    include.release.openshift.io/ibm-cloud-managed: 'true'
    include.release.openshift.io/self-managed-high-availability: 'true'
    include.release.openshift.io/single-node-developer: 'true'
  creationTimestamp: '2022-05-28T07:09:34Z'
  generation: 1
  name: monitoring
  resourceVersion: '83227939'
  uid: 515945b4-7b3d-4b77-9699-1a71a94d8e55
spec: {}
status:
  conditions:
  - lastTransitionTime: '2022-09-26T10:10:45Z'
    message: Rolling out the stack.
    reason: RollOutInProgress
    status: 'True'
    type: Progressing
  - lastTransitionTime: '2022-09-26T10:10:44Z'
    message: 'Failed to rollout the stack. Error: running task Updating node-exporter
      failed: reconciling node-exporter DaemonSet failed: updating DaemonSet object
      failed: waiting for DaemonSetRollout of openshift-monitoring/node-exporter:
      got 1 unavailable nodes'
    reason: UpdatingnodeExporterFailed
    status: 'True'
    type: Degraded
  - lastTransitionTime: '2022-09-26T10:10:45Z'
    message: Rollout of the monitoring stack is in progress. Please wait until it
      finishes.
    reason: RollOutInProgress
    status: 'True'
    type: Upgradeable
  - lastTransitionTime: '2022-09-26T10:10:44Z'
    message: Rollout of the monitoring stack failed and is degraded. Please investigate
      the degraded status error.
    reason: UpdatingnodeExporterFailed
    status: 'False'
    type: Available
  extension: null
  relatedObjects:
  - group: ''
    name: openshift-monitoring
    resource: namespaces
  - group: ''
    name: openshift-user-workload-monitoring
    resource: namespaces
  - group: monitoring.coreos.com
    name: ''
    resource: servicemonitors
  - group: monitoring.coreos.com
    name: ''
    resource: podmonitors
  - group: monitoring.coreos.com
    name: ''
    resource: prometheusrules
  - group: monitoring.coreos.com
    name: ''
    resource: alertmanagers
  - group: monitoring.coreos.com
    name: ''
    resource: prometheuses
  - group: monitoring.coreos.com
    name: ''
    resource: thanosrulers
  - group: monitoring.coreos.com
    name: ''
    resource: alertmanagerconfigs
  versions:
  - name: operator
    version: 4.8.36


***network operator description***

apiVersion: config.openshift.io/v1
kind: ClusterOperator
metadata:
  annotations:
    include.release.openshift.io/ibm-cloud-managed: 'true'
    include.release.openshift.io/self-managed-high-availability: 'true'
    include.release.openshift.io/single-node-developer: 'true'
    network.operator.openshift.io/last-seen-state: '{"DaemonsetStates":[{"Namespace":"openshift-sdn","Name":"sdn","LastSeenStatus":{"currentNumberScheduled":6,"numberMisscheduled":0,"desiredNumberScheduled":6,"numberReady":5,"observedGeneration":2,"updatedNumberScheduled":12,"numberAvailable":5,"numberUnavailable":1},"LastChangeTime":"2022-09-26T09:54:55.100586864Z"},{"Namespace":"openshift-multus","Name":"multus-additional-cni-plugins","LastSeenStatus":{"currentNumberScheduled":6,"numberMisscheduled":0,"desiredNumberScheduled":6,"numberReady":5,"observedGeneration":2,"updatedNumberScheduled":6,"numberAvailable":5,"numberUnavailable":1},"LastChangeTime":"2022-09-26T09:54:54.874659375Z"},{"Namespace":"openshift-multus","Name":"multus","LastSeenStatus":{"currentNumberScheduled":6,"numberMisscheduled":0,"desiredNumberScheduled":5,"numberReady":5,"observedGeneration":2,"updatedNumberScheduled":6,"numberAvailable":5,"numberUnavailable":1},"LastChangeTime":"2022-09-26T09:54:54.951078716Z"}],"DeploymentStates":[]}'
  creationTimestamp: '2022-05-28T07:09:34Z'
  generation: 1
  name: network
  resourceVersion: '83229149'
  uid: 9565a6cb-7745-4a00-bff9-6e999897520c
spec: {}
status:
  conditions:
  - lastTransitionTime: '2022-09-26T10:05:47Z'
    message: 'DaemonSet "openshift-multus/multus" rollout is not making progress -
      last change 2022-09-26T09:54:54Z

      DaemonSet "openshift-multus/multus-additional-cni-plugins" rollout is not making
      progress - last change 2022-09-26T09:54:54Z

      DaemonSet "openshift-sdn/sdn" rollout is not making progress - last change 2022-09-26T09:54:55Z'
    reason: RolloutHung
    status: 'True'
    type: Degraded
  - lastTransitionTime: '2022-05-28T07:16:42Z'
    status: 'False'
    type: ManagementStateDegraded
  - lastTransitionTime: '2022-05-28T07:16:42Z'
    status: 'True'
    type: Upgradeable
  - lastTransitionTime: '2022-09-26T09:54:54Z'
    message: 'DaemonSet "openshift-multus/multus" is not available (awaiting 1 nodes)

      DaemonSet "openshift-multus/multus-additional-cni-plugins" is not available
      (awaiting 1 nodes)

      DaemonSet "openshift-multus/network-metrics-daemon" is not available (awaiting
      1 nodes)

      DaemonSet "openshift-sdn/sdn" is not available (awaiting 1 nodes)

      DaemonSet "openshift-network-diagnostics/network-check-target" is not available
      (awaiting 1 nodes)'
    reason: Deploying
    status: 'True'
    type: Progressing
  - lastTransitionTime: '2022-05-28T07:18:32Z'
    status: 'True'
    type: Available
  extension: null
  relatedObjects:
  - group: ''
    name: applied-cluster
    namespace: openshift-network-operator
    resource: configmaps
  - group: apiextensions.k8s.io
    name: network-attachment-definitions.k8s.cni.cncf.io
    resource: customresourcedefinitions
  - group: apiextensions.k8s.io
    name: ippools.whereabouts.cni.cncf.io
    resource: customresourcedefinitions
  - group: apiextensions.k8s.io
    name: overlappingrangeipreservations.whereabouts.cni.cncf.io
    resource: customresourcedefinitions
  - group: ''
    name: openshift-multus
    resource: namespaces
  - group: rbac.authorization.k8s.io
    name: multus
    resource: clusterroles
  - group: ''
    name: multus
    namespace: openshift-multus
    resource: serviceaccounts
  - group: rbac.authorization.k8s.io
    name: multus
    resource: clusterrolebindings
  - group: rbac.authorization.k8s.io
    name: multus-whereabouts
    resource: clusterrolebindings
  - group: rbac.authorization.k8s.io
    name: multus-whereabouts
    namespace: openshift-multus
    resource: rolebindings
  - group: rbac.authorization.k8s.io
    name: whereabouts-cni
    resource: clusterroles
  - group: rbac.authorization.k8s.io
    name: whereabouts-cni
    namespace: openshift-multus
    resource: roles
  - group: ''
    name: cni-binary-copy-script
    namespace: openshift-multus
    resource: configmaps
  - group: apps
    name: multus
    namespace: openshift-multus
    resource: daemonsets
  - group: apps
    name: multus-additional-cni-plugins
    namespace: openshift-multus
    resource: daemonsets
  - group: batch
    name: ip-reconciler
    namespace: openshift-multus
    resource: cronjobs
  - group: ''
    name: metrics-daemon-sa
    namespace: openshift-multus
    resource: serviceaccounts
  - group: rbac.authorization.k8s.io
    name: metrics-daemon-role
    resource: clusterroles
  - group: rbac.authorization.k8s.io
    name: metrics-daemon-sa-rolebinding
    resource: clusterrolebindings
  - group: apps
    name: network-metrics-daemon
    namespace: openshift-multus
    resource: daemonsets
  - group: monitoring.coreos.com
    name: monitor-network
    namespace: openshift-multus
    resource: servicemonitors
  - group: ''
    name: network-metrics-service
    namespace: openshift-multus
    resource: services
  - group: rbac.authorization.k8s.io
    name: prometheus-k8s
    namespace: openshift-multus
    resource: roles
  - group: rbac.authorization.k8s.io
    name: prometheus-k8s
    namespace: openshift-multus
    resource: rolebindings
  - group: ''
    name: multus-admission-controller
    namespace: openshift-multus
    resource: services
  - group: rbac.authorization.k8s.io
    name: multus-admission-controller-webhook
    resource: clusterroles
  - group: rbac.authorization.k8s.io
    name: multus-admission-controller-webhook
    resource: clusterrolebindings
  - group: admissionregistration.k8s.io
    name: multus.openshift.io
    resource: validatingwebhookconfigurations
  - group: apps
    name: multus-admission-controller
    namespace: openshift-multus
    resource: daemonsets
  - group: monitoring.coreos.com
    name: monitor-multus-admission-controller
    namespace: openshift-multus
    resource: servicemonitors
  - group: rbac.authorization.k8s.io
    name: prometheus-k8s
    namespace: openshift-multus
    resource: roles
  - group: rbac.authorization.k8s.io
    name: prometheus-k8s
    namespace: openshift-multus
    resource: rolebindings
  - group: monitoring.coreos.com
    name: prometheus-k8s-rules
    namespace: openshift-multus
    resource: prometheusrules
  - group: ''
    name: openshift-sdn
    resource: namespaces
  - group: apiextensions.k8s.io
    name: clusternetworks.network.openshift.io
    resource: customresourcedefinitions
  - group: apiextensions.k8s.io
    name: hostsubnets.network.openshift.io
    resource: customresourcedefinitions
  - group: apiextensions.k8s.io
    name: netnamespaces.network.openshift.io
    resource: customresourcedefinitions
  - group: apiextensions.k8s.io
    name: egressnetworkpolicies.network.openshift.io
    resource: customresourcedefinitions
  - group: rbac.authorization.k8s.io
    name: openshift-sdn
    resource: clusterroles
  - group: ''
    name: sdn
    namespace: openshift-sdn
    resource: serviceaccounts
  - group: rbac.authorization.k8s.io
    name: openshift-sdn
    resource: clusterrolebindings
  - group: ''
    name: sdn-controller
    namespace: openshift-sdn
    resource: serviceaccounts
  - group: rbac.authorization.k8s.io
    name: openshift-sdn-controller
    resource: clusterroles
  - group: rbac.authorization.k8s.io
    name: openshift-sdn-controller
    resource: clusterrolebindings
  - group: rbac.authorization.k8s.io
    name: openshift-sdn-controller-leaderelection
    namespace: openshift-sdn
    resource: roles
  - group: rbac.authorization.k8s.io
    name: openshift-sdn-controller-leaderelection
    namespace: openshift-sdn
    resource: rolebindings
  - group: network.openshift.io
    name: default
    resource: clusternetworks
  - group: flowcontrol.apiserver.k8s.io
    name: openshift-sdn
    resource: flowschemas
  - group: monitoring.coreos.com
    name: networking-rules
    namespace: openshift-sdn
    resource: prometheusrules
  - group: apps
    name: sdn-controller
    namespace: openshift-sdn
    resource: daemonsets
  - group: monitoring.coreos.com
    name: monitor-sdn
    namespace: openshift-sdn
    resource: servicemonitors
  - group: ''
    name: sdn
    namespace: openshift-sdn
    resource: services
  - group: rbac.authorization.k8s.io
    name: prometheus-k8s
    namespace: openshift-sdn
    resource: roles
  - group: rbac.authorization.k8s.io
    name: prometheus-k8s
    namespace: openshift-sdn
    resource: rolebindings
  - group: ''
    name: openshift-host-network
    resource: namespaces
  - group: ''
    name: host-network-namespace-quotas
    namespace: openshift-host-network
    resource: resourcequotas
  - group: ''
    name: sdn-config
    namespace: openshift-sdn
    resource: configmaps
  - group: apps
    name: sdn
    namespace: openshift-sdn
    resource: daemonsets
  - group: ''
    name: openshift-network-diagnostics
    resource: namespaces
  - group: ''
    name: network-diagnostics
    namespace: openshift-network-diagnostics
    resource: serviceaccounts
  - group: rbac.authorization.k8s.io
    name: network-diagnostics
    namespace: openshift-network-diagnostics
    resource: roles
  - group: rbac.authorization.k8s.io
    name: network-diagnostics
    namespace: openshift-network-diagnostics
    resource: rolebindings
  - group: rbac.authorization.k8s.io
    name: network-diagnostics
    resource: clusterroles
  - group: rbac.authorization.k8s.io
    name: network-diagnostics
    resource: clusterrolebindings
  - group: rbac.authorization.k8s.io
    name: network-diagnostics
    namespace: kube-system
    resource: rolebindings
  - group: apps
    name: network-check-source
    namespace: openshift-network-diagnostics
    resource: deployments
  - group: ''
    name: network-check-source
    namespace: openshift-network-diagnostics
    resource: services
  - group: monitoring.coreos.com
    name: network-check-source
    namespace: openshift-network-diagnostics
    resource: servicemonitors
  - group: apps
    name: network-check-target
    namespace: openshift-network-diagnostics
    resource: daemonsets
  - group: ''
    name: network-check-target
    namespace: openshift-network-diagnostics
    resource: services
  - group: ''
    name: openshift-network-operator
    resource: namespaces
  - group: operator.openshift.io
    name: cluster
    resource: networks
  - group: networking.k8s.io
    name: ''
    resource: NetworkPolicy
  - group: k8s.ovn.org
    name: ''
    resource: EgressFirewall
  - group: k8s.ovn.org
    name: ''
    resource: EgressIP
  versions:
  - name: operator
    version: 4.8.36


----------Degraded machine-config-pool----------

NAME                  CONFIG                               UPDATED  UPDATING  DEGRADED  MACHINECOUNT  READYMACHINECOUNT  UPDATEDMACHINECOUNT  DEGRADEDMACHINECOUNT  AGE
common   rendered-commonf0ddfcabd8b552f08bba0a145e4d003a   False    True      False     1             0                  1                    0                     111d

----------Degraded machine-config-pool description----------


***common machine-config-pool description***

apiVersion: machineconfiguration.openshift.io/v1
kind: MachineConfigPool
metadata:
  creationTimestamp: '2022-06-04T17:17:07Z'
  generation: 23
  labels:
    machineconfiguration.openshift.io/role: common
  name: common
  resourceVersion: '83207492'
  uid: f345e944-d2da-4cad-9183-4a6629c143b0
spec:
  configuration:
    name: rendered-common-f0ddfcabd8b552f08bba0a145e4d003a
    source:
    - apiVersion: machineconfiguration.openshift.io/v1
      kind: MachineConfig
      name: 00-worker
    - apiVersion: machineconfiguration.openshift.io/v1
      kind: MachineConfig
      name: 01-worker-container-runtime
    - apiVersion: machineconfiguration.openshift.io/v1
      kind: MachineConfig
      name: 01-worker-kubelet
    - apiVersion: machineconfiguration.openshift.io/v1
      kind: MachineConfig
      name: 50-nto-common
    - apiVersion: machineconfiguration.openshift.io/v1
      kind: MachineConfig
      name: 50-performance-common-profile0
    - apiVersion: machineconfiguration.openshift.io/v1
      kind: MachineConfig
      name: 50-ran-enable-sctp
    - apiVersion: machineconfiguration.openshift.io/v1
      kind: MachineConfig
      name: 50-workers-chrony-configuration
    - apiVersion: machineconfiguration.openshift.io/v1
      kind: MachineConfig
      name: 99-common-generated-kubelet
    - apiVersion: machineconfiguration.openshift.io/v1
      kind: MachineConfig
      name: 99-worker-generated-registries
    - apiVersion: machineconfiguration.openshift.io/v1
      kind: MachineConfig
      name: 99-worker-ssh
  machineConfigSelector:
    matchExpressions:
    - key: machineconfiguration.openshift.io/role
      operator: In
      values:
      - worker
      - ran
      - common
  nodeSelector:
    matchLabels:
      node-role.kubernetes.io/common: ''
  paused: false
status:
  conditions:
  - lastTransitionTime: '2022-06-04T17:17:12Z'
    message: ''
    reason: ''
    status: 'False'
    type: RenderDegraded
  - lastTransitionTime: '2022-09-17T11:46:16Z'
    message: ''
    reason: ''
    status: 'False'
    type: NodeDegraded
  - lastTransitionTime: '2022-09-17T11:46:16Z'
    message: ''
    reason: ''
    status: 'False'
    type: Degraded
  - lastTransitionTime: '2022-09-26T09:54:59Z'
    message: ''
    reason: ''
    status: 'False'
    type: Updated
  - lastTransitionTime: '2022-09-26T09:54:59Z'
    message: All nodes are updating to rendered-common-f0ddfcabd8b552f08bba0a145e4d003a
    reason: ''
    status: 'True'
    type: Updating
  configuration:
    name: rendered-common-f0ddfcabd8b552f08bba0a145e4d003a
    source:
    - apiVersion: machineconfiguration.openshift.io/v1
      kind: MachineConfig
      name: 00-worker
    - apiVersion: machineconfiguration.openshift.io/v1
      kind: MachineConfig
      name: 01-worker-container-runtime
    - apiVersion: machineconfiguration.openshift.io/v1
      kind: MachineConfig
      name: 01-worker-kubelet
    - apiVersion: machineconfiguration.openshift.io/v1
      kind: MachineConfig
      name: 50-nto-common
    - apiVersion: machineconfiguration.openshift.io/v1
      kind: MachineConfig
      name: 50-performance-common-profile0
    - apiVersion: machineconfiguration.openshift.io/v1
      kind: MachineConfig
      name: 50-ran-enable-sctp
    - apiVersion: machineconfiguration.openshift.io/v1
      kind: MachineConfig
      name: 50-workers-chrony-configuration
    - apiVersion: machineconfiguration.openshift.io/v1
      kind: MachineConfig
      name: 99-common-generated-kubelet
    - apiVersion: machineconfiguration.openshift.io/v1
      kind: MachineConfig
      name: 99-worker-generated-registries
    - apiVersion: machineconfiguration.openshift.io/v1
      kind: MachineConfig
      name: 99-worker-ssh
  degradedMachineCount: 0
  machineCount: 1
  observedGeneration: 23
  readyMachineCount: 0
  unavailableMachineCount: 1
  updatedMachineCount: 1


----------Degraded Nodes----------

NAME          STATUS    ROLES           AGE   VERSION          INTERNAL-IP  EXTERNAL-IP  OS-IMAGE                                                      KERNEL-VERSION                CONTAINER-RUNTIME
test          NotReady  common,worker   111d  v1.21.8+ee73ea2  10.5x.x.x  <none>       Red Hat Enterprise Linux CoreOS 48.84.202203290727-0 (Ootpa)  4.18.0-305.40.2.el8_4.x86_64  cri-o://1.21.6-2.rhaos4.8.gitb948fcd.2.el8

----------Description of Degraded Nodes----------


***test***

kind: Node
metadata:
  annotations:
    machineconfiguration.openshift.io/controlPlaneTopology: HighlyAvailable
    machineconfiguration.openshift.io/currentConfig: rendered-common-f0ddfcabd8b552f08bba0a145e4d003a
    machineconfiguration.openshift.io/desiredConfig: rendered-common-f0ddfcabd8b552f08bba0a145e4d003a
    machineconfiguration.openshift.io/reason: ""
    machineconfiguration.openshift.io/ssh: accessed
    machineconfiguration.openshift.io/state: Done
    sriovnetwork.openshift.io/state: Idle
    volumes.kubernetes.io/controller-managed-attach-detach: "true"
  creationTimestamp: "2022-06-04T16:59:31Z"
  labels:
    beta.kubernetes.io/arch: amd64
    beta.kubernetes.io/os: linux
    kubernetes.io/arch: amd64
    kubernetes.io/hostname: test
    kubernetes.io/os: linux
    node-role.kubernetes.io/common: ""
    node-role.kubernetes.io/worker: ""
    node.openshift.io/os_id: rhcos
  name: test
  resourceVersion: "83207503"
  uid: c1965bd7-d0d5-4e1c-a2dd-ab0ff9a2b8ab
spec:
  taints:
  - effect: NoSchedule
    key: node.kubernetes.io/unreachable
    timeAdded: "2022-09-26T09:54:54Z"
  - effect: NoExecute
    key: node.kubernetes.io/unreachable
    timeAdded: "2022-09-26T09:55:00Z"
status:
  addresses:
  - address: 10.5x.x.x
    type: InternalIP
  - address: test
    type: Hostname
  allocatable:
    cpu: "74"
    ephemeral-storage: 932697068Ki
    hugepages-1Gi: 160Gi
    hugepages-2Mi: "0"
    memory: 225917436Ki
    pods: "250"
  capacity:
    cpu: "80"
    ephemeral-storage: 932697068Ki
    hugepages-1Gi: 160Gi
    hugepages-2Mi: "0"
    memory: 394815996Ki
    pods: "250"
  conditions:
  - lastHeartbeatTime: "2022-09-26T09:51:06Z"
    lastTransitionTime: "2022-09-26T09:54:54Z"
    message: Kubelet stopped posting node status.
    reason: NodeStatusUnknown
    status: Unknown
    type: MemoryPressure
  - lastHeartbeatTime: "2022-09-26T09:51:06Z"
    lastTransitionTime: "2022-09-26T09:54:54Z"
    message: Kubelet stopped posting node status.
    reason: NodeStatusUnknown
    status: Unknown
    type: DiskPressure
  - lastHeartbeatTime: "2022-09-26T09:51:06Z"
    lastTransitionTime: "2022-09-26T09:54:54Z"
    message: Kubelet stopped posting node status.
    reason: NodeStatusUnknown
    status: Unknown
    type: PIDPressure
  - lastHeartbeatTime: "2022-09-26T09:51:06Z"
    lastTransitionTime: "2022-09-26T09:54:54Z"
    message: Kubelet stopped posting node status.
    reason: NodeStatusUnknown
    status: Unknown
    type: Ready
  nodeInfo:
    architecture: amd64
    bootID: 4968f78d-e640-433e-8a83-d6fe24bb18ae
    containerRuntimeVersion: cri-o://1.21.6-2.rhaos4.8.gitb948fcd.2.el8
    kernelVersion: 4.18.0-305.40.2.el8_4.x86_64
    kubeProxyVersion: v1.21.8+ee73ea2
    kubeletVersion: v1.21.8+ee73ea2
    machineID: e4f6a16040d84bef999e122380d4d3ea
    operatingSystem: linux
    osImage: Red Hat Enterprise Linux CoreOS 48.84.202203290727-0 (Ootpa)
    systemUUID: 4c4xxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxxxx

----------Pods not in Running state----------

NAMESPACE                                         NAME                                                     READY  STATUS     RESTARTS  AGE    IP            NODE
openshift-multus                                  ip-reconciler-27720360-6q2zm                             0/1    Failed     0         11d    10.1x.x.x   master1

----------machine-config-daemon pod logs for degraded nodes----------


***machine-config-daemon-7q6tq pod logs for degraded test node***
2022-09-26T00:09:15.014235833-05:00 I1006 05:09:15.014210 4164362 update.go:1511] Writing systemd unit "custom-timezone.service"
2022-09-26T00:09:15.366899380-05:00 I1006 05:09:15.366842 4164362 update.go:1428] Enabled systemd units: [kubelet-auto-node-size.service kubelet.service machine-config-daemon-firstboot.service machine-config-daemon-pull.service etc-NetworkManager-systemConnectionsMerged.mount node-valid-hostname.service openvswitch.service ovs-configuration.service ovsdb-server.service vsphere-hostname.service custom-timezone.service]
2022-09-26T00:09:15.711697047-05:00 I1006 05:09:15.711611 4164362 update.go:1439] Disabled systemd units [nodeip-configuration.service]
2022-09-26T00:09:15.711697047-05:00 I1006 05:09:15.711661 4164362 update.go:1246] Deleting stale data
2022-09-26T00:09:15.736075628-05:00 I1006 05:09:15.736018 4164362 update.go:1309] Removed stale file "/etc/NetworkManager/dispatcher.d/40-mdns-hostname"
2022-09-26T00:09:15.742859761-05:00 I1006 05:09:15.742792 4164362 update.go:1309] Removed stale file "/etc/kubernetes/static-pod-resources/mdns/config.hcl.tmpl"
2022-09-26T00:09:15.749550288-05:00 I1006 05:09:15.749491 4164362 update.go:1309] Removed stale file "/etc/kubernetes/manifests/mdns-publisher.yaml"
2022-09-26T00:09:15.769924766-05:00 I1006 05:09:15.769856 4164362 update.go:1689] Writing SSHKeys at "/home/core/.ssh/authorized_keys"
2022-09-26T00:09:15.793767437-05:00 I1006 05:09:15.793718 4164362 run.go:18] Running: nice -- ionice -c 3 oc image extract --path /:/run/mco-machine-os-content/os-content-101981175 --registry-config /var/lib/kubelet/config.json quay.io/openshift-release-dev/ocp-v4.0-art-dev@sha256:8e3f0xxxxxxxxxxxx
```
