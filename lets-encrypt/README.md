Create a ClusterIssuer

```
microk8s kubectl apply -f ./clusterIssuer.yaml
```

Verify that the ClusterIssuer was created successfully with

```
microk8s kubectl get clusterissuer -o wide
```

Deploy a simple microbot deployment for test:

```
microk8s kubectl create deploy --image cdkbot/microbot:1 --replicas 3 microbot

microk8s kubectl expose deploy microbot --port 80 --type ClusterIP
```

```
microk8s kubectl apply -f - <<EOF
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
 name: microbot-ingress
 annotations:
   cert-manager.io/cluster-issuer: lets-encrypt
spec:
 tls:
 - hosts:
   - srv.jcdev.online
   secretName: microbot-ingress-tls
 rules:
 - host: srv.jcdev.online
   http:
     paths:
     - backend:
         service:
           name: microbot
           port:
             number: 80
       path: /
       pathType: Exact
EOF
```
