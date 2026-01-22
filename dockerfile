FROM dart:stable AS build

WORKDIR /app

# Copy the backend folder specifically
COPY lib/backend/ /app/backend/

# Move into the backend directory
WORKDIR /app/backend

# Clean any local residue and get fresh packages
RUN rm -rf .dart_frog build .dart_tool build pubspec.lock
RUN dart pub get

# Build the production bundle
RUN dart pub global activate dart_frog_cli
RUN dart pub global run dart_frog_cli:dart_frog build

FROM dart:stable
WORKDIR /app

# Copy the build output from the build stage
COPY --from=build /app/backend/build /app/build

EXPOSE 8080

CMD ["dart", "build/bin/server.dart", "--port", "8080", "--address", "0.0.0.0"]