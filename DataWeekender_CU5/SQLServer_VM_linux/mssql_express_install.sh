#!/bin/bash
MSSQL_SA_PASSWORD='${sqlpassword}'
TCP_PORT='${sqlport}'

# Product ID of the version of SQL server you're installing
# Must be evaluation, developer, express, web, standard, enterprise, or your 25 digit product key
# Defaults to developer
MSSQL_PID='express'

wget -qO- https://packages.microsoft.com/keys/microsoft.asc | sudo apt-key add -

sudo add-apt-repository "$(wget -qO- https://packages.microsoft.com/config/ubuntu/18.04/mssql-server-2019.list)"

sudo apt-get update
sudo apt-get install -y mssql-server

sudo MSSQL_SA_PASSWORD=$MSSQL_SA_PASSWORD MSSQL_PID=$MSSQL_PID /opt/mssql/bin/mssql-conf -n setup accept-eula
sudo systemctl restart mssql-server

# https://docs.microsoft.com/en-us/sql/linux/sql-server-linux-configure-mssql-conf?view=sql-server-2017
sudo /opt/mssql/bin/mssql-conf set telemetry.customerfeedback false
sudo systemctl restart mssql-server

sudo /opt/mssql/bin/mssql-conf set network.tcpport $TCP_PORT
sudo systemctl restart mssql-server

# Configure firewall to allow TCP port
sudo ufw allow $TCP_PORT/tcp
sudo ufw reload