class Mob_Handler {

  // Alien speed settings
  int framesPerBeat = 0;              // The amount of frames that elapse every beat of the song
  int frameSubtractAmount = 0;        // The amount of frames subtracted from frames per beat every 8 beats
  int frameSpeedLimit = 0;            // The least amount of frames per beat that the aliens can move at

  // Input variables
  int levelNumber;                    // The number of the current level, used to calculate difficulty and other parameters.

  // Constants
  color NEON_GREEN = #74ff03;

  // Class variables
  int currentFrame = 0;
  boolean moveLeft = false;
  boolean changedDirection = false;
  int amountOfBeats = 0;
  boolean playerLose = false;
  int rightAlienLimit = 0;
  int jumpDistance = 0;
  int dropDownDistance = 0;
  int alienAmountPerRow = 0;
  int alienAmountPerColumn = 0;

  // Player lose animation variables
  int animPauseCount = 0;
  int animMoveCount = 0;
  boolean displayPlayerLose = false;
  boolean youLosePlayed = false;
  int spaceBuffer = 0;
  boolean displaySpaceSkip = true;
  int spaceSkipCounter = 0;

  // Constants
  static final int LEVEL_ONE_RIGHT_ALIEN = 9;     // The element number for the right-most alien of the first row
  static final int LEVEL_TWO_RIGHT_ALIEN = 14;    // Level 4 and 5 also
  static final int LEVEL_THREE_RIGHT_ALIEN = 11;
  final float PIXEL_JUMP_DISTANCE = displayWidth * 0.025; // 48px The amount of pixels the aliens will move every beat


  // Pixel Constants
  final float MOB_LEFT_LIMIT = displayWidth * 0.078125;       // 150px
  final float MOB_RIGHT_LIMIT = displayWidth * 0.87760416;    // 1685px
  final float PLAYER_LOSE_LINE = displayHeight * 0.833333333; // 900px
  final float ALIEN_Y_SPAWN = displayHeight * 0.0925925926;        // 100px
  final float ALIEN_X_SPAWN_INCREMENT = displayWidth * 0.052083;   // 100px
  final float LEVEL_ONE_X_SPAWN_OFFSET = displayWidth * 0.239583;  // 460px
  final float LEVEL_TWO_X_SPAWN_OFFSET = displayWidth * 0.109375;  // 210px
  final float LEVEL_THREE_X_SPAWN_OFFSET = displayWidth * 0.1875;  // 360px
  final float LEVEL_FOUR_X_SPAWN_OFFSET = displayWidth * 0.109375; // 210px
  final float LEVEL_FIVE_X_SPAWN_OFFSET = displayWidth * 0.109375; // 210px

  // Objects
  Alien[] alienArray;

  Mob_Handler(int levelNumber) {
    this.levelNumber = levelNumber;
    int alienAmount = getAlienAmount(levelNumber);
    alienArray = new Alien[alienAmount];
    alienArray = alienArrayFill();
    switch (levelNumber) {
    case 1:
      rightAlienLimit = LEVEL_ONE_RIGHT_ALIEN;
      break;
    case 3:
      rightAlienLimit = LEVEL_THREE_RIGHT_ALIEN;
      break;
    default:
      rightAlienLimit = LEVEL_TWO_RIGHT_ALIEN;
    }
    setSpeed();
  }

  void draw(float[][] bulletPosition, Player player, HUD_Container userHUD, Boolean playerLose) {
    moveAliens(alienArray);
    drawAliens(bulletPosition, player, userHUD, playerLose);
    playerLoseHandler();
    explodePlasma();
  }


