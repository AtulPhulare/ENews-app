# enews

1. Dependencies:
Add the following dependencies to your pubspec.yaml file:

dependencies:
  get: ^4.6.6
  http: ^1.2.2
  intl: ^0.20.1
  shared_preferences: ^2.3.3
  shimmer: ^3.0.0

2. Setup:
Install Flutter:
Follow the official Flutter installation guide to install Flutter.

Get Dependencies: Run the following command to fetch the dependencies:

flutter pub get

3. Run the App:

Use an emulator or a real device to run the app:
flutter run


# enews Flutter App Overview

This ENews Flutter app uses GetX for theme management, Shimmer for loading animations, and SharedPreferences for saving articles locally. It includes a search feature to find articles based on their titles.

App Structure:
main.dart: The entry point of the app, initializing necessary setups.

controller Folder:
theme_controller.dart: Handles the app's theme (dark/light mode) using GetX.

Views Folder:
home_screen.dart: Displays a grid view of categories.
newsbycategory.dart: Fetches and displays articles based on selected categories.
article_screen.dart: Shows detailed information about a selected article with a bookmark feature.
bookmarks.dart: Manages stored bookmarks in local storage, with the ability to delete them via a dismissible widget.

Widgets Folder:
article_card.dart: Displays individual articles in a list on the news_by_category.dart screen.
category_screen.dart: Displays the UI for different article categories in home_screen.dart.
newsappbar.dart: A custom app bar used throughout the app.