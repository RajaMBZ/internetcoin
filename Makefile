# This Makefile is meant to be used by people that do not usually work
# with Go source code. If you know what GOPATH is then you probably
# don't need to bother with make.

.PHONY: internetcoin android ios internetcoin-cross swarm evm all test clean
.PHONY: internetcoin-linux internetcoin-linux-386 internetcoin-linux-amd64 internetcoin-linux-mips64 internetcoin-linux-mips64le
.PHONY: internetcoin-linux-arm internetcoin-linux-arm-5 internetcoin-linux-arm-6 internetcoin-linux-arm-7 internetcoin-linux-arm64
.PHONY: internetcoin-darwin internetcoin-darwin-386 internetcoin-darwin-amd64
.PHONY: internetcoin-windows internetcoin-windows-386 internetcoin-windows-amd64
##export GOPATH=$(pwd)
GOBIN = $(shell pwd)/build/bin
GO ?= latest

internetcoin:
	build/env.sh go run build/ci.go install ./cmd/internetcoin
	@echo "Done building."
	@echo "Run \"$(GOBIN)/internetcoin\" to launch internetcoin."

swarm:
	build/env.sh go run build/ci.go install ./cmd/swarm
	@echo "Done building."
	@echo "Run \"$(GOBIN)/swarm\" to launch swarm."

all:
	build/env.sh go run build/ci.go install

android:
	build/env.sh go run build/ci.go aar --local
	@echo "Done building."
	@echo "Import \"$(GOBIN)/internetcoin.aar\" to use the library."

ios:
	build/env.sh go run build/ci.go xcode --local
	@echo "Done building."
	@echo "Import \"$(GOBIN)/internetcoin.framework\" to use the library."

test: all
	build/env.sh go run build/ci.go test

clean:
	rm -fr build/_workspace/pkg/ $(GOBIN)/*

# The devtools target installs tools required for 'go generate'.
# You need to put $GOBIN (or $GOPATH/bin) in your PATH to use 'go generate'.

devtools:
	env GOBIN= go get -u golang.org/x/tools/cmd/stringer
	env GOBIN= go get -u github.com/kevinburke/go-bindata/go-bindata
	env GOBIN= go get -u github.com/fjl/gencodec
	env GOBIN= go get -u github.com/golang/protobuf/protoc-gen-go
	env GOBIN= go install ./cmd/abigen
	@type "npm" 2> /dev/null || echo 'Please install node.js and npm'
	@type "solc" 2> /dev/null || echo 'Please install solc'
	@type "protoc" 2> /dev/null || echo 'Please install protoc'

# Cross Compilation Targets (xgo)

internetcoin-cross: internetcoin-linux internetcoin-darwin internetcoin-windows internetcoin-android internetcoin-ios
	@echo "Full cross compilation done:"
	@ls -ld $(GOBIN)/internetcoin-*

internetcoin-linux: internetcoin-linux-386 internetcoin-linux-amd64 internetcoin-linux-arm internetcoin-linux-mips64 internetcoin-linux-mips64le
	@echo "Linux cross compilation done:"
	@ls -ld $(GOBIN)/internetcoin-linux-*

internetcoin-linux-386:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=linux/386 -v ./cmd/internetcoin
	@echo "Linux 386 cross compilation done:"
	@ls -ld $(GOBIN)/internetcoin-linux-* | grep 386

internetcoin-linux-amd64:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=linux/amd64 -v ./cmd/internetcoin
	@echo "Linux amd64 cross compilation done:"
	@ls -ld $(GOBIN)/internetcoin-linux-* | grep amd64

internetcoin-linux-arm: internetcoin-linux-arm-5 internetcoin-linux-arm-6 internetcoin-linux-arm-7 internetcoin-linux-arm64
	@echo "Linux ARM cross compilation done:"
	@ls -ld $(GOBIN)/internetcoin-linux-* | grep arm

internetcoin-linux-arm-5:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=linux/arm-5 -v ./cmd/internetcoin
	@echo "Linux ARMv5 cross compilation done:"
	@ls -ld $(GOBIN)/internetcoin-linux-* | grep arm-5

internetcoin-linux-arm-6:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=linux/arm-6 -v ./cmd/internetcoin
	@echo "Linux ARMv6 cross compilation done:"
	@ls -ld $(GOBIN)/internetcoin-linux-* | grep arm-6

internetcoin-linux-arm-7:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=linux/arm-7 -v ./cmd/internetcoin
	@echo "Linux ARMv7 cross compilation done:"
	@ls -ld $(GOBIN)/internetcoin-linux-* | grep arm-7

internetcoin-linux-arm64:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=linux/arm64 -v ./cmd/internetcoin
	@echo "Linux ARM64 cross compilation done:"
	@ls -ld $(GOBIN)/internetcoin-linux-* | grep arm64

internetcoin-linux-mips:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=linux/mips --ldflags '-extldflags "-static"' -v ./cmd/internetcoin
	@echo "Linux MIPS cross compilation done:"
	@ls -ld $(GOBIN)/internetcoin-linux-* | grep mips

internetcoin-linux-mipsle:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=linux/mipsle --ldflags '-extldflags "-static"' -v ./cmd/internetcoin
	@echo "Linux MIPSle cross compilation done:"
	@ls -ld $(GOBIN)/internetcoin-linux-* | grep mipsle

internetcoin-linux-mips64:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=linux/mips64 --ldflags '-extldflags "-static"' -v ./cmd/internetcoin
	@echo "Linux MIPS64 cross compilation done:"
	@ls -ld $(GOBIN)/internetcoin-linux-* | grep mips64

internetcoin-linux-mips64le:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=linux/mips64le --ldflags '-extldflags "-static"' -v ./cmd/internetcoin
	@echo "Linux MIPS64le cross compilation done:"
	@ls -ld $(GOBIN)/internetcoin-linux-* | grep mips64le

internetcoin-darwin: internetcoin-darwin-386 internetcoin-darwin-amd64
	@echo "Darwin cross compilation done:"
	@ls -ld $(GOBIN)/internetcoin-darwin-*

internetcoin-darwin-386:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=darwin/386 -v ./cmd/internetcoin
	@echo "Darwin 386 cross compilation done:"
	@ls -ld $(GOBIN)/internetcoin-darwin-* | grep 386

internetcoin-darwin-amd64:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=darwin/amd64 -v ./cmd/internetcoin
	@echo "Darwin amd64 cross compilation done:"
	@ls -ld $(GOBIN)/internetcoin-darwin-* | grep amd64

internetcoin-windows: internetcoin-windows-386 internetcoin-windows-amd64
	@echo "Windows cross compilation done:"
	@ls -ld $(GOBIN)/internetcoin-windows-*

internetcoin-windows-386:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=windows/386 -v ./cmd/internetcoin
	@echo "Windows 386 cross compilation done:"
	@ls -ld $(GOBIN)/internetcoin-windows-* | grep 386

internetcoin-windows-amd64:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=windows/amd64 -v ./cmd/internetcoin
	@echo "Windows amd64 cross compilation done:"
	@ls -ld $(GOBIN)/internetcoin-windows-* | grep amd64
