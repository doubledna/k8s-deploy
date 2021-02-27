#!/bin/bash
# 用于添加k8s master节点

# 用于获取步骤
STEPS=$1

case $STEPS in
1 | initEnv)
  echo "开始初始化环境"
  ansible-playbook -i inventory/masters initMasterEnv.yml;;
2 |  generateCert)
  echo "更新master组件所需证书"
  ansible-playbook -i inventory/masters generateMasterCert.yml --extra-vars "function=addMaster";;
3 |  apiServer)
  echo "开始安装apiServer节点"
  ansible-playbook -i inventory/masters kubeApi.yml --extra-vars "function=addMaster";;
4 |  controller)
  echo "开始安装controller节点"
  ansible-playbook -i inventory/masters kubeController.yml --extra-vars "function=addMaster";;
5 |  scheduler)
  echo "开始安装scheduler节点"
  ansible-playbook -i inventory/masters kubeScheduler.yml --extra-vars "function=addMaster";;
*)
  echo "抱歉，请正确选择 ./add_master.sh xxx
       1 或 initEnv
       2 或 generateCert
       3 或 apiServer
       4 或 controller
       5 或 scheduler";;
esac
