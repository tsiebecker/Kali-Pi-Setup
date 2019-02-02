#!/bin/bash
parent_path=$( cd "$(dirname "${BASH_SOURCE[0]}")" ; pwd -P )
cd "$parent_path"
#{ sleep 10 && service NetworkManager restart && service wpa_supplicant restart; }&

./mmup.sh ||
./mmdown.sh
