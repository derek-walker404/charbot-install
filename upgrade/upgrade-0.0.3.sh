#!/bin/bash

rm upgrade-0.0.1.sh
rm upgrade-0.0.2.sh

grep -rl 'device.version = *' app.properties | xargs sed -i -e 's/device.version = .*$/device.version = 0.0.3/g'
rm app.properties-e

echo 'Changing device.version to 0.0.3' > upgrade-0.0.3.log

rm upgrade-0.0.3.sh

sudo reboot
