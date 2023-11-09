# Specify the Dart SDK base image version using dart:<version> (ex: dart:2.12)
FROM dart:stable AS build

# Resolve app dependencies.
WORKDIR /app
COPY pubspec.* ./

# TODO: Resolve this, it makes no sense to copy the whole package
COPY /pipe ./pipe
# Does not work: https://stackoverflow.com/a/24540011/13595734
# COPY ../../ ./pipe

RUN dart pub get

# Copy app source code and AOT compile it.
COPY . .
# Ensure packages are still up-to-date if anything has changed
RUN dart pub get --offline
RUN dart compile exe bin/app.dart -o bin/executable

# Build minimal serving image from AOT-compiled `/server` and required system
# libraries and configuration files stored in `/runtime/` from the build stage.
FROM scratch
COPY --from=build /runtime/ /
COPY --from=build /app/bin/executable /app/bin/

# Start server.
EXPOSE 8080
CMD ["/app/bin/executable"]