#!/bin/bash
AGENT_VERSION=$1
OS_SUPPORTED=false
REPO_URL=''

if [[ ! ${AGENT_VERSION} =~ ^([0-9]+\.){0,2}(\*|[0-9]+)$ ]]; then
	echo '[ERROR] Please insert a valid version param'
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
fi

if $OS_SUPPORTED; then
	echo '[INFO] Succesful!'
else
	echo '[ERROR] This System OS is not current suportted'
fi
