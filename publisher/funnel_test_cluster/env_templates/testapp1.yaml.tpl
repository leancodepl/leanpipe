apiVersion: v1
kind: Service
metadata:
  name: $ENV_NAME_KEBABC-testapp1-svc
  namespace: $ENV_NAME_KEBABC
  labels:
    app: $ENV_NAME_KEBABC-testapp1
spec:
  ports:
    - port: 80
      targetPort: 8080
      protocol: TCP
  clusterIP: None
  selector:
    app: $ENV_NAME_KEBABC-testapp1
---
apiVersion: apps/v1
kind: StatefulSet
metadata:
  name: $ENV_NAME_KEBABC-testapp1
  namespace: $ENV_NAME_KEBABC
  labels:
    app: $ENV_NAME_KEBABC-testapp1
spec:
  selector:
    matchLabels:
      app: $ENV_NAME_KEBABC-testapp1
  serviceName: $ENV_NAME_KEBABC-testapp1-svc
  replicas: $TESTAPP1_REPLICAS
  template:
    metadata:
      labels:
        app: $ENV_NAME_KEBABC-testapp1
    spec:
      containers:
        - name: testapp1
          image: testapp1
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
