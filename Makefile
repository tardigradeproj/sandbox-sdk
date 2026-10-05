PROTOC ?= protoc
GOBIN  ?= $(shell go env GOPATH)/bin

PROTO_DIR    := api
PROTO_FILES  := $(wildcard $(PROTO_DIR)/*.proto)
PROTO_OUT    := pkg/api

.PHONY: proto proto-tools proto-clean

# Install the protoc plugins used to generate Go code.
proto-tools:
	go install google.golang.org/protobuf/cmd/protoc-gen-go@latest
	go install google.golang.org/grpc/cmd/protoc-gen-go-grpc@latest

# Generate Go/gRPC code from api/*.proto into pkg/api/.
proto:
	mkdir -p $(PROTO_OUT)
	PATH="$(GOBIN):$$PATH" $(PROTOC) \
		--proto_path=$(PROTO_DIR) \
		--go_out=$(PROTO_OUT) --go_opt=paths=source_relative \
		--go-grpc_out=$(PROTO_OUT) --go-grpc_opt=paths=source_relative \
		$(PROTO_FILES)

proto-clean:
	rm -f $(PROTO_OUT)/*.pb.go
