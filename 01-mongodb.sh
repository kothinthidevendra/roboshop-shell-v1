#!/bin/bash
## This script is to install mongodb
## User should have sudo access to install
## Add mongo db repo to /etc/yum.repo.d
## Install mongodb, enable service, start service
## Enable remote connection in mongodb config file and restart
## verify the servie status, port and process

user_id=$(id -u)
logs_folder="/var/log/roboshop"
logs_file="${logs_folder}/${0}.log"

if [ $user_id != 0 ]; then 
    echo "Please run this script with sudo access"
    exit 1
fi

mkdir -p $logs_folder

validate(){
    if [ $1 != 0 ]; then
    echo "$2 failed"
    exit 1
    else
    echo "$2 success"
    fi
}

### Copying the repo file to server  ###
cp mongo.repo /etc/yum.repos.d/mongo.repo
validate $? "Adding mongo repo"

dnf install mongodb-org -y
validate $? "installing mongodb"

systemctl enable mongod
systemctl start mongod
validate $? "Enabling and strating the service"

sed -i 's/127.0.0.1/0.0.0.0/g' /etc/mongod.conf
validate $? "Updating the remote connectivity"

systemctl restart mongod
validate $? "restarting mongodb service"

