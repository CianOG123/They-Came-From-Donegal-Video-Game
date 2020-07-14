class Alien {

  // Difficulty Variables
  int bulletFireRate = 1000;              // The lower the number, the more likely it is that the alien will fire a bullet at the player
  int bulletFireSpeed = 10;                // The amount of pixels the alien bullets will move every frame. 3 is slow, 15 is very fast.

  // Local Variables
  int alienMaxScore = 100;                // The max amount of points you can get for killing an alien
  int alienMinScore = 10;                 // The least amount of points you can get from killing an alien
  int alienType;                          // The type of alien that we want to display
  PImage alienImage;                      // Image being used to display the alien
  PImage hitImage;                        // Image displayed when the alien is hit
  PImage bulletImage;                     // Image used for the aliens bullet
  int alienHealth;                        // Amount of health points the alien has
  float[] alienPosition = new float[2];   // The position of the alien on the screen
  boolean alienDead = false;              // Set whether or not the alien is being displayed
  boolean alienExploding = false;         // should the alien explode
  int alienExplodeTimer = 0;              // Incremental counter for alien explode animation
  boolean playHitAnimation = false;       // Should alien hit animation be played
  int alienHitCounter = 0;                // Incremental counter for alien hit animation
  boolean bulletFired = false;            // If the aliens bullet is currently on screen
  float[] bulletPosition = new float[2];  // The position of the aliens bullet
  boolean dropItem = false;               // Set to true if the alien is dropping an item
  float[] itemPosition = new float[2];
  boolean triedToDropItem = false;        // Set to true if the program has tried to drop an item.
  boolean isHitByLaser = false;
  boolean isHitByPlasma = false;

  // SFX
  boolean playPlayerHit = false;
  boolean playAlienExplode = true;
  int playerHitCounter = 0;

  Alien(int alienType, float xSpawn, float ySpawn) {
    this.alienType = alienType;
    alienImage = setAlienImage(alienType);
    alienHealth = setAlienHealth(alienType);
    setAlienSpawn(alienPosition, xSpawn, ySpawn);
    hitImage = setAlienHitImage(alienType);
    bulletImage = setAlienBulletImage(alienType);
  }

  // Draw the alien to the screen
  void draw(float[][] bulletPosition, Player player, HUD_Container userHUD, Boolean playerLose) {
    if (alienDead == false) {
      setDifficultySettings();
      explodeAlien(player, userHUD);
      isAlienHit(bulletPosition, player);
      if (playerLose == false) {
        fireBullet();
      }
    }
    itemHandler(player);
    animateBullet();
    isShipHit(player);
    image(alienImage, alienPosition[0], alienPosition[1]);
    alienHitAnimation(player, userHUD);
  }

  // Handles player hit SFX
  void playerHitSFX(Player player) {
    if ((playerHitCounter == 0) && (player.playerInvisible == false)) {
      playerHit.stop();
      playerHit.play();
      playerHitCounter++;
    } else if (playerHitCounter != 0) {
      playerHitCounter++;
      playPlayerHit = false;
      if (playerHitCounter >= 60) {
        playerHit.stop();
        playerHitCounter = 0;
      }
    }
  }

  // Changes difficulty settings
  void setDifficultySettings() {
    switch (difficultyLevel) {
    case HARD:
      bulletFireRate = 900;
      bulletFireSpeed = 15;
      break;
    case MEDIUM:
      bulletFireRate = 1100;
      bulletFireSpeed = 10;
      break;
    default:
      bulletFireRate = 1200;
      bulletFireSpeed = 5;
      break;
    }
  }

  // Handles everything to do with items
  void itemHandler(Player player) {
    dropItem();
    animateItem();
    hasPlayerCollectedItem(player);
  }

  // Decides if the alien should drop an item when dead
  void dropItem() {
    if (((alienType == AFFRAIC_PIRATE) || (alienType == AFFRAIC_RAINBOW) || (alienType == AFFRAIC_ROBOT) || (alienType == AFFRAIC_ALIEN)) 
    && ((alienDead == true) && (triedToDropItem == false))) {
      triedToDropItem = true;
      float randomNumber = random(6);
      if ((int) randomNumber == 0) {
        dropItem = true;
        itemPosition[0] = alienPosition[0];
        itemPosition[1] = alienPosition[1];
      }
    }
  }

  // Animates the aliens item on the screen
  void animateItem() {
    if ((dropItem == true) && (itemPosition[1] < displayHeight)) {
      itemPosition[1] += 5;
      image(ammoDrop, itemPosition[0], itemPosition[1]);
    }
  }

  // checks to see if the player has collected the item
  void hasPlayerCollectedItem(Player player) {
    int shipYPosition = (displayHeight - currentShip.height);
    if ((itemPosition[1] + ammoDrop.height > shipYPosition) && (itemPosition[1] < shipYPosition + currentShip.height)) {
      if ((itemPosition[0] + ammoDrop.width > player.shipXPosition) && (itemPosition[0] < player.shipXPosition + currentShip.width)) {
        playerPickup.play();
        itemPosition[1] += displayHeight;
        switch (alienType) {
        case AFFRAIC_PIRATE:
          player.playerGetsCannonBall();
          break;
        case AFFRAIC_ROBOT:
          player.playerGetsLaser();
          break;
        case AFFRAIC_ALIEN:
          player.playerGetsPlasma();
          break;
        default:
          player.playerGetsRainbow(); 
          break;
        }
      }
    }
  }

  // Checks if the bullet has hit the ship and tells the player class if the ship has been hit
  void isShipHit(Player player) {
    if (((bulletPosition[1] + bulletImage.height) > (displayHeight - currentShip.height)) && (bulletPosition[1] < displayHeight)) {
      if (((bulletPosition[0] + bulletImage.width) > player.shipXPosition) && (bulletPosition[0] < (player.shipXPosition + currentShip.width))) {
        playerHitSFX(player);
        player.setShipHit(true);
      }
    }
  }

  // Randomly fires the aliens bullet
  void fireBullet() { 
    if (bulletFired == false) {
      float randomNumber = random(bulletFireRate);
      if ((int) randomNumber == 0) {
        switch (alienType) {
        case AFFRAIC_PIRATE:
          alienCannon.stop();
          alienCannon.play();
          break;
        case AFFRAIC_ROBOT:
          alienLaser.stop();
          alienLaser.play();
          break;
        case AFFRAIC_RAINBOW:
          alienRainbow.stop();
          alienRainbow.play();
          break;
        case AFFRAIC_ALIEN:
          alienPlasma.stop();
          alienPlasma.play();
          break;
        default:
          alienShoot.stop();
          alienShoot.play();
          break;
        }
        bulletFired = true;
        bulletPosition[0] = alienPosition[0] + (alienImage.width / 2) - (bulletImage.width / 2);
        bulletPosition[1] = alienPosition[1] + bulletImage.height;
      }
    }
  }

  // Moves the aliens bullet across the screen
  void animateBullet() {
    if (bulletFired == true) {
      image(bulletImage, bulletPosition[0], bulletPosition[1]);
      bulletPosition[1] += bulletFireSpeed;
      if (bulletPosition[1] > displayHeight + 100) {
        bulletFired = false;
      }
    }
  }

  // Explodes the alien and removes it from the screen
  void explodeAlien(Player player, HUD_Container userHUD) {
    if ((alienExploding == true) && (alienExplodeTimer <= 30)) {
      if (playAlienExplode == true) {
        playAlienExplode = false;
        alienExplode.play();
      }
      alienImage = affraicCustard;
      alienExplodeTimer++;
    } else if ((alienExploding == true) && (alienExplodeTimer > 30)) {
      alienDead = true;
      alienExploding = false;
      alienImage = affraicBlank;
      player.autoIncrementScore(MEDIUM_POINTS, userHUD, (int) alienPosition[0], (int) alienPosition[1]);
    }
  }

  // alien flashes red when hit
  void alienHitAnimation(Player player, HUD_Container userHUD) {
    if (((alienType == AFFRAIC_TOUGH) || (alienType == AFFRAIC_RAINBOW) || (alienType == AFFRAIC_ROBOT) || (alienType == AFFRAIC_ALIEN)) 
      && (playHitAnimation == true)) {
      if ((alienExploding == false) && (alienDead == false)) {
        image(hitImage, alienPosition[0], alienPosition[1]);
      }
      alienHitCounter++;
      if (alienHitCounter == 10) {
        playHitAnimation = false;
        player.autoIncrementScore(LOW_POINTS, userHUD, (int) alienPosition[0], (int) alienPosition[1]);
        alienHitCounter = 0;
      }
    }
  }

  // Checks whether or not the alien has been hit by a players bullet.
  void isAlienHit(float[][] bulletPosition, Player player) {
    if (alienDead == false) {
      // normal bullet
      for (int i = 0; i < bulletPosition.length; i++) {
        // Checking bullet is within Y domain of alien
        if ((bulletPosition[i][1] < alienPosition[1] + alienImage.height) && (bulletPosition[i][1] + bulletNormal.height > alienPosition[1])) {
          // Checking bullet is within X domain of alien
          if ((bulletPosition[i][0] + bulletNormal.width > alienPosition[0]) && (bulletPosition[i][0] < alienPosition[0] + alienImage.width)) {
            if (alienExploding == false) {
              switch (alienType) {
              case AFFRAIC_TOUGH:
                toughHit.stop();
                toughHit.play();
                alienHealth--;
                playHitAnimation = true;
                break;
              case AFFRAIC_RAINBOW:
                rainbowHit.stop();
                rainbowHit.play();
                alienHealth--;
                playHitAnimation = true;
                break;
              case AFFRAIC_ROBOT:
                robotHit.stop();
                robotHit.play();
                alienHealth--;
                playHitAnimation = true;
                break;
              case AFFRAIC_ALIEN:
                alienHit.stop();
                alienHit.play();
                alienHealth--;
                playHitAnimation = true;
                break;
              default:
                alienExploding = true;
                break;
              }
            }
            player.forceDespawnBullet(i);
          }
        }
      }
      // cannonball bullet
      if (player.isCannonBallFired == true) {
        // Checking bullet is within Y domain of alien
        if ((player.cannonBallPosition[1] < alienPosition[1] + alienImage.height) && (player.cannonBallPosition[1] + bulletCannonBall.height > alienPosition[1])) {
          // Checking bullet is within X domain of alien
          if ((player.cannonBallPosition[0] + bulletNormal.width > alienPosition[0]) && (player.cannonBallPosition[0] < alienPosition[0] + alienImage.width)) {
            alienHealth--;
            playHitAnimation = true;
          }
        }
      }
      // Checking Rainbow bullet
      if (player.isRainbowFired == true) {
        // Checking bullet is within Y domain of alien
        if ((player.rainbowPosition[1] < alienPosition[1] + alienImage.height) && (player.rainbowPosition[1] + bulletPlayerRainbow.height > alienPosition[1])) {
          // Checking bullet is within X domain of alien
          if ((player.rainbowPosition[0] + bulletPlayerRainbow.width > alienPosition[0]) && (player.rainbowPosition[0] < alienPosition[0] + alienImage.width)) {
            alienHealth--;
            playHitAnimation = true;
          }
        }
      }
      // Checking Laser
      if (player.isLaserFired == true) {
        // Checking bullet is within Y domain of alien
        if ((player.laserPosition[1] < alienPosition[1] + alienImage.height) && (player.laserPosition[1] + bulletPlayerLaser.height > alienPosition[1])) {
          // Checking bullet is within X domain of alien
          if ((player.laserPosition[0] + bulletPlayerLaser.width > alienPosition[0]) && (player.laserPosition[0] < alienPosition[0] + alienImage.width)) {
            alienHealth = 0;
            playHitAnimation = true;
            isHitByLaser = true;
          }
        }
      }
      // Checking secondary laser
      if (player.displaySecondaryLaser == true) {
        // Checking bullet is within Y domain of alien
        if ((player.secondaryLaserPosition[1] < alienPosition[1] + alienImage.height) && (player.secondaryLaserPosition[1] + 
          bulletPlayerSecondaryLaser.height > alienPosition[1])) {
          // Checking bullet is within X domain of alien
          if ((player.secondaryLaserPosition[0] + bulletPlayerSecondaryLaser.width > alienPosition[0]) && (player.secondaryLaserPosition[0] < alienPosition[0] 
            + alienImage.width)) {
            alienHealth = 0;
            playHitAnimation = true;
          }
        }
      }
      // Checking Plasma bullet
      if (player.isPlasmaFired == true) {
        // Checking bullet is within Y domain of alien
        if ((player.plasmaPosition[1] < alienPosition[1] + alienImage.height) && (player.plasmaPosition[1] + bulletPlasma.height > alienPosition[1])) {
          // Checking bullet is within X domain of alien
          if ((player.plasmaPosition[0] + bulletPlasma.width > alienPosition[0]) && (player.plasmaPosition[0] < alienPosition[0] + alienImage.width)) {
            alienHealth = 0;
            isHitByPlasma = true;
            playHitAnimation = true;
            player.despawnPlasma();
          }
        }
      }
      // If alien Health = 0
      if ((alienExploding == false) && (alienHealth == 0)) {
        alienExploding = true;
        playHitAnimation = false;
      }
    }
  }

  // Set alien Position
  float[] setAlienSpawn(float[] alienPosition, float xPosition, float yPosition) {
    alienPosition[0] = xPosition;
    alienPosition[1] = yPosition;
    return alienPosition;
  }

  // Increments the position of the alien on the screen
  float[] incrementAlienPosition(float xIncrement, float yIncrement) {
    alienPosition[0] = alienPosition[0] + xIncrement;
    alienPosition[1] = alienPosition[1] + yIncrement;
    return alienPosition;
  }

  // Sets the image being used to display the alien
  PImage setAlienImage(int alienType) {
    PImage alienImage;
    switch (alienType) {
    case AFFRAIC_TOUGH:
      alienImage = affraicTough;
      break;
    case AFFRAIC_PIRATE:
      alienImage = affraicPirate;
      break;
    case AFFRAIC_RAINBOW:
      alienImage = affraicRainbow;
      break;
    case AFFRAIC_ROBOT:
      alienImage = affraicRobot;
      break;
    case AFFRAIC_ALIEN:
      alienImage = affraicAlien;
      break;
    default:
      alienImage = affraicNormal;
      break;
    }
    return alienImage;
  }

  int setAlienHealth(int alienType) {
    int alienHealth;
    if ((alienType == AFFRAIC_RAINBOW) || (alienType == AFFRAIC_ROBOT) || (alienType == AFFRAIC_TOUGH)) {
      alienHealth = 2;
    } else if (alienType == AFFRAIC_ALIEN) {
      alienHealth = 3;
    } else if (alienType == AFFRAIC_QUEEN) {
      alienHealth = 8;
    } else {
      alienHealth = 1;
    }

    return alienHealth;
  }

  PImage setAlienHitImage(int alienType) {
    PImage hitImage;
    switch (alienType) {
    case AFFRAIC_TOUGH:
      hitImage = affraicToughHit;
      break;
    case AFFRAIC_RAINBOW:
      hitImage = affraicRainbowHit;
      break;
    case AFFRAIC_ALIEN:
      hitImage = affraicAlienHit;
      break;
    case AFFRAIC_ROBOT:
      hitImage = affraicRobotHit;
      break;
    default:
      hitImage = alienImage;
      break;
    }
    return hitImage;
  }

  PImage setAlienBulletImage(int alienType) {
    PImage bulletImage;
    switch (alienType) {
    case AFFRAIC_PIRATE:
      bulletImage = bulletCannonBall;
      break;
    case AFFRAIC_RAINBOW:
      bulletImage = bulletRainbow;
      break;
    case AFFRAIC_ROBOT:
      bulletImage = bulletLaser;
      break;
    case AFFRAIC_ALIEN:
      bulletImage = bulletPlasma;
      break;
    default:
      bulletImage = bulletRed;
      break;
    }
    return bulletImage;
  }
}
