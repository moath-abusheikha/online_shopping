FROM dart:stable AS build

WORKDIR /app

# Copy the backend folder specifically
# Ensure your local path is lib/backend/
COPY lib/backend/ /app/lib/backend/

# Move into the backend directory
WORKDIR /app/lib/backend

# Get dependencies for the backend
RUN dart pub get

# Activate dart_frog and build
RUN dart pub global activate dart_frog_cli
RUN dart pub global run dart_frog_cli:dart_frog build

FROM dart:stable
WORKDIR /app

# Copy the build output
COPY --from=build /app/lib/backend/build /app/build

EXPOSE 8080

CMD ["dart", "build/bin/main.dart", "--port", "8080", "--address", "0.0.0.0"]