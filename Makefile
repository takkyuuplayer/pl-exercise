all: setup

setup:
	carton install
	carton update
	mkdir -p cache
test: setup
	carton exec -- prove -Ilib -r t

perl:
	cd docker && $(MAKE) perl
