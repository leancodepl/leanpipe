FROM dart:stable AS build

COPY ../../ .

RUN rm -rf example

WORKDIR publisher_integration_tests/app/

RUN dart pub get

RUN dart compile exe bin/app.dart -o bin/executable

WORKDIR /

RUN ls

# Build minimal serving image from AOT-compiled executable and required system
# libraries and configuration files stored in `/runtime/` from the build stage.
FROM scratch

COPY --from=build /runtime/ /
COPY --from=build root/publisher_integration_tests/app/bin/executable publisher_integration_tests/app/bin/

CMD ["/publisher_integration_tests/app/bin/executable"]