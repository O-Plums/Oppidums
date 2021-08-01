<p align="center">
  <a href="https://strapi.io">
    <img src="https://github.com/O-Plums/Oppidums/blob/main/assets/oppidums.png" width="318px" alt="Oppidums logo" />
  </a>
  <h1 align='center'>Oppidums</h1>
</p>

Oppidums a pour but d'offrir aux utilisateurs des informations culturelles, historiques, touristiques, ou autres, sur les villes proposées dans l'application.

<div style='display:flex;flex-direction:row'>
<img src="https://github.com/O-Plums/Oppidums/blob/main/repo_images/screenshot1.png" width="175" height="auto" />
<img src="https://github.com/O-Plums/Oppidums/blob/main/repo_images/screenshot2.png" width="175" height="auto" />
<img src="https://github.com/O-Plums/Oppidums/blob/main/repo_images/screenshot3.png" width="175" height="auto" />
<img src="https://github.com/O-Plums/Oppidums/blob/main/repo_images/screenshot4.png" width="175" height="auto" />
</div>

# Telecharger l'app
<p align="center">
  <a href="https://play.google.com/store/apps/details?id=com.oppidums.app">
    <img src="https://github.com/O-Plums/Oppidums/blob/main/repo_images/playstore.png" width="318px" alt="android logo" />
  </a>
     <a href="https://apps.apple.com/us/app/oppidums/id1574072581">
    <img src="https://github.com/O-Plums/Oppidums/blob/main/repo_images/appstore.png" width="300px" alt="ios logo" />
  </a>
</p>


# Présentation

L’idée de ce projet nous est venue pour différentes raisons. 

Premièrement, lorsque nous visitons certaines villes et que nous nous trouvons face à certains bâtiments, nous souhaiterons trouver facilement et rapidement des informations sur ceux-ci, sans devoir entreprendre de grandes recherches. \
Deuxièmement, lorsque que nous nous rendons à l’office de tourisme, habituellement, nous en ressortons avec un nombre incalculable de flyers et nous ne sommes pas plus avancés sur ce que nous voulons visiter et découvrir. Nous en sommes, même, découragé. \
Troisièmement, lorsque nous visitons des monuments assez connus dans une ville, les « affiches » explicatives sur ceux-ci sont souvent prises d'assaut par la foule. Celles-ci deviennent, alors, difficilement accessibles. 

L’inaccessibilité de ces informations nous motive à réaliser cette application. \
L’application a donc pour but de répondre à ces inconvénients, en rendant les informations historiques, touristiques et culturelles plus accessibles et centralisées.

Par la suite, l’application aura pour but d’offrir aux utilisateurs des informations culturelles, historiques, touristiques, ou autres, sur les villes proposées dans l’application. L’objectif de celle-ci est de promouvoir la culture des villes, notamment en rendant leur histoire accessible à tous. L'application sera une plus-value pour les villes et leur développement technologique et mettra en évidence, aux yeux de tous, leur histoire. Les villes qui souhaitent promouvoir et transmettre leur histoire, peuvent aussi trouver un intérêt touristique dans l’application. Voilà autant de motivations qui devraient pousser les villes à s’intéresser au projet. 

L'application est constituée de trois grandes parties : « Histoire », « Tourisme » et « Culture ». Chacune d'elles présentera des monuments, lieux, etc. qui les représentent, les illustrent. Les utilisateurs y trouveront, aussi, des informations sur ceux-ci. Pour chacun d’entre eux, l’utilisateur aura la possibilité « d’approuver » et de le commenter. Une quatrième partie reprendra des informations générales sur la ville, un bref descriptif de son histoire et donnera, également, accès à un calendrier reprenant les divers événements de la ville.

# Démarrez l'application

```
git clone https://github.com/O-Plums/Oppidums
flutter pub get
flutter run
```
* L'architecture du projet
```
lib
├── app_config.dart 
├── main.dart
├── main_prod.dart
├── main_staging.dart
├── models
│   ├── city_model.dart
│   └── user_model.dart
├── net 
│   ├── city_api.dart
│   ├── ***
│   └── user_api.dart
├── router.dart
└── views
    ├── calendar
    │   └── ***
    ├── city
    │   ├── ***
    ├── home
    │   ├── ***
    ├── meet
    │   ├── ***
    ├── place
    │   └── place_view.dart
    ├── splash
    │   └── splash_view.dart
    └── widgets
        ├── app_bar.dart
        ├── ***
        └── simple_select.dart
```
* Dossier "Net" : Trouvez toutes les requêtes API construites avec Strapi.
* Dossier "Models" : Tous les models utilisés dans l'application pour garder les informations "flash".
* Fichier "Route" : Un fichier qui liste toutes les routes de l'application.
* Dossier "Views" : Trouvez toutes les "Views" de l'application, un dossier par "View" et un dossier "Widgets" rassemblant tous les widgets utilisés.

# Pré-requis

Flutter
```
flutter --version
Flutter 2.0.1 • channel stable • https://github.com/flutter/flutter.git
Framework • revision c5a4b4029c (3 months ago) • 2021-03-04 09:47:48 -0800
Engine • revision 40441def69
Tools • Dart 2.12.0
```

# Contribution

Veuillez lire nos [Contributing Guide](https://github.com/O-Plums/Oppidums/blob/main/CONTRIBUTING.md) avant de soumettre des "Pulls requests" pour notre projet.

# License

Oppidums est [MIT](https://github.com/O-Plums/Oppidums/blob/main/LICENSE) licensée.
