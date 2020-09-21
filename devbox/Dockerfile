FROM centos:8

RUN yum -y install epel-release
RUN yum -y install 'dnf-command(config-manager)'
RUN yum config-manager --set-enabled PowerTools
RUN yum clean all
RUN yum -y update
RUN yum -y install lsof vim git sudo openssh-server passwd file
RUN yum -y install ansible
RUN yum -y install httpd mod_ssl
RUN /usr/libexec/httpd-ssl-gencerts

RUN echo -e "ZONE=\"Europe/Berlin\"\nUTC=true" > /etc/sysconfig/clock

RUN curl -s "https://labs.consol.de/repo/stable/RPM-GPG-KEY" > /etc/pki/rpm-gpg/RPM-GPG-KEY-labsconsolde
RUN rpm -Uvh "https://labs.consol.de/repo/stable/rhel8/i386/labs-consol-stable.rhel8.noarch.rpm"
RUN rpm -Uvh "https://labs.consol.de/repo/testing/rhel8/i386/labs-consol-testing.rhel8.noarch.rpm"
RUN yum install -y omd-labs-edition-daily

CMD /box/devbox/run.sh
