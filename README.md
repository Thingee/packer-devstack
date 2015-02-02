# packer-devstack
Have packer create a virtual machine image of DevStack within OpenStack. This will take an Ubuntu Trusty image in Glance and start up a virtual machine in Nova with it. Using this as the base, it will install DevStack on the virtual machine, set local.conf to OFFLINE=true, upload the state of the virtual machine to Glance, and destroy the virtual machine. The end result is you have an image in Glance ready to start up DevStack in around 3 minutes!

### Getting Started

#### Download the base image

    wget https://cloud-images.ubuntu.com/trusty/current/trusty-server-cloudimg-amd64-disk1.img
    glance image-create --name ubuntu-trusty --disk-format qcow2 --container-format bare --file trusty-server-cloudimg-amd64-disk1.img
    

#### Edit the openstack.json file
**provider**: Your keystone public endpoint.

**ssh_username**: This is user to login as on the base image. This image has a cloud-init ran with an 'ubuntu' user expected, so this should just be ubuntu as i.s

**image_name**: What to name your DevStack image in Glance.

**source_image**: The image_id you get from glance image-create above.

**flavor**: A flavor to use on the virtual machine that's starting with the base image to build up DevStack on it. Devstack docs recommend at least 2GB of memory or more.

#### Run Packer

    packer build packer-devstack/openstack.json
    
## Dependencies
* [OpenStack](http://www.openstack.org/software)
* [Packer](http://packer.io)
