#!/usr/bin/env bash


# create a function which returns nginx v-host configuration
create_vhost() {
    # Define the v-host configuration
    vhost="server {
        listen      443 ssl;
        listen [::]:443 ssl;
        server_name $1;

        # SSl
        ssl_certificate /etc/nginx/ssl/$1.cert.pem;
        ssl_certificate_key /etc/nginx/ssl/$1.key.pem;
        ssl_protocols TLSv1.2 TLSv1.1 TLSv1;

        location / {
            include /etc/nginx/proxy.conf;
            proxy_pass http://nodejs:$2;
        }
    }"
    # Return the v-host configuration
    echo "$vhost"
}

#create a sorted list of domains from domains file
# Check if domains file exists
if [ -f /domains-list/domains ]; then
    # Read domains from domains.txt file
    domains=$(cat /domains-list/domains | sort)
    i=0
    # Loop through each domain
    # Create v-host configuration for each domains
    # Create SSL certificates for each domains
    # Create symbolic link for each domains

    for domain in $domains; do
        # set port number in increament starting from 9000
        port=$((9000 + i++))
        # check if v-host configuration file exists
        if [ -f /etc/nginx/sites-available/$domain.conf ]; then
            echo "v-host configuration file for $domain already exists."
            continue
        fi
        # Generate SSL certificates for the domains
        key_file=$domain.key.pem
        cert_file=$domain.cert.pem
        mkcert -key-file $key_file -cert-file $cert_file $domain

        # Display the port number and domain name
        touch /etc/nginx/sites-available/$domain.conf
        create_vhost $domain $port >> /etc/nginx/sites-available/$domain.conf
        ln -s /etc/nginx/sites-available/$domain.conf /etc/nginx/sites-enabled/$domain.conf
    done
    

else
    echo "domains file not found."
    exit 1
fi
