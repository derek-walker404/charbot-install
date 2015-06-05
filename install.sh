#!/bin/bash

wget https://s3-us-west-1.amazonaws.com/charbot-dl/client/app.properties
wget https://s3-us-west-1.amazonaws.com/charbot-dl/client/charbot-install-0.1.0-SNAPSHOT.jar
wget https://s3-us-west-1.amazonaws.com/charbot-dl/client/charbox-client-0.1.0-SNAPSHOT.jar

echo 'install.service.id = client-installer-charbot' >> app.properties
echo 'install.service.apikey = 4wt589jhergfh3' >> app.properties
echo 'install.service.group = install' >> app.properties

java -jar charbot-install-0.1.0-SNAPSHOT.jar

#### TODO: start on boot
#### TODO: run install on first boot
####        boot -> charbot.sh => (1st boot) install.sh
####                           => (2nd+ boots) client.sh
####
#### echo 'java -jar charbox-client-0.1.0-SNAPSHOT.jar &' >> /etc/rc.local
####

java -jar charbox-client-0.1.0-SNAPSHOT.jar client &