  // Kills all aliens in the surronding area of a plasma
  void explodePlasma() {
    //if(isPlasmaFired == true){
    for (int i = 0; i < alienArray.length; i++) {
      if (alienArray[i].isHitByPlasma == true) {
        alienArray[i].isHitByPlasma = false; 
        int alienRowIndex = i % alienAmountPerRow;
        int alienColumnIndex = alienAmountPerRow;
        for (int j = 0; j < alienAmountPerColumn; j++) {
          if (i < (j * alienAmountPerRow) + alienAmountPerRow) {     
            alienColumnIndex = j;
            j = alienAmountPerColumn;
          }
        }
        boolean leftSpace = false;
        boolean rightSpace = false;

        // Handling aliens to the left
        if (alienRowIndex >= 1) {
          leftSpace = true;
          if (alienArray[i - 1].alienDead == false) {
            alienArray[i - 1].alienHealth = 0;
            alienArray[i - 1].playHitAnimation = true;
          }
          if (alienRowIndex >= 2) {
            if (alienArray[i - 2].alienDead == false) {
              alienArray[i - 2].alienHealth--;
              alienArray[i - 2].playHitAnimation = true;
            }
          }
        }
        // Handling aliens to the right
        if (alienRowIndex <= (alienAmountPerRow - 2)) {
          rightSpace = true;
          if (alienArray[i + 1].alienDead == false) {
            alienArray[i + 1].alienHealth = 0;
            alienArray[i + 1].playHitAnimation = true;
          }
          if (alienRowIndex <= (alienAmountPerRow - 3)) {
            if (alienArray[i + 2].alienDead == false) {
              alienArray[i + 2].alienHealth--;
              alienArray[i + 2].playHitAnimation = true;
            }
          }
        }
        // Handling aliens above
        if (alienColumnIndex > 0) {
          if (alienArray[i - alienAmountPerRow].alienDead == false) {
            alienArray[i - alienAmountPerRow].alienHealth = 0;
            alienArray[i - alienAmountPerRow].playHitAnimation = true;
          }
          if (leftSpace == true) {
            if (alienArray[i - alienAmountPerRow - 1].alienDead == false) {
              alienArray[i - alienAmountPerRow - 1].alienHealth--;
              alienArray[i - alienAmountPerRow - 1].playHitAnimation = true;
            }
          }
          if (rightSpace == true) {
            if (alienArray[i - alienAmountPerRow + 1].alienDead == false) {
              alienArray[i - alienAmountPerRow + 1].alienHealth--;
              alienArray[i - alienAmountPerRow + 1].playHitAnimation = true;
            }
          }
        }
        // Handling aliens below
        if (alienColumnIndex < (alienAmountPerColumn - 1)) {
          if (alienArray[i + alienAmountPerRow].alienDead == false) {
            alienArray[i + alienAmountPerRow].alienHealth = 0;
            alienArray[i + alienAmountPerRow].playHitAnimation = true;
          }
          if (leftSpace == true) {
            if (alienArray[i + alienAmountPerRow - 1].alienDead == false) {
              alienArray[i + alienAmountPerRow - 1].alienHealth--;
              alienArray[i + alienAmountPerRow - 1].playHitAnimation = true;
            }
          }
          if (rightSpace == true) {
            if (alienArray[i + alienAmountPerRow + 1].alienDead == false) {
              alienArray[i + alienAmountPerRow + 1].alienHealth--;
              alienArray[i + alienAmountPerRow + 1].playHitAnimation = true;
            }
          }
        }
      }
    }
  }

  // Draws each indiviudal alien
  void drawAliens(float[][] bulletPosition, Player player, HUD_Container userHUD, Boolean playerLose) {
    for (int i = 0; i < alienArray.length; i++) {
      alienArray[i].draw(bulletPosition, player, userHUD, playerLose);
    }
  }

  // Sets the speed of the aliens depending on the level
  void setSpeed() {
    switch (levelNumber) {
    case 1:
      framesPerBeat = 80;
      frameSpeedLimit = 30;
      frameSubtractAmount = 5;
      break;
    case 2:
      framesPerBeat = 75;
      frameSpeedLimit = 25;
      frameSubtractAmount = 6;
      break;
    case 3:
      framesPerBeat = 70;
      frameSpeedLimit = 20;
      frameSubtractAmount = 6;
      break;
    case 4:
      framesPerBeat = 65;
      frameSpeedLimit = 15;
      frameSubtractAmount = 7;
      break;
    case 5:
      framesPerBeat = 60;
      frameSpeedLimit = 10;
      frameSubtractAmount = 7;
      break;
    }
  }

