FROM dart:3.5.0 AS build

COPY ../../ .

RUN rm -rf example

WORKDIR publisher_integration_tests/app/

RUN dart pub get

ENTRYPOINT ["dart", "test", "bin/app.dart"]
