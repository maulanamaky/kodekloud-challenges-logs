### Challenge 2

#### Login as root
```
sudo -i
```
---

#### Check config at .kube about controlplane port must be 6443.
''The connection to the server controlplane:6443 was refused - did you specify the right host or port?''

that error mean the port server controlplane is wrong in kubeconfig.

---

#### Check certificate at kube-apiserver.yaml from /etc/kubernetes/pki

file certificate at /etc/kubernetes/pki

file static pod at /etc/kubernetes/manifests/kube-apiserver.yaml

---

#### Change image coredns deployment
```
kubectl set image deployment coredns cordns=<IMAGE>
```
> <CONTAINER_NAME>=<IMAGE>:<TAG>

---

#### Make sure node01 is ready
''SchedulingDisabled'' this mean is the node01 has cordon.
```
kubectl uncordon node01
```
---

#### Copy files from controlplane to node01
```
scp  /media node01:/web
```
---

#### make pv
```
apiVersion: v1
kind: PersistentVolume
metadata:
  name: data-pv
spec:
  capacity:
    storage: 1Gi
  volumeMode: Filesystem
  accessModes:
    - ReadWriteMany
  persistentVolumeReclaimPolicy: Recycle
  hostPath:
    path: /web
```
---

#### make pvc
```
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: data-pvc
spec:
  accessModes:
    - ReadWriteMany
  volumeName: data-pv
  volumeMode: Filesystem
  resources:
    requests:
      storage: 1Gi

### make pod
apiVersion: v1
kind: Pod
metadata:
  creationTimestamp: null
  labels:
    run: gop-file-server
  name: gop-file-server
spec:
  containers:
  - args:
    - client
    image: kodekloud/fileserver
    name: gop-file-server
    volumeMounts:
    - mountPath: /web
      name: data-store
  volumes:
  - name: data-store
    persistentVolumeClaim:
      claimName: data-pvc

  dnsPolicy: ClusterFirst
  restartPolicy: Always
status: {}
```
---

### make service
```
kubectl expose pod <NAME> --port 8080 --target-port 8080
```
