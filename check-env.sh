#!/bin/bash

# Détecter l'environnement
detect_environment() {
  echo ""
  echo "🧪 DÉTECTION DE L'ENVIRONNEMENT DE DÉVELOPPEMENT"
  echo "=========================================="
  
  # Vérifier l'OS
  OS=$(uname)
  echo "📊 Système d'exploitation: $OS"
  
  # Vérifier la version de Flutter
  FLUTTER_VERSION=$(flutter --version | head -n 1)
  echo "📊 Version de Flutter: $FLUTTER_VERSION"
  
  # Trouver les interfaces réseau et adresses IP
  echo ""
  echo "🔍 INTERFACES RÉSEAU DISPONIBLES"
  echo "=============================="
  if [[ "$OS" == "Darwin" ]]; then  # macOS
    NETWORK_INTERFACES=$(ifconfig | grep -E "^[a-z0-9]+" | awk -F ":" '{print $1}')
    for interface in $NETWORK_INTERFACES; do
      IP=$(ifconfig $interface | grep "inet " | grep -v 127.0.0.1 | awk '{print $2}')
      if [[ ! -z "$IP" ]]; then
        echo "📡 Interface: $interface - Adresse IP: $IP"
      fi
    done
  elif [[ "$OS" == "Linux" ]]; then  # Linux
    NETWORK_INTERFACES=$(ip -o link show | awk -F': ' '{print $2}')
    for interface in $NETWORK_INTERFACES; do
      IP=$(ip -o -4 addr list $interface | awk '{print $4}' | cut -d/ -f1)
      if [[ ! -z "$IP" && "$IP" != "" ]]; then
        echo "📡 Interface: $interface - Adresse IP: $IP"
      fi
    done
  fi
  
  echo ""
  echo "🌐 CONFIGURATION DU SERVEUR"
  echo "========================="
  if [[ "$OS" == "Darwin" ]]; then  # macOS
    IP=$(ifconfig en0 | grep "inet " | awk '{print $2}')
    if [[ -z "$IP" ]]; then
      IP=$(ifconfig en1 | grep "inet " | awk '{print $2}')
    fi
  elif [[ "$OS" == "Linux" ]]; then  # Linux
    IP=$(hostname -I | awk '{print $1}')
  fi
  
  echo "🔗 URL du serveur: http://$IP:3000"
  echo ""
  echo "📱 CONFIGURATION POUR DIFFÉRENTES PLATEFORMES"
  echo "==========================================="
  echo "🔹 Simulateur iOS:       http://localhost:3000"
  echo "🔹 Émulateur Android:    http://10.0.2.2:3000"
  echo "🔹 Appareil iOS:         http://$IP:3000"
  echo "🔹 Appareil Android:     http://$IP:3000"
  echo "🔹 Navigateur Web:       http://localhost:3000"
  echo ""
}

# Lancer le script de détection
detect_environment

# Demander si l'utilisateur souhaite démarrer le serveur
echo "Voulez-vous démarrer le serveur JSON ? (o/n)"
read START_SERVER

if [[ "$START_SERVER" == "o" || "$START_SERVER" == "O" || "$START_SERVER" == "oui" ]]; then
  echo "Démarrage du serveur..."
  ./start-server.sh
else
  echo "Serveur non démarré. Vous pouvez le démarrer manuellement avec './start-server.sh'"
fi
