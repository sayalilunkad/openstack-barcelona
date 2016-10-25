# Overview

## Talk contents

* What is Barbican?

* Packages for RDO and SUSE Openstack Cloud available now

* Secret Store Back-ends

* What are all these services about? `barbican-retry`, `barbican-keystone-listener`, `barbican-worker`

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

* Packages for RDO available

* Packages for SUSE OpenStack Cloud available

* Packages for Ubuntu already available

* Puppet modules and Chef cookbooks to install and configure Barbican are available

<!--

Puppet modules https://github.com/openstack/puppet-barbican have been
tested against RDO and are currently running in puppet integration tests.
A Crowbar Barclamp (Chef cookbook along with Crowbar Web UI integration) has
been developed and tested for SUSE OpenStack Cloud 7:
https://github.com/crowbar/crowbar-openstack/tree/master/chef/cookbooks/barbican

-->

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
The Barbican puppet modules set up Barbican by default over Apache using
mod_wsgi.

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
-->

## Barbican Architecture
![alt tag](http://docs.openstack.org/developer/barbican/_images/barbican-overall-architecture.gif)

## Secret Store Back-ends

* Operators need to decide how and where secrets are stored.

* Barbican has a plugin infrastructure, configured in barbican.conf

* As of Newton, multiple plugins can be enabled, and can be configured per project.

<!--

Configuring multiple plugins is useful when you need to provide different levels
of security. Secrets used by a development or test project could use the basic
development plugin, while some secrets may require a FIPS common criteria
certified storage mechanism using an HSM

-->

## Some Secret Store Plugins

* Development plugin
 * Secrets encrypted by symmetric key and stored in Barbican DB
 * Encryption key stored in plaintext in barbican.conf
 * NOT for production

* PKCS11 plugin
 * Secrets encrypted by project specific key encryption keys (KEK) and stored in Barbican DB
 * KEKs encrypted by Master KEK, which is stored in HSM using PKCS#11.
 * In production with Lunasa, but others possible.

## More Secret Store Plugins

* Dogtag Plugin
 * Secrets stored in Dogtag KRA
 * KRA is backed by either NSS database or HSM (through PKCS#11)
 * Lunasa and Thales netHSM tested, others possible.
 * FIPS/ Common Criteria etc.

* KMIP

 * Secrets stored in KMIP device


# Use Cases

## Use case: Encrypted Cinder Volumes

* Cinder can create LUKS encrypted volumes

* Keys in Barbican (for Nova to decrypt)

* Details: Heat templates and this morning's hands-on workshop

<!--

With the help of Barbican, Cinder can create LUKS encrypted volumes. For this
to work, Cinder will store the encryption key in a Barbican secret container.
From there, Nova can later retrieve it to attach the volume to an instance.
To this end, Nova will create a decrypted device on the compute node the target
instance resides on. This device gets attached to the instance - volume
encryption is transparent to the instance.

You may already have tried your hand at encrypted volumes in this morning's
"Secure Your Cinder" workshop. If you missed the workshop, don't worry. The
slides for our talk are publicly available (We'll provide a link at the end)
and come with a Heat template and instructions for creating encrypted Cinder
volumes. For the Heat template to work you may need to adjust some
configuration and you may also have to apply a patch. See the READMEs in the
heat-templates/ directory and below for details.

-->

## Use case: Magnum Cluster Certificates

* Magnum: acts as a CA for its clusters

* CA certificates are stored in Barbican by default

* Trivial to set up: Have barbican running and `cert_manager_type=barbican` in
  `magnum.conf` (default setting).

<!--

This one is a bit more mundane. When Magnum creates a cluster of multiple
instances and the container orchestration engine riding herd on these instances
(such as Kubernetes) is using SSL, all instances need SSL certificates signed
by a CA. Magnum generates such a CA for each cluster and stores its keys in
Barbican. The instances then use the Magnum API to retrieve the CA's
certificate and submit CSRs for their own certificates to Magnum.

This is trivial to set up so we haven't provided a heat template. All you need
is make sure your OpenStack cloud is running Barbican when you roll out Magnum
and ensure the cert_manager setting in magnum.conf is at its default of
"barbican".

-->

## Use case: Load Balancer as a Service

* Neutron LBaaS supports SSL termination now.

* Certificates stored in Barbican.

* Neutron spawns a dedicated instance or configures an SSL termination
  appliance (various plugins available).

* See Heat template for details.

<!--

Finally, we've got another non-trivial use case: SSL termination on Neutron's
Load Balancer as a Service. This requires the neutron_lbaas plugin in Neutron
to be enabled.

Conceptually it's fairly simple: Neutron's got tons of backend drivers for Load
Balancer as a Service. A fair amount of these (not least Neutron's own haproxy
driver) support SSL. neutron_lbaas takes care of storing these certificates for
deferred operations that may happen well after load balancer creation (for
instance in a failover scenario) and passes them into its drivers as required.
For storing the secrets it uses a Barbican secret container.

There's no workshop for this one, but we created another Heat template for
building a SSL enabled Neutron load balancer. You'll find this template in the
talk's repository as well. Again, you may need to configure some things for
this to work. See our READMEs and the comments in the Heat templates for
details.

-->
