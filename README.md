powerdns-sqlite3-gui
================

powerdns-sqlite3にWebGUIのPowerDNS-Adminをパッケージしました。

■変更点

・PowerDNS-Adminが追加、それに伴い標準のWebサーバー機能は8080ポートで動作するよう修正。

・環境変数に「RECURSOR」を追加。これにより設定外ドメインの外部問い合わせ先を指定できます。

・環境変数に「ALLOW_RECURSION」を追加

###Usage:

git clone https://github.com/gittrname/powerdns-sqlite3-gui.git

docker build -t powerdns-sqlite3-gui powerdns-sqlite3-gui

docker run -d --name pdns -p 53:53/udp -p 53:53/tcp -p 80:80 -p 8080:8080 -v /your/shared/volume:/data -e "WEBPASSWD=password" -e "RECURSOR=8.8.8.8" -e "ALLOW_RECURSION=192.168.1.0/24" powerdns-sqlite3-gui:latest
