## package settings
%define consul_user    consul
%define consul_group   %{consul_user}
%define consul_home    /opt/consul
%define consul_datadir %{consul_home}/data
%define consul_bindir  %{consul_home}/bin
%define consul_confdir /etc/consul
%define debug_package  %{nil}

Name:           consul
Version:        1.7.3
Release:        0%{?dist}
Summary:        Service discovery and configuration made easy.

Group:          System Environment/Daemons
License:        Mozilla Public License, version 2.0
URL:            http://www.consul.io

Source0:        https://releases.hashicorp.com/%{name}/%{version}/%{name}_%{version}_linux_amd64.zip
Source1:        https://releases.hashicorp.com/%{name}/%{version}/%{name}_%{version}_SHA256SUMS
Source2:        https://releases.hashicorp.com/%{name}/%{version}/%{name}_%{version}_SHA256SUMS.sig
Source3:        hashicorp.asc

Source4:        %{name}.service

BuildRequires:  systemd-units

Requires(pre):      shadow-utils
Requires(post):     systemd
Requires(preun):    systemd
Requires(postun):   systemd

%description
Consul is a tool for service discovery and configuration.
Consul is distributed, highly available, and extremely scalable.

%prep
gpg --verify %{SOURCE2} %{SOURCE1}
awk '/linux_amd64.zip/ {print $1,"%{SOURCE0}"}' %{SOURCE1} | sha256sum -c -

%setup -q -c

%build

%install
## directories
%{__install} -d -m 0755 %{buildroot}%{consul_confdir}
%{__install} -d -m 0750 %{buildroot}%{consul_datadir}
%{__install} -d -m 0755 %{buildroot}%{consul_bindir}

## sytem files
%{__install} -p -D -m 0640 %{SOURCE3} %{buildroot}%{_unitdir}/%{name}.service

## main binary
%{__install} -p -D -m 0755 %{name} %{buildroot}%{consul_bindir}/%{name}

## symlink to /usr/local/bin
%{__install} -d -m 0755 %{buildroot}/usr/local/bin
%{__ln_s} %{consul_bindir}/%{name} %{buildroot}/usr/local/bin/%{name}

%pre
## add required user and group if needed
getent group %{consul_group} >/dev/null || \
  groupadd -r %{consul_group}
getent passwd %{consul_user} >/dev/null || \
  useradd -r -g %{consul_user} -d %{consul_home} \
  -s /sbin/nologin -c %{name} %{consul_user}
exit 0

%post
%systemd_post %{name}.service

%preun
%systemd_preun %{name}.service

%postun
%systemd_postun_with_restart %{name}.service

%files
%defattr(-,root,root,-)
%{_unitdir}/%{name}.service
%{consul_bindir}/%{name}
%attr(-,%{consul_user},%{consul_group}) %dir %{consul_datadir}
/usr/local/bin/consul
%{consul_confdir}

%changelog
