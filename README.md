# Consul RPM Builder

Want a Consul RPM for CentOS? Great, that's what this project will give you!

# Building

All the build steps are handled by `make` in a [Makefile](Makefile).

The default make target will build a docker image with an RPM-build environment (based on [centos:7](https://hub.docker.com/_/centos)) then run a [build](build.sh) script to generate the RPM.

## Quick Start

```bash
git clone https://github.com/natemccurdy/consul-rpm-builder.git
cd consul-rpm-builder
make
```

## Result

An RPM and source RPM will be created in the `artifacts/` folder:
1. `RPMS/x86_64/consul-<version>-<release>.rpm` - The main RPM
1. `SRPMS/consul-<version><release>.src.rpm` - The source RPM

# Running

1. Install the RPM
2. Add configs to `/etc/consul/*`
3. Start the service and tail the logs: `systemctl start consul.service` and `journalctl -f --no-pager -u consul`
4. Optionally start on reboot with: `systemctl enable consul.service`

## Configuring

Config files are loaded in lexicographical order from the `config-dir` specified in `/etc/sysconfig/consul` (config package).

# Inspired By

* [myENA/consul-rpm](https://github.com/myENA/consul-rpm) - Originally forked from myENA, but I customized it so much that it ended up being easier to maintain as a new peoject.  Specifically, I only use Docker and I build and RPM with specs that match the [solarkennedy/puppet-consul](https://forge.puppet.com/KyleAnderson/consul) Puppet module and my personal preferences.

