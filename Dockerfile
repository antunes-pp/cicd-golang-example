FROM golang:1.21.1-alpine3.18 AS buildstage

WORKDIR /go/src/app

COPY . .

RUN apk update

RUN go mod tidy

RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -ldflags "-s -w" -o api ./cmd/api

FROM alpine:3.18 AS finalstage

ENV PORT=4200

WORKDIR /app

COPY --from=buildstage /go/src/app/api .

EXPOSE $PORT

CMD ["/app/api"]

