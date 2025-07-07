#!/bin/bash

#   Waterwall
WATERWALL_PATH="/root/packettunnel/packettannel"

#   dir scr
SCRIPT_PATH="/root/restart_waterwall.sh"

echo "🔧 ایجاد اسکریپت ریستارت در $SCRIPT_PATH..."

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
echo "⏱ اضافه کردن کران‌جاب برای اجرای هر ۱۵ دقیقه..."

# delete cron
crontab -l 2>/dev/null | grep -v "$SCRIPT_PATH" > /tmp/current_cron || true

# add cron
@reboot /root/restart_waterwall.sh
echo "*/15 * * * * $SCRIPT_PATH" >> /tmp/current_cron

# ثبت کران‌تاب جدید
crontab /tmp/current_cron
rm /tmp/current_cron

echo "✅ کران‌جاب ثبت شد. هر ۱۵ دقیقه Waterwall ریستارت میشه."

#  
echo "🚀 اجرای اولیه Waterwall..."
bash "$SCRIPT_PATH"

echo "🎉 نصب کامل شد."
