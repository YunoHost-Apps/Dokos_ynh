#!/usr/bin/env bash

# Retrieve server IP
server_ip=$(hostname -I | awk '{print $1}')

#Retrieve script folder
script_folder=$(pwd)

# Setting up colors for echo commands
YELLOW='\033[1;33m'
GREEN='\033[0;32m'
RED='\033[0;31m'
LIGHT_BLUE='\033[1;34m'
NC='\033[0m' # No Color

# Checking Supported OS and distribution
SUPPORTED_DISTRIBUTIONS=("Ubuntu" "Debian")
SUPPORTED_VERSIONS=("22.04" "11" "12")

check_os() {
    local os_name=$(lsb_release -is)
    local os_version=$(lsb_release -rs)
    local os_supported=false
    local version_supported=false

    for i in "${SUPPORTED_DISTRIBUTIONS[@]}"; do
        if [[ "$i" = "$os_name" ]]; then
            os_supported=true
            break
        fi
    done

    for i in "${SUPPORTED_VERSIONS[@]}"; do
        if [[ "$i" = "$os_version" ]]; then
            version_supported=true
            break
        fi
    done

    if [[ "$os_supported" = false ]] || [[ "$version_supported" = false ]]; then
        echo -e "${RED}This script is not compatible with your operating system or its version.${NC}"
        exit 1
    fi
}

# Detect the platform (similar to $OSTYPE)
OS="`uname`"
case $OS in
  'Linux')
    OS='Linux'
    if [ -f /etc/redhat-release ] ; then
      DISTRO='CentOS'
    elif [ -f /etc/debian_version ] ; then
      if [ "$(lsb_release -si)" == "Ubuntu" ]; then
        DISTRO='Ubuntu'
      else
        DISTRO='Debian'
      fi
    fi
    ;;
  *) ;;
esac


ask_twice() {
    local prompt="$1"
    local secret="$2"
    local val1 val2

    while true; do
        if [ "$secret" = "true" ]; then

            read -rsp "$prompt: " val1

            echo >&2
        else
            read -rp "$prompt: " val1
            echo >&2
        fi
        
        if [ "$secret" = "true" ]; then
            read -rsp "Confirm password: " val2
            echo >&2
        else
            read -rp "Confirm password: " val2
            echo >&2
        fi

        if [ "$val1" = "$val2" ]; then
            printf "${GREEN}Password confirmed${NC}" >&2
            echo "$val1"
            break
        else
            printf "${RED}Inputs do not match. Please try again${NC}\n" >&2
            echo -e "\n"
        fi
    done
}
echo -e "${LIGHT_BLUE}Welcome to the Dokos Installer...${NC}"
echo -e "\n"
sleep 3

# Check OS and version compatibility for all versions
check_os

bench_folder="dokos-bench-folder"
benchdir="$HOME/$bench_folder"

#First Let's take you home
cd $(sudo -u $USER echo $HOME)
echo -e "\n"

#Now let's make sure your instance has the most updated packages
echo -e "${YELLOW}Updating system packages...${NC}"
sleep 2
sudo apt update
sudo apt upgrade -y
echo -e "${GREEN}System packages updated.${NC}"
sleep 2

#Now let's install a couple of requirements: git, curl and pip
echo -e "${YELLOW}Installing preliminary package requirements${NC}"
sleep 3
sudo apt install software-properties-common git curl -y

#Next we'll install the python environment manager...
echo -e "${YELLOW}Installing python environment manager and other requirements...${NC}"
sleep 2

# Install Python 3.10 if not already installed or version is less than 3.10
py_version=$(python3 --version 2>&1 | awk '{print $2}')
py_major=$(echo "$py_version" | cut -d '.' -f 1)
py_minor=$(echo "$py_version" | cut -d '.' -f 2)