  // Moves the aliens to the next position on the screen
  void moveAliens(Alien[] alienArray) {
    if (playerLose == false) {
      if (currentFrame == framesPerBeat) {
        amountOfBeats++;
        if (amountOfBeats % 8 == 0) {
          if (framesPerBeat > frameSpeedLimit) {
            framesPerBeat -= frameSubtractAmount;
          }
        }
        if ((alienArray[rightAlienLimit].alienPosition[0] >= MOB_RIGHT_LIMIT) && (moveLeft == false)) {
          jumpDistance = 0;
          dropDownDistance = (int) PIXEL_JUMP_DISTANCE;
          moveLeft = true;
        } else if ((alienArray[0].alienPosition[0] <= MOB_LEFT_LIMIT) && (moveLeft == true)) {
          jumpDistance = 0;
          dropDownDistance = (int) PIXEL_JUMP_DISTANCE;
          moveLeft = false;
        } else if (moveLeft == true) {
          jumpDistance = (int) -PIXEL_JUMP_DISTANCE;
          dropDownDistance = 0;
        } else {
          jumpDistance = (int) PIXEL_JUMP_DISTANCE;
          dropDownDistance = 0;
        }
        for (int i = 0; i < alienArray.length; i++) {
          alienArray[i].incrementAlienPosition(jumpDistance, dropDownDistance);
          currentFrame = 0;
        }
      }
      currentFrame++;
    }
  }

  // Handles everything to do with the player losing
  void playerLoseHandler() {
    checkPlayerLoseLine();
    animatePlayerLose();
    displayPlayerLose();
  }

