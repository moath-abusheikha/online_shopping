FROM dart:stable AS build

WORKDIR /app
COPY pubspec.* ./
RUN dart pub get

COPY . .
RUN dart pub global activate dart_frog_cli
RUN dart pub global run dart_frog_cli:dart_frog build

FROM dart:stable
WORKDIR /app
COPY --from=build /app/build /app/build

EXPOSE 8080
# Set address to 0.0.0.0 so Render can access it
CMD ["dart", "build/bin/main.dart", "--port", "8080", "--address", "0.0.0.0"]