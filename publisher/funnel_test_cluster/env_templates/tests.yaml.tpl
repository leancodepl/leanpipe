apiVersion: batch/v1
kind: Job
metadata:
  name: $ENV_NAME-tests
  namespace: $ENV_NAME
  labels:
    app: $ENV_NAME-tests
spec:
  template:
    spec:
      restartPolicy: Never
      containers:
      - name: $ENV_NAME-tests
        image: $TESTS_NAME
        ports:
          - containerPort: 22
