#!/bin/bash

LOG_FILE=upgrade-0.1.0.log
NOW=$(date)
echo $NOW > $LOG_FILE
echo 'Changing device.version to 0.1.0' >> $LOG_FILE
echo 'Adding auto-recovery cron job' >> $LOG_FILE



# replace device version
grep -rl 'device.version = *' app.properties | xargs sed -i -e 's/device.version = .*$/device.version = 0.1.0/g'
rm app.properties-e



# add update script
echo '#!/bin/bash' > check-alive.sh
echo '' >> check-alive.sh
echo "PATH=$PATH" >> check-alive.sh
echo '' >> check-alive.sh
echo 'COUNT=$(ps aux | grep -c "java -jar charbo")' >> check-alive.sh
echo 'if [ "$COUNT" -eq "1" ]' >> check-alive.sh
echo 'then' >> check-alive.sh
echo '    echo "$(date) Client Dead" >> boot.log' >> check-alive.sh
echo '    sudo reboot' >> check-alive.sh
echo 'fi' >> check-alive.sh
 
chmod +x check-alive.sh




# add update script cron job
CRON=charbot.cron
echo 'SHELL=/bin/sh' > $CRON
echo "PATH=$PATH" >> $CRON
echo '' >> $CRON
echo '* * * * * sh /home/odroid/check-alive.sh' >> $CRON
crontab $CRON




# clean up
rm upgrade-0.1.0.sh
rm $CRON
sudo reboot
