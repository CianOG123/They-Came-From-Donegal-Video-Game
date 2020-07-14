class High_Score_Pop_Up {

  // Colours
  color NEON_GREEN = #74ff03;

  // Variables
  int playerScorePosition = -1;
  String playerName = "";
  boolean scoreCalculated = false;
  boolean scoresSaved = false;
  
  static final String SCORE_FILE = "HighScores.txt";

  // Arrays
  String[] playerNames = new String[3];
  String[] playerScores = new String[3];
  String[] saveData= new String[7];

  // Constants
  final float SCORE_BOARD_Y = 360 + 20;  // 625px
  final float NAME_ONE_POSITION_X = 775; // 775px
  final float NAME_ONE_POSITION_Y = 550 + 20; // 500px
  final float SCORE_ONE_POSITION_X = 925; // 925px
  final float SCORE_OFFSET_Y = 100; // 100px Difference between each score
  final float PLAYER_SCORE_X = displayWidth / 2; // 960px
  final float PLAYER_SCORE_Y = 885 + 20;
  int highScoreOffset = 0;


  High_Score_Pop_Up() {
    scoreCalculated = false;
    scoresSaved = false;
    loadScores();
  }

  void draw() {
    if (eventLogger.shiftScores == true) {
      highScoreOffset = -150;
    } else {
      highScoreOffset = 0;
    }
    if (eventLogger.displayHighScores == true) {
      checkPlayerScore();
      textAlign(CENTER, TOP);
      image(highScoresBoard, 960 - (highScoresBoard.width / 2), SCORE_BOARD_Y + highScoreOffset);
      for (int i = 0; i < playerNames.length; i++) {
        textFont(statsNormalFont);
        fill(NEON_GREEN);
        textAlign(LEFT, TOP);
        text(playerNames[i], NAME_ONE_POSITION_X, NAME_ONE_POSITION_Y + i * SCORE_OFFSET_Y + highScoreOffset);
        textAlign(LEFT, TOP);
        text(playerScores[i], SCORE_ONE_POSITION_X, NAME_ONE_POSITION_Y + i * SCORE_OFFSET_Y + highScoreOffset);
      }
      textAlign(CENTER, TOP);
      text(eventLogger.playerScore, PLAYER_SCORE_X, PLAYER_SCORE_Y + highScoreOffset);
      saveScores();
    }
  }

  // Checks to see if the highscore should be on the scoreboard and inserts it
  void checkPlayerScore() {
    if (scoreCalculated == false) {
      scoreCalculated = true;
      playerScorePosition = -1;
      for (int i = playerScores.length - 1; i >= 0; i--) {
        int scoreBoardScore = Integer.parseInt(playerScores[i]);
        if (eventLogger.playerScore > scoreBoardScore) {
          playerScorePosition = i;
        }
      }
      if (playerScorePosition != -1) {
        if (playerScorePosition == 2) {
          String playerScoreString = String.valueOf(eventLogger.playerScore);
          playerScores[2] = playerScoreString;
          playerNames[2] = playerName;
        } else if (playerScorePosition <= 1) {
          playerScores[2] = playerScores[1];
          playerNames[2] = playerNames[1];
          if (playerScorePosition == 0) {
            playerScores[1] = playerScores[0];
            playerNames[1] = playerNames[0];
          }
          String playerScoreString = String.valueOf(eventLogger.playerScore);
          playerScores[playerScorePosition] = playerScoreString;
          playerNames[playerScorePosition] = playerName;
        }
      }
    }
  }

  // Saves the scores to the file
  void saveScores() {
    saveData[0] = playerNames[0];
    saveData[2] = playerNames[1];
    saveData[4] = playerNames[2];
    saveData[1] = playerScores[0];
    saveData[3] = playerScores[1];
    saveData[5] = playerScores[2];
    saveData[6] = playerName;
    saveStrings(SCORE_FILE, saveData);
    println("\nSaved");
  }

  // Loads the scores
  void loadScores() {
    String[] scoreData = loadStrings(SCORE_FILE);
    for (int i = 0; i < scoreData.length; i++) {
      if ((i == 0) || (i == 2) || (i == 4)) {
        for (int j = 0; j < playerNames.length; j++) {
          if (playerNames[j] == null) {
            playerNames[j] = scoreData[i];
            j = playerNames.length;
          }
        }
      } else if (i == 6) {
        playerName = scoreData[6];
      } else {
        for (int j = 0; j < playerNames.length; j++) {
          if (playerScores[j] == null) {
            playerScores[j] = scoreData[i];
            j = playerScores.length;
          }
        }
      }
    }
  }
}
