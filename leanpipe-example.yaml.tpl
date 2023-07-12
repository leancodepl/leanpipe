apiVersion: apps/v1
kind: Deployment
metadata:
  labels:
    app: leanpipe-example
  name: leanpipe-example
  namespace: leanpipe-example
spec:
  replicas: 1
  selector:
    matchLabels:
      app: leanpipe-example
  template:
    metadata:
      labels:
        app: leanpipe-example
    spec:
      containers:
      - image: leancode.azurecr.io/leanpipe-example:${APP_VERSION}
        name: app
---
apiVersion: v1
kind: Service
metadata:
  name: leanpipe-example
  namespace: leanpipe-example
spec:
  ports:
  - port: 8080
    protocol: TCP
    targetPort: 8080
  selector:
    app: leanpipe-example
  type: ClusterIP
---
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: leanpipe-example-ingress
  namespace: leanpipe-example
spec:
  ingressClassName: traefik
  rules:
    - host: leanpipe-example.test.lncd.pl
      http:
        paths:
          - pathType: ImplementationSpecific
            backend:
              service:
                name: leanpipe-example
                port:
                  number: 8080