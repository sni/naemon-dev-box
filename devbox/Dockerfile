FROM rockylinux:8

RUN dnf clean all
#RUN dnf -y install centos-release-stream
#RUN dnf -y swap centos-{linux,stream}-repos
#RUN dnf -y distro-sync
RUN dnf -y install epel-release
RUN dnf -y install 'dnf-command(config-manager)'
RUN dnf config-manager --set-enabled powertools
RUN dnf clean all
RUN dnf -y update
RUN dnf -y install lsof vim git sudo openssh-server passwd file
RUN dnf -y install ansible
RUN dnf -y install httpd mod_ssl
RUN /usr/libexec/httpd-ssl-gencerts

RUN echo -e "ZONE=\"Europe/Berlin\"\nUTC=true" > /etc/sysconfig/clock

RUN curl -s "https://labs.consol.de/repo/stable/RPM-GPG-KEY" > /etc/pki/rpm-gpg/RPM-GPG-KEY-labsconsolde
RUN rpm -Uvh "https://labs.consol.de/repo/stable/rhel8/i386/labs-consol-stable.rhel8.noarch.rpm"
RUN rpm -Uvh "https://labs.consol.de/repo/testing/rhel8/i386/labs-consol-testing.rhel8.noarch.rpm"
RUN dnf install -y omd-labs-edition-daily

CMD /box/devbox/run.sh
