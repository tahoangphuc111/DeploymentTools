#!/bin/bash
set -e
sudo apt update -y
sudo apt upgrade -y
sudo apt install -y software-properties-common
sudo add-apt-repository ppa:deadsnakes/ppa -y
sudo apt update -y
sudo apt install -y \
  python3.10 \
  python3.10-dev \
  python3.10-venv \
  python3.10-distutils
sudo apt install -y \
  git gcc g++ make \
  libxml2-dev libxslt1-dev zlib1g-dev gettext \
  curl redis-server pkg-config \
  memcached build-essential libseccomp-dev
curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
sudo apt install -y nodejs
sudo npm install -g sass postcss-cli postcss autoprefixer
sudo apt install -y mariadb-server libmysqlclient-dev
sudo service mysql start
sudo mysql <<EOF
CREATE DATABASE IF NOT EXISTS dmoj
  DEFAULT CHARACTER SET utf8mb4
  DEFAULT COLLATE utf8mb4_general_ci;

CREATE USER IF NOT EXISTS 'dmoj'@'localhost'
  IDENTIFIED BY 'greenhat1998';

GRANT ALL PRIVILEGES ON dmoj.* TO 'dmoj'@'localhost';
FLUSH PRIVILEGES;
EOF

sudo mariadb-tzinfo-to-sql /usr/share/zoneinfo | sudo mariadb mysql
python3.10 -m venv venv
source venv/bin/activate
python -m pip install --upgrade pip setuptools wheel
cd site
pip install mysqlclient==2.1.1
pip install websocket-client
pip install -r requirements.txt
pip install lxml_html_clean
npm install
mkdir -p problems media static
./make_style.sh
python manage.py collectstatic --noinput
python manage.py compilemessages
python manage.py compilejsi18n
python manage.py migrate
python manage.py loaddata navbar
python manage.py loaddata language_small
python manage.py loaddata demo
python manage.py addjudge judge01 "abcdefghijklmnopqrstuvwxyz"
pip install dmoj