  // Fills the alien array depending on the level number
  Alien[] alienArrayFill() {
    // Sets how the Affraics are displayed and organised on the screen, and which type are diplayed
    if (levelNumber == 1) {
      int xSpawn = 0;
      float xSpawnOffset = LEVEL_ONE_X_SPAWN_OFFSET;  // 460px
      float ySpawn = ALIEN_Y_SPAWN;  // 100 px
      int rowElementCounter = 1;
      int rowNumber = 0;
      int alienType = AFFRAIC_NORMAL;
      for (int i = 0; i < alienArray.length; i++) {
        // Setting the image for the alien being displayed
        if (enableSuperAffraics == true) {
          if ((rowNumber == 0) || (((rowNumber == 1) || (rowNumber == 2)) && ((rowElementCounter == 1) || 
            (rowElementCounter == 2) || (rowElementCounter == 9) || (rowElementCounter == 10)))) {
            alienType = AFFRAIC_NORMAL;
          } else if (rowNumber == 1) {
            alienType = AFFRAIC_PIRATE;
          } else {
            alienType = AFFRAIC_TOUGH;
          }
        } else {
          alienType = AFFRAIC_NORMAL;
        }
        alienArray[i] = new Alien(alienType, xSpawn + xSpawnOffset, ySpawn);
        xSpawn += ALIEN_X_SPAWN_INCREMENT;
        if (rowElementCounter == 10) {
          ySpawn += ALIEN_Y_SPAWN;
          xSpawn = 0;
          rowElementCounter = 0;
          rowNumber++;
        }
        rowElementCounter++;
      }
    } else if (levelNumber == 2) {
      int xSpawn = 0;             // The x spawn position of the alien, incremented by 100 for each element, reset to 0 for each row
      float xSpawnOffset = LEVEL_TWO_X_SPAWN_OFFSET;     // The distance from the left wall all the aliens will be spawned
      float ySpawn = ALIEN_Y_SPAWN;           // The y spawn position of the alien, incremented by 100 every row
      int rowElementCounter = 1;  // The column we are setting the alien type
      int rowNumber = 0;          // The row in which we are setting the alien type
      int alienType = AFFRAIC_NORMAL;
      for (int i = 0; i < alienArray.length; i++) {
        // Setting the image for the alien being displayed
        if (enableSuperAffraics == true) {
          if ((rowElementCounter == 1) || (rowElementCounter == 2) || (rowElementCounter == 3) || (rowElementCounter == 13) 
            || (rowElementCounter == 14) || (rowElementCounter == 15)) {
            alienType = AFFRAIC_NORMAL;
          } else if (((rowNumber == 0) || (rowNumber == 2)) && ((rowElementCounter == 7) || (rowElementCounter == 8) || (rowElementCounter == 9))) {
            alienType = AFFRAIC_PIRATE;
          } else if ((rowNumber == 1) && ((rowElementCounter == 4) || (rowElementCounter == 5) || (rowElementCounter == 6) || (rowElementCounter == 10) 
            || (rowElementCounter == 11) || (rowElementCounter == 12))) {
            alienType = AFFRAIC_TOUGH;
          } else {
            alienType = AFFRAIC_RAINBOW;
          }
        }
        alienArray[i] = new Alien(alienType, xSpawn + xSpawnOffset, ySpawn);
        xSpawn += 100;
        if (rowElementCounter == 15) {
          ySpawn += ALIEN_Y_SPAWN;
          xSpawn = 0;
          rowElementCounter = 0;
          rowNumber++;
        }
        rowElementCounter++;
      }
    } else if (levelNumber == 3) {
      int xSpawn = 0;             // The x spawn position of the alien, incremented by 100 for each element, reset to 0 for each row
      float xSpawnOffset = LEVEL_THREE_X_SPAWN_OFFSET;     // The distance from the left wall all the aliens will be spawned
      float ySpawn = ALIEN_Y_SPAWN;           // The y spawn position of the alien, incremented by 100 every row
      int rowElementCounter = 1;  // The column we are setting the alien type
      int rowNumber = 0;          // The row in which we are setting the alien type
      int alienType = AFFRAIC_NORMAL;
      for (int i = 0; i < alienArray.length; i++) {
        // Setting the image for the alien being displayed
        if (enableSuperAffraics == true) {
          if ((rowElementCounter == 1) || (rowElementCounter == 2) || (rowElementCounter == 11) || (rowElementCounter == 12)) {
            alienType = AFFRAIC_NORMAL;
          } else if (rowNumber == 0) {
            alienType = AFFRAIC_ROBOT;
          } else if (rowNumber == 1) {
            alienType = AFFRAIC_TOUGH;
          } else if ((rowNumber == 2) || ((rowNumber == 4) && ((rowElementCounter == 6) || (rowElementCounter == 7)))) {
            alienType = AFFRAIC_RAINBOW;
          } else {
            alienType = AFFRAIC_PIRATE;
          }
        }
        alienArray[i] = new Alien(alienType, xSpawn + xSpawnOffset, ySpawn);
        xSpawn += 100;
        if (rowElementCounter == 12) {
          ySpawn += ALIEN_Y_SPAWN;
          xSpawn = 0;
          rowElementCounter = 0;
          rowNumber++;
        }
        rowElementCounter++;
      }
    } else if (levelNumber == 4) {
      int xSpawn = 0;             // The x spawn position of the alien, incremented by 100 for each element, reset to 0 for each row
      float xSpawnOffset = LEVEL_FOUR_X_SPAWN_OFFSET;     // The distance from the left wall all the aliens will be spawned
      float ySpawn = ALIEN_Y_SPAWN;           // The y spawn position of the alien, incremented by 100 every row
      int rowElementCounter = 1;  // The column we are setting the alien type
      int rowNumber = 0;          // The row in which we are setting the alien type
      int alienType = AFFRAIC_NORMAL;
      for (int i = 0; i < alienArray.length; i++) {
        // Setting the image for the alien being displayed
        if (enableSuperAffraics == true) {
          if ((rowNumber == 0) || ((rowElementCounter == 1) || (rowElementCounter == 15))) {
            alienType = AFFRAIC_ALIEN;
          } else if ((rowElementCounter == 2) || (rowElementCounter == 3) || (rowElementCounter == 13) || (rowElementCounter == 14)) {
            alienType = AFFRAIC_PIRATE;
          } else if (rowNumber == 1) {
            alienType = AFFRAIC_ROBOT;
          } else if (rowNumber == 2) {
            alienType = AFFRAIC_RAINBOW;
          } else {
            alienType = AFFRAIC_TOUGH;
          }
        }
        alienArray[i] = new Alien(alienType, xSpawn + xSpawnOffset, ySpawn);
        xSpawn += 100;
        if (rowElementCounter == 15) {
          ySpawn += ALIEN_Y_SPAWN;
          xSpawn = 0;
          rowElementCounter = 0;
          rowNumber++;
        }
        rowElementCounter++;
      }
    } else {
      int xSpawn = 0;             // The x spawn position of the alien, incremented by 100 for each element, reset to 0 for each row
      float xSpawnOffset = LEVEL_FIVE_X_SPAWN_OFFSET;     // The distance from the left wall all the aliens will be spawned
      float ySpawn = ALIEN_Y_SPAWN;           // The y spawn position of the alien, incremented by 100 every row
      int rowElementCounter = 1;  // The column we are setting the alien type
      int rowNumber = 0;          // The row in which we are setting the alien type
      int alienType = AFFRAIC_NORMAL;
      for (int i = 0; i < alienArray.length; i++) {
        // Setting the image for the alien being displayed
        if (enableSuperAffraics == true) {
          if (rowNumber == 0) {
            alienType = AFFRAIC_ALIEN;
          } else if (rowNumber == 1) {
            alienType = AFFRAIC_ROBOT;
          } else if (rowNumber == 2) {
            alienType = AFFRAIC_RAINBOW;
          } else if (rowNumber == 3) {
            alienType = AFFRAIC_TOUGH;
          } else {
            alienType = AFFRAIC_PIRATE;
          }
        }
        alienArray[i] = new Alien(alienType, xSpawn + xSpawnOffset, ySpawn);
        xSpawn += 100;
        if (rowElementCounter == 15) {
          ySpawn += ALIEN_Y_SPAWN;
          xSpawn = 0;
          rowElementCounter = 0;
          rowNumber++;
        }
        rowElementCounter++;
      }
    }
    return alienArray;
  }


