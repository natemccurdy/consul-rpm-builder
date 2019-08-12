# Consul RPM Builder

Want a Consul RPM for CentOS? Great, that's what this project will give you!

The spec files in this project can generate:
* consul 1.5.1
* consul-template 0.21.0

# Building

All the build steps are handled by `make` in a [Makefile](Makefile).

The default make target will build a docker image (based on [centos:7](https://hub.docker.com/_/centos)) then run the [build](build.sh) script to generate the RPMs.

## Quick Start

Make all RPMS:

```bash
git clone https://github.com/natemccurdy/consul-rpm-builder.git
cd consul-rpm-builder
make
```

Make just the Consul RPM:
```bash
make consul
```

Make just the Consul Template RPM:
```bash
make consul-template
```

## Result

RPM's and source RPM's will be made in the `artifacts/` folder (created by the build process):
* `RPMS/x86_64/consul-<version>-<release>.rpm`
* `SRPMS/consul-<version><release>.src.rpm`
* `RPMS/x86_64/consul-template-<version>-<release>.rpm`
* `SRPMS/consul-template-<version><release>.src.rpm`

# Running

Consul:
1. Install the RPM
2. Add configs to `/etc/consul/*`
3. Start the service and tail the logs: `systemctl start consul.service` and `journalctl -f --no-pager -u consul`
4. Optionally start on reboot with: `systemctl enable consul.service`

Consul Template:
1. Install the RPM
2. Add configs to `/etc/consul-template/`
3. Start the service and tail the logs: `systemctl start consul-template.service` and `journalctl -f --no-pager -u consul`
4. Optionally start on reboot with: `systemctl enable consul-template.service`

## Configuring

Config files are loaded in lexicographical order from the `config-dir`.
* Consul - `/etc/consul/`
* Consul Template - `/etc/consul-template/`

# Inspired By

* [myENA/consul-rpm](https://github.com/myENA/consul-rpm) - Originally forked from myENA, but I customized it so much that it ended up being easier to maintain as a new peoject.  Specifically, I only use Docker and I build and RPM with specs that match the [solarkennedy/puppet-consul](https://forge.puppet.com/KyleAnderson/consul) Puppet module and my personal preferences.

