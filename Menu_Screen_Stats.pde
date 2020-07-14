class Menu_Screen_Stats {

  // Displayed Variables
  int accumulatedPoints = 0;   // The points from gameplay added to the bonus points
  int bonusPoints = 0;         // Amount of bonus points the player has earned
  int aliensKilled = 0;
  float accuracy = 0;
  int timeMinutes = 0;
  int timeSeconds = 0;
  int healthRemaining = 0;
  int specialWeaponsUsed = 0;
  // Hidden Display Variables
  int currentLevel = 0;
  int gamePlayPoints = 0;      // The points that the player has gained during gameplay
  int bulletsFired = 0;        // The amount of bullets that the player has fired
  int bulletsNeeded = 0;       // The amount of bullets needed to kill all the enemies in the level
  int completeTime = 0;        // Stored in frames

  // Other Variables
  // Booleans
  boolean mouseDisplayed = false;
  boolean gotLevelObject = false;
  boolean gotStatsData = false;
  
  // Animation Variables
  int pauseCounter = 0;
  boolean incrementPoints = false;
  int spaceSkipCounter = 0;
  boolean displaySpaceSkip = false;
  

  // Objects
  Alien_Level_Container level;

  // Colors
  static final color SPACE_BACKGROUND_COLOR = #202035;
  static final color NEON_GREEN = #74FF03;
  static final color PURPLE_NURPLE = #9C27B0;

  // Pixel Constants
  final float STATS_BOARD_X = displayWidth * 0.03125;  // 60px
  final float STATS_BOARD_Y = displayHeight  *0.055555556; // 60px
  final float HEADER_POSITION_X = displayWidth * 0.5;  // 960px
  final float HEADER_POSITION_Y = displayHeight * 0.0925925925;  // 100px
  final float STATS_POSITION_X = displayWidth * 0.05729166667; // 110px
  final float BONUS_POSITION_Y = displayHeight * 0.2037037038; // 220px
  final float ALIENS_KILLED_Y = displayHeight * 0.29629629627; // 320px
  final float ACCURACY_Y = displayHeight * 0.370370370;  // 400px
  final float TIME_Y = displayHeight * 0.444444444;  // 480px
  final float HEALTH_Y = displayHeight * 0.518518518518;  // 560px
  final float SPECIAL_Y =displayHeight * 0.592592592592;  // 640px
  final float POINTS_EARNED_Y = displayHeight * 0.66666667;  // 720px
  final float TOTAL_POINTS_HEADER_X = displayWidth * 0.552083333;  // 1060px
  final float TOTAL_POINTS_HEADER_Y = displayHeight * 0.370370370370;  // 400px
  final float SPACE_SKIP_Y_POSITION = displayHeight * 0.87962962962; // 950px
  
  // SFX
  boolean playStatsScreen = true;
  boolean playPressSpace = true;


  Menu_Screen_Stats(int levelNumber) {
    //SFX
    playStatsScreen = true;
    playPressSpace = true;
    
    currentLevel = levelNumber;
  }

  void draw() {
    if(playStatsScreen == true){
      playStatsScreen = false;
      statsScreen.play();
    }
    gatherData();
    drawSpace();
    drawStats();
    incrementPoints();
    spaceToContinue();
  }
  
  // Action taken if space is pressed
  void spacePressed(){
    if(keyPressed == true){
      if(key == ' '){
        eventLogger.setPlayerScore(accumulatedPoints);
        eventLogger.nextLevel(currentLevel);
        stopAllSFX();
      }
    }
  }
  
  // Animates the space skip text
  void spaceToContinue(){
    if(displaySpaceSkip == true){
      if(spaceSkipCounter < 60){
        spaceSkipCounter++;
      }
      else{
        if(playPressSpace == true){
          playPressSpace = false;
          pressSpace.play();
        }
        fill(NEON_GREEN);
        textFont(pressSpaceFont);
        textAlign(CENTER, TOP);
        text("PRESS SPACE TO CONTINUE", (displayWidth / 2), SPACE_SKIP_Y_POSITION);
        spacePressed();
      }
    }
  }
  
  // Animates and increments the point counter
  void incrementPoints(){
    if(pauseCounter < 90){
      pauseCounter++;
      incrementPoints = true;
    }
    else{
      if((incrementPoints == true) && (frameCount % 2 == 0) && (accumulatedPoints < (gamePlayPoints + bonusPoints))){
        if(countScore.isPlaying() == false){
          countScore.play();
        }
        accumulatedPoints += 17;
        if(accumulatedPoints >= (gamePlayPoints + bonusPoints)){
          countScore.stop();
          scoreCounted.play();
          accumulatedPoints = gamePlayPoints + bonusPoints;
          incrementPoints = false;
          displaySpaceSkip = true;
        }
      }
    }
  }

  // Gathers all relevant data from other classes to create statistics
  void gatherData() {
    if (gotStatsData == false) {
      gotStatsData = true;
      getLevel();
      gamePlayPoints = level.player.getPlayerScore();
      accumulatedPoints = gamePlayPoints;
      aliensKilled = getAlienAmount(currentLevel);
      bulletsFired = level.player.getBulletsFired();
      bulletsNeeded = getBulletsNeeded();
      completeTime = level.getGamePlayTime();
      healthRemaining = level.player.getShipHealth();
      specialWeaponsUsed = level.player.getSpecialWeaponsUsed();
      getTime();
      getAccuracy();
      getBonusPoints();
    }
  }
  
  // Returns the accuracy of the player
  void getAccuracy() {
    if (bulletsFired != 0) {
      accuracy = (((float) bulletsNeeded / bulletsFired) * 100);
      if (accuracy > 99) {
        accuracy = 100;
      }
    }
  }

  // Calculates the amount of bonus points the player has earned
  void getBonusPoints() {
    bonusPoints += aliensKilled * 9;
    bonusPoints += accuracy * 5;
    bonusPoints += (300 - ((timeMinutes * 60) + timeSeconds)) * 2;
    bonusPoints += healthRemaining * 2;
    bonusPoints += specialWeaponsUsed * 50;
    bonusPoints += currentLevel * 3.5;
    switch (difficultyLevel){
      case HARD:
      bonusPoints *= 2;
      break;
      case MEDIUM:
      bonusPoints *= 1.5;
      break;
      default:
      break;
    }
  }

  // Returns the time used to complete the level
  void getTime() {
    timeSeconds = completeTime / 60;
    timeMinutes = timeSeconds / 60;
    timeSeconds = timeSeconds % 60;
  }

  // Gets the current level object to gather data from
  void getLevel() {
    if (gotLevelObject == false) {
      gotLevelObject = true;
      level = eventLogger.getLevel(currentLevel);
    }
  }

  // Draws the text statistics and board to the screen
  void drawStats() {
    image(menuStatsBoard, STATS_BOARD_X, STATS_BOARD_Y);
    textAlign(CENTER, TOP);
    fill(NEON_GREEN);
    textFont(statsHeadingFont);
    text("LEVEL COMPLETE", HEADER_POSITION_X, HEADER_POSITION_Y);
    text(accumulatedPoints, 1350, TOTAL_POINTS_HEADER_Y + 100);
    textFont(statsBonusFont);
    text(bonusPoints, 435, POINTS_EARNED_Y + 80);
    textAlign(LEFT, TOP);
    textFont(statsHeadingFont);
    text("Total Points", TOTAL_POINTS_HEADER_X, TOTAL_POINTS_HEADER_Y);
    fill(PURPLE_NURPLE);
    textFont(statsBonusFont);
    text("Bonus Points", STATS_POSITION_X, BONUS_POSITION_Y);
    text("Points Earned", STATS_POSITION_X, POINTS_EARNED_Y);
    fill(NEON_GREEN);
    textFont(statsNormalFont);
    text("Aliens Defeated: " + aliensKilled, STATS_POSITION_X, ALIENS_KILLED_Y);
    text("Accuracy: " + (int) accuracy + "%", STATS_POSITION_X, ACCURACY_Y);
    text("Time Completed: " + timeMinutes + "m " + timeSeconds + "s ", STATS_POSITION_X, TIME_Y);
    text("Health Remaining: " + healthRemaining + "%", STATS_POSITION_X, HEALTH_Y);
    text("Special Items used: " + specialWeaponsUsed, STATS_POSITION_X, SPECIAL_Y);
  }

  // Ensures the mouse is being displayed on screen
  void displayMouse() {
    if (mouseDisplayed == false) {
      mouseDisplayed = true;
      cursor();
    }
  }

  // Draws the space background to the screen
  void drawSpace() {
    fill(SPACE_BACKGROUND_COLOR);
    noStroke();
    rect(0, 0, displayWidth, displayHeight);
  }

  // Returns the minimum amount of bullets needed to complete the level
  int getBulletsNeeded() {
    int bullets = 0;
    switch (currentLevel){
      case 1:
      bullets = 36;
      break;
      case 2:
      bullets = 60;
      break;
      case 3:
      bullets = 74;
      break;
      case 4:
      bullets = 129;
      break;
      default:
      bullets = 155;
      break;
    }
    return bullets;
  }


  // Gets the amount of aliens depending on the level
  int getAlienAmount(int levelNumber) {
    int alienAmount;
    switch (levelNumber) {
    case 1:
      alienAmount = 30;
      break;
    case 2:
      alienAmount = 45;
      break;
    case 3:
      alienAmount = 48;
      break;
    case 4:
      alienAmount = 60;
      break;
    default:
      alienAmount = 75;
      break;
    }
    return alienAmount;
  }
}
