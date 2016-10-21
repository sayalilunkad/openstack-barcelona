# Heat templates for master

In this directory you will find the following Heat templates:

* *cinder-encrypted.yaml:* builds an instance and attaches an encrypted Cinder volume to it
* *lbaas.yaml:* builds two instances behind a SSL enabled keystore

Both templates were tested on a Devstack instance built shortly before the
Summit. `lbaas.yaml` should work out of the box in this sort of environment.
For `cinder-encrypted.yaml` to work, you may need to adapt some configuration
settings for the following services:

* `Cinder`
* `Nova`

You will find commented configuration snippets for all affected files in the
`etc/` subdirectory. Both Heat templates contain a comment with an example Heat
client invocation at the top. You will probably have to modify this slighly for
your own use.
