FROM rust:1.56.0 AS builder 
WORKDIR /app

COPY . .
ENV SQLX_OFFLINE true

RUN cargo build --release --bin backend 

FROM debian:bullseye-slim AS runtime
WORKDIR /app

RUN apt-get update -y \
    && apt-get install -y --no-install-recommends openssl \
    # Clean up
    && apt-get autoremove -y \
    && apt-get clean -y \
    && rm -rf /var/lib/apt/lists/*

# Copy the build output from the builder stage
COPY --from=builder /app/target/release/backend backend 

# Copy configuration and .env file for runtime
COPY configuration configuration
COPY .env .env

ENV APP_ENVIRONMENT production

# You may need to adjust the ENTRYPOINT to use 'dotenv' if your application does not natively load '.env' files.
ENTRYPOINT ["./backend"]

