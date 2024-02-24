cat << EOF >> ~/.ssh/config

Host ${hostname}
    Hostname ${hostname}
    User ${user}
    Identifyfile ${Identifyfile}
EOF