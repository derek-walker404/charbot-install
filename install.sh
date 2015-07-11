#!/bin/bash

./clean.sh > install.log

wget --no-check-certificate https://s3-us-west-1.amazonaws.com/charbot-dl/client/app.properties &>> install.log
wget --no-check-certificate https://s3-us-west-1.amazonaws.com/charbot-dl/client/install-client.sh &>> install.log

./install-auth.sh
rm install-auth.sh

chmod +x install-client.sh
./install-client.sh
