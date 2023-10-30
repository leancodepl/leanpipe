apiVersion: batch/v1
kind: Job
metadata:
  name: $ENV_NAME_KEBABC-tests
  namespace: $ENV_NAME_KEBABC
  labels:
    app: $ENV_NAME_KEBABC-tests
spec:
  template:
    spec:
      restartPolicy: Never
      containers:
      - name: $ENV_NAME_KEBABC-tests
        image: $TESTS_NAME
        ports:
          - containerPort: 22
