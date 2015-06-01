all: test

setup:
	mkdir -p cache
test: setup
	carton exec -- prove -Ilib -r t
