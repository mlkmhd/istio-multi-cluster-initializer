#!/bin/bash
set -ex

CERTIFICATES_COUNT=$1

cert_dir=`dirname "$BASH_SOURCE"`/certs

echo "Clean up contents of dir './chapter12/certs'"
rm -rf ${cert_dir}

echo "Generating new certificates"

mkdir -p ${cert_dir}

step certificate create root.istio.io ${cert_dir}/root-cert.pem ${cert_dir}/root-ca.key \
  --profile root-ca --no-password --insecure --san root.istio.io \
  --not-after 87600h --kty RSA

for ((i=1;i<=${CERTIFICATES_COUNT};i++)); do
    mkdir -p ${cert_dir}/cluster-${i}
    
    step certificate create cluster-${i}.intermediate.istio.io ${cert_dir}/cluster-${i}/ca-cert.pem ${cert_dir}/cluster-${i}/ca-key.pem --ca ${cert_dir}/root-cert.pem --ca-key ${cert_dir}/root-ca.key --profile intermediate-ca --not-after 87600h --no-password --insecure --san cluster-${i}.intermediate.istio.io --kty RSA 

    cat ${cert_dir}/cluster-${i}/ca-cert.pem ${cert_dir}/root-cert.pem > ${cert_dir}/cluster-${i}/cert-chain.pem
done
