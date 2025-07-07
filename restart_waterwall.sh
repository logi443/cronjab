#!/bin/bash

# Waterwall binary path
WATERWALL_PATH="/root/packettunnel/Waterwall"

# Restart script path
SCRIPT_PATH="/root/restart_waterwall.sh"

# Log files
LOG_FILE="/root/waterwall.log"
CRON_LOG="/root/waterwall_cron_debug.log"

echo "🔧 Creating $SCRIPT_PATH..."

# Create the restart script
cat <<EOF > "$SCRIPT_PATH"
#!/bin/bash

# Log script execution (for cron debug)
echo "[\$(date)] Running restart_waterwall.sh" >> "$CRON_LOG"

# Kill any existing Waterwall process
/usr/bin/pkill -f "$WATERWALL_PATH" 2>/dev/null

# Wait a few seconds
sleep 5

# Start Waterwall with nohup and log output
/usr/bin/nohup $WATERWALL_PATH > "$LOG_FILE" 2>&1 &
EOF

# Make restart script executable
chmod +x "$SCRIPT_PATH"

echo "✅ Restart script created."

# Update root crontab
echo "⏱ Updating cron..."

# Remove duplicate entries
crontab -l 2>/dev/null | grep -v "$SCRIPT_PATH" > /tmp/current_cron || true

# Add reboot and interval jobs
echo "@reboot $SCRIPT_PATH" >> /tmp/current_cron
echo "*/15 * * * * $SCRIPT_PATH" >> /tmp/current_cron

# Apply new crontab
crontab /tmp/current_cron
rm /tmp/current_cron

echo "✅ Cron jobs added."

# Run Waterwall for the first time
echo "🚀 First manual run..."
bash "$SCRIPT_PATH"

echo "🎉 Done."