if [ -z "$py_version" ] || [ "$py_major" -lt 3 ] || [ "$py_major" -eq 3 -a "$py_minor" -lt 10 ]; then
    echo -e "${LIGHT_BLUE}It appears this instance does not meet the minimum Python version required for Dokos 3 (Python3.10)...${NC}"
    sleep 2 
    echo -e "${YELLOW}Not to worry, we will sort it out for you${NC}"
    sleep 4
    echo -e "${YELLOW}Installing Python 3.10+...${NC}"
    sleep 2
    sudo apt -qq install build-essential zlib1g-dev libncurses5-dev libgdbm-dev libnss3-dev libssl-dev libreadline-dev libffi-dev libsqlite3-dev wget libbz2-dev -y && \
    wget https://www.python.org/ftp/python/3.10.11/Python-3.10.11.tgz && \
    tar -xf Python-3.10.11.tgz && \
    cd Python-3.10.11 && \
    ./configure --prefix=/usr/local --enable-optimizations --enable-shared LDFLAGS="-Wl,-rpath /usr/local/lib" && \
    make -j $(nproc) && \
    sudo make altinstall && \
    cd .. && \
    sudo rm -rf Python-3.10.11 && \
    sudo rm Python-3.10.11.tgz && \
    pip3.10 install --user --upgrade pip && \
    echo -e "${GREEN}Python3.10 installation successful!${NC}"
    sleep 2
fi
echo -e "\n"
echo -e "${YELLOW}Installing additional Python packages and Redis Server${NC}"
sleep 2
sudo apt install ca-certificates git python3-dev python3-setuptools python3-venv python3-pip python3-distutils redis-server xvfb libfontconfig wkhtmltopdf -y && \
# Mise à jour des dépôts
sudo apt --fix-broken install -y && \
sudo apt install fontconfig xvfb libfontconfig xfonts-base xfonts-75dpi libxrender1 -y && \

echo -e "${GREEN}Done!${NC}"
sleep 1
echo -e "\n"
#... And mariadb with some extra needed applications.
echo -e "${YELLOW}Now installing MariaDB.${NC}"
sleep 2
sudo apt install mariadb-server mariadb-client -y
echo -e "${GREEN}MariaDB and other packages have been installed successfully.${NC}"
sleep 2


#Install NVM, Node, npm and yarn
echo -e ${YELLOW}"Now to install NVM, Node, npm and yarn${NC}"
sleep 2
curl https://raw.githubusercontent.com/creationix/nvm/master/install.sh | bash

# Add environment variables to .profile
echo 'export NVM_DIR="$HOME/.nvm"' >> ~/.profile
echo '[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm' >> ~/.profile
echo '[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion' >> ~/.profile

# Source .profile to load the new environment variables in the current session
source ~/.profile

# Conditional Node.js installation based on the version of ERPNext selected
nvm install 18
node_version="18"
sudo apt-get -qq install npm -y
sudo npm install -g yarn
echo -e "${GREEN}Package installation complete!${NC}"
sleep 2

# Now let's reactivate virtual environment if needed and install bench
echo -e "${YELLOW}Now let's reactivate virtual environment if needed and install bench${NC}"
sleep 4
if [ -z "$py_version" ] || [ "$py_major" -lt 3 ] || [ "$py_major" -eq 3 -a "$py_minor" -lt 10 ]; then
    python3.10 -m venv $USER && \
    source $USER/bin/activate
    nvm use $node_version
fi
pip3 install --upgrade --quiet dokos-cli


#Initiate bench in $bench_folder folder, but get a supervisor can't restart bench error...
echo -e "${YELLOW}Initialising bench in $bench_folder folder.${NC}" 
echo -e "${LIGHT_BLUE}If you get a restart failed, don't worry, we will resolve that later.${NC}"
sleep 4
bench init $bench_folder --version v4 --verbose
echo -e "${GREEN}Bench installation complete!${NC}"
sleep 2

sudo -k

# Prompt user for site name
echo -e "${YELLOW}Preparing for new site installation. This could take a minute... or two so please be patient.${NC}"
read -p "Enter the site name (If you wish to install SSL later, please enter a FQDN): " site_name
sleep 1
admin_pwd=$(ask_twice "Enter the Administrator password" "true")
echo -e "\n"
sleep 1

#Next let's set some important parameters.
read -p "Choose a name for Dokos's database and database's username: " db_name
sleep 1
db_pwd=$(ask_twice "Choose a password for the Dokos's database's username" "true")
echo -e "\n"
sleep 1

#Now we'll go through the required settings of the mysql_secure_installation...
echo -e ${YELLOW}"Now we'll go ahead to apply MariaDB security settings...${NC}"
sleep 2
    
