.PHONY: default clean build run lib getwindowlib getmaclib package-linux package-windows package-mac package

default: build run

buildclean:
	@[[ ! -e igjam16.love ]] || rm igjam16.love

clean:
	@[[ ! -e igjam16.love ]] || rm igjam16.love
	@[[ ! -e pkg ]] || rm -r pkg
	@[[ ! -e lib ]] || rm -r lib
	@[[ ! -e temp ]] || rm -r temp

build: buildclean
	@zip -q -r -0 igjam16.love assets/*
	@cd src/ && zip -q -r ../igjam16.love *

build-fast:
	@zip -q -r -0 igjam16.love assets/*
	@./script/fast.sh
	@cd temp/ && zip -q -r ../igjam16.love *
	@rm -rf temp

fast: build-fast
	@love igjam16.love

run:
	@love igjam16.love

setup:
	git submodule update --init --recursive

package-linux: build
	@./script/download.sh linux
	@./script/package.sh linux

package-windows: build
	@./script/download.sh windows
	@./script/package.sh windows

package-mac: build
	@./script/download.sh osx
	@./script/package.sh osx
