#!/bin/bash
# 用于添加nodes

# 用于获取步骤
STEPS=$1

case $STEPS in
1 | initEnv)
  echo "开始初始化环境"
  ansible-playbook -i inventory/node initNodeEnv.yml;;
2 | flanneld)
  echo "开始flanneld"
  ansible-playbook -i inventory/node flannel.yml --extra-vars "function=addNode";;
3 | docker)
  echo "开始安装docker"
  ansible-playbook -i inventory/node docker.yml;;
4 | nodesConfig)
  echo "开始配置node节点kubeconfig"
  ansible-playbook -i inventory/node nodeNodesConfig.yml --extra-vars "function=addNode";;
5 | nodes)
  echo "开始配置nodes"
  ansible-playbook -i inventory/node nodes.yml;;
6 | autoCsr)
  echo "开始自动化CSR"
  ansible-playbook -i inventory/node autoNodeCsr.yml --extra-vars "function=addNode";;
*)
  echo "抱歉，请正确选择 ./addNode.sh xxx
       1 或 initEnv
       2 或 flanneld
       3 或 docker
       4 或 nodesConfig
       5 或 nodes
       6 或 autoCsr";;
esac
