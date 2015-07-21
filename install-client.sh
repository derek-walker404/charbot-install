#!/bin/bash

wget --no-check-certificate https://s3-us-west-1.amazonaws.com/charbot-dl/client/charbot-install-0.1.0-SNAPSHOT.jar &>> install.log
wget --no-check-certificate https://s3-us-west-1.amazonaws.com/charbot-dl/client/charbox-client-0.1.5-SNAPSHOT.jar &>> install.log

java -jar charbot-install-0.1.0-SNAPSHOT.jar &>> install.log

rm charbot-install-0.1.0-SNAPSHOT.jar

cp charbot_run.sh charbot_0.1.5.sh
echo 'java -jar charbox-client-0.1.5-SNAPSHOT.jar client &' >> charbot_0.1.5.sh
rm charbot.sh
ln /home/odroid/charbot_0.1.5.sh charbot.sh

./charbot.sh
