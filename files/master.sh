#!/bin/sh

kubeadm init --pod-network-cidr=10.244.0.0/16 --apiserver-bind-port=443 --token TOKEN --token-ttl 0

# kubectl
mkdir -p $HOME/.kube
cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
chown $(id -u):$(id -g) $HOME/.kube/config

# flannel
kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml