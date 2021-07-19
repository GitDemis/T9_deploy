
#!/bin/sh

## El nombre de la carpeta se utilizará como nombre de servicio, el script se puede correr en cualquier tomcat9

echo "Generando variables.."

APPNAME="${PWD##*/}" #nombre del directorio
DIR="${PWD}" #ruta fija de la carpeta

echo $APPNAME
echo $DIR

echo "Generando archivo de servicio.."

## Se genera el archivo de configuracion en la carpeta de servicios systemd utilizando la variable como nombre

cat > /etc/systemd/system/$APPNAME.service << EOF
[Unit]
Description=Tomcat Server
After=syslog.target network.target

[Service]
Type=forking
User=tomcat
Group=tomcat

Environment=JAVA_HOME=/usr/lib/jvm/jre
Environment='JAVA_OPTS=-Djava.awt.headless=true'
Environment=CATALINA_HOME=$DIR
Environment=CATALINA_BASE=$DIR
Environment=CATALINA_PID=$DIR/temp/tomcat.pid
Environment='CATALINA_OPTS=-Xms512M -Xmx1024M'
ExecStart=$DIR/bin/catalina.sh start
ExecStop=$DIR/bin/catalina.sh stop

[Install]
WantedBy=multi-user.target
EOF

echo "Iniciando Servicio $APPNAME.."

# Se recargan los servicios de systemd

sudo systemctl daemon-reload

echo "Servicio $APPNAME iniciado. Configurando Autostart.."

# Se inicia y se habilita el inicio automatico de la aplicacion

sudo systemctl start $APPNAME.service
sudo systemctl enable $APPNAME.service

echo "Servicio configurado e iniciado. Muchas gracias. SystemsCorp S.A."