  // Checks to see if any alien has reached the playerLoseLine and carries out necessary actions if so
  void checkPlayerLoseLine() {
    for (int i = 0; i < alienArray.length; i++) {
      if ((alienArray[i].alienPosition[1] >= PLAYER_LOSE_LINE) && (alienArray[i].alienDead == false) && 
        ((alienArray[i].alienImage != affraicBlank) || (alienArray[i].alienImage != affraicCustard))) {
        playerLose = true;
        eventLogger.shipHealth = 0;
      }
    }
  }

  // Animates the aliens when the player loses
  void animatePlayerLose() {
    if (playerLose == true) {
      if (animPauseCount <= 120) {
        animPauseCount++;
      } else if (alienArray[0].alienPosition[1] < displayHeight + 50) {
        if (alienDescend.isPlaying() == false) {
          alienDescend.stop();
          alienDescend.play();
        }
        for (int i = 0; i < alienArray.length; i++) {
          alienArray[i].alienPosition[1] += 2;
          alienArray[i].alienPosition[0] += alienSinAnimation(10, 1); // speed, distance
        }
        animMoveCount++;
      } else {
        displayPlayerLose = true;
      }
    }
  }

  // Displays the player lose logo
  void displayPlayerLose() {
    if (displayPlayerLose == true) {
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
          text("--- PRESS \"SPACE\" WHEN READY TO RETURN TO MAIN MENU ---", (displayWidth / 2), 1000);
        }
      }
      if (youLosePlayed == false) {
        youLosePlayed = true;
        youLose.stop();
        youLose.play();
      }
      image(logoYouLose, (displayWidth / 2) - (logoStart.width / 2), - 135);
      eventLogger.displayHighScores = true;
      // Allows the user to skip the intro animation by pressing space
      if (keyPressed) {
        if (key == ' ') {
          displayPlayerLose = false;
          eventLogger.displayMainMenu = true;
          eventLogger.resetGame();
          eventLogger.displayHighScores = false;
        }
      }
    }
  }

  // Decides how big the alien array should be based on the level number
  int getAlienAmount(int levelNumber) {
    int alienAmount;
    switch (levelNumber) {
    case 1:
      alienAmount = 30;
      alienAmountPerRow = 10;
      alienAmountPerColumn = 3;
      break;
    case 2:
      alienAmount = 45;
      alienAmountPerRow = 15;
      alienAmountPerColumn = 3;
      break;
    case 3:
      alienAmount = 48;
      alienAmountPerRow = 12;
      alienAmountPerColumn = 4;
      break;
    case 4:
      alienAmount = 60;
      alienAmountPerRow = 15;
      alienAmountPerColumn = 4;
      break;
    default:
      alienAmount = 75;
      alienAmountPerRow = 15;
      alienAmountPerColumn = 5;
      break;
    }
    return alienAmount;
  }

  // moves the aliens in a sinusoidal fashion used in playerLose animation
  float alienSinAnimation(int speed, int distance) {
    float hoverSpeed = ((float) frameCount) / speed;
    float animVariable = distance * sin(hoverSpeed);
    return animVariable;
  }

  // Returns if the player has lost
  boolean getPlayerLose() {
    return playerLose;
  }

  // Sets the playerLose boolean
  void setPlayerLose() {
    playerLose = true;
  }

  // Are all enemies dead
  boolean areAllAliensDead() {
    boolean allAliensDead = true;
    for (int i = 0; i < alienArray.length; i++) {
      if (alienArray[i].alienDead == false) {
        allAliensDead = false;
        i = alienArray.length;
      }
    }
    return allAliensDead;
  }
}
