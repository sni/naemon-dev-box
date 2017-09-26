# add consol labs stable and testing repository
rpm --import https://labs.consol.de/repo/stable/RPM-GPG-KEY
rpm -Uvh "https://labs.consol.de/repo/stable/rhel7/i386/labs-consol-stable.rhel7.noarch.rpm"
rpm -Uvh "https://labs.consol.de/repo/testing/rhel7/i386/labs-consol-testing.rhel7.noarch.rpm"

# add epel repository
rpm --import https://archive.fedoraproject.org/pub/epel/RPM-GPG-KEY-EPEL-7
rpm -Uvh "https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm"

# install latest omd
yum install -y omd-labs-edition-daily

# set timezone to Europe/Berlin
echo 'ZONE=\"Europe/Berlin\"' > /etc/sysconfig/clock
echo 'UTC=true'              >> /etc/sysconfig/clock
