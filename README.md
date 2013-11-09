# sprout-dev

A development and automated test environment for [Sprout](https://github.com/pivotal-sprout/sprout).

### Dependencies

1. [Vmware Fusion](http://www.vmware.com/products/fusion/overview.html)
1. [Packer](http://www.packer.io/)
1. [Vagrant 1.3.5+](http://www.vagrantup.com/)
1. Vagrant's [Vmware Fusion Provider](http://www.vagrantup.com/vmware)
1. Tim Sutton's [osx-vm-templates](https://github.com/timsutton/osx-vm-templates) for building an OSX box with Packer
1. [ServerSpec](http://serverspec.org/)

### Creating a Mountain Lion box for Vagrant with Packer

1. Clone Tim Sutton's [osx-vm-templates](https://github.com/timsutton/osx-vm-templates)

    ```
    git clone https://github.com/timsutton/osx-vm-templates
    ```

1. Extract a Packer compatible image from the OSX Mountain Lion installer

    ```
    cd osx-vm-templates
    sudo prepare_iso/prepare_iso.sh "/Applications/Install OS X Mountain Lion.app" out
    ```

    Take note of the checksum of the generated image and its full path from the output of this command, you'll need this in a moment.

1. Edit the Packer template [packer/template.json](https://github.com/timsutton/osx-vm-templates/blob/master/packer/template.json)

    1. Change [iso_checksum](https://github.com/timsutton/osx-vm-templates/blob/master/packer/template.json#L8) to the checksum of the image generated earlier
    1. Change [iso_url](https://github.com/timsutton/osx-vm-templates/blob/master/packer/template.json#L9) to the absolute path of the image generated earlier, keep the `file:///` prefix.
    1. Remove the `chef-omnibus.sh` and `puppet.sh` scripts from the list of [provisioners](https://github.com/timsutton/osx-vm-templates/blob/master/packer/template.json#L35)
    1. Don't forget to save the file!

1. Create a new box with Packer

    ```
    cd packer
    packer build template.json
    ```

1. Add the box generated earlier to Vagrant

    ```
    vagrant box add mountain-lion packer_vmware_vmware.box
    ```

### Starting the OSX guest with Vagrant

1. Clone this repo

    ```
    git clone --recursive https://github.com/hiremaga/sprout-dev
    ```

1. Start vagrant using this repo's Vagrantfile

    ```
    cd sprout-dev
    vagrant up --provider vmware_fusion
    ```

### Run specs

```
bundle install
bundle exec rspec
```

If everything is setup correctly the output should be:

```
→ bundle exec rspec

sprout-osx-apps::chrome
  installs Google Chrome into /Applications

Command "uname"
  should return stdout "Darwin"

Finished in 5.54 seconds
2 examples, 0 failures
```
