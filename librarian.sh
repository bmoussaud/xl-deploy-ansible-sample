#!/bin/bash

function do_main() {
    install_ruby_dev
    install_puppet
    install_librarian
    install_jsonpath
    install_puppet_module
}


function install_ruby_dev() {
    install_package ruby-dev
}

function check_installed {
    echo "Checking whether [$1] is installed"

    $(which apt-get > /dev/null 2>&1)
    FOUND_APT=$?
    $(which yum > /dev/null 2>&1)
    FOUND_YUM=$?

    if [ "${FOUND_YUM}" -eq '0' ]; then
        yum -q -y makecache
        yum -q -y install $1
        echo "$1 installed."
    elif [ "${FOUND_APT}" -eq '0' ]; then
        apt-get -q -y install $1
        if [ $? -eq 0 ]; then
            echo "$1 installed."
        else
            failed "Couldn't install '$1'"
        fi
    else
        failed "No package installer available. You may need to install $1 manually."
    fi
}

function install_package {
    echo "installing $1"

    $(which apt-get > /dev/null 2>&1)
    FOUND_APT=$?
    $(which yum > /dev/null 2>&1)
    FOUND_YUM=$?

    if [ "${FOUND_YUM}" -eq '0' ]; then
        yum -q -y makecache
        yum -q -y install $1
        echo "$1 installed."
    elif [ "${FOUND_APT}" -eq '0' ]; then
        if ! is_installed_apt $1; then
            apt-get -q -y update
            apt-get -q -y install $1
            if [ $? -eq 0 ]; then
                echo "$1 installed."
            else
                failed "Couldn't install '$1'"
            fi
        fi
    else
        failed "No package installer available. You may need to install $1 manually."
    fi
}

function is_installed_apt {
    INSTALLED=$(dpkg-query -W -f '${Status}\n' $1 | grep 'install ok installed')
    if [ "" == "$INSTALLED" ]; then
        echo "$1 is not installed yet"
        return 1
    else
        echo "$1 is installed"
        return 0
    fi
}

function install_puppet() {
    if [ "$(gem search -i puppet)" = "false" ]; then
        install_gem_package puppet
    else
        echo 'puppet found'
    fi
}

function install_librarian() {
    if [ "$(gem search -i librarian-puppet)" = "false" ]; then
        #install_gem_package librarian-puppet 1.0.3
        install_gem_package librarian-puppet
    else
        echo 'librarian-puppet found'
    fi
}

function install_jsonpath() {
    if [ "$(gem search -i jsonpath)" = "false" ]; then
        install_gem_package jsonpath
    else
        echo 'jsonpath found'
    fi
}

function install_gem_package {
    echo "installing $1 $2"
    $(which gem > /dev/null 2>&1)
    FOUND_GEM=$?

    if [ "${FOUND_GEM}" -eq '0' ]; then
        if [ -z "$2" ]; then
            gem install --no-ri --no-rdoc $1
        else
            gem install --no-ri --no-rdoc $1 -v $2
        fi
        echo "$1 $2 installed."
    else
        failed "No gem package installer available. You may need to install $1 $2 manually."
    fi
}

function install_puppet_module() {
    PUPPET_DIR=/etc/puppet/
    make_dir ${PUPPET_DIR}
    cp /vagrant/puppet/Puppetfile ${PUPPET_DIR}
    cd ${PUPPET_DIR} && ( librarian_clean_install || retry_librarian_clean_install || failed "Librarian puppet could not install modules" )
}

function make_dir {
    if [ ! -d "$1" ]; then
        mkdir -p $1
    fi
}

function librarian_clean_install() {
    echo "Preparing for puppet module install in `pwd`"
    librarian-puppet clean
    echo "Updating Puppetfile.lock"
    librarian-puppet update
    echo "Installing puppet modules"
    librarian-puppet install
    result=$?
    if [ ${result} != 0 ] ; then
        return ${result}
    fi
    echo "All puppet modules installed successfully"
}

function retry_librarian_clean_install () {
    echo "Failed! Retrying in 10 seconds"
    sleep 10
    librarian_clean_install
}

function failed {
    echo "$1" 1>&2
    exit 1
}

do_main
