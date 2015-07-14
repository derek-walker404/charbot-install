#!/bin/bash




LOG_FILE=upgrade-0.1.4.log
NOW=$(date)
echo $NOW > $LOG_FILE
echo 'Changing device.version to 0.1.4' >> $LOG_FILE
echo 'Install new version of client' >> $LOG_FILE
echo '    - Fixed SST Bug.' >> $LOG_FILE
echo '    - Added timeout to SST job.' >> $LOG_FILE
echo '    - Additional Logging.' >> $LOG_FILE
echo '    - Adding device.version to properties file.' >> $LOG_FILE




# replace device version
wget https://s3-us-west-1.amazonaws.com/charbot-dl/client/charbox-client-0.1.4-SNAPSHOT.jar
grep -rl 'java -jar charbo*' charbot.sh | xargs sed -i -e 's/java -jar charbox.*$/java -jar charbox-client-0.1.4-SNAPSHOT.jar client \&/g'
rm charbot.sh-e




# append device version
echo 'device.version = 0.1.4' >> app.properties




# clean up
rm upgrade-0.1.4.sh
sudo reboot
