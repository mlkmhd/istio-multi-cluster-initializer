#!/bin/bash

set -xe

export TOTAL_CLUSTERS=3

for ((i=1;i<=${TOTAL_CLUSTERS};i++)); do
    
    for ((j=1;j<=${TOTAL_CLUSTERS};j++)); do
    
        if [ ${i} != ${j} ]; then
        
            kubectl --context=cluster-${i} get services --all-namespaces -l multiclusterSync=enabled -o json | jq 'del(.items[].metadata.annotations)' > tmp/cluster-${i}-services.txt
            
            cat tmp/cluster-${i}-services.txt | jq -c '.items[]' | while read item; do
                service_name=`echo $item | jq -r '.metadata.name'`
                namespace=`echo $item | jq -r '.metadata.namespace'`
                
                kubectl --context=cluster-${j} create ns $namespace || true
                
                kubectl --context=cluster-${i} get service ${service_name} -n ${namespace} -o json | jq 'del(.metadata.labels.multiclusterSync)' | jq 'del(.metadata.uid)' | jq 'del(.metadata.resourceVersion)' | jq 'del(.metadata.creationTimestamp)' | jq 'del(.spec.clusterIP)' | jq 'del(.spec.clusterIPs)' | jq 'del(.status)' | kubectl --context=cluster-${j} apply -f -
                
            done
            
        fi
    
    done
done
