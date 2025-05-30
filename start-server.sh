#!/bin/bash

# S'assurer que json-server est installé
if ! command -v json-server &> /dev/null; then
    echo "json-server n'est pas installé. Installation..."
    npm install -g json-server
fi

# Fonction pour obtenir toutes les adresses IP disponibles
get_ip_addresses() {
    echo "=== Adresses IP disponibles ==="
    
    # Pour macOS
    if command -v ifconfig &> /dev/null; then
        echo "Interfaces réseau (macOS):"
        ifconfig | grep "inet " | grep -v 127.0.0.1 | awk '{print "  - " $2}'
    fi
    
    # Pour Linux/macOS alternatif
    if command -v hostname &> /dev/null; then
        echo "Hostname IP (Linux/macOS):"
        hostname -I | tr ' ' '\n' | grep -v '^$' | awk '{print "  - " $1}'
    fi
    
    echo ""
    echo "=== Configuration de l'application ==="
    echo "📱 Simulateur iOS: utilisez 'localhost' ou 'http://localhost:3000'"
    echo "🤖 Émulateur Android: utilisez '10.0.2.2' ou 'http://10.0.2.2:3000'"
    echo "📱 iPhone/iPad physique: utilisez l'une des adresses IP ci-dessus, par exemple 'http://192.168.1.x:3000'"
    echo "🤖 Android physique: utilisez l'une des adresses IP ci-dessus, par exemple 'http://192.168.1.x:3000'"
    echo ""
}

# Obtenir l'adresse IP locale pour permettre l'accès depuis des appareils mobiles
IP_ADDRESS=$(ifconfig en0 | grep inet | grep -v inet6 | awk '{print $2}')
if [ -z "$IP_ADDRESS" ]; then
    # Essayer une autre interface si en0 n'a pas d'adresse IP
    IP_ADDRESS=$(ifconfig en1 | grep inet | grep -v inet6 | awk '{print $2}')
fi
if [ -z "$IP_ADDRESS" ]; then
    # Utiliser localhost comme fallback
    IP_ADDRESS="localhost"
fi

# Afficher les informations sur les adresses IP
get_ip_addresses

echo "=== Démarrage du serveur ==="
echo "Démarrage du serveur sur l'adresse IP: $IP_ADDRESS"
echo "Pour accéder au serveur:"
echo "🌐 Dans un navigateur: http://$IP_ADDRESS:3000"
echo "📱 Depuis un appareil mobile: http://$IP_ADDRESS:3000"
echo "📝 Pour modifier les données: http://$IP_ADDRESS:3000/db"
echo ""

# Démarrer json-server avec le fichier db.json
json-server --watch db.json --port 3000 --host "$IP_ADDRESS"
