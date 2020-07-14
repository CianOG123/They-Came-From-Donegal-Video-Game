class Win_Animation {

  // Pixel Constants
  final float MOUTH_OPEN_OFFSET = displayHeight * -0.037037;      // -40px
  final float AFFRAIC_SHIP_Y_POSITION = displayHeight * -0.259;   // -280px

  // Arrays
  float[] shipPosition = new float[2];

  // Variables
  float mouthYOffset = MOUTH_OPEN_OFFSET;

  // Counters
  int animFlameCounter = 0;
  int animPauseShip = 0;

  // Animation Booleans
  boolean playAnimation = false;
  boolean isAnimOver = false;
  boolean displayFlames = false;
  boolean openMouth = false;
  boolean isMouthOpen = false;
  boolean removeShip = false;
  boolean isShipDown = false;
  boolean isShipPaused = false;
  boolean pauseShip = false;
  
  // SFX
  boolean playPlayerWin = true;
  boolean playShipTalk = true;

  Win_Animation() {
    playPlayerWin = true;
    shipPosition[0] = (displayWidth / 2) - (affraicShipBase.width / 2);
    shipPosition[1] =  -1 * (affraicShipBase.height + 100);
  }

  void draw() {
    if (playAnimation == true) {
      if(playPlayerWin == true){
        playPlayerWin = false;
        playerWin.stop();
        playerWin.play();
      }
      drawShip();
      openMouth = moveShipDown(openMouth);
      pauseShip = openShipMouth(pauseShip);
      removeShip = pauseAnimation(removeShip, textBoxWinLevelOne);
      isAnimOver = removeShip(isAnimOver);
      if (isAnimOver == true) {
        playAnimation = false;
      }
    }
  }

  // Draws the ship to the screen
  void drawShip() {
    image(affraicShipBase, shipPosition[0], shipPosition[1]);
    image(affraicShipEyes, shipPosition[0], shipPosition[1]);
    image(affraicShipMouth, shipPosition[0], shipPosition[1] + mouthYOffset);
    shipFlameAnimator();
  }

  // Moves the ship down onto the screen
  boolean moveShipDown(boolean nextAnim) {
    if (nextAnim == true) {
      return nextAnim;
    } else {
      if (isShipDown == false) {
        if(shipMove.isPlaying() == false){
          shipMove.stop();
          shipMove.play();
        }
        shipPosition[1] += 2;
        if (shipPosition[1] >= AFFRAIC_SHIP_Y_POSITION) {
          shipMove.stop();
          isShipDown = true;
          nextAnim = true;
        }
      }
      return nextAnim;
    }
  }

  // Opens the ship mouth
  boolean openShipMouth(boolean nextAnim) {
    if (nextAnim == true) {
      return nextAnim;
    } else {
      if (openMouth == true) {
        if(mouthOpen.isPlaying() == true){
          mouthOpen.stop();
          mouthOpen.play();
        }
        mouthYOffset++;
        if (mouthYOffset >= 0) {
          mouthOpen.stop();
          openMouth = true;
          nextAnim = true;
        }
      }
      return nextAnim;
    }
  }

  // Causes a pause in animation for dramatic effect
  boolean pauseAnimation(boolean nextAnim, PImage textBox) {
    if (nextAnim == true) {
      return nextAnim;
    } else {
      if (pauseShip == true) {
        if(playShipTalk == true){
          playShipTalk = false;
          shipTalk.stop();
          shipTalk.play();
        }
        animPauseShip++;
        image(textBox, (displayWidth / 2) + 100, 200);
        if (animPauseShip == 120) {
          pauseShip = false;
          nextAnim = true;
        }
      }
      return nextAnim;
    }
  }

  // Moves the ship of the screen
  boolean removeShip(boolean nextAnim) {
    if (nextAnim == true) {
      return nextAnim;
    } else {
      if (removeShip == true) {
        if(shipMove.isPlaying() == false){
          shipMove.stop();
          shipMove.play();
        }
        if (mouthYOffset > MOUTH_OPEN_OFFSET) {
          mouthYOffset -= 2;
        }
        shipPosition[1] -= 4;
        if (shipPosition[1] <= - (affraicShipBase.height + 200)) {
          shipMove.stop();
          nextAnim = true;
        }
      }
      return nextAnim;
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

  void playAnimation() {
    playAnimation = true;
  }
  
  boolean isAnimationOver(){
    return isAnimOver;
  }
}
