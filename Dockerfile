FROM centos:7

RUN yum install -y \
      rpmdevtools \
    && yum clean all \
    && rm -rf /var/cache/yum

ENV     BUILDDIR /root/rpmbuild
RUN     mkdir $BUILDDIR
WORKDIR $BUILDDIR

ENV    ARTIFACTS /tmp/artifacts
VOLUME [$ARTIFACTS]

ENV  SOURCE /tmp/build
COPY . $SOURCE

CMD ["bash", "-c", "${SOURCE}/build.sh"]
