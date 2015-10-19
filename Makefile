PACKER_VERSION := 0.8.6

default: release

release: tmp/packer.zip
	vagrant up release
	vagrant ssh release

source:
	vagrant up source
	vagrant ssh source

clean:
	rm -rf tmp/
	vagrant destroy -f

tmp/packer.zip: tmp/
	 wget --output-document tmp/packer.zip \
	   https://dl.bintray.com/mitchellh/packer/packer_$(PACKER_VERSION)_linux_amd64.zip
	 touch tmp/packer.zip

tmp/:
	mkdir -p tmp/

.PHONY: default release source
