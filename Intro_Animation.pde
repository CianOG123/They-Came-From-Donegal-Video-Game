class Intro_Animation {

  // Constants
  color NEON_GREEN = #74ff03;
  // Pixel Constans
  final float AFFRAIC_SHIP_Y_POSITION = displayHeight * -0.13888889;  // -150px
  final float MOUTH_OPEN_OFFSET = displayHeight * -0.034259259;       // -37px
  final float ALIEN_X_SHIP_SPAWN = displayWidth * 0.4427;             // 850px Used to spawn the aliens in the ship of the mouth
  final float ALIEN_Y_SHIP_SPAWN = displayHeight * 0.3425925926;      // 370px     
  final float ALIEN_FINAL_POS_Y_OFFSET = displayHeight * 0.41667;     // 450px
  final float SPACE_SKIP_Y_POSITION = displayHeight * 0.925925926;    // 1000
  static final int ALIEN_MOVE_FRAMES = 11;

  // Variables
  boolean introAnimOver = false;
  float[] shipPosition = new float[2];
  float mouthYOffset = MOUTH_OPEN_OFFSET;
  boolean[] animateAlien;
  boolean[] displayAlien;
  float[] alienIncrement = new float[2];      // Stores the amount of pixels on the x and y axis the alien should move every frame
  float[] alienMovePosition = new float[2];   // Stores the position of the moving alien
  float alienYOffset = ALIEN_FINAL_POS_Y_OFFSET;

  // Animation counters
  // Variables
  int animMoveAlien = 0;
  int animPauseShip = 0;
  int animFlameCounter = 0;
  int animPauseAlien = 0;
  int startCounter = 0;
  int spaceSkipCounter = 0;
  int spaceBuffer = 0;
  // Booleans
  boolean isShipDown = false;
  boolean isShipPaused = false;
  boolean isMouthOpen = false;
  boolean isMouthClosed = false;
  boolean isShipUp = false;
  boolean displayFlames = false;
  boolean drawAliens = false;
  boolean moveAlien = false;
  boolean pauseAlien = true;
  boolean isIncrementCalculated = false;
  boolean allAliensMoved = false;
  boolean openMouth = false;
  boolean shipRemoved = false;
  boolean positionAliens = false;
  boolean displayStartLogo = false;
  boolean displaySpaceSkip = true;

  //Sound Booleans
  boolean musicPlaying = false;
  boolean playAlienPosition = true;
  boolean[] playAlienMove;
  boolean playStart = true;

  // affraicShipBase, affraicShipEyes, affraicShipMouth, affraicShipFlames

  // Objects
  Mob_Handler levelMob;
  Alien[] alienArray;
  HUD_Container userInterface;
  Player player;

  Intro_Animation(Mob_Handler levelMob, int levelNumber) {
    // SFX
    playAlienPosition = true;
    playAlienMove = new boolean[levelMob.alienArray.length];
    for (int i = 0; i < levelMob.alienArray.length; i++) {
      playAlienMove[i] = true;
    }
    
    userInterface = new HUD_Container(levelNumber);
    this.levelMob = levelMob;
    this.alienArray = levelMob.alienArray;
    shipPosition[0] = (displayWidth / 2) - (affraicShipBase.width / 2);
    shipPosition[1] =  -1 * (affraicShipBase.height + 100);
    displayAlien = new boolean[alienArray.length];
    animateAlien = new boolean[alienArray.length];
    for (int i = 0; i < displayAlien.length; i++) {
      displayAlien[i] = false;
      animateAlien[i] = false;
    }
    animateAlien[0] = true;
    alienMovePosition[0] = ALIEN_X_SHIP_SPAWN;
    alienMovePosition[1] = ALIEN_Y_SHIP_SPAWN;
  }

  void draw() {
    musicPlayer();
    moveShipDown();
    pauseAnimation(1);
    openShipMouth();
    pauseAnimation(2);
    drawShip();
    drawAliens();
    removeShip();
    displayStartLogo();
    skipHandler();
    userInterface.draw(eventLogger.levelOne.player);
  }

  // Plays the intro music
  void musicPlayer() {
    if (musicPlaying == false) {
      musicPlaying = true;
      musicSpaceDeGrey.stop();
      musicSpaceDeGrey.play();
      musicSpaceDeGrey.amp(musicVolume);
    }
  }

  void displayStartLogo() {
    if (displayStartLogo == true) {
      if (playStart == true) {
        playStart = false;
        start.stop();
        start.play();
        musicSpaceDeGrey.stop();
        shipPosition[0] = -100 - affraicShipBase.width;
        alienYOffset = 0;
        for (int i = 0; i < alienArray.length; i++) {
          displayAlien[i] = true;
        }
      }
      image(logoStart, (displayWidth / 2) - (logoStart.width / 2), (displayHeight / 2) - (logoStart.height / 2));
      startCounter++;
      if (startCounter == 60) {
        displayStartLogo = false;
        drawAliens = false;
        introAnimOver = true;
      }
    }
  }

  // Handles everything to do with skipping the intro
  void skipHandler() {
    skipIntroAnimation();
    skipPrompt();
  }

  // Displays the skip animation prompt
  void skipPrompt() {
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
        text("--- PRESS \"SPACE\" WHEN READY TO SKIP INTRO ---", (displayWidth / 2), SPACE_SKIP_Y_POSITION);
      }
    }
  }

  // Allows the user to skip the intro animation by pressing space
  void skipIntroAnimation() {
    if (spaceBuffer == 120) {
      if (keyPressed) {
        if (key == ' ') {
          shipMove.stop();
          mouthOpen.stop();
          shipTalk.stop();
          alienMove.stop();
          alienPosition.stop();
          isShipDown = true;
          isShipPaused = true;
          isMouthOpen = true;
          isMouthClosed = true;
          isShipUp = true;
          displayFlames = false;
          drawAliens = true;
          moveAlien = false;
          pauseAlien = false;
          allAliensMoved = true;
          openMouth = false;
          shipRemoved = true;
          positionAliens = false;
          displayStartLogo = true;
        }
      }
    }
  }

  // draws the aliens to the screen
  void drawAliens() {
    if (drawAliens == true) {
      for (int i = 0; i < alienArray.length; i++) {
        if (animateAlien[i] == true) {
          if (allAliensMoved == false) {
            pauseAlien(alienArray[i]);
            calculateIncrements(i);
            moveAlien(alienArray[i], i);
          }
        }
      }
      drawStillAliens();
    }
  }

  // Pause alien
  void pauseAlien(Alien alien) {
    if (pauseAlien == true) {
      animPauseAlien++;
      if (animPauseAlien == 5) {
        isIncrementCalculated = false;
        pauseAlien = false;
        animPauseAlien = 0;
        moveAlien = true;
      } else {
        image(alien.alienImage, ALIEN_X_SHIP_SPAWN, ALIEN_Y_SHIP_SPAWN);
      }
    }
  }

  // Moves the alien on the screen
  void moveAlien(Alien alien, int index) {
    if (moveAlien == true) {
      if (playAlienMove[index] == true) {
        alienMove.play();
        playAlienMove[index] = false;
      }
      animMoveAlien++;
      if (animMoveAlien >= ALIEN_MOVE_FRAMES) {
        animMoveAlien = 0;
        alienMovePosition[0] = ALIEN_X_SHIP_SPAWN;
        alienMovePosition[1] = ALIEN_Y_SHIP_SPAWN;
        moveAlien = false;
        pauseAlien = true;
        displayAlien[index] = true;
        animateAlien[index] = false;
        if (index < (alienArray.length - 1)) {
          animateAlien[index + 1] = true;
        } else {
          allAliensMoved = true;
        }
      } else {
        alienMovePosition[0] += alienIncrement[0];
        alienMovePosition[1] += alienIncrement[1];
        alienMovePosition[0] += -6;
        alienMovePosition[1] += 4;
        image(alien.alienImage, alienMovePosition[0], alienMovePosition[1]);
      }
    }
  }

  // Draw the still aliens to the screen
  void drawStillAliens() {
    for (int i = 0; i < alienArray.length; i++) {
      if (displayAlien[i] == true) {
        image(alienArray[i].alienImage, alienArray[i].alienPosition[0], alienArray[i].alienPosition[1] + alienYOffset);
        if (positionAliens == true) {
          if (playAlienPosition == true) {
            playAlienPosition = !playAlienPosition;
            alienPosition.stop();
            alienPosition.play();
          }
          alienYOffset -= .25;
          if (alienYOffset <= 0) {
            alienPosition.stop();
            positionAliens = false;
          }
        }
      }
    }
  }

  // Calculates the x and y increments for the alien
  float[] calculateIncrements(int index) {
    if (isIncrementCalculated == false) {
      // Calculating x increment
      alienIncrement[0] = (alienArray[index].alienPosition[0] - ALIEN_X_SHIP_SPAWN) / ALIEN_MOVE_FRAMES;
      // Calculating y increment
      alienIncrement[1] = ((alienArray[index].alienPosition[1] + ALIEN_FINAL_POS_Y_OFFSET) - ALIEN_Y_SHIP_SPAWN) / ALIEN_MOVE_FRAMES;
      isIncrementCalculated = true;
    }
    return alienIncrement;
  }

  // Draws the ship to the screen
  void drawShip() {
    image(affraicShipBase, shipPosition[0], shipPosition[1]);
    image(affraicShipEyes, shipPosition[0], shipPosition[1]);
    image(affraicShipMouth, shipPosition[0], shipPosition[1] + mouthYOffset);
    shipFlameAnimator();
  }

  // Causes a pause in animation for dramatic effect
  void pauseAnimation(int pauseNumber) {
    if (pauseNumber == 1) {
      if (isShipPaused == true) {
        animPauseShip++;
        if (animPauseShip == 60) {
          openMouth = true;
          animPauseShip = 0;
          isShipPaused = false;
        }
      }
    } else {
      if (isMouthOpen == true) {
        animPauseShip++;
        if (animPauseShip == 30) {
          animPauseShip = 0;
          drawAliens = true;
        }
      }
    }
  }

  // Moves the ship of the screen
  void removeShip() {
    if ((allAliensMoved == true) && (shipRemoved == false)) {
      if (shipMove.isPlaying() == false) {
        shipMove.stop();
        shipMove.play();
      }
      shipPosition[1] -= 4;
      if (shipPosition[1] <= -affraicShipBase.height) {
        shipMove.stop();
        shipRemoved = true;
        positionAliens = true;
      }
    }
  }

  // Opens the ship mouth
  void openShipMouth() {
    if (openMouth == true) {
      if (mouthOpen.isPlaying() == false) {
        mouthOpen.stop();
        mouthOpen.play();
      }
      mouthYOffset++;
      if (mouthYOffset >= 0) {
        mouthOpen.stop();
        openMouth = false;
        isMouthOpen = true;
      }
    }
  }

  // Animates the ships flames
  void shipFlameAnimator() {
    animFlameCounter++;
    if (animFlameCounter == 10) {
      displayFlames = !displayFlames;
      animFlameCounter = 0;
    }
    if (displayFlames == true) {
      image(affraicShipFlames, shipPosition[0], shipPosition[1]);
    }
  }

  // Moves the ship down onto the screen
  void moveShipDown() {
    if (isShipDown == false) {
      if (shipMove.isPlaying() == false) {
        shipMove.stop();
        shipMove.play();
      }
      shipPosition[1] += 2;
      if (shipPosition[1] >= AFFRAIC_SHIP_Y_POSITION) {
        shipMove.stop();
        isShipDown = true;
        isShipPaused = true;
      }
    }
  }


  // returns if the intro animation is over
  boolean getIntroAnimOver() {
    return introAnimOver;
  }
}
