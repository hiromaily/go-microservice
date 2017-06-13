# Note: tabs by space can't not used for Makefile!
# -buildmode=plugin not supported on darwin/amd64
SRC_DIR=grpc
DST_DIR=grpc

###############################################################################
# Golang detection and formatter
###############################################################################
fmt:
	go fmt `go list ./... | grep -v '/vendor/'`

vet:
	go vet `go list ./... | grep -v '/vendor/'`

lint:
	golint ./... | grep -v '^vendor\/' || true
	misspell `find . -name "*.go" | grep -v '/vendor/'`
	ineffassign .

chk:
	go fmt `go list ./... | grep -v '/vendor/'`
	go vet `go list ./... | grep -v '/vendor/'`
	golint ./... | grep -v '^vendor\/' || true
	misspell `find . -name "*.go" | grep -v '/vendor/'`
	ineffassign .

###############################################################################
# Settings
###############################################################################
init:
	git clone https://github.com/micro/go-micro.git
	git clone https://github.com/grpc/grpc-go.git

	go get google.golang.org/grpc
	go get -u github.com/golang/protobuf/protoc-gen-go
	brew install protobuf

genproto:
	protoc -I=$(SRC_DIR) --go_out=$(DST_DIR) $(SRC_DIR)/protos/sample.proto


#https://github.com/golang/protobuf
#https://developers.google.com/protocol-buffers/docs/reference/go-generated
#protoc --go_out=plugins=grpc:protos/. protos/*.proto
#protoc --proto_path=grpc --go_out=grpc grpc/protos/*.proto
#protoc -I=$(SRC_DIR) --go_out=$(DST_DIR) $SRC_DIR/protos/sample.proto

###############################################################################
# Build
###############################################################################
#http://www.grpc.io/docs/quickstart/go.html

client:
	go build -i -v ./grpc/client/

server:
	go build -i -v ./grpc/server/

###############################################################################
# Run
###############################################################################
rserver:
	go run ./grpc/server/main.go

rclient:
	go run ./grpc/client/main.go


###############################################################################
# Run background
###############################################################################
#run:
#	go run ./grpc/server/main.go &
#	sleep 0.5s
#	go run ./grpc/client/main.go

listen:
	sudo lsof -i -P | grep "LISTEN"

showps:
	ps aux | grep 'go run gropc/server/main.go' | awk '{print $2}'

stop:
	kill $(ps aux | grep 'go run gropc/server/main.go' | awk '{print $2}')

