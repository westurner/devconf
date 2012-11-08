#!/bin/bash

MIRROR="http://localhost:23142/ubuntu"

UBUNTU="ubuntu-standard,ubuntu-minimal"
MAINT="language-pack-en-base,byobu,debsums,curl,mercurial,etckeeper,wajig,htop"
BASE="${UBUNTU},linux-image,grub-pc,lvm2,cryptsetup,dcfldd,python-software-properties,${MAINT}"

NETWORK="iptables,vlan,ufw,shorewall,openssh-server,dnsmasq,ulogd,ulogd-sqlite3,ulogd-pcap,openssl-blacklist"
NETWORK_DEV="${NETWORK},dnsutils,traceroute,whois,itop,ntop,httping,nmap,elinks,tcpdump,tshark"
XTABLES="xtables-addons-common,xtables-addons-dkms"

PULSEAUDIO="pulseaudio,pulseaudio-utils,aumix"
PULSEAUDIO_GUI="${PULSEAUDIO},pulseaudio-module-x11,paman,paprefs,pavumeter,pulseaudio-module-gconf" # 1004

PYTHON="python,ipython"
PYTHON_DEV="${PYTHON},cython,python-dev,python-doc,pep8,pyflakes"

JAVA="sun-java6-jre,ca-certificates-java"
JAVA_DEV="${JAVA},sun-java6-jdk,ant,maven"
JENKINS="jenkins"

ERLANG="erlang"
RABBITMQ="rabbitmq-server"

RUBY="ruby,ri,rubygems" # always outdated?
RUBY_DEV="${RUBY}"

PUPPET="puppet,facter,vim-puppet"
PUPPETMASTER="${PUPPET},${RUBY_DEV},puppetmaster"

MYSQL="mysql-client"
MYSQL_SERVER="${MYSQL},mysql-server"

POSTGRES="postgresql-client"
POSTGRES_SERVER="${POSTGRES},postgresql-8.4"

LINUX_DEV="linux-headers-generic,linux-source,build-essential"

VCS="bzr,mercurial,subversion,hgsvn,git-svn"
DEV="${LINUX_DEV},${VCS},${PYTHON_DEV},aspell-en,sqlite3,tofrodos,exuberant-ctags,graphviz,sshfs,${VCS}"
DEV_GUI="${DEV},terminator"

MEDIA="inkscape,gimp"

WORKSTATION="ubuntu-desktop,${BASE},${DEV_GUI},${PULSEAUDIO_GUI},${NETWORK_DEV}"
FLASH="adobe-flashplugin,adobe-flashproperties-gtk"

#CHROME="google-chrome-stable"

COMPIZ="compiz,compizconfig-backend-gconf,compizconfig-settings-manager,compiz-core,compiz-fusion-plugins-extra,compiz-fusion-plugins-main,compiz-gnome,compiz-plugins"

SELINUX="selinux,setools,checkpolicy"

PACKAGES="${WORKSTATION},${SELINUX},${COMPIZ},${RUBY_DEV},${PUPPET}"

EXCLUDES="popularity-contest,xserver-xorg-video-*"

COMPONENTS="main,restricted,universe,multiverse"
ARCH="$1"
DIST="oneiric"
CHROOT_PATH="/srv/rebuild"
CHROOT_HOSTNAME="rebuild"
KEYRING="/usr/share/keyrings/ubuntu-archive-keyring.gpg"

_debootstrap() {
    debootstrap \
        --components="$COMPONENTS"  \
        --include="$PACKAGES"   \
        --arch=$ARCH    \
        --keyring=$KEYRING \
        --verbose \
        $DIST   \
        "$CHROOT_PATH"  \
        "$MIRROR"
}


_andthen() {
APT_PROXY="http://apt:23142" # FIXME: nginx proxy encoding

    cat >> $CHROOT_PATH/etc/apt/sources.list << EOF
deb http://archive.ubuntu.com/ubuntu/ oneiric main restricted universe multiverse
deb-src http://archive.ubuntu.com/ubuntu/ oneiric main restricted universe multiverse

deb http://archive.ubuntu.com/ubuntu/ oneiric-updates main restricted universe multiverse
deb-src http://archive.ubuntu.com/ubuntu/ oneiric-updates main restricted universe multiverse

deb http://archive.ubuntu.com/ubuntu/ oneiric-security main restricted universe multiverse
deb-src http://archive.ubuntu.com/ubuntu/ oneiric-security main restricted universe multiverse
EOF

    cat >> $CHROOT_PATH/etc/apt.conf << EOF
Acquire::http { Proxy "${APT_PROXY}"; };
EOF

    echo "$CHROOT_HOSTNAME" >> $CHROOT_PATH/etc/hostname

}


_debootstrap
#_andthen
