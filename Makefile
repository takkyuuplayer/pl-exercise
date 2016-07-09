all: setup

setup:
	carton install
	mkdir -p cache
test: setup
	carton exec -- prove -Ilib -r t
