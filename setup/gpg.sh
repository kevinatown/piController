#!/bin/bash

git clone https://github.com/DexterInd/GoPiGo.git
source GoPiGo/Setup/install.sh
python GoPiGo/Software/Python/setup.py install

# sudo sh -c "curl -kL dexterindustries.com/update_gopigo | bash"