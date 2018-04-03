#!/bin/bash

set -euo pipefail

AGENT_VERSION=$1
OS_SUPPORTED=false
REPO_URL=''

if [[ ! ${AGENT_VERSION} =~ ^([0-9]+\.){0,2}(\*|[0-9]+)$ ]]; then
    echo "[ERROR] Please insert a valid version param."
    exit 1;
fi

if [  ${AGENT_VERSION:0:1} != "5" ] && [ ${AGENT_VERSION:0:1} != "1" ] ; then
    echo "[ERROR] Please insert a valid version."
    echo "[ERROR] Puppet 4 is 1."
    echo "[ERROR] Puppet 5 is 5."
    exit 1;
fi

if [ -f /etc/redhat-release ]; then
    RH_MAJ_VERSION=`cat /etc/redhat-release | sed s/.*release\ // | sed s/\ .*// | cut -d'.' -f1`
    if [ $RH_MAJ_VERSION -ge 6 ]; then
        OS_SUPPORTED=true
        if [ ${AGENT_VERSION:0:1} == "5" ]; then
            REPO_URL="http://yum.puppet.com/puppet5/puppet5-release-el-${RH_MAJ_VERSION}.noarch.rpm"
        else
            REPO_URL="http://yum.puppet.com/puppetlabs-release-pc1-el-${RH_MAJ_VERSION}.noarch.rpm"
        fi
        yum install -y $REPO_URL
        yum install -y "puppet-agent-${AGENT_VERSION}*"
    fi
elif [ `uname -n | cut -d'-' -f1` == 'debian' ]; then
    DEBIAN_MAJ_VERSION=`cat /etc/debian_version | sed s/.*release\ // | sed s/\ .*// | cut -d'.' -f1`
    OS_SUPPORTED=true
    case "${DEBIAN_MAJ_VERSION}" in
        8)
            DEBIAN_MAJ_VERSION="jessie"
            ;;
        9)
      	    DEBIAN_MAJ_VERSION="stretch"
	    ;;
        *)
      	    OS_SUPPORTED=false
	    ;;
    esac
    if ${OS_SUPPORTED}; then
        if [ ${AGENT_VERSION:0:1} == "5" ]; then
            REPO_URL="https://apt.puppetlabs.com/puppet5-release-${DEBIAN_MAJ_VERSION}.deb"
            PKG="puppet5-release-${DEBIAN_MAJ_VERSION}.deb"
    	else
            REPO_URL="https://apt.puppetlabs.com/puppetlabs-release-${DEBIAN_MAJ_VERSION}.deb"
            PKG="puppetlabs-release-pc1-${DEBIAN_MAJ_VERSION}.deb"
    	fi
    	wget ${REPO_URL}
    	dpkg -i ${PKG}
    	apt-get update
    	apt-get install "puppet-agent=${AGENT_VERSION}*"
    fi
elif [ -f /etc/SuSE-release ]; then
    SLES_MAJ_VERSION=`grep SUSE /etc/SuSE-release | cut -d' ' -f5`
    if [ ${SLES_MAJ_VERSION} -ge 11 ]; then
        OS_SUPPORTED=true
        gem uninstall --all --executables facter hiera puppet
        if [ ${AGENT_VERSION:0:1} == "5" ]; then
            REPO_URL="https://yum.puppet.com/puppet5/puppet5-release-sles-${SLES_MAJ_VERSION}.noarch.rpm"
        else
            REPO_URL="http://yum.puppet.com/puppetlabs-release-pc1-sles-${SLES_MAJ_VERSION}.noarch.rpm"
        fi
    fi
    curl -s -O http://yum.puppetlabs.com/RPM-GPG-KEY-puppet \
        && rpm --import RPM-GPG-KEY-puppet \
        && rm -f RPM-GPG-KEY-puppet
    zypper install --no-confirm ${REPO_URL}
    zypper install --oldpackage --no-recommends --no-confirm "puppet-agent"
elif [ `uname -n | cut -d'-' -f1` == 'ubuntu' ]; then
    UBUNTU_MAJ_VERSION=`grep RELEASE /etc/lsb-release | cut -d'='  -f2 | cut -d'.' -f1`
    UBUNTU_MAJ_CODENAME=`grep CODENAME /etc/lsb-release | cut -d'=' -f2`
    if [ ${UBUNTU_MAJ_VERSION} -ge 14 ]; then
        OS_SUPPORTED=true
        if [ ${AGENT_VERSION:0:1} == "5" ]; then
            REPO_URL="https://apt.puppetlabs.com/puppet5-release-${UBUNTU_MAJ_CODENAME}.deb"
            PKG="puppet5-release-${UBUNTU_MAJ_CODENAME}.deb"
        else
            REPO_URL="https://apt.puppetlabs.com/puppetlabs-release-pc1-${UBUNTU_MAJ_CODENAME}.deb"
            PKG="puppetlabs-release-pc1-${UBUNTU_MAJ_CODENAME}.deb"
        fi
    fi
    curl -s -O ${REPO_URL}
    dpkg -i ${PKG}
    rm ${PKG}
    apt-get update
    apt-get install -y "puppet-agent=${AGENT_VERSION}*"
fi

if ${OS_SUPPORTED}; then
    echo '[INFO] Succesful!'
else
    echo '[ERROR] This System OS is not current suportted'
fi
