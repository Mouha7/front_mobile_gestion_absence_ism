# Serveur Fictif pour l'Application de Gestion des Absences ISM

Ce projet inclut un serveur fictif basé sur json-server pour faciliter le développement et les tests de l'application mobile.

## Prérequis

- Node.js installé sur votre machine
- npm (gestionnaire de paquets Node.js)

## Installation

Les dépendances nécessaires sont déjà configurées dans le projet. Si vous avez cloné ce dépôt récemment, exécutez:

```bash
npm install
```

## Démarrage du serveur

Plusieurs options sont disponibles pour démarrer le serveur:

### 1. Serveur simple

```bash
npm run server
```

Démarre json-server avec la base de données `db.json` sur le port 3000.

### 2. Serveur avec délai simulé

```bash
npm run server-delay
```

Démarre json-server avec un délai de 1 seconde pour simuler la latence réseau.

### 3. Serveur personnalisé

```bash
npm run server-custom
```

Démarre le serveur avec des routes personnalisées définies dans `server.js`.

## Points d'accès API

Une fois le serveur démarré, les ressources suivantes sont accessibles:

- Pointages: http://localhost:3000/pointages
- Étudiants: http://localhost:3000/etudiants
- Absences: http://localhost:3000/absences
- Matières: http://localhost:3000/matieres
- Classes: http://localhost:3000/classes

### Routes personnalisées

- Pointages par classe: http://localhost:3000/pointages/classe/:classe
- Étudiants par classe: http://localhost:3000/etudiants/classe/:classe

## Configuration de l'application Flutter

Pour configurer l'application Flutter afin qu'elle utilise le serveur fictif:

1. Assurez-vous que le serveur est en cours d'exécution
2. Dans votre application Flutter, utilisez l'URL appropriée selon le contexte:
   - Pour l'émulateur Android: `http://10.0.2.2:3000`
   - Pour le simulateur iOS: `http://localhost:3000`
   - Pour un appareil physique: utilisez l'adresse IP de votre machine

Pour simplifier, utilisez la classe `MockApiConfig` fournie:

```dart
// Dans votre fichier d'initialisation (par exemple main.dart)
import 'package:front_mobile_gestion_absence_ism/app/data/services/mock_api_config.dart';

void main() {
  // ...initialisation...
  
  // Configurez l'API pour utiliser le serveur fictif en mode développement
  if (kDebugMode) {
    MockApiConfig.setupMockApi();
  }
  
  // ...suite de l'initialisation...
}
```

## Modification des données

Vous pouvez modifier les données dans le fichier `db.json` pour adapter le jeu de données à vos besoins de test.
