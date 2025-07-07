#!/bin/bash

# اجرای دستورات فقط برای بار اول
FIRST_RUN_FLAG="/root/.packettunnel_setup_done"

if [ ! -f "$FIRST_RUN_FLAG" ]; then
    echo "🚨 Running first-time setup..."

    systemctl stop packettunnel.service
    systemctl disable packettunnel.service
    timedatectl set-timezone Asia/Tehran

    touch "$FIRST_RUN_FLAG"
    echo "First-time setup complete. ✅"
fi

#   Waterwall
WATERWALL_PATH="/root/packettunnel/Waterwall"

#   dir scr
SCRIPT_PATH="/root/restart_waterwall.sh"

echo "🔧 creating $SCRIPT_PATH..."

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

echo "done ✅"

# اضافه کردن به cron root
echo "⏱ adding "

# delete cron
crontab -l 2>/dev/null | grep -v "$SCRIPT_PATH" > /tmp/current_cron || true

# add cron
echo "@reboot $SCRIPT_PATH" >> /tmp/current_cron
echo "*/15 * * * * $SCRIPT_PATH" >> /tmp/current_cron

# ثبت کران‌تاب جدید
crontab /tmp/current_cron
rm /tmp/current_cron

echo "Waterwall cron created ✅"

#  
echo "first run Waterwall... 🚀"
bash "$SCRIPT_PATH"

echo "done.🎉"
