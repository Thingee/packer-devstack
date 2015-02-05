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

    $ glance image-list
    +--------------------------------------+---------------+-------------+------------------+-------------+--------+
    | ID                                   | Name          | Disk Format | Container Format | Size        | Status |
    +--------------------------------------+---------------+-------------+------------------+-------------+--------+
    | d88ae264-d2bb-42cf-8914-94042f579322 | ubuntu-trusty | qcow2       | bare             | 256180736   | active |
    +--------------------------------------+---------------+-------------+------------------+-------------+--------+

    $ packer build packer-devstack/openstack.json
    openstack output will be in this color.
    ==> openstack: Creating temporary keypair for this instance...
    ==> openstack: Waiting for server (0f263a60-b5e9-45f9-9b86-3cfe00a55b63) to become ready...
    ==> openstack: Waiting for SSH to become available...
    ==> openstack: Connected to SSH!
    ==> openstack: Provisioning with shell script: scripts/root_setup.sh
    
    ...
    
    openstack: Horizon is now available at http://172.30.128.6/
    openstack: Keystone is serving at http://172.30.128.6:5000/v2.0/
    openstack: Examples on using novaclient command line is in exercise.sh
    openstack: The default users are: admin and demo
    openstack: The password: secrete
    openstack: This is your host ip: 172.30.128.6
    openstack: 2015-02-02 20:44:20.464 | stack.sh completed in 1298 seconds.
    ==> openstack: Creating the image: test-devstack
    ==> openstack: Image: 84d4dcc9-4f19-46d5-9b6e-84c6d5b0f1fe
    ==> openstack: Waiting for image to become ready...
    ==> openstack: Terminating the source server...
    ==> openstack: Deleting temporary keypair...
    Build 'openstack' finished.
    
    $ glance image-list
    +--------------------------------------+-----------------+-------------+------------------+-------------+--------+
    | ID                                   | Name            | Disk Format | Container Format | Size        | Status |
    +--------------------------------------+-----------------+-------------+------------------+-------------+--------+
    | 84d4dcc9-4f19-46d5-9b6e-84c6d5b0f1fe | trusty-devstack | qcow2       | bare             | 2923757568  | active |
    | d88ae264-d2bb-42cf-8914-94042f579322 | ubuntu-trusty   | qcow2       | bare             | 256180736   | active |
    +--------------------------------------+-----------------+-------------+------------------+-------------+--------+

#### Start A DevStack Virtual Machine

    $ nova boot --image trusty-devstack --user-data packer-devstack/user-data/devstack.sh --flavor 3 --key-name mykey devstack-vm

This will first do a git pull on /opt/stack directories, and then run stack.sh:

    Updating cinder
    Already up-to-date.
    Updating glance
    Already up-to-date.
    Updating heat
    Already up-to-date.
    Updating heat-cfntools
    Already up-to-date.
    Updating heat-templates
    Already up-to-date.
    Updating horizon
    Already up-to-date.
    Updating keystone
    Already up-to-date.

    ...

    Horizon is now available at http://172.30.128.5/
    Keystone is serving at http://172.30.128.5:5000/v2.0/
    Examples on using novaclient command line is in exercise.sh
    The default users are: admin and demo
    The password: secrete
    This is your host ip: 172.30.128.5
    2015-02-05 23:04:35.165 | stack.sh completed in 332 seconds.
