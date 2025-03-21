#!/bin/bash

# Define variables
SSHD_CONFIG_SNC="/etc/ssh/sshd_config_snc"
SERVICE_NAME="snc.service"
PORT="2244"
SERVICE_FILE="/etc/systemd/system/$SERVICE_NAME"

# Step 1: Copy the default SSH configuration to create the new one
echo "Copying default SSH configuration to create snc configuration..."
sudo cp /etc/ssh/sshd_config $SSHD_CONFIG_SNC

# Step 2: Modify the new SSH configuration to use port 2244
echo "Modifying SSH configuration to use port $PORT..."
sudo sed -i "s/^#Port 22/Port $PORT/" $SSHD_CONFIG_SNC

# Step 3: Create the systemd service file for snc.service
echo "Creating systemd service for snc..."
sudo bash -c "cat > $SERVICE_FILE <<EOL
[Unit]
Description=OpenSSH server for snc service
After=network.target

[Service]
ExecStart=/usr/sbin/sshd -f $SSHD_CONFIG_SNC
Restart=always

[Install]
WantedBy=multi-user.target
EOL"

# Step 4: Reload systemd and start the snc service
echo "Reloading systemd and starting $SERVICE_NAME..."
sudo systemctl daemon-reload
sudo systemctl start $SERVICE_NAME
sudo systemctl enable $SERVICE_NAME

# Step 5: Verify the service status
echo "Verifying the status of $SERVICE_NAME..."
sudo systemctl status $SERVICE_NAME

# Step 6: Verify that the service is listening on the correct port
echo "Verifying that snc is listening on port $PORT..."
sudo netstat -tulnp | grep $PORT
