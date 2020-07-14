class Win_Screen {

  final float STATS_BOARD_X = displayWidth * 0.03125;  // 60px
  final float STATS_BOARD_Y = displayHeight  *0.055555556; // 60px
  final float SPACE_Y = 900;

  boolean winSoundPlayed = false;
  int spaceBuffer = 0;
  int spaceSkipCounter = 0;
  boolean displaySpaceSkip = true;
  color NEON_GREEN = #74ff03;
  int spaceWait = 0;

  Win_Screen() {
    spaceWait = 0;
    winSoundPlayed = false;
    spaceBuffer = 0;
    spaceSkipCounter = 0;
    displaySpaceSkip = true;
  }

  void draw() {
    image(menuStatsBoard, STATS_BOARD_X, STATS_BOARD_Y);
    displayPlayerWin();
  }

  // Displays the player win logo
  void displayPlayerWin() {
    if (spaceBuffer != 120) {
      spaceBuffer++;
    }
    if (spaceBuffer == 120) {
      spaceSkipCounter++;
      if (spaceSkipCounter == 45) {
        spaceSkipCounter = 0;
        displaySpaceSkip = !displaySpaceSkip;
      }
      if (displaySpaceSkip == true) {
        fill(NEON_GREEN);
        textFont(pressSpaceFont);
        textAlign(CENTER, TOP);
        text("--- PRESS \"SPACE\" WHEN READY TO RETURN TO MAIN MENU ---", (displayWidth / 2), SPACE_Y);
      }
    }
    if (winSoundPlayed == false) {
      winSoundPlayed = true;
      statsScreen.stop();
      statsScreen.play();
    }
    eventLogger.displayHighScores = true;
    eventLogger.shiftScores = true;
    // Allows the user to skip the intro animation by pressing space
    if (spaceWait >= 120) {
      if (keyPressed) {
        if (key == ' ') {
          eventLogger.displayWinScreen = false;
          eventLogger.displayMainMenu = true;
          eventLogger.resetGame();
          eventLogger.displayHighScores = false;
          eventLogger.shiftScores = false;
        }
      }
    } else {
      spaceWait++;
    }
  }
}
