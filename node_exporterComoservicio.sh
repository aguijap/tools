
#!/bin/bash

# Variables
NODE_EXPORTER_VERSION="1.3.1"  # Cambia esto a la versión que desees
NODE_EXPORTER_USER="node_exporter"
NODE_EXPORTER_DIR="/usr/local/bin"
NODE_EXPORTER_URL="https://github.com/prometheus/node_exporter/releases/download/v${NODE_EXPORTER_VERSION}/node_exporter-${NODE_EXPORTER_VERSION}.linux-amd64.tar.gz"
SERVICE_FILE="/etc/systemd/system/node_exporter.service"

# Paso 1: Crear un usuario para node_exporter
echo "Creando usuario para node_exporter..."
sudo useradd --no-create-home --shell /bin/false $NODE_EXPORTER_USER

# Paso 2: Descargar y extraer node_exporter
echo "Descargando node_exporter..."
curl -LO $NODE_EXPORTER_URL

echo "Extrayendo node_exporter..."
tar -xvf node_exporter-${NODE_EXPORTER_VERSION}.linux-amd64.tar.gz

echo "Moviendo node_exporter a /usr/local/bin..."
sudo mv node_exporter-${NODE_EXPORTER_VERSION}.linux-amd64/node_exporter $NODE_EXPORTER_DIR/

# Paso 3: Limpiar archivos descargados
rm -rf node_exporter-${NODE_EXPORTER_VERSION}.linux-amd64*
  
# Paso 4: Crear archivo de servicio systemd
echo "Creando archivo de servicio systemd para node_exporter..."
echo "[Unit]
Description=Node Exporter
Documentation=https://github.com/prometheus/node_exporter

[Service]
User=$NODE_EXPORTER_USER
ExecStart=$NODE_EXPORTER_DIR/node_exporter
Restart=always

[Install]
WantedBy=multi-user.target" | sudo tee $SERVICE_FILE > /dev/null

# Paso 5: Recargar systemd y habilitar el servicio
echo "Recargando systemd y habilitando node_exporter..."
sudo systemctl daemon-reload
sudo systemctl enable node_exporter
sudo systemctl start node_exporter

# Paso 6: Verificar el estado del servicio
echo "Verificando el estado de node_exporter..."
sudo systemctl status node_exporter
