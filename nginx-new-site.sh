#!/usr/bin/env bash

# Arguments
SITE_NAME=$1

# Variables
domain=dev.${SITE_NAME}
hosts=/etc/hosts
conf_path=$(pwd)/nginx/sites
default_site_name=laravel
example_conf_name=${default_site_name}.conf.example

example_site_conf=${conf_path}/${example_conf_name}
site_conf=${conf_path}/${SITE_NAME}.conf

NORMAL='\e[0m'
GREEN='\e[32m'
RED='\e[31m'

echo_success()
{
    echo -e "${GREEN}${1}${NORMAL}"
}

echo_danger()
{
    echo -e "${RED}${1}${NORMAL}"
}

main()
{
    if [ "$(whoami)" != 'root' ]; then
        echo_danger "You have no permission to run $0 as non-root user. Use sudo"
    fi

    if [ "${SITE_NAME}" == '' ]; then
        echo_danger "Enter site name!\n"
        exit 1
    fi

    ### Create site conf
    if [ -f ${site_conf} ]; then
        echo_danger "File ${site_conf} already exists.\n"
    else
        cp ${example_site_conf} ${site_conf}
        chmod 775 ${site_conf}
        chown www-data:www-data ${site_conf}
        sed -i "s/${default_site_name}/${SITE_NAME}/g" ${site_conf}

        echo_success "Created ${site_conf} !\n"
    fi

    ### Add domain in /etc/hosts
    if ! echo "127.0.0.1  $domain" >> ${hosts}; then
        echo_danger "Not able write in ${hosts}"
        exit 1
    else
        echo_success "Host added to ${hosts} file"
    fi
}

main

exit 0
