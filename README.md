# Oppidum

Oppidum aims to provide users with cultural, historical, tourist, or other information on the cities offered in the application.

<div style='display:flex;flex-direction:row'>
<img src="https://github.com/O-Plums/Oppidum/blob/main/repo_images/cities_view.png" width="175" height="auto" />
<img src="https://github.com/O-Plums/Oppidum/blob/main/repo_images/tourism_view.png" width="175" height="auto" />
<img src="https://github.com/O-Plums/Oppidum/blob/main/repo_images/drawer_view.png" width="175" height="auto" />
<img src="https://github.com/O-Plums/Oppidum/blob/main/repo_images/city_view.png" width="175" height="auto" />
<img src="https://github.com/O-Plums/Oppidum/blob/main/repo_images/place_view.png" width="175" height="auto" />
</div>


# Presentation

The idea of this project came to us for different reasons. 

Firstly, when we visit certain cities and we find ourselves in front of certain buildings, we would like to find information about them easily and quickly, without having to undertake extensive research. \
Secondly, when we go to the tourist office, we usually come out with countless flyers and we are not more advanced on what we want to visit and discover. We are even discouraged. \
Thirdly, when we visit well-known monuments in a city, the explanatory "posters" on them are often taken over by the crowd. These become, then, difficult to access. The inaccessibility of this information motivates us to create this application. 

The application aims to respond to these disadvantages by making historical, tourist and cultural information more accessible and centralized.
Subsequently, the application aims to offer users cultural, historical, tourist, or other information on the cities proposed in the application. The objective of the application is to promote the culture of the cities, in particular by making their history accessible to all. The application will be an added value for the cities and their technological development and will highlight their history for all to see. Cities that wish to promote and transmit their history can also find a tourist interest in the application. These are all motivations that should push cities to be interested in the project. 

The application consists of three main parts: "History", "Tourism" and "Culture". Each of them will present monuments, places, etc. that represent and illustrate them. Users will also find information about them. For each of them, the user will have the possibility to "approve" and comment on it. A fourth part will contain general information about the city, a brief description of its history and will also give access to a calendar of the various events in the city.

# Getting Started

```
git clone https://github.com/O-Plums/Oppidum
flutter pub get
flutter run
```
* Tree of the project
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
* Net folder: Find all the request to the api build with strapi.
* Models folder: All the model use in the app to store flash information.
* Route: A file that list all the route of the app.
* Views folder: Find all Views of the app, one folder by View and a folder Widgets for the global widget.

# Requirements

Flutter
```
flutter --version
Flutter 2.0.1 • channel stable • https://github.com/flutter/flutter.git
Framework • revision c5a4b4029c (3 months ago) • 2021-03-04 09:47:48 -0800
Engine • revision 40441def69
Tools • Dart 2.12.0
```

# Contributing

Please read our [Contributing Guide](https://github.com/O-Plums/Oppidum/blob/main/CONTRIBUTING.md) before submitting a Pull Request to the project.

# License

Oppidum is [MIT](https://github.com/O-Plums/Oppidum/blob/main/LICENSE) licensed.
