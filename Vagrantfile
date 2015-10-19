Vagrant.configure(2) do |config|
  config.vm.box = 'ubuntu/trusty64'

  config.vm.provider :virtualbox do |vbox|
    vbox.cpus = 2
    vbox.memory = 2048
  end

  config.vm.synced_folder '../', '/vagrant'

  config.vm.provision :shell, inline: <<-SHELL
    which docker || {
      apt-get install -y wget

      wget -qO- https://get.docker.com/ | sh
    }
    docker version
  SHELL

  config.vm.define :release do |config|
    config.vm.provision :file,
      source: "tmp/packer.zip",
      destination: "/tmp/packer.zip"

    config.vm.provision :shell, inline: <<-SHELL
      set -e

      which packer || {
        apt-get install -y unzip
        unzip -o /tmp/packer.zip -d /usr/local/bin/
      }
      packer version
    SHELL
  end

  config.vm.define :source do |config|
    config.vm.provision :shell, inline: <<-SHELL
      set -e

      which go || {
        apt-get install -y wget

        wget --output-document=go.tar.gz \
          https://storage.googleapis.com/golang/go1.4.2.linux-amd64.tar.gz

        tar -C /usr/local -xzf go.tar.gz
        cp /usr/local/go/bin/* /usr/local/bin/
      }
      export GOPATH=/usr/share/go
      mkdir -p $GOPATH
      export PATH=$PATH:$GOPATH/bin:/usr/local/go/bin
      go version

      which packer || {
        apt-get install -y bzr git

        [ -d $GOPATH/src/github.com/mitchellh/packer/ ] || {
          git clone https://github.com/mitchellh/packer.git \
            $GOPATH/src/github.com/mitchellh/packer
        }

        cd $GOPATH/src/github.com/mitchellh/packer
        git pull
        make updatedeps
        make dev
        cd
        cp -R $GOPATH/bin/* /usr/local/bin
      }
      packer version
    SHELL
  end
end
