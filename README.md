# ansible部署K8S集群

#### k8s下载地址

* k8s下载地址：https://github.com/kubernetes/kubernetes/blob/master/CHANGELOG-1.18.md
* k8s 1.15.6下载地址：https://storage.googleapis.com/kubernetes-release/release/v1.15.6/kubernetes-server-linux-amd64.tar.gz
* 请将文件解压放在/tmp/kubernetes目录下

#### 在新集群环境中使用，请修改group_var/和inventory两个目录中对应变量值

#### 命令行执行

* 安装集群 ./addCluster.sh
* 增加Node节点 ./addNode.sh
* 增加Master节点 ./addMaster.sh （增加主节点，请自行更新API代理中新增节点端口）

#### 检查各个组件是否正常工作

##### api

* 1. kubernetes 服务 IP 是 apiserver 自动创建的，一般是 --service-cluster-ip-range 参数指定的网段的第一个IP，后续可以通过下面命令获取：
  * $ kubectl get svc kubernetes

* 2. 检查集群信息
  * $ kubectl cluster-info
  * $ kubectl get all --all-namespaces
  * $ kubectl get componentstatuses

##### controller

* 1. 查看输出的 metrics 注意：以下命令在 kube-controller-manager 节点上执行

  * $ curl -s --cacert /etc/kubernetes/cert/ca.pem --cert /etc/kubernetes/cert/admin.pem --key /etc/kubernetes/cert/admin-key.pem https://172.16.52.130:10252/metrics |head

* 2. kube-controller-manager 的权限
  * $ kubectl describe clusterrole system:kube-controller-manager
  * $ kubectl get clusterrole|grep controller
  * $ kubectl describe clusterrole system:controller:deployment-controller

* 3. 查看当前的 leader

  * $ kubectl get endpoints kube-controller-manager --namespace=kube-system  -o yaml

##### scheduler

* 1. 查看输出的 metrics 注意：以下命令在 kube-scheduler 节点上执行。(kube-scheduler 监听 10251 和 10251 端口：10251：接收 http 请求，非安全端口，不需要认证授权；10259：接收 https 请求，安全端口，需要认证授  权；两个接口都对外提供 /metrics 和 /healthz 的访问
  * $ sudo netstat -lnpt |grep kube-sch
  * $ curl -s http://127.0.0.1:10251/metrics |head
  * $ curl -s --cacert /etc/kubernetes/cert/ca.pem --cert /etc/kubernetes/cert/admin.pem --key /etc/kubernetes/cert/admin-key.pem https://172.16.52.130:10259/metrics |head

* 2. 查看当前leader
  * $ kubectl get endpoints kube-scheduler --namespace=kube-system  -o yaml

##### kubelet

* 1. 查看 kubeadm 为各节点创建的 token：
  * $ kubeadm token list --kubeconfig ~/.kube/config

* 2. 查看各 token 关联的 Secret：
  * $ kubectl get secrets  -n kube-system|grep bootstrap-token
  * kube-controller-manager 为各 node 生成了 kubeconfig 文件和公私钥(在node节点上查看)：
  * $ ls -l /etc/kubernetes/kubelet.kubeconfig
  * $ ls -l /etc/kubernetes/cert/|grep kubelet

* 4. 预定义的 ClusterRole system:kubelet-api-admin 授予访问 kubelet 所有 API 的权限(kube-apiserver 使用的 kubernetes 证书 User 授予了该权限)：
  * $ kubectl describe clusterrole system:kubelet-api-admin

##### etcd

* 1. 查看etcd 当前leader:
  * ETCDCTL_API=3 /usr/local/k8s/bin/etcdctl -w table --cacert=/etc/kubernetes/cert/ca.pem --cert=/etc/etcd/cert/etcd.pem --key=/etc/etcd/cert/etcd-key.pem --endpoints="https://IP1:2379,https://IP2:2379" endpoint status
