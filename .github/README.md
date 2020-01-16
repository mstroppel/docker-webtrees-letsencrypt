# Using Webtrees with SSL enabled integrated with NGINX proxy and autorenew LetsEncrypt certificates

This docker-compose should be used with WebProxy (the NGINX Proxy):

[https://github.com/evertramos/docker-compose-letsencrypt-nginx-proxy-companion](https://github.com/evertramos/docker-compose-letsencrypt-nginx-proxy-companion)

## Usage

After everything is settle, and you have your three containers running (_proxy, generator and letsencrypt_) you do the following:

1. Clone this repository:

```bash
git clone https://github.com/marcostroppel/docker-webtrees-letsencrypt.git
```

Or just copy the content of `docker-compose.yml` and the `.env` file, as of below:

```bash
version: '3'

services:
   webtrees-db:
     container_name: ${DB_CONTAINER_NAME}
     image: mariadb:10
     restart: unless-stopped
     volumes:
        - ${LOCAL_DB_DIR}:/var/lib/mysql
     environment:
       MYSQL_DATABASE: ${MYSQL_DATABASE}
       MYSQL_ROOT_PASSWORD: ${MYSQL_ROOT_PASSWORD}
       MYSQL_USER: ${MYSQL_USER}
       MYSQL_PASSWORD: ${MYSQL_PASSWORD}

   webtrees-site:
     depends_on:
       - ${DB_CONTAINER_NAME}
     container_name: ${APP_CONTAINER_NAME}
     image: justinvoelker/docker-webtrees:${WEBTREES_VERSION}
     restart: unless-stopped
     volumes:
       - ${WEBTREES_DATA_DIR}:/var/www/html/data
     environment:
       SERVER_NAME: ${VIRTUAL_HOST}
       WEBTREES_DB_HOST: ${DB_CONTAINER_NAME}
       WEBTREES_DB_PORT: 3306
       WEBTREES_DB_USER: ${MYSQL_USER}
       WEBTREES_DB_PASS: ${MYSQL_PASSWORD}
       WEBTREES_DB_NAME: ${MYSQL_DATABASE}
       WEBTREES_TBL_PFX: wt_
       VIRTUAL_HOST: ${VIRTUAL_HOST}
       LETSENCRYPT_HOST: ${LETSENCRYPT_HOST}
       LETSENCRYPT_EMAIL: ${LETSENCRYPT_EMAIL}

networks:
    default:
       external:
         name: ${NETWORK}
```

> **[IMPORTANT]** Make sure to update your **services** name for each application so it does not conflicts with another service, such as, in the _docker_compose.yml_ where we have **db** you could use **site1-db**, and **webtrees** you could use **site1-webtrees**. Update this to site2 when you put up a new site.

1. Make a copy of our .env.sample and rename it to .env:

Update this file with your preferences.

```bash
#
# Configuration for Nextcloud using NGINX WebProxy
#

# Containers name
DB_CONTAINER_NAME=webtrees-db
APP_CONTAINER_NAME=webtrees-app

# Mysql settings
MYSQL_HOST=webtrees-db
MYSQL_DATABASE=webtrees_db
MYSQL_ROOT_PASSWORD=cloud,root,password
MYSQL_USER=cloud_user
MYSQL_PASSWORD=cloud,user,password

# webtrees data path
WEBTREES_VERSION=latest
LOCAL_DB_DIR=/home/user/webtrees/data/db
WEBTREES_DATA_DIR=/home/user/webtrees/data/cloud

# Host
VIRTUAL_HOST=cloud.yourdomain.com
LETSENCRYPT_HOST=cloud.yourdomain.com
LETSENCRYPT_EMAIL=your_email@yourdomain.com

#
# Network name
#
# Your container app must use a network conencted to your webproxy 
# https://github.com/evertramos/docker-compose-letsencrypt-nginx-proxy-companion
#
NETWORK=webproxy
```

>This container must use a network connected to your webproxy or the same network of your webproxy.

1. Start your project

```bash
./start.sh
```

**Be patient** - when you first run a container to get new certificates, it may take a few minutes.

----

### Make sure the webtrees data files has user and group set to **www-data**, so you could update, install, delete files from your admin panel.

----
