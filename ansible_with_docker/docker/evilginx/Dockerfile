# --- Etap 1: Kompilacja (Builder) ---
FROM golang:1.23-alpine AS builder

# Instalacja paczek potrzebnych do pobrania i skompilowania kodu
RUN apk add --no-cache git make gcc musl-dev

WORKDIR /src

# Pobranie oficjalnego repozytorium 
RUN git clone https://github.com/kgretzky/evilginx2.git .

# Kompilacja narzędzia
RUN make

# --- Etap 2: Lekki obraz docelowy ---
FROM alpine:latest

# Instalacja podstawowych certyfikatów (często wymagane przy ruchu sieciowym)
RUN apk add --no-cache ca-certificates tzdata

WORKDIR /app

# Skopiowanie wyłącznie gotowej aplikacji i niezbędnych szablonów z pierwszego etapu
COPY --from=builder /src/build/evilginx /app/evilginx
COPY --from=builder /src/phishlets /app/phishlets

# Porty używane przez Evilginx: HTTP, HTTPS, oraz DNS (do rozwiązywania nazw)
EXPOSE 80 443 53/udp

# Uruchomienie aplikacji
ENTRYPOINT ["/app/evilginx"]
