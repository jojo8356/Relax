# Relax & Breathe

Application de relaxation et respiration profonde développée en Flutter. Elle propose un exercice de respiration guidé avec un élément visuel animé sur lequel se concentrer.

## Fonctionnalités

- **Animation de respiration** : Cercle animé qui s'agrandit et se rétrécit au rythme de la respiration
- **Cycle 4-4-4-4** : Technique de respiration carrée (4 secondes inspiration, 4 secondes rétention, 4 secondes expiration, 4 secondes rétention)
- **Indicateur de phase** : Affichage visuel de la phase en cours
- **Compteur de secondes** : Décompte en temps réel pour chaque phase
- **Couleurs adaptatives** : Chaque phase a sa propre couleur pour faciliter la concentration
- **Contrôles simples** : Démarrer/Pause et Réinitialiser

## Plateformes supportées

- Android
- Linux
- Windows
- macOS
- Web

## Prérequis

- Flutter SDK >= 3.0.0
- Dart SDK >= 3.0.0

## Installation

```bash
# Cloner le projet
git clone <repository-url>
cd Relax

# Installer les dépendances
flutter pub get
```

## Lancement

```bash
# Android
flutter run

# Linux
flutter run -d linux

# Windows
flutter run -d windows

# Web
flutter run -d chrome
```

## Build

```bash
# APK Android
flutter build apk --release

# Linux
flutter build linux --release

# Windows
flutter build windows --release
```

## Structure du projet

```
lib/
└── main.dart          # Application principale avec écran de respiration
```

## Technique de respiration

L'application utilise la technique de **respiration carrée** (box breathing) :

1. **Inspirez** (4 secondes) - Le cercle s'agrandit
2. **Retenez** (4 secondes) - Le cercle reste grand
3. **Expirez** (4 secondes) - Le cercle se rétrécit
4. **Retenez** (4 secondes) - Le cercle reste petit

Cette technique est utilisée pour réduire le stress, améliorer la concentration et favoriser la relaxation.

## Licence

MIT
