/*
/  Class responisble for the 'story board' of the game. Choosing what is drawn to the screen, which level is being played, scores and user preferences.
 /  This class is also responsible for setting and changing the music during the game.
 */

class Event_Logger {

  // Variables
  int playerScore = 0;
  int shipHealth = 100;                // The health of the ship as a percentage
  boolean hasCannonBall = false;
  boolean hasRainbow = false;
  boolean hasLaser = false;
  boolean hasPlasma = false;
  boolean shiftScores = false;

  // Event object declaration
  Menu_Screen_Main menuScreenMain;
  Alien_Level_Container levelOne;
  Alien_Level_Container levelTwo;
  Alien_Level_Container levelThree;
  Alien_Level_Container levelFour;
  Alien_Level_Container levelFive;
  High_Score_Pop_Up highScores;
  Win_Screen winScreen;

  // Event Booleans
  Boolean displayMainMenu = true;
  Boolean displayLevelOne = false;
  Boolean displayLevelTwo = false;
  Boolean displayLevelThree = false;
  Boolean displayLevelFour = false;
  Boolean displayLevelFive = false;
  boolean displayCredits = false;
  boolean displayHighScores = false;
  boolean displayWinScreen = false;

  // Level Settings
  int currentLevel;

  Event_Logger() {
    resetGame();
  }

  void resetGame() {
    currentLevel = 1;

    playerScore = 0;
    shipHealth = 100;               
    hasCannonBall = false;
    hasRainbow = false;
    hasLaser = false;
    hasPlasma = false;

    // Menu Objects initialisation
    menuScreenMain = new Menu_Screen_Main();

    // Level Object Initialisation
    levelOne = new Alien_Level_Container(currentLevel, musicMainMenu);
    levelTwo = new Alien_Level_Container(currentLevel, musicMainMenu);
    levelThree = new Alien_Level_Container(currentLevel, musicMainMenu);
    levelFour = new Alien_Level_Container(currentLevel, musicMainMenu);
    levelFive = new Alien_Level_Container(currentLevel, musicMainMenu);
    
    // High Scores Objects
    highScores = new High_Score_Pop_Up();
    
    // Win Screen
    winScreen = new Win_Screen();
  }

  void difficultySettings() {
    if (difficultyLevel == HARD) {
      shipHealth = 75;
    } else {
      shipHealth = 100;
    }
  }

  void draw() {
    if (displayMainMenu == true) {
      menuScreenMain.draw();
    } else if (displayLevelOne == true) { 
      levelOne.draw();
    } else if (displayLevelTwo == true) { 
      levelTwo.draw();
    } else if (displayLevelThree == true) { 
      levelThree.draw();
    } else if (displayLevelFour == true) { 
      levelFour.draw();
    } else if (displayLevelFive == true) {
      levelFive.draw();
    } 
    else if(displayWinScreen == true){
      winScreen.draw();
    }else {
      text("Oh no! You broke the game >:(", 100, 100 );
    }
    highScores.draw();
  }



  void initialiseLevel(int levelNumber) {
    switch (levelNumber) {
    case 1:
      levelOne = new Alien_Level_Container(levelNumber, musicMainMenu);
      break;
    case 2:
      levelTwo = new Alien_Level_Container(levelNumber, musicMainMenu);
      break;
    case 3:
      levelThree = new Alien_Level_Container(levelNumber, musicMainMenu);
      break;
    case 4:
      levelFour = new Alien_Level_Container(levelNumber, musicMainMenu);
      break;
    default:
      levelFive = new Alien_Level_Container(levelNumber, musicMainMenu);
      break;
    }
  }

  // Resets the players score to zero
  void resetPlayerScore() {
    playerScore = 0;
  }

  // Sets the players score
  void setPlayerScore(int newScore) {
    playerScore = newScore;
  }

  // Returns the corresponing level
  Alien_Level_Container getLevel(int levelNumber) {
    switch (levelNumber) {
    case 1:
      return levelOne;
    case 2:
      return levelTwo;
    case 3:
      return levelThree;
    case 4:
      return levelFour;
    default:
      return levelFive;
    }
  }

  // Change to next level
  void nextLevel(int currentLevel) {
    switch (currentLevel) {
    case 1:
      displayLevelOne = false;
      displayLevelTwo = true;
      currentLevel = 2;
      initialiseLevel(currentLevel);
      break;
    case 2:
      displayLevelTwo = false;
      displayLevelThree = true;
      currentLevel = 3;
      initialiseLevel(currentLevel);
      break;
    case 3:
      displayLevelThree = false;
      displayLevelFour = true;
      currentLevel = 4;
      initialiseLevel(currentLevel);
      break;
    case 4:
      displayLevelFour = false;
      displayLevelFive = true;
      currentLevel = 5;
      initialiseLevel(currentLevel);
      break;
    case 5:
      displayLevelFive = false;
      displayWinScreen = true;
      break;
    default:
      break;
    }
  }
}
