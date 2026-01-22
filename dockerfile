FROM dart:stable AS build

WORKDIR /app

# 1. Copy the backend folder from your repo into the /app/lib/backend folder in Docker
COPY lib/backend/ /app/lib/backend/

# 2. Move into that directory
WORKDIR /app/lib/backend

# 3. DEBUG: This will show us in the Render logs if pubspec.yaml exists
RUN ls -la

# 4. Get dependencies for the backend
RUN dart pub get

# 5. Build the Dart Frog production server
RUN dart pub global activate dart_frog_cli
RUN dart pub global run dart_frog_cli:dart_frog build

# --- Runtime Stage ---
FROM dart:stable
WORKDIR /app

# Copy the built output from the build stage
COPY --from=build /app/lib/backend/build /app/build

EXPOSE 8080

# Start the server
CMD ["dart", "build/bin/server.dart", "--port", "8080", "--address", "0.0.0.0"]