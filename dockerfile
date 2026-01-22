FROM dart:stable AS build

# 1. Set the working directory to the backend folder
WORKDIR /app/lib/backend

# 2. Copy only the backend's pubspec first to cache dependencies
# This matches your: ./lib/backend/pubspec.yaml
COPY lib/backend/pubspec.* ./
RUN dart pub get

# 3. Copy the rest of the backend source code
COPY lib/backend/ .

# 4. Activate Dart Frog and build the production bundle
RUN dart pub global activate dart_frog_cli
RUN dart pub global run dart_frog_cli:dart_frog build

# 5. Start a clean runtime image
FROM dart:stable
WORKDIR /app

# 6. Copy the built server from the 'build' stage
COPY --from=build /app/lib/backend/build /app/build

# 7. Expose the port Render expects
EXPOSE 8080

# 8. Start the server
# Address 0.0.0.0 is required for Render to route traffic to the container
CMD ["dart", "build/bin/main.dart", "--port", "8080", "--address", "0.0.0.0"]