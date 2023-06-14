# istio-multicluster-initializer
this repository is a helper for initializing Isio mesh over multiple Kubernetes cluster

## Requirement
first you need to install the following tools:

```bash
$ wget https://github.com/smallstep/cli/releases/download/v0.24.4/step_linux_0.24.4_amd64.tar.gz -O step.tar.gz
$ tar -xvzf step.tar.gz
$ mv step_0.24.4/bin/step /usr/bin/
$ chmod +x /usr/bin/step
```

and then run the following command to generate certificate chains:
```bash
$ cd gen-certs
$ ./gen-certs.sh 2
```
you also need to create a single `~/.kube/config` file with different contexts. the contexts should have a name like `ctx-1`, `ctx-2`, `ctx-3`, ...

## Installation
first, you need to install some requirements like envsubst and istioctl on your machine like this:
```bash
$ sudo apt install envsubst -y
$ wget -c "https://github.com/istio/istio/releases/download/1.15.7/istio-1.15.7-linux-amd64.tar.gz" -O istio.tar.gz
$ tar -xvzf istio.tar.gz
$ sudo mv istio-1.15.7/bin/istioctl /usr/bin/
```

then run the install.sh script file to deploy Istio on them and connect them together (the arguments 2 referes to the cluster counts and you need to change it if you're connecting more that 2 clusters to each other):
```bash
$ cd istio-multi-cluster-initializer/
$ ./install.sh 2
```

for checking the pods that are deployed or not you can run the following commands on the cluster1:
```bash
$ kubectl --context=ctx-1 -n istio-system get pods
NAME                                     READY   STATUS    RESTARTS   AGE
istio-eastwestgateway-7684764f5f-ttrpk   1/1     Running   0          46s
istiod-75f7cc5c-p9ms9                    1/1     Running   0          14h
and on the cluster2:
$ kubectl --context=ctx-2 -n istio-system get pods
NAME                                     READY   STATUS    RESTARTS   AGE
istio-eastwestgateway-5bdf7fdf4c-jcbmm   1/1     Running   0          12s
istiod-86d44ff4fb-mq8cl                  1/1     Running   0          64s
```

if all pods inside the istio-system namespace is at Running status, you can continue on this document, but if there's a problem with them, you need to check it out first. 
