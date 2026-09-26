## Requires ufw 

# Setup default values
sudo ufw default deny incoming
sudo ufw default allow outgoing

sudo systemctl enable --now ufw
sudo ufw enable
sudo ufw status verbose
