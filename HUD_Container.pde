class HUD_Container {

  // Constants
  static final int X_AXIS = 0;
  static final int Y_AXIS = 1;

  // Colors
  color LIGHT_PURPLE = #8159C9;
  color GRADIENT_DARK_GREEN = #56AB2F;
  color GRADIENT_LIGHT_GREEN = #A8E063;
  color GRADIENT_LIGHT_RED = #F00000;
  color GRADIENT_DARK_RED = #DC281E;
  color NEON_GREEN = #74ff03;

  // Variables
  int alphaOpacity = 255;
  int scoreCycler = 0;          // Used to cycle through the score history array and remember which element was modified last
  int scoreAmount = 20;
  int levelNumber;

  // Arrays
  int[] scoreHistory;
  boolean[] scoreAnimationPlayed;
  int[] scoreAnimationCounter;
  int[][] scorePosition;

  //booleans
  boolean alphaOpacitySwitch = false;      // Used to vary the opacity of alpha opacity

  // Pixel Constants
  final float INTERFACE_HEALTH_XY = 0;                         // 0px
  final float HEALTH_BAR_X = displayWidth * 0.0260416;         // 50px
  final float HEALTH_BAR_Y = displayHeight * 0.004629;         // 5px
  final float HEALTH_BAR_WIDTH = displayWidth * 0.07864583;    // 151px
  final float HEALTH_BAR_HEIGHT = displayHeight *0.016667;     // 18px
  final float HEALTH_TEXT_X = displayWidth * 0.02708;          // 52px
  final float HEALTH_TEXT_Y = displayHeight * 0.006481;        // 7px

  HUD_Container(int levelNumber) {
    alphaOpacity = 255;
    scoreCycler = 0;       
    scoreAmount = 20;
    this.levelNumber = levelNumber;
    scoreHistory = new int[scoreAmount];
    scoreAnimationPlayed = new boolean[scoreAmount];
    for (int i = 0; i < scoreAnimationPlayed.length; i++) {
      scoreAnimationPlayed[i] = false;
    }
    scoreAnimationCounter = new int[scoreAmount];
    scorePosition = new int[scoreAmount][2];
  }

  void draw(Player player) {
    drawHealthBar(player);
    drawScoreBoard(player);
    drawLevelNumber();
    scoreAnimation();
  }

  // Draws the level number to the screen
  void drawLevelNumber() {
    image(interfaceLevel, (displayWidth - interfaceLevel.width) + 110, 0);
    fill(NEON_GREEN);
    textFont(hudScoreFontLarge);
    textAlign(CENTER, TOP);
    text("Level: " + levelNumber, displayWidth - 60, 5);
  }

  // Draws the score board to the screen
  void drawScoreBoard(Player player) {
    image(interfaceScore, ((displayWidth / 2) - (interfaceScore.width / 2)), 0);
    fill(NEON_GREEN);
    textFont(hudScoreFontLarge);
    textAlign(CENTER, TOP);
    text(player.getPlayerScore(), (displayWidth / 2), 35);
  }

  // Plays an animation whenever the score is incremented
  void scoreAnimation() {
    for (int i = 0; i < scoreAnimationPlayed.length; i++) {
      if (scoreAnimationPlayed[i] == true) {
        scoreAnimationCounter[i]++;
        text("+" + scoreHistory[i], scorePosition[i][0], scorePosition[i][1]); 
        scorePosition[i][1] -= 1;
        if (scoreAnimationCounter[i] == 30) {
          scoreAnimationPlayed[i] = false;
          scoreAnimationCounter[i] = 0;
        }
      }
    }
  }

  void addNewScore(int increment, int xPosition, int yPosition) {
    scoreAnimationPlayed[scoreCycler] = true;
    scoreAnimationCounter[scoreCycler] = 0;
    scoreHistory[scoreCycler] = increment;
    scorePosition[scoreCycler][0] = xPosition;
    scorePosition[scoreCycler][1] = yPosition;
    if (scoreCycler == (scoreAnimationPlayed.length - 1)) {
      scoreCycler = 0;
    } else {
      scoreCycler++;
    }
  }

  // Draws the healthbar to the screen
  void drawHealthBar(Player player) {
    image(interfaceHealth, INTERFACE_HEALTH_XY, INTERFACE_HEALTH_XY);
    fill(LIGHT_PURPLE);
    noStroke();
    rect(HEALTH_BAR_X, HEALTH_BAR_Y, HEALTH_BAR_WIDTH, HEALTH_BAR_HEIGHT);
    if (player.getShipHealth() > 25) {
      setGradient((int) HEALTH_BAR_X, 5, (player.getShipHealth() * 1.5), HEALTH_BAR_HEIGHT - 1, NEON_GREEN, GRADIENT_DARK_GREEN, X_AXIS);
      fill(GRADIENT_DARK_GREEN);
      textFont(hudHealthFont);
      textAlign(LEFT, TOP);
      text(player.getShipHealth() + "%", HEALTH_TEXT_X, HEALTH_TEXT_Y );
    } else {
      fill(GRADIENT_LIGHT_RED, alphaOpacity);
      rect(HEALTH_BAR_X, HEALTH_BAR_Y, (player.getShipHealth() * 1.5), HEALTH_BAR_HEIGHT);
      if (alphaOpacitySwitch == false) {
        alphaOpacity -= 5;
        if (alphaOpacity == 0) {
          alphaOpacitySwitch = true;
        }
      } else {
        alphaOpacity += 5;
        if (alphaOpacity == 255) {
          alphaOpacitySwitch = false;
        }
      }
    }
  }

  // Sets the colour gradient for the health bar
  void setGradient(int xPosition, int yPosition, float gradientWidth, float gradientHeight, color color1, color color2, int axis ) {
    noFill();
    if (axis == Y_AXIS) {  // Top to bottom gradient
      for (int i = yPosition; i <= yPosition + gradientHeight; i++) {
        float inter = map(i, yPosition, yPosition + gradientHeight, 0, 1);
        color constructedColor = lerpColor(color1, color2, inter);
        stroke(constructedColor);
        line(xPosition, i, xPosition + gradientWidth, i);
      }
    } else if (axis == X_AXIS) {  // Left to right gradient
      for (int i = xPosition; i <= xPosition + gradientWidth; i++) {
        float inter = map(i, xPosition, xPosition + gradientWidth, 0, 1);
        color constructedColor = lerpColor(color1, color2, inter);
        stroke(constructedColor);
        line(i, yPosition, i, yPosition + gradientHeight);
      }
    }
  }
}
