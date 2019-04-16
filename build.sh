#!/bin/bash
set -ex

: "${ARTIFACTS:+}"    # If ARTIFACTS exists, copy built RPMs to it.
: "${BUILDDIR:=.}"    # Use CWD as the default build dir
: "${SOURCE:?}"       # SOURCE must be set via environment variables.
: "${SPEC_FILE:=all}" # Which spec file to process. Will do all specs if unset.

# Hashicorp public key ID: https://www.hashicorp.com/security
: "${HASHI_PUB_KEY_ID:=51852D87348FFC4C}"
# Optional path to the Hashicorp public key file. If this is set, we use it
# instead of grabbing the key from a keyserver.
: "${HASHI_PUB_KEY_FILE:+}"

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

# Either use the pub key file or grab it from a keyserver.
if [[ -n $HASHI_PUB_KEY_FILE ]]; then
  gpg --import "$HASHI_PUB_KEY_FILE"
else
  gpg --keyserver hkp://keys.gnupg.net --recv-keys "$HASHI_PUB_KEY_ID"
fi

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
