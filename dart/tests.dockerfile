# Specify the Dart SDK base image version using dart:<version> (ex: dart:2.12)
FROM dart:stable AS build

WORKDIR /publisher_integration_tests/app

COPY ../../ ./pipe/
RUN rm -rf pipe/example

COPY /publisher_integration_tests/app .

RUN dart pub get 
RUN dart compile exe bin/app.dart -o bin/executable

WORKDIR /
RUN cd publisher_integration_tests/app/bin; ls

# Build minimal serving image from AOT-compiled `/server` and required system
# libraries and configuration files stored in `/runtime/` from the build stage.
FROM scratch

COPY --from=build /runtime/ /
COPY --from=build publisher_integration_tests/app/bin/executable publisher_integration_tests/app/bin/

# Start server.
EXPOSE 8080
CMD ["/publisher_integration_tests/app/bin/executable"]