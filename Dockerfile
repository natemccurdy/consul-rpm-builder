FROM centos:7

VOLUME ["/tmp/artifacts"]

RUN yum install -y \
      rpmdevtools \
      rpm-devel \
    && yum clean all \
    && rm -rf /var/cache/yum \
    && mkdir /root/rpmbuild

COPY . /tmp/build

WORKDIR /root/rpmbuild

CMD ["/tmp/build/build.sh"]
