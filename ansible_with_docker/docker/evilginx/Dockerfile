# --- Builder ---
FROM golang:1.23-alpine AS builder

# Build dependencies
RUN apk add --no-cache git make gcc musl-dev

WORKDIR /src
 
RUN git clone https://github.com/kgretzky/evilginx2.git .

RUN make

# --- Image ---
FROM alpine:latest

# Required for network requests and timestamps
RUN apk add --no-cache ca-certificates tzdata

WORKDIR /app

COPY --from=builder /src/build/evilginx /app/evilginx
COPY --from=builder /src/phishlets /app/phishlets

EXPOSE 80 443 53/udp

ENTRYPOINT ["/app/evilginx"]
