# Overview

## Talk contents

* What is Barbican?

* Packages for RDO (RPM Distribution of OpenStack) and SOC SUSE Openstack Cloud available now

* What are all these services about? - barbican-retry, barbican-keystone-listener, barbican-worker

* Use cases: Encrypted cinder volumes, Magnum Cluster certificates, LBaaS

## What is Barbican?

* Getting key material into instances in a secure manner

* Secure Storage for key material (passwords, keys, certificates, arbitrary binary data)

* Provisioning: Interaction with CAs

<!--
Barbican has three main tasks: distributing and storing key material,
and interaction with CAs.

OpenStack instances need various secrets, such as SSL keys, passwords to
authenticate against databases or APIs outside an instance or encryption
keys to access storage volumes. Barbican can get these into an instance
in a secure, auditable manner.

Since instances may be short-lived, it also provides secure, long-term
storage for such secrets. If an instance is rebuilt - as can happen in a
cloud based setup - its secrets can be retrieved from Barbican's secret
storage using a Keystone token.

Last but not least, instances can use Barbican to access certificate
authorities supported by Barbican plugins to submit certificate sign
requests to these CAs through a uniform API.

-->

## More packages available now

* Packages for RDO (RPM Distribution of OpenStack) available

* Packages for SOC (SUSE OpenStack Cloud) available

* Packages for Ubuntu already available

## Barbican Services 101

* barbican-api: interaction with users and instances

* barbican-worker: handles communication with external
  CAs

* barbican-retry: legacy service used for TLS certificate generation

* barbican-keystone-listener: cleans up Barbican resources upon
  Keystone user deletion

<!--

barbican-api is Barbican's main point of contact for the outside world.
Users use it to create secrets, secret containers and
certificates. Instances use it to retrieve their secrets and submit
their certificate sign requests. A note on operations: this should be
run using some sort of WSGI enabled web server. If you install a
package, this won't be a problem SUSE and Ubuntu provide Apache
configuration for running barbican-api using mod_wsgi, while RDO
provides configuration for running it in the gunicorn web server.

barbican-worker is a RabbitMQ driven service that handles communicating
with external CAs for certificate signing requests. It's possible to
have an arbitrary number of workers Synchronization between workers
happens by the consumption of RabbitMQ messages being atomic.

barbican-retry is only used to support TLS certificate generation. It is
scheduled to be removed at some point now. As a rule, you won't need the
retry process for asymmetric and symmetric key generation

barbican-keystone-listener is a cleanup tool that eavesdrops on
Keystone's RabbitMQ queues and cleans up Barbican resources when
projects/users get deleted.

TODO alee: Is this suitable for use? (has been broken throughout Mitaka,
see https://review.openstack.org/#/c/339052/)
-->

## Barbican Architecture
![alt tag](http://docs.openstack.org/developer/barbican/_images/barbican-overall-architecture.gif)

# Use Cases

## Use case: Encrypted Cinder Volumes

## Use case: Magnum Cluster Certificates

## Use case: Load Balancer as a Service

<!--
Let's start this off by giving you a short refresher on what Barbican is and
what it does.
-->
