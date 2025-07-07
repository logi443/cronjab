#!/bin/bash

#   Waterwall
WATERWALL_PATH="/root/packettunnel/Waterwall"

#   dir scr
SCRIPT_PATH="/root/restart_waterwall.sh"

echo "🔧 creating    $SCRIPT_PATH..."

# scr
cat <<EOF > "$SCRIPT_PATH"
#!/bin/bash

# b
/usr/bin/pkill -f "$WATERWALL_PATH" 2>/dev/null

# sleep 
sleep 5

# b
cd /root/packettunnel
/usr/bin/nohup ./Waterwall > /dev/null 2>&1 &
EOF

# chmod
chmod +x "$SCRIPT_PATH"

echo "✅done"

# اضافه کردن به cron root
echo "⏱ adding "

# delete cron
crontab -l 2>/dev/null | grep -v "$SCRIPT_PATH" > /tmp/current_cron || true

# add cron
echo "@reboot $SCRIPT_PATH" >> /tmp/current_cron
echo "*/10 * * * * $SCRIPT_PATH" >> /tmp/current_cron

# ثبت کران‌تاب جدید
crontab /tmp/current_cron
rm /tmp/current_cron

echo "✅  Waterwall cron created"

#  
echo "🚀  frist run Waterwall..."
bash "$SCRIPT_PATH"

echo "🎉  done."
