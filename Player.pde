class Player {
  // Useful settings
  int bulletFireSpeed = 10;                            // The speed at which the bullets move across the screen
  int bulletLimiter = 10;                               // Amount of frames that must elapse before another bullet can be fired
  int bulletAmount = 11;                                // Total amount of bullets that can be on screen at the same time
  int invincibilityTime = 120;                                 // Amount of frames the player will be invincible after being hit (always in multiples of 30)

  // Dimensions and pixel constants
  final float SHIP_EDGE_BOUNDARY = displayWidth * 0.0052083;   // 10px
  final float BULLET_SPAWN_Y = displayHeight * 0.87962;        // 950px

  // Variables
  float shipXPosition;
  int bulletFrameCounter;              // Counts the amount of frames between bullets to avoid bullet spam
  PImage bulletImage;
  boolean shipHit = false;             // If the ship has been hit or not
  boolean playerInvisible = false;    // Invincible given to the player for a short period of time after being hit
  int invincibilityCounter = 0;
  boolean shipHitAnimation = false;    // If the ship hit image should be displayed.
  int shipHitAnimCounter = 0;          // counts how long the ship hit image should be displayed
  int invisibleAnimCounter = 0;
  boolean shipImageInvisible = false;
  boolean playerLose = false;
  int explodeAnimCount = 0;
  boolean shipExplodeAnimOver = false;
  float[] cannonBallPosition = new float[2];
  boolean isCannonBallFired = false;
  float[] rainbowPosition = new float[2];
  boolean isRainbowFired = false;
  boolean rainbowTrailEnabled = false;
  float[][] rainbowTrailPosition = new float[2][12];
  int rainbowTrailOpacity = 255;
  float rainbowSinDistance = 4;
  float rainbowSinSpeed = 20;
  float[] laserPosition = new float[2];
  boolean isLaserFired = false;
  float[] secondaryLaserPosition = new float[2];
  boolean displaySecondaryLaser = false;
  int laserCounter = 0;
  boolean isPlasmaFired = false;
  float[] plasmaPosition = new float[2];
  int bulletsFired = 0;
  int specialWeaponsUsed = 0;          // Used to count the amount of times a special weapon is used


  // Arrays
  Boolean[] isBulletFired;             // Contains whether or not a bullet is currently moving across the screen
  float[][] bulletPosition;            // Contains the position of all bullets on the screen

  // Objects
  Intro_Animation levelIntroAnim;
  Mob_Handler currentMob;

  // SFX
  boolean playLoseSound = true;



  Player(Intro_Animation levelIntroAnim, Mob_Handler currentMob) {
    currentShip = shipWarhead;
    shipHit = false;             // If the ship has been hit or not
    playerInvisible = false;    // Invincible given to the player for a short period of time after being hit
    invincibilityCounter = 0;
    shipHitAnimation = false;    // If the ship hit image should be displayed.
    shipHitAnimCounter = 0;          // counts how long the ship hit image should be displayed
    invisibleAnimCounter = 0;
    shipImageInvisible = false;
    playerLose = false;
    explodeAnimCount = 0;
    shipExplodeAnimOver = false;
    cannonBallPosition = new float[2];
    isCannonBallFired = false;
    rainbowPosition = new float[2];
    isRainbowFired = false;
    rainbowTrailEnabled = false;
    rainbowTrailPosition = new float[2][12];
    rainbowTrailOpacity = 255;
    rainbowSinDistance = 4;
    rainbowSinSpeed = 20;
    laserPosition = new float[2];
    isLaserFired = false;
    secondaryLaserPosition = new float[2];
    displaySecondaryLaser = false;
    laserCounter = 0;
    isPlasmaFired = false;
    plasmaPosition = new float[2];
    bulletsFired = 0;
    specialWeaponsUsed = 0;          // Used to count the amount of times a special weapon is used

    //SFX
    playLoseSound = true;

    this.levelIntroAnim = levelIntroAnim;
    this.currentMob = currentMob;

    // Setting up player bullet system
    isBulletFired = new Boolean[bulletAmount];
    for (int i = 0; i < isBulletFired.length; i++) {
      isBulletFired[i] = false;
    }
    bulletPosition = new float[bulletAmount][2];
    bulletFrameCounter = bulletLimiter;
    bulletImage = bulletNormal;
  }

  void draw(HUD_Container userInterface) {
    difficultySettings();
    if ((levelIntroAnim.getIntroAnimOver() == true) && (playerLose == false)) {
      drawBullet(userInterface);
    }
    shipXPosition = getShipXPosition(shipXPosition);
    drawPlayerShip();
    shipHitHandler();
  }

  // Changes settings relating to difficulty level
  void difficultySettings() {
    switch (difficultyLevel) {
    case HARD:
      bulletFireSpeed = 8;
      bulletLimiter = 13;
      bulletAmount = 8;
      invincibilityTime = 60; 
      break;
    case MEDIUM:
      bulletFireSpeed = 10;
      bulletLimiter = 10;
      bulletAmount = 11;
      invincibilityTime = 120; 
      break;
    case EASY:
      bulletFireSpeed = 10;
      bulletLimiter = 10;
      bulletAmount = 12;
      invincibilityTime = 180; 
      break;
    }
  }

  // Handles everything if the ship is hit
  void shipHitHandler() {
    if (playerLose == false) {
      shipHit();
      shipHitAnimation();
      shipInvincibilityTimer();
      shipInvisibleAnimator();
    } else {
      explodeShipAnim();
    }
  }

  // Performs necessary actions if the ship is hit
  void shipHit() {
    if ((shipHit == true) && (playerInvisible == false)) {
      shipHit = false;
      shipHitAnimation = true;
      playerInvisible = true;
      float damagePoints = random(4, 20);
      if (eventLogger.shipHealth - (int) damagePoints < 0) {
        eventLogger.shipHealth = 0;
        playerLose = true;
      } else {
        eventLogger.shipHealth -= (int) damagePoints;
      }
      invincibilityCounter = 0;
    }
  }

  // Animation for exploding the ship
  void explodeShipAnim() {
    if ((playerLose == true) && (shipExplodeAnimOver == false)) {
      if (playLoseSound == true) {
        playLoseSound = false;
        playerLoseSound.play();
      }
      currentShip = shipExplode;
      explodeAnimCount++;
      if (explodeAnimCount == 60) {
        shipExplodeAnimOver = true;
      }
    }
  }

  void shipInvincibilityTimer() {
    if (playerInvisible == true) {
      invincibilityCounter++;
      if (invincibilityCounter == invincibilityTime) {
        playerInvisible = false;
        invincibilityCounter = 0;
      }
    }
  }

  void shipInvisibleAnimator() {
    if (playerInvisible == true) {
      invisibleAnimCounter++;
      if (invisibleAnimCounter == 10) {
        if (shipImageInvisible == true) {
          currentShip = shipWarheadInvisible;
          shipImageInvisible = false;
        } else {
          currentShip = shipWarhead;
          shipImageInvisible = true;
        }
        invisibleAnimCounter = 0;
      }
    }
    if (shipImageInvisible == true) {
      currentShip = shipWarhead;
    }
  }

  void shipHitAnimation() {
    if (shipHitAnimation == true) {
      shipHitAnimCounter++;
      image(shipWarheadHit, shipXPosition, (displayHeight - currentShip.height));
      if (shipHitAnimCounter == 10) {
        shipHitAnimCounter = 0;
        shipHitAnimation = false;
      }
    }
  }

  // allows other classes to set if the player ship has been hit
  void setShipHit(boolean isShipHit) {
    if ((shipHit == false) && (playerInvisible == false) && (shipHitAnimation == false)) {
      shipHit = isShipHit;
    }
  }

  // Calculates the position that the ship is in based on mouse position
  float getShipXPosition(float currentShipXPosition) {
    float shipXPosition = currentShipXPosition;
    if (playerLose == false) {
      if (mouseX < SHIP_EDGE_BOUNDARY) {
        shipXPosition = SHIP_EDGE_BOUNDARY;
      } else if (mouseX > (displayWidth - currentShip.width - SHIP_EDGE_BOUNDARY)) {
        shipXPosition = (displayWidth - currentShip.width - SHIP_EDGE_BOUNDARY);
      } else {
        shipXPosition = mouseX;
      }
    }
    return shipXPosition;
  }

  // Draws the players ship to the screen
  float drawPlayerShip() {
    if ((playerLose == false) || (shipExplodeAnimOver == false)) {
      image(currentShip, shipXPosition, (displayHeight - currentShip.height));
    }
    return shipXPosition;
  }

  float[][] getBulletPosition() {
    return bulletPosition;
  }

  // Draws the bullet on the screen and handles everything to do with the bullet
  void drawBullet(HUD_Container userInterface) {
    bulletFrameCounter = fireNewBullet(bulletFrameCounter, userInterface);
    animateBullet();
    despawnBullet();
    bulletFrameCounter = bulletFrameCounter(bulletFrameCounter);
    animateCannonBall();
    animateRainbow();
    animateRainbowTrail();
    animateLaser();
    animateSecondaryLaser();
    animatePlasma();
  }

  // Fires a new bullet if the corresponding key has been pressed
  // Sets bulletFrameCounter = 0 if a bullet has been fired
  int fireNewBullet(int bulletFrameCounter, HUD_Container userInterface) {
    if (bulletFrameCounter == bulletLimiter) {
      if (keyPressed) {
        // firing normal bullet
        if ((key == 'a') || (key == 'A')) {
          playerShoot.stop();
          playerShoot.play();
          for (int i = 0; i < isBulletFired.length; i++) {
            if (isBulletFired[i] == false) {
              bulletsFired += 1;
              isBulletFired[i] = true;
              i = isBulletFired.length;
              bulletFrameCounter = 0;
            }
          }
        } 
        // firing cannonball
        if ((key == 's') || (key == 'S')) {
          if (eventLogger.hasCannonBall == true) {
            if (isCannonBallFired == false) {
              playerCannon.stop();
              playerCannon.play();
              specialWeaponsUsed++;
              isCannonBallFired = true;
              eventLogger.hasCannonBall = false;
              cannonBallPosition[0] = shipXPosition + (currentShip.width / 2) - (bulletCannonBall.width / 2);
              cannonBallPosition[1] = -1 *  bulletCannonBall.height;
              userInterface.addNewScore(100, (int) shipXPosition + (currentShip.width), (int) BULLET_SPAWN_Y);
            }
          }
        }
        // Firing Rainbow
        if ((key == 'd') || (key == 'D')) {
          if (eventLogger.hasRainbow == true) {
            playerRainbow.stop();
            playerRainbow.play();
            specialWeaponsUsed++;
            isRainbowFired = true;
            eventLogger.hasRainbow = false;
            rainbowPosition[0] = shipXPosition + (currentShip.width / 2) - (bulletRainbow.width / 2);
            rainbowPosition[1] = BULLET_SPAWN_Y;
            userInterface.addNewScore(150, (int) shipXPosition + (currentShip.width), (int) BULLET_SPAWN_Y);
          }
        }
        // Firing Laser
        if ((key == 'z') || (key == 'Z')) {
          if (eventLogger.hasLaser == true) {
            playerLaser.stop();
            playerLaser.play();
            specialWeaponsUsed++;
            isLaserFired = true;
            eventLogger.hasLaser = false;
            laserPosition[0] = shipXPosition + (currentShip.width / 2) - (bulletPlayerLaser.width / 2);
            laserPosition[1] = BULLET_SPAWN_Y;
            userInterface.addNewScore(175, (int) shipXPosition + (currentShip.width), (int) BULLET_SPAWN_Y);
          }
        }
        // Firing Plasma
        if ((key == 'x') || (key == 'X')) {
          if (eventLogger.hasPlasma == true) {
            playerPlasma.stop();
            playerPlasma.play();
            specialWeaponsUsed++;
            isPlasmaFired = true;
            eventLogger.hasPlasma = false;
            plasmaPosition[0] = shipXPosition + (currentShip.width / 2) - (bulletPlasma.width / 2);
            plasmaPosition[1] = BULLET_SPAWN_Y;
            userInterface.addNewScore(200, (int) shipXPosition + (currentShip.width), (int) BULLET_SPAWN_Y);
          }
        }
      }
    }
    return bulletFrameCounter;
  }

  // Animates the plasma on the screen
  void animatePlasma() {
    if (isPlasmaFired == true) {
      plasmaPosition[1] -= bulletFireSpeed;
      image(bulletPlasma, plasmaPosition[0], plasmaPosition[1]);
      if (plasmaPosition[1] < -bulletPlasma.height) {
        isPlasmaFired = false;
      }
    }
  }

  // Despawns a plasma bullet
  void despawnPlasma() {
    if (isPlasmaFired == true) {
      plasmaPosition[1] = -bulletPlasma.height;
    }
  }

  // Animates the laser on the screen
  void animateLaser() {
    if (isLaserFired == true) {
      laserCounter++;
      if (laserPosition[1] < 0) {
        laserPosition[1] += 10;//displayHeight * 0.3333;
      } else {
        laserPosition[1] = 0;
      }
      image(bulletPlayerLaser, laserPosition[0], laserPosition[1]);
      if (laserCounter == 10) {
        laserCounter = 0;
        isLaserFired = false;
      }
    }
  }

  // Checks for a hit so secondary laser can be fired
  void animateSecondaryLaser() {
    if (displaySecondaryLaser == false) {
      for (int i = 0; i < currentMob.alienArray.length; i++) {
        if (currentMob.alienArray[i].isHitByLaser == true) {
          displaySecondaryLaser = true;
          currentMob.alienArray[i].isHitByLaser = false;
          secondaryLaserPosition[0] = 0;
          secondaryLaserPosition[1] = currentMob.alienArray[i].alienPosition[1] + (affraicNormal.height / 2) - (bulletPlayerSecondaryLaser.height / 2);
        }
      }
    } else if (displaySecondaryLaser == true) {
      image(bulletPlayerSecondaryLaser, secondaryLaserPosition[0], secondaryLaserPosition[1]);
    }
    if (isLaserFired == false) {
      displaySecondaryLaser = false;
    }
  }


  // Animates the cannonball on the screen
  void animateCannonBall() {
    if (isCannonBallFired == true) {
      cannonBallPosition[1] += bulletFireSpeed;
      image(bulletCannonBall, cannonBallPosition[0], cannonBallPosition[1]);
      if (cannonBallPosition[1] > displayHeight) {
        isCannonBallFired = false;
      }
    }
  }

  // Animates the rainbow on the screen
  void animateRainbow() {
    if (isRainbowFired == true) {
      rainbowPosition[1] -= bulletFireSpeed;
      image(bulletPlayerRainbow, rainbowPosition[0], rainbowPosition[1]);
      if (rainbowPosition[1] < -(bulletRainbow.height * 22)) {
        isRainbowFired = false;
      }
    }
  }

  // Animates the rainbows trail
  void animateRainbowTrail() {
    if ((isRainbowFired == true) && (rainbowTrailEnabled == false)) {
      rainbowTrailEnabled = true;
    } else if (rainbowTrailEnabled == true) {
      for (int i = 0; i < rainbowTrailPosition[0].length; i++) {
        if (i == 0) {
          rainbowTrailPosition[0][i] = rainbowPosition[0];
          rainbowTrailPosition[1][i] = rainbowPosition[1] + bulletPlayerRainbow.height;
        } else {
          rainbowTrailPosition[0][i] = rainbowTrailPosition[0][i - 1];
          rainbowTrailPosition[1][i] = rainbowTrailPosition[1][i - 1] + bulletPlayerRainbow.height;
        }
        tint(255, 255 - (i * 20));  // First value is greyscale second value is alpha channel
        image(bulletPlayerRainbow, rainbowTrailPosition[0][i], rainbowTrailPosition[1][i]);
        tint(255, 255);  // Resetting for later images
      }
      if (rainbowTrailPosition[1][rainbowTrailPosition[0].length - 1] < -bulletPlayerRainbow.height) {
        rainbowTrailEnabled = false;
      }
    }
  }

  // Moves the bullets on the screen
  void animateBullet() {
    for (int i = 0; i < isBulletFired.length; i++) {
      if (isBulletFired[i] == true) {
        // Setting the bullet position
        if (bulletPosition[i][0] < 0) {
          bulletPosition[i][0] = shipXPosition + (currentShip.width / 2) - (bulletNormal.width / 2);
          bulletPosition[i][1] = BULLET_SPAWN_Y;
        } else {
          bulletPosition[i][1] -= bulletFireSpeed;
          image(bulletImage, bulletPosition[i][0], bulletPosition[i][1]);
        }
      }
    }
  }

  // Forces a bullet to despawn 
  void forceDespawnBullet(int bulletIndex) {
    if ((bulletIndex < isBulletFired.length) && (bulletIndex >= 0)) {
      bulletPosition[bulletIndex][1] = -200;
    }
  }

  // Checks each bullets position and despawns it if is off the screen 
  void despawnBullet() {
    for (int i = 0; i < isBulletFired.length; i++) {
      if ((isBulletFired[i] == true) && (bulletPosition[i][1] < (-bulletImage.width))) {
        bulletPosition[i][0] = -200;
        bulletPosition[i][1] = -200;
        isBulletFired[i] = false;
      }
    }
  }

  // increments the bullet frame counter
  int bulletFrameCounter(int bulletFrameCounter) {
    if (bulletFrameCounter != bulletLimiter) {
      bulletFrameCounter++;
    }
    return bulletFrameCounter;
  }

  int getShipHealth() {
    return eventLogger.shipHealth;
  }

  int getPlayerScore() {
    return eventLogger.playerScore;
  }

  void setPlayerScore(int score) {
    if (score >= 0) {
      eventLogger.playerScore = score;
    }
  }

  void incrementPlayerScore(int scoreIncrement) {
    eventLogger.playerScore += scoreIncrement;
  }

  // When called this function will increment the score by a random number 
  // Input LOW_POINTS, MEDIUM_POINTS, HIGH_POINTS
  void autoIncrementScore(int pointReturn, HUD_Container userHUD, int xPosition, int yPosition) {
    float randomNumber;
    if (pointReturn == LOW_POINTS) {
      randomNumber = random(10, 30);
    } else if (pointReturn == MEDIUM_POINTS) {
      randomNumber = random(30, 80);
    } else if (pointReturn == HIGH_POINTS) {
      randomNumber = random(80, 150);
    } else {
      randomNumber = random(10, 100);
    }
    eventLogger.playerScore += (int) randomNumber;
    userHUD.addNewScore((int) randomNumber, xPosition, yPosition);
  }

  // Gives the player a cannonball item
  void playerGetsCannonBall() {
    eventLogger.hasCannonBall = true;
  }

  // Gives the player a rainbow item
  void playerGetsRainbow() {
    eventLogger.hasRainbow = true;
  }

  // Gives the player a laser item
  void playerGetsLaser() {
    eventLogger.hasLaser = true;
  }

  // Gives the playert a plasma item
  void playerGetsPlasma() {
    eventLogger.hasPlasma = true;
  }

  // Returns the amount of bullets the player was fired so far
  int getBulletsFired() {
    return bulletsFired;
  }

  // Returns the amount of times a special weapon has been used
  int getSpecialWeaponsUsed() {
    return specialWeaponsUsed;
  }

  // Returns if the player has lost
  boolean getPlayerLose() {
    return playerLose;
  }

  // Sets the playerLose boolean
  void setPlayerLose() {
    playerLose = true;
  }
}
