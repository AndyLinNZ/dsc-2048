# Part 1 / Workshop 5 - Game logic design

## Setting Up

### Learning Outcomes

* Using dart to create the idea of the 2048 game logic.
* Creating a board with tiles on it, and implmenting the features that will happen if you merge.
* Transitioning that logic to a state where it can be used in conjunction with Flutter to make an app.

## Pre-requisites
If you have created a Flutter app before, you can ignore this section. It is also useful to visit [2048](https://play2048.co/) to play around to get more familiar with the game.

It is highly recommended you visit our first workshop link [to setting up a Flutter environment](https://dsc.community.dev/events/details/developer-student-clubs-university-of-melbourne-presents-flutter-workshop1-basics-of-flutter-and-making-your-very-first-app/#/)

Below are a few rough steps on what you need before starting this project.
### Dart

https://dart.dev/

### Visual Studio Code / Android Studio / Flutlab

https://code.visualstudio.com/download
https://developer.android.com/studio
https://flutlab.io/

### Making a Directory

For simplity, we will be using Visual Studio Code as our code editor for describing these steps. If you are using flutlab.io, you don't need to worry about creating the project structure, since it will be already done for you.

* First, in Visual Studio Code, choose the directory you want to create your project in through  `Ctrl+K Ctrl+O`. 
* Then `Ctrl shift p` and select `Flutter: New Project` and then choosing a Flutter project name, such as `two_zero_four_eight`. Alternatively, you can open up your terminal through selecting `Terminal` on the top window bar and clicking `New Terminal`. Then in the terminal, type `flutter create two_zero_four_eight`.

## Stage 1: Initialising a board and creating tiles.
