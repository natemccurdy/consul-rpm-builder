#!/bin/bash
set -ex

: "${SOURCE:=/tmp/build}"
: "${BUILDDIR:=/root/rpmbuild}"

# Create the build folders.
rpmdev-setuptree

# Link the specs.
ln -sf "${SOURCE}"/SPECS/*.spec "${BUILDDIR}/SPECS"

# Link the sources.
ln -sf "${SOURCE}"/SOURCES/* "${BUILDDIR}/SOURCES"

# Get the Hashicorp public signing key
# https://www.hashicorp.com/security
gpg --keyserver hkp://keys.gnupg.net --recv-keys 51852D87348FFC4C

# Download any Source's mentioned in the specs.
for spec in "${BUILDDIR}"/SPECS/*.spec; do
  spectool -g -R "$spec"
done

# Build the source and binary RPM packages.
rpmbuild -ba "${BUILDDIR}"/SPECS/*.spec

# Copy the RPM's to the mounted volume and out of the container.
cp -v -r -f "${BUILDDIR}/RPMS" "${BUILDDIR}/SRPMS" /tmp/artifacts/