sudo mysql -u root -e "CREATE USER '$db_name'@'localhost' IDENTIFIED BY '$db_pwd';"
sudo mysql -u root -e "CREATE DATABASE IF NOT EXISTS $db_name CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;"
sudo mysql -u root -e "GRANT ALL PRIVILEGES ON $db_name . * TO '$db_name'@'localhost';"
sudo mysql -u root -e "FLUSH PRIVILEGES;"

#echo -e "${YELLOW}...And add some settings to /etc/mysql/my.cnf:${NC}"
#sleep 2

#sudo bash -c 'cat << EOF >> /etc/mysql/my.cnf
#[mysqld]
#character-set-client-handshake = FALSE
#character-set-server = utf8mb4
#collation-server = utf8mb4_unicode_ci

#[mysql]
#default-character-set = utf8mb4
#EOF'

#sudo service mysql restart
echo -e "${GREEN}MariaDB settings done!${NC}"
echo -e "\n"
sleep 1

echo -e "${YELLOW}Now setting up your site. This might take a few minutes. Please wait...${NC}"
sleep 1
# Change directory to $bench_folder
cd $bench_folder && \

sudo chmod -R o+rx /home/$(echo $USER)

bench get-app --branch v4 payments
bench get-app --branch v4 dokos
bench get-app --branch v4 hrms

#to trick the command bench new-site which check value of character_set_server and collation_server even though we created a database setting character and collation for the database itself
 
character_set_server=$(sudo mysql -u root -ss -N -e "SELECT VARIABLE_VALUE FROM information_schema.GLOBAL_VARIABLES WHERE  variable_name ='character_set_server';")
collation_server=$(sudo mysql -u root -ss -N -e "SELECT VARIABLE_VALUE FROM information_schema.GLOBAL_VARIABLES WHERE  variable_name ='collation_server';")
sudo mysql -u root -e "SET GLOBAL character_set_server = 'utf8mb4'";
sudo mysql -u root -e "SET GLOBAL collation_server = 'utf8mb4_unicode_ci'";

bench new-site $site_name --db-name $db_name --db-password $db_pwd --no-setup-db --admin-password $admin_pwd

# putting back the original value of character_set_server and collation_server
sudo mysql -u root -e "SET GLOBAL character_set_server = '$character_set_server'";
sudo mysql -u root -e "SET GLOBAL collation_server = '$collation_server'";

### fail2ban était installé et paramétré par la commande "sudo bench setup production $USER" mais n'est plus traité dans ce script du coup

echo -e "${YELLOW}Installing packages and dependencies for Production...${NC}"
sleep 2

# Setup supervisor and nginx config
#yes | sudo bench setup production $USER && \
sudo apt install nginx supervisor -y
#sudo mv /etc/nginx/nginx.conf /etc/nginx/nginx.conf.old
#sudo cp $script_folder/nginx.conf /etc/nginx/nginx.conf
#chmod o+r /etc/nginx/nginx.conf
sudo bash -c 'cat << EOF >> /etc/nginx/conf.d/'"$bench_folder"'.conf
upstream '"$bench_folder"'-frappe {
	server 127.0.0.1:8000 fail_timeout=0;
}

upstream '"$bench_folder"'-socketio-server {
	server 127.0.0.1:9000 fail_timeout=0;
}

