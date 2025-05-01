FROM golang:1.24 AS builder
#maximum version supported by tidy (should match with go.mod file or less)

WORKDIR /app
COPY go.mod ./
RUN go mod tidy
COPY . .
RUN CGO_ENABLED=0 GOOS=linux go build -o server .

# Final image
FROM alpine:latest
WORKDIR /root/
COPY --from=builder /app/server /
EXPOSE 8080

CMD ["/server"]
