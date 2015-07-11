#!/bin/bash

./clean.sh > install.log

wget --no-check-certificate https://s3-us-west-1.amazonaws.com/charbot-dl/client/app.properties &>> install.log
wget --no-check-certificate https://s3-us-west-1.amazonaws.com/charbot-dl/client/charbot-install-0.1.0-SNAPSHOT.jar &>> install.log
wget --no-check-certificate https://s3-us-west-1.amazonaws.com/charbot-dl/client/charbox-client-0.1.3-SNAPSHOT.jar &>> install.log

./install-client.sh
rm install-client.sh

java -jar charbot-install-0.1.0-SNAPSHOT.jar &>> install.log

rm charbot-install-0.1.0-SNAPSHOT.jar

cp charbot_run.sh charbot_0.1.3.sh
echo 'java -jar charbox-client-0.1.3-SNAPSHOT.jar client &' >> charbot_0.1.3.sh
rm charbot.sh
ln /home/odroid/charbot_0.1.3.sh charbot.sh

./charbot.sh
