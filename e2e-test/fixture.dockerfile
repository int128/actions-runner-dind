FROM golang:1.20 as builder
WORKDIR /workspace
COPY fixture.go /workspace
RUN CGO_ENABLED=0 go build -o main /workspace/fixture.go

FROM gcr.io/distroless/static:nonroot
WORKDIR /
COPY --from=builder /workspace/main .
USER 65532:65532
CMD ["/main"]
