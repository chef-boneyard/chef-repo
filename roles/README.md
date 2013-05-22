# Roles used in an OpenStack deployment

We structure the roles used in the deployment into neat,
easily encapsulated building blocks. Service nodes will
take on one or more roles in the deployment, and having
role definitions simple and combinable makes it easy to
identify what purpose a node serves in the cluster by simply
looking at the roles the node lists.

## Base roles

There are a set of role definitions that serve as building
blocks for other roles:

* base.json

  A collection of recipes that ALL nodes in the OpenStack cluster
  will have. Every non-base role includes this role in its run list.

* booted.json

  An interim state that ALL nodes are initially checked into, before
  they are assigned their proper role.

  In this role it is safe to perform tasks which require a reboot, such
  as configuring grub with SOL, udev changes, static IP pivoting, etc...

* graphed.json

  A collection of recipes that any node that is graphed will
  have.

* logged.json

  A collection a recipes that any node that has services logged
  in some way will have.

* system-tools

  A collection of recipes that installs system administration tools.

## Worker roles

There are a set of role definitions that control what services
run on a service node.

* openstack-base.json

  A base role applied to all openstack nodes.

* openstack-dashboard.json

  Sets up the Horizon OpenStack dashboard.

* openstack-identity-api.json

  Sets up the OpenStack Identity API service (commonly called
  Keystone).

* openstack-identity-admin-api.json

  Sets up the OpenStack Identity Admin API service.

* openstack-compute-api-native.json

  Sets up and runs the native OpenStack Compute API service.

* openstack-compute-api-ec2.json

  Sets up the EC2 compatible API service.

* openstack-compute-api-ec2-metadata.json

  Sets up the EC2 Metadata API service on the node.

* openstack-compute-worker.json

  Sets up the OpenStack Compute worker service (nova-compute).

* openstack-compute-scheduler.json

  Sets up the OpenStack Compute scheduler service.

* openstack-compute-network.json

  Sets up the Nova OpenStack network service - incompatible
  with the openstack-network-api role, which represents the
  newer Quantum OpenStack Network API service.

* openstack-compute-cert.json

  Sets up the OpenStack Compute cert service.

* openstack-compute-vncproxy.json

  Sets up the OpenStack Compute (No)VNC Proxy service.

* openstack-image-api.json

  Sets up the OpenStack Image API service (commonly called
  Glance).

* openstack-image-registry-api.json

  Sets up the OpenStack Image Registry service.

* openstack-network-api.json

  Sets up the Quantum OpenStack Network API service.

* openstack-volume-api.json

  Sets up the OpenStack Volume API service (commonly called
  Cinder).

* openstack-volume-scheduler.json

  Sets up the OpenStack Volume scheduler service.

* openstack-volume-worker.json

  Sets up the OpenStack Volume worker service (cinder-volume).

## Aggregate roles

These roles are composed of more granular roles:

* openstack-compute-worker-multihost.json

  Sets up the OpenStack Compute worker service (nova-compute) in `multi_host`
  networking mode, which requires the nova-network and nova-metadata-api
  services to run on the same host, therefore this role composes:

  * openstack-compute-api-metadata.json
  * openstack-compute-worker.json
  * openstack-compute-network.json