server {
	
	listen 80;
	listen [::]:80;

	server_name '"$site_name"';

	root '"$benchdir"'/sites;

	proxy_buffer_size 128k;
	proxy_buffers 4 256k;
	proxy_busy_buffers_size 256k;

	add_header X-Frame-Options "SAMEORIGIN";
	add_header Strict-Transport-Security "max-age=63072000; includeSubDomains; preload";
	add_header X-Content-Type-Options nosniff;
	add_header X-XSS-Protection "1; mode=block";
	add_header Referrer-Policy "same-origin, strict-origin-when-cross-origin";

	location /assets {
		try_files \$uri =404;
	}

	location ~ ^/protected/(.*) {
		internal;
		try_files /'"$site_name"'/\$1 =404;
	}

	location /socket.io {
		proxy_http_version 1.1;
		proxy_set_header Upgrade \$http_upgrade;
		proxy_set_header Connection "upgrade";
		proxy_set_header X-Frappe-Site-Name '"$site_name"';
		proxy_set_header Origin $scheme://\$http_host;
		proxy_set_header Host '"$site_name"';

		proxy_pass http://'"$bench_folder"'-socketio-server;
	}

	location ^~ /.well-known/acme-challenge/ {
		default_type "text/plain";
		root /var/www/letsencrypt;
	}

	location = /.well-known/acme-challenge/ {
		return 404;
	}

	location / {

		rewrite ^(.+)/\$ \$1 permanent;
  		rewrite ^(.+)/index\.html\$ \$1 permanent;
  		rewrite ^(.+)\.html\$ \$1 permanent;

		location ~* ^/files/.*.(htm|html|svg|xml) {
			add_header Content-disposition "attachment";
			try_files /'"$site_name"'/public/\$uri @webserver;
		}

		try_files /'"$site_name"'/public/\$uri @webserver;
	}

	location @webserver {
		proxy_http_version 1.1;
		proxy_set_header X-Forwarded-For \$remote_addr;
		proxy_set_header X-Forwarded-Proto \$scheme;
		proxy_set_header X-Frappe-Site-Name '"$site_name"';
		proxy_set_header Host '"$site_name"';
		proxy_set_header X-Use-X-Accel-Redirect True;
		proxy_read_timeout 120;
		proxy_redirect off;

		proxy_pass  http://'"$bench_folder"'-frappe;
	}

	# error pages
	error_page 502 /502.html;
	location /502.html {
		root /usr/local/lib/python3.10/dist-packages/bench/config/templates;
		internal;
	}
	
	# optimizations
	sendfile on;
	keepalive_timeout 15;
	client_max_body_size 50m;
	client_body_buffer_size 16K;
	client_header_buffer_size 1k;
	large_client_header_buffers 4 32k;

	# enable gzip compresion
	gzip on;
	gzip_http_version 1.1;
	gzip_comp_level 5;
	gzip_min_length 256;
	gzip_proxied any;
	gzip_vary on;
	gzip_types
		application/atom+xml
		application/javascript
		application/json
		application/rss+xml
		application/vnd.ms-fontobject
		application/x-font-ttf
		application/font-woff
		application/x-web-app-manifest+json
		application/xhtml+xml
		application/xml
		font/opentype
		image/svg+xml
		image/x-icon
		text/css
		text/plain
		text/x-component
		;

	tcp_nodelay on;
	server_tokens off;

	open_file_cache max=65000 inactive=1m;
	open_file_cache_valid 5s;
	open_file_cache_min_uses 1;
	open_file_cache_errors on;

}


EOF'

sudo bash -c 'cat << EOF >> /etc/supervisor/conf.d/'"$bench_folder"'.conf
; Notes:
; priority=1 --> Lower priorities indicate programs that start first and shut down last
; killasgroup=true --> send kill signal to child processes too

[program:'"$bench_folder"'-frappe-web]
command='"$benchdir"'/env/bin/gunicorn -b 127.0.0.1:8000 -w 3 --max-requests 5000 --max-requests-jitter 500 -t 120 frappe.app:application --preload
priority=4
autostart=true
autorestart=true
stdout_logfile='"$benchdir"'/logs/web.log
stderr_logfile='"$benchdir"'/logs/web.error.log
user='"$USER"'
directory='"$benchdir"'/sites

[program:'"$bench_folder"'-frappe-schedule]
command=/usr/local/bin/bench schedule
priority=3
autostart=true
autorestart=true
stdout_logfile='"$benchdir"'/logs/schedule.log
stderr_logfile='"$benchdir"'/logs/schedule.error.log
user='"$USER"'
directory='"$benchdir"'

[program:'"$bench_folder"'-frappe-default-worker]
command=/usr/local/bin/bench worker --queue default
priority=4
autostart=true
autorestart=true
stdout_logfile='"$benchdir"'/logs/worker.log
stderr_logfile='"$benchdir"'/logs/worker.error.log
user='"$USER"'
stopwaitsecs=1560
directory='"$benchdir"'
killasgroup=true
numprocs=1
process_name=%(program_name)s-%(process_num)d

[program:'"$bench_folder"'-frappe-short-worker]
command=/usr/local/bin/bench worker --queue short
priority=4
autostart=true
autorestart=true
stdout_logfile='"$benchdir"'/logs/worker.log
stderr_logfile='"$benchdir"'/logs/worker.error.log
user='"$USER"'
stopwaitsecs=360
directory='"$benchdir"'
killasgroup=true
numprocs=1
process_name=%(program_name)s-%(process_num)d

