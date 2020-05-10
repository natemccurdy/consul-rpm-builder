## package settings
%define consul_template_home    /opt/consul
%define consul_template_bindir  %{consul_template_home}/bin
%define consul_template_confdir /etc/consul-template
%define debug_package  %{nil}

Name:           consul-template
Version:        0.25.0
Release:        0%{?dist}
Summary:        Consul Template provides a convenient way to populate values from Consul into the filesystem.

Group:          System Environment/Daemons
License:        Mozilla Public License, version 2.0
URL:            https://github.com/hashicorp/consul-template

Source0:        https://releases.hashicorp.com/%{name}/%{version}/%{name}_%{version}_linux_amd64.zip
Source1:        https://releases.hashicorp.com/%{name}/%{version}/%{name}_%{version}_SHA256SUMS
Source2:        https://releases.hashicorp.com/%{name}/%{version}/%{name}_%{version}_SHA256SUMS.sig

Source3:        %{name}.service

BuildRequires:  systemd-units

Requires(pre):      shadow-utils
Requires(post):     systemd
Requires(preun):    systemd
Requires(postun):   systemd

%description
The daemon consul-template queries a Consul instance and updates
any number of specified templates on the filesystem.
As an added bonus, consul-template can optionally run arbitrary
commands when the update process completes.

%prep
gpg --verify %{SOURCE2} %{SOURCE1}
awk '/linux_amd64.zip/ {print $1,"%{SOURCE0}"}' %{SOURCE1} | sha256sum -c -

%setup -q -c

%build

%install
## directories
%{__install} -d -m 0755 %{buildroot}%{consul_template_confdir}
%{__install} -d -m 0755 %{buildroot}%{consul_template_bindir}

## sytem files
%{__install} -p -D -m 0640 %{SOURCE3} %{buildroot}%{_unitdir}/%{name}.service

## main binary
%{__install} -p -D -m 0755 %{name} %{buildroot}%{consul_template_bindir}/%{name}

## symlink to /usr/local/bin
%{__install} -d -m 0755 %{buildroot}/usr/local/bin
%{__ln_s} %{consul_template_bindir}/%{name} %{buildroot}/usr/local/bin/%{name}

%pre

%post
%systemd_post %{name}.service

%preun
%systemd_preun %{name}.service

%postun
%systemd_postun_with_restart %{name}.service

%files
%defattr(-,root,root,-)
%{_unitdir}/%{name}.service
%{consul_template_bindir}/%{name}
/usr/local/bin/%{name}
%{consul_template_confdir}

%changelog
