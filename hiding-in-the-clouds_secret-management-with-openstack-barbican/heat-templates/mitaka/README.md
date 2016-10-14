# Heat templates for stable/mitaka

In this directory you will find the following Heat templates:

* *cinder-encrypted.yaml:* builds an instance and attaches an encrypted Cinder volume to it
* *lbaas.yaml:* builds two instances behind a SSL enabled keystore

For these Heat templates to work, you will need to adapt some configuration
settings in the following files:

* `cinder.conf`
* `heat.conf`
* `nova.conf`
* `neutron.conf`
* `neutron_lbaas.conf`

You will find commented configuration snippets for each of these files in the
`etc/` subdirectory. Both Heat templates contain a comment with an example Heat
client invocation at the top. You will probably have to modify this slighly for
your own use.

For encrypted Cinder volumes to work through Heat, you will also need to apply
the patch attached to this bug:

https://bugs.launchpad.net/cinder/+bug/1631078