[program:'"$bench_folder"'-frappe-long-worker]
command=/usr/local/bin/bench worker --queue long
priority=4
autostart=true
autorestart=true
stdout_logfile='"$benchdir"'/logs/worker.log
stderr_logfile='"$benchdir"'/logs/worker.error.log
user='"$USER"'
stopwaitsecs=1560
directory='"$benchdir"'
killasgroup=true
numprocs=1
process_name=%(program_name)s-%(process_num)d

[program:'"$bench_folder"'-redis-cache]
command=/usr/bin/redis-server '"$benchdir"'/config/redis_cache.conf
priority=1
autostart=true
autorestart=true
stdout_logfile='"$benchdir"'/logs/redis-cache.log
stderr_logfile='"$benchdir"'/logs/redis-cache.error.log
user='"$USER"'
directory='"$benchdir"'/sites

[program:'"$bench_folder"'-redis-queue]
command=/usr/bin/redis-server '"$benchdir"'/config/redis_queue.conf
priority=1
autostart=true
autorestart=true
stdout_logfile='"$benchdir"'/logs/redis-queue.log
stderr_logfile='"$benchdir"'/logs/redis-queue.error.log
user='"$USER"'
directory='"$benchdir"'/sites

[program:'"$bench_folder"'-node-socketio]
command=/usr/bin/node '"$benchdir"'/apps/frappe/socketio.js
priority=4
autostart=true
autorestart=true
stdout_logfile='"$benchdir"'/logs/node-socketio.log
stderr_logfile='"$benchdir"'/logs/node-socketio.error.log
user='"$USER"'
directory='"$benchdir"'

[group:'"$bench_folder"'-web]
programs='"$bench_folder"'-frappe-web,'"$bench_folder"'-node-socketio

[group:'"$bench_folder"'-workers]
programs='"$bench_folder"'-frappe-schedule,'"$bench_folder"'-frappe-default-worker,'"$bench_folder"'-frappe-short-worker,'"$bench_folder"'-frappe-long-worker

[group:'"$bench_folder"'-redis]
programs='"$bench_folder"'-redis-cache,'"$bench_folder"'-redis-queue
EOF'

echo -e "${YELLOW}Applying necessary permissions to supervisor...${NC}"
sleep 1
# Change ownership of supervisord.conf
sudo sed -i '6i chown='"$USER"':'"$USER"'' /etc/supervisor/supervisord.conf && \

sudo bash -c 'cat << EOF >> /etc/hosts
127.0.1.1 '"$site_name"'
EOF'

# Restart nginx and supervisor
sudo service nginx restart
sudo service supervisor restart
/usr/bin/supervisorctl reread
/usr/bin/supervisorctl update
sudo service nginx reload

# Setup production again to reflect the new site
#yes | sudo bench setup production $USER && \

echo -e "${YELLOW}Enabling Scheduler...${NC}"
sleep 1

# Enable and resume the scheduler for the site
bench --site $site_name scheduler enable && \
bench --site $site_name scheduler resume && \
bench --site $site_name install-app payments
bench --site $site_name install-app dokos
bench --site $site_name install-app hrms

echo -e "${YELLOW}Restarting bench to apply all changes and optimizing environment pernissions.${NC}"
sleep 1

#Now to make sure the environment is fully setup
sudo chmod 755 /home/$(echo $USER)
sleep 3
printf "${GREEN}Production setup complete! "
printf '\xF0\x9F\x8E\x86'
printf "${NC}\n"
sleep 3


# Now let's reactivate virtual environment
if [ -z "$py_version" ] || [ "$py_major" -lt 3 ] || [ "$py_major" -eq 3 -a "$py_minor" -lt 10 ]; then
    deactivate
fi

echo -e "${GREEN}--------------------------------------------------------------------------------"
echo -e "Congratulations! You have successfully installed Dokos 4."
echo -e "You can start using your new ERPNext installation by visiting http://$site_name"
echo -e "(if you have enabled SSL and used a Fully Qualified Domain Name"
echo -e "during installation) or http://$server_ip to begin."
echo -e "Install additional apps as required. Visit https://docs.erpnext.com for Documentation."
echo -e "Enjoy using ERPNext!"
echo -e "--------------------------------------------------------------------------------${NC}"
