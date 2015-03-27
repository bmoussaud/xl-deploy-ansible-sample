
function do_main() {
    install_package ansible
    # pre-install package for offline demo
    install_package openjdk-7-jre
    install_package tomcat7
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

function failed {
    echo "$1" 1>&2
    exit 1
}

do_main
