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

* audited.json

  A collection a recipes that any node that is audited in some
  way will have.

* base.json

  A collection of recipes that ALL nodes in the OpenStack cluster
  will have. Every non-base role includes this role in its run list.

* booted.json

  An interim state that ALL nodes are initially checked into, before
  they are assigned their proper role.

  In this role it is safe to perform tasks which require a reboot, such
  as configuring grub with SOL, udev changes, static IP pivoting, etc...

* infra-access.json

  A role used to configure remote access into a zone.  Primarily used
  to configure SSH on a public interface.  However, will probably be
  used to configure VPN access.

* infra-caching.json

  A collection of recipes that configures caching on nodes in an environment.
  Uses memcached by default.

* graphed.json

  A collection of recipes that any node that is graphed will
  have.

* monitored.json

  A collection of recipes that any node that is monitored will
  have.

* logged.json

  A collection a recipes that any node that has services logged
  in some way will have.

* ssl-proxied.json

  A collection of recipes that sets up nginx or some other proxy
  for terminating SSL connections.

* system-tools

  A collection of recipes that installs system administration tools.

* arista-switch

  A collection of recipes that run on Arista switches for management.

## Zone roles

Each deployment zone also has a single role definition that all nodes
in the zone will be assigned. This allows us to circumvent Chef's restriction
that a node can only be assigned a single Chef **environment**.

The zone role definitions contain zone-specific URIs for OpenStack endpoints,
and this enables us to get around the current `osops-utils::ip_location`
automatic IP assignment of OpenStack endpoints based on a network name.

The Chef **environments**, meanwhile, are just common sets of attributes
that different types of deployments share, such as CI or production zones.

## Worker roles

There are a set of role definitions that control what services
run on a service node.

* infra-graphing.json

  A node having this role has graphing software installed.  This
  enables graphing of nodes that have the graphed.json role
  in their run list.

* infra-monitoring.json

  A node having this role has monitoring software installed.  This
  enables monitoring of nodes that have the monitored.json role
  in their run list.

* infra-console-logging.json

  A node having this role has console logging software installed.  This
  enables the collection of serial console logging from all nodes.

* infra-logging.json

  A node having this role has logging software installed.  This
  enables the collection of syslog events from nodes that have the
  logged.json role in their run list.

* infra-messaging.json

  A node having this role has a message queue server installed that
  services OpenStack services.

* infra-db-openstack.json

  A node having this role has a database server installed that
  services backend databases for OpenStack services (except Identity
  database, which is infra-db-identity).

* infra-db-identity.json

  A node having this role has a database server installed that
  services backend database cluster for OpenStack Identity.

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

* infra-db-all.json

  Database infrastructure role composed of the following roles:

  * infra-db-openstack.json
  * infra-db-identity.json

* infra-all.json

  An all-in-one infrastructure role composed of the following roles:

  * infra-monitoring.json
  * infra-messaging.json
  * infra-db-all.json
  * logged.json

* openstack-web.json

  A node having this role functions as a front-end, public-facing
  web server for OpenStack's dashboard and other web assets. It is
  composed of several subroles:

  * openstack-dashboard.json
  * ssl-proxied.json
  * monitored.json
  * logged.json

* openstack-identity.json

  A node having this role functions as the authentication and
  authorization service for the OpenStack cluster. It is composed
  of several breakout roles:

  * openstack-identity-api.json
  * openstack-identity-admin-api.json
  * ssl-proxied.json
  * monitored.json
  * logged.json

* openstack-volume.json

  A node having this role functions as a complete block storage
  service for the OpenStack cluster. It is composed
  of several breakout roles:

  * openstack-volume-api.json
  * openstack-volume-scheduler.json
  * openstack-volume-worker.json
  * ssl-proxied.json
  * monitored.json
  * logged.json

* openstack-compute-api.json

  A node having this role functions as a public-facing Compute API
  server. There are two breakdown roles that this role encompasses:

  * openstack-compute-api-native.json
  * openstack-compute-api-ec2.json
  * ssl-proxied.json
  * monitored.json
  * logged.json

* openstack-compute-controller.json

  A node having this role functions as an all-in-one controller that
  is composed of a number of subroles:

  * openstack-compute-api.json
  * openstack-compute-scheduler.json
  * openstack-identity.json
  * openstack-image.json
  * openstack-volume-api.json
  * openstack-volume-scheduler.json
  * openstack-network-api.json or openstack-compute-network.json (mutex)
  * openstack-compute-cert.json
  * monitored.json
  * logged.json

* openstack-image.json

  A node having this role functions as the image service for the OpenStack
  cluster. It is composed of several breakout roles:

  * openstack-image-api.json
  * openstack-image-registry.json
  * monitored.json
  * logged.json

* openstack-compute-worker-multihost.json

  Sets up the OpenStack Compute worker service (nova-compute) in `multi_host`
  networking mode, which requires the nova-network and nova-metadata-api
  services to run on the same host, therefore this role composes:

  * openstack-compute-api-metadata.json
  * openstack-compute-worker.json
  * openstack-compute-network.json
