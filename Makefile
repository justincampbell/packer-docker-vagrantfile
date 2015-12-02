PACKER_VERSION = $(shell curl https://checkpoint-api.hashicorp.com/v1/check/packer | jq .current_version | tr -d '"')

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
	   https://releases.hashicorp.com/packer/$(PACKER_VERSION)/packer_$(PACKER_VERSION)_linux_amd64.zip
	 touch tmp/packer.zip

tmp/:
	mkdir -p tmp/

.PHONY: default release source
