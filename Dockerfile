FROM golang:alpine AS builder
RUN apk add --no-cache git
RUN go get -d github.com/gorilla/handlers \
  github.com/gorilla/mux \
  github.com/sabhiram/go-wol \
  github.com/gocarina/gocsv

WORKDIR /app
COPY . .
RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o main .

# Docker run Go app
FROM scratch
WORKDIR /app/
COPY --from=builder /app/main /app/ 
COPY pages /app/pages/

ENTRYPOINT ["/app/main"]  

EXPOSE 8080
