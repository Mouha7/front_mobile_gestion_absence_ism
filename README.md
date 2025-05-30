# Application Mobile de Gestion des Absences ISM

Cette application mobile Flutter permet de gérer les absences des étudiants de l'ISM (Institut Supérieur de Management).

## Fonctionnalités

- Affichage d'un QR code pour l'identification des étudiants
- Visualisation des retards récents
- Historique complet des absences
- Configuration flexible du serveur API
- Détection automatique de la plateforme (iOS, Android, Web)
- Indicateur temporaire de l'état de connexion au serveur

## Prérequis

- Flutter SDK 3.7.2 ou supérieur
- Node.js et npm (pour json-server)
- Un éditeur de code (VS Code recommandé)

## Installation

1. Clonez ce dépôt
2. Installez les dépendances Flutter
   ```bash
   flutter pub get
   ```
3. Installez json-server globalement (si ce n'est pas déjà fait)
   ```bash
   npm install -g json-server
   ```

## Démarrage du serveur backend

1. Vérifiez votre environnement et détectez votre configuration réseau
   ```bash
   chmod +x check-env.sh
   ./check-env.sh
   ```

2. Rendez le script de démarrage exécutable (si ce n'est pas déjà fait)
   ```bash
   chmod +x start-server.sh
   ```
   
3. Exécutez le script pour démarrer json-server
   ```bash
   ./start-server.sh
   ```

Ce script détectera automatiquement votre adresse IP locale et démarrera json-server sur le port 3000.

## Configuration de l'application

L'application détecte automatiquement la plateforme d'exécution et configure l'URL du serveur en conséquence :

- **Simulateur iOS** : `http://localhost:3000`
- **Émulateur Android** : `http://10.0.2.2:3000`
- **Appareils physiques (iOS/Android)** : Nécessite l'adresse IP de l'ordinateur exécutant le serveur

Pour lancer l'application :
```bash
flutter run
```

### Configuration manuelle

L'application inclut une interface de configuration du serveur accessible depuis l'indicateur de connexion. Cette interface permet de :

1. Tester la connexion à une URL personnalisée
2. Rechercher les adresses IP disponibles sur le réseau local
3. Choisir parmi des configurations prédéfinies

## Résolution des problèmes courants

### Problèmes de connexion au serveur

1. **L'application ne se connecte pas au serveur**
   - Vérifiez que le serveur est en cours d'exécution (`./start-server.sh`)
   - Vérifiez que l'URL du serveur est correctement configurée

2. **Erreur "Connection refused" sur un appareil physique**
   - Assurez-vous que l'appareil et l'ordinateur sont sur le même réseau Wi-Fi
   - Vérifiez que l'adresse IP de l'ordinateur est correctement configurée
   - Désactivez temporairement le pare-feu de l'ordinateur

3. **Erreur "Network unreachable" sur un émulateur Android**
   - Utilisez `10.0.2.2` au lieu de `localhost` dans l'URL du serveur

## Structure du projet

- `lib/app/modules/etudiant/views/` : Écrans de l'interface utilisateur
- `lib/app/controllers/` : Contrôleurs de logique métier (GetX)
- `lib/app/data/services/` : Services pour l'API et le stockage
- `lib/theme/` : Configuration du thème de l'application
- `db.json` : Base de données simulée pour json-server
- `start-server.sh` : Script de démarrage du serveur JSON
- `check-env.sh` : Script de détection de l'environnement et de la configuration réseau

## Plateformes supportées

- iOS (simulateur et appareils physiques)
- Android (émulateur et appareils physiques)
- Web (expérimental)

## Contribuer

1. Fork ce dépôt
2. Créez une branche pour votre fonctionnalité
3. Faites vos modifications
4. Soumettez une pull request

## Licence

Ce projet est sous licence MIT.
