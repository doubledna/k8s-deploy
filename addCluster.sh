#!/bin/bash
# 用于部署k8s

# 用于获取步骤
STEPS=$1

case $STEPS in
1 | initEnv)
  echo "开始初始化环境"
  ansible-playbook -i inventory/k8s initEnv.yml;;
2 | generateCert)
  echo "开始生成证书"
  ansible-playbook -i inventory/k8s generateCert.yml --extra-vars "function=addCluster";;
3 | etcd)
  echo "开始安装etcd"
  ansible-playbook -i inventory/k8s etcd.yml;;
4 | flanneld)
  echo "开始flanneld"
  ansible-playbook -i inventory/k8s flannel.yml --extra-vars "function=addCluster";;
5 | docker)
  echo "开始安装docker"
  ansible-playbook -i inventory/k8s docker.yml;;
6 | kubeNginx)
  echo "开始安装api代理"
  ansible-playbook -i inventory/k8s kubeNginx.yml;;
7 | kubectl)
  echo "开始安装kubectl"
  ansible-playbook -i inventory/k8s kubectl.yml;;
8 |  kubeApi)
  echo "开始安装apiServer节点"
  ansible-playbook -i inventory/k8s kubeApi.yml --extra-vars "function=addCluster";;
9 |  kubeController)
  echo "开始安装controller节点"
  ansible-playbook -i inventory/k8s kubeController.yml --extra-vars "function=addCluster";;
10 |  kubeScheduler)
  echo "开始安装scheduler节点"
  ansible-playbook -i inventory/k8s kubeScheduler.yml --extra-vars "function=addCluster";;
11 | nodesConfig)
  echo "开始配置node节点kubeconfig"
  ansible-playbook -i inventory/k8s nodesConfig.yml --extra-vars "function=addCluster";;
12 | nodes)
  echo "开始配置nodes"
  ansible-playbook -i inventory/k8s nodes.yml;;
13 | autoCsr)
  echo "开始自动化CSR"
  ansible-playbook -i inventory/k8s autoCsr.yml --extra-vars "function=addCluster";;
14 | testK8s)
  echo "开始安装nginx，测试集群功能，不需要请勿安装"
  ansible-playbook -i inventory/k8s testK8s.yml;;
15 | deleteK8s)
  echo "开始清理k8s集群，请慎重操作"
  ansible-playbook -i inventory/k8s deleteK8s.yml;;
*)
  echo "抱歉，请正确选择 ./addCluster.sh 数字/名称
       1 或 initEnv
       2 或 generateCert
       3 或 etcd 
       4 或 flanneld
       5 或 docker
       6 或 kubeNginx
       7 或 kubectl
       8 或 kubeApi
       9 或 kubeController
       10 或 kubeScheduler
       11 或 nodesConfig
       12 或 nodes
       13 或 autoCsr
       14 或 testK8s
       15 或 deleteK8s";;
esac
