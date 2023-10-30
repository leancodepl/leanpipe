apiVersion: v1
kind: Service
metadata:
  name: $ENV_NAME-funnel-svc
  namespace: $ENV_NAME
  labels:
    app: $ENV_NAME-funnel
spec:
  ports:
    - port: 80
      targetPort: 8080
      protocol: TCP
  clusterIP: None
  selector:
    app: $ENV_NAME-funnel
---
apiVersion: apps/v1
kind: StatefulSet
metadata:
  name: $ENV_NAME-funnel
  namespace: $ENV_NAME
  labels:
    app: $ENV_NAME-funnel
spec:
  selector:
    matchLabels:
      app: $ENV_NAME-funnel
  serviceName: $ENV_NAME-funnel-svc
  replicas: $FUNNEL_REPLICAS
  template:
    metadata:
      labels:
        app: $ENV_NAME-funnel
    spec:
      containers:
        - name: leanpipe-funnel
          image: testapp_funnel
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
