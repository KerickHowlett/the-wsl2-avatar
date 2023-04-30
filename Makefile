all: listen

build:
	@echo "Building wsl2-ssh-bridge..."
	@GOOS=windows go build -o wsl2-ssh-bridge.exe -ldflags -H=windowsgui main.go

SSH_PATH := "${USERPROFILE}/.ssh/"
install: build
	@echo "Installing wsl2-ssh-bridge..."
	@mkdir -p "${SSH_PATH}"
	@mv wsl2-ssh-bridge.exe "${SSH_PATH}"

IS_INSTALLED := $(shell [ -e where socat > NUL 2>&1 ] && echo 0 || echo 1)
listen: build
	@echo "Attempting to establish WSL2/SSH Bridge..."
ifeq ($(IS_INSTALLED), 0)
	@socat UNIX-LISTEN:ssh.sock,fork EXEC:"${SSH_PATH}/wsl2-ssh-bridge.exe"
	@echo "WSL2/SSH Bridge has been successfully established!"
else
	@echo "[ERROR]: Please install socat first!"
endif

