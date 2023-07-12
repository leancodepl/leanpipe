apiVersion: v1
kind: Namespace
metadata:
  name: ${APP_NAME}
---
apiVersion: apps/v1
kind: Deployment
metadata:
  labels:
    app: ${APP_NAME}
  name: ${APP_NAME}
  namespace: ${APP_NAME}
spec:
  replicas: 1
  selector:
    matchLabels:
      app: ${APP_NAME}
  template:
    metadata:
      labels:
        app: ${APP_NAME}
    spec:
      containers:
      - image: ${IMAGE_NAME}
        name: app
        resources:
          requests:
            cpu: ${CPU_REQUEST}
            memory: ${MEMORY_REQUEST}
          limits:
            cpu: ${CPU_LIMIT}
            memory: ${MEMORY_LIMIT}
---
apiVersion: v1
kind: Service
metadata:
  name: ${APP_NAME}
  namespace: ${APP_NAME}
spec:
  ports:
  - port: 8080
    protocol: TCP
    targetPort: 8080
  selector:
    app: ${APP_NAME}
  type: ClusterIP
---
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: ${APP_NAME}-ingress
  namespace: ${APP_NAME}
spec:
  ingressClassName: traefik
  rules:
    - host: ${APP_NAME}.test.lncd.pl
      http:
        paths:
          - pathType: ImplementationSpecific
            backend:
              service:
                name: ${APP_NAME}
                port:
                  number: 8080