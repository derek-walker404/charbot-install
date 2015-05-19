#!/bin/bash

wget http://d15zsdmbm3oz79.cloudfront.net/client/app.properties
wget http://d15zsdmbm3oz79.cloudfront.net/client/charbot-install-0.1.0-SNAPSHOT.jar
wget http://d15zsdmbm3oz79.cloudfront.net/client/charbox-client-0.1.0-SNAPSHOT.jar

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

java -jar charbox-client-0.1.0-SNAPSHOT.jar &
