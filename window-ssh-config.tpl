add-content -path C:/Users/KWAME/.ssh/config -value @'

Host ${hostname}
  HostName ${hostname}
  User ${user}
  IdentityFile ${identifyfile}
  '@