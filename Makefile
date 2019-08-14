# https://grpc.io/docs/tutorials/basic/go/
# https://github.com/grpc/grpc-go/tree/
# https://github.com/grpc/grpc-go/tree/master/examples/route_guide

SRC_DIR=grpc
DST_DIR=grpc


###############################################################################
# Settings
###############################################################################
.PHONY: init
init:
	git clone https://github.com/micro/go-micro.git
	git clone https://github.com/grpc/grpc-go.git

	brew install protobuf
	go get google.golang.org/grpc
	go get -u github.com/golang/protobuf/protoc-gen-go

	go get github.com/golang/mock/gomock
	go install github.com/golang/mock/mockgen

.PHONY: update
update:
	brew upgrade protobuf
	go get -u google.golang.org/grpc
	go get -u github.com/golang/protobuf/protoc-gen-go
	protoc --version  # libprotoc 3.7.1

	go get -u github.com/golang/mock/gomock
	go install github.com/golang/mock/mockgen

.PHONY: generate
generate:
	go generate ./examples/route_guide/...

# Or
.PHONY: genproto
genproto:
	#protoc --go_out=plugins=grpc:. $(SRC_DIR)/protos/sample.proto
	protoc -I examples/route_guide/rg_proto --go_out=plugins=grpc:examples/route_guide/rg_proto examples/route_guide/rg_proto/route_guide.proto

# this code may be better to add to route_guide.pb.go
# //go:generate mockgen -source ./route_guide.pb.go -destination .../mocks/rg_mock.go
.PHONY: genmock
genmockmaster/examples:
	mockgen -source examples/route_guide/rg_proto/route_guide.pb.go -destination examples/route_guide/mocks/rg_mock.go

.PHONY: clean
clean:
	rm -rf go-micro
	rm -rf grpc-go

#https://github.com/golang/protobuf
#https://developers.google.com/protocol-buffers/docs/reference/go-generated
#protoc --go_out=plugins=grpc:protos/. protos/*.proto
#protoc --proto_path=grpc --go_out=grpc grpc/protos/*.proto
#protoc -I=$(SRC_DIR) --go_out=$(DST_DIR) $(SRC_DIR)/protos/sample.proto

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
	go run -race ./grpc/server/main.go

rclient:
	go run -race ./grpc/client/main.go


###############################################################################
# Run background
###############################################################################
#run:
#	go run -race ./grpc/server/main.go &
#	sleep 0.5s
#	go run -race ./grpc/client/main.go

listen:
	sudo lsof -i -P | grep "LISTEN"

showps:
	ps aux | grep 'go run gropc/server/main.go' | awk '{print $2}'

stop:
	kill $(ps aux | grep 'go run gropc/server/main.go' | awk '{print $2}')

