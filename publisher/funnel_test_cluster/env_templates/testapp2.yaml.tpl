apiVersion: v1
kind: Service
metadata:
  name: $ENV_NAME_KEBABC-testapp2-svc
  namespace: $ENV_NAME_KEBABC
  labels:
    app: $ENV_NAME_KEBABC-testapp2
spec:
  ports:
    - port: 80
      targetPort: 8080
      protocol: TCP
  clusterIP: None
  selector:
    app: $ENV_NAME_KEBABC-testapp2
---
apiVersion: apps/v1
kind: StatefulSet
metadata:
  name: $ENV_NAME_KEBABC-testapp2
  namespace: $ENV_NAME_KEBABC
  labels:
    app: $ENV_NAME_KEBABC-testapp2
spec:
  selector:
    matchLabels:
      app: $ENV_NAME_KEBABC-testapp2
  serviceName: $ENV_NAME_KEBABC-testapp2-svc
  replicas: 1
  template:
    metadata:
      labels:
        app: $ENV_NAME_KEBABC-testapp2
    spec:
      containers:
        - name: testapp2
          image: testapp2
          env:
            - name: MassTransit__RabbitMq__Url
              value: rabbitmq://guest:guest@rabbitmq-$RABBITMQ_INSTANCE.rabbitmq-svc.default.svc.cluster.local/
          ports:
            - containerPort: 8080
            - containerPort: 22
          livenessProbe:
            httpGet:
              path: /health/live
              port: 8080
            initialDelaySeconds: 2
            periodSeconds: 2
            timeoutSeconds: 5
          readinessProbe:
            httpGet:
              path: /health/ready
              port: 8080
            initialDelaySeconds: 5
            periodSeconds: 2
            timeoutSeconds: 5
