#!/bin/bash

# Create a vote namespace
kubectl create ns vote

# Create a db deployment
cat <<EOF | kubectl apply -f -
apiVersion: apps/v1
kind: Deployment
metadata:
  creationTimestamp: null
  labels:
    app: db
  name: db
  namespace: vote
spec:
  replicas: 1
  selector:
    matchLabels:
      app: db
  strategy: {}
  template:
    metadata:
      creationTimestamp: null
      labels:
        app: db
    spec:
      containers:
      - image: postgres:15-alpine
        name: postgres
        env:
        - name: POSTGRES_HOST_AUTH_METHOD
          value: trust
        volumeMounts:
        - name: db-data
          mountPath: /var/lib/postgresql/data
      volumes:
      - name: db-data
        emptyDir: {}
status: {}
EOF

# Create svc for db deployment
kubectl expose deployment db --name db --port 5432 --target-port 5432 -n vote

# Create worker deployment
kubectl create deployment worker \
--image dockersamples/examplevotingapp_worker \
-n vote

# Create redis deployment
cat <<EOF | kubectl apply -f -
apiVersion: apps/v1
kind: Deployment
metadata:
  creationTimestamp: null
  labels:
    app: redis
  name: redis
  namespace: vote
spec:
  replicas: 1
  selector:
    matchLabels:
      app: redis
  strategy: {}
  template:
    metadata:
      creationTimestamp: null
      labels:
        app: redis
    spec:
      containers:
      - image: redis:alpine
        name: redis
        volumeMounts:
        - name: redis-data
          mountPath: /data
      volumes:
      - name: redis-data
        emptyDir: {}
status: {}
EOF

# Create svc for redis deployment
kubectl expose deployment redis --port 6379 --target-port 6379 -n vote

# Create vote deployment 
kubectl create deployment vote \
--image dockersamples/examplevotingapp_vote \
-n vote

# Deploy svc for vote deployment with declarative manifest
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Service
metadata:
  creationTimestamp: null
  labels:
    app: vote
  name: vote
  namespace: vote
spec:
  ports:
  - port: 8081
    protocol: TCP
    targetPort: 80
    nodePort: 30001
  selector:
    app: vote
  type: NodePort
status:
  loadBalancer: {}

# Create result deployment
kubectl create deployment result \ 
--image dockersamples/examplevotingapp_result \
-n vote

# Deploy svc for result deployment
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Service
metadata:
  creationTimestamp: null
  labels:
    app: result
  name: result
  namespace: vote
spec:
  ports:
  - port: 8081
    protocol: TCP
    targetPort: 80
    nodePort: 31001
  selector:
    app: result
  type: NodePort
status:
  loadBalancer: {}
  









