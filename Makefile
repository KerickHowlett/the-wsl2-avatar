all: build install listen

build:
	GOOS=windows go build -o wsl2-ssh-bridge.exe -ldflags -H=windowsgui main.go

install: build
	SSH_PATH := "${env:USERPROFILE}/.ssh/"
	mkdir -p $(SSH_PATH)
	mv wsl2-ssh-bridge.exe $(SSH_PATH)

listen: build
	socat UNIX-LISTEN:ssh.sock,fork EXEC:./wsl2-ssh-bridge.exe
