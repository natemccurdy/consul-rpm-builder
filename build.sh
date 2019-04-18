#!/bin/bash
set -ex

: "${ARTIFACTS:+}"    # If ARTIFACTS exists, copy built RPMs to it.
: "${BUILDDIR:=.}"    # Use CWD as the default build dir
: "${SOURCE:?}"       # SOURCE must be set via environment variables.
: "${SPEC_FILE:=all}" # Which spec file to process. Will do all specs if unset.
: "${HASHI_PUB_KEY_ID:=51852D87348FFC4C}"

# Create the build folders.
mkdir -p ${BUILDDIR}/{SPECS,SOURCES,RPMS,SRPMS}

# Link the specs.
if [[ $SPEC_FILE == all ]]; then
  ln -sf "${SOURCE}"/SPECS/*.spec "${BUILDDIR}/SPECS"
else
  ln -sf "${SOURCE}"/SPECS/"${SPEC_FILE}".spec "${BUILDDIR}/SPECS"
fi

# Link the sources.
ln -sf "${SOURCE}"/SOURCES/* "${BUILDDIR}/SOURCES"

# Get the Hashicorp public signing key
# https://www.hashicorp.com/security
gpg --keyserver hkp://keys.gnupg.net --recv-keys "$HASHI_PUB_KEY_ID"

# Download any Source's mentioned in the specs.
for spec in "${BUILDDIR}"/SPECS/*.spec; do
  spectool -g -C "${BUILDDIR}/SOURCES" "$spec"
done

# Build the source and binary RPM packages.
rpmbuild -ba "${BUILDDIR}"/SPECS/*.spec --define "_topdir $BUILDDIR"

if [[ -n $ARTIFACTS ]]; then
  [[ -d $ARTIFACTS ]] || mkdir -p "$ARTIFACTS"
  # Copy the RPM's to the mounted volume and out of the container.
  cp -v -r -f "${BUILDDIR}/RPMS" "${BUILDDIR}/SRPMS" "$ARTIFACTS"
fi
