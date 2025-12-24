### Challenge 1

#### 'developer-role' should have all permissions for services, persistentvolumeclaims, and pods in development ns.
```
kubectl create role developer-role --verb=* \
--resource=services,persistentvolumeclaims,pods -n development
```

#### create role binding, name is developer-rolebinding, role is developer-role, namespace is development, and user is martin
```
kubectl create rolebinding developer-rolebinding --user=martin --role=developer-role -n development
```
---

#### set context 'developer' with user martin and cluster for kubernetes
```
kubectl config set-credentials martin --client-certificate <.pub> --client-key <.key>
```

```
kubectl config set-context developer --user martin --cluster kubernetes
```
#### activate the context by admin
```
kubectl config use-context developer
```
---

#### Make pod
```
apiVersion: v1
kind: Pod
metadata:
  creationTimestamp: null
  labels:
    run: jekyll
  name: jekyll
  namespace: development
spec:
  initContainers:
  - name: copy-jekyll-site
    image: gcr.io/kodekloud/customimage/jekyll
    command: ["sh", "-c", "rm -rf /site/* && jekyll new /site && cd /site && bundle install"]
    volumeMounts:
    - name: site
      mountPath: /site
  containers:
  - image: gcr.io/kodekloud/customimage/jekyll-serve
    name: jekyll
    command: ["sh", "-c", "cd /site && bundle install && bundle exec jekyll serve --host 0.0.0.0 --port 4000"]
    volumeMounts:
    - name: site
      mountPath: /site
  volumes:
  - name: site
    persistentVolumeClaim:
      claimName: jekyll-site
```
---

#### create service
```
kubectl expose pod <POD> --name <SVC_NAME> -n <NAMESPACE> --type NodePort --port <PORT> --target-port <T_PORT> --dry-run client -o yaml > svc.yaml
```
> add `nodePort: <NP_PORT>` in ports scope.
