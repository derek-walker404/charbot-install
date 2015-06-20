#!/bin/bash

echo 'Hello, Charbot++!' > upgrade-0.0.2.log

grep -rl 'device.version = *' app.properties | xargs sed -i -e 's/device.version = .*$/device.version = 0.0.2/g'
rm app.properties-e

sudo reboot
