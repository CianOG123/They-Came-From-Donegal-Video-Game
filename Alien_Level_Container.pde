class Alien_Level_Container {

  // Level Specific Variables
  int levelNumber;
  float index = -(levelOneMap.height - displayHeight);
  boolean playerLose = false;
  boolean playerWin = false;
  boolean displayStats = false;
  boolean hideCursor = false;
  int timeBeforeGameplay = 0;
  int gamePlayTime = 0;
  boolean timeBeforeGamePlayStored = false;
  boolean gamePlayStored = false;

  // Objects
  Player player;
  Mob_Handler levelMob;
  HUD_Container userHUD;
  Intro_Animation levelIntroAnim;
  Win_Animation levelWinAnim;
  Menu_Screen_Stats statsScreen;

  // Music handlers
  SoundFile levelMusic;
  boolean menuMusicStopped = false;
  boolean levelMusicPlaying = false;

  Alien_Level_Container (int levelNumber, SoundFile levelMusic) {
    this.levelNumber = levelNumber;
    this.levelMusic = levelMusic;
    levelMob = new Mob_Handler(levelNumber);
    userHUD = new HUD_Container(levelNumber);
    levelIntroAnim = new Intro_Animation(levelMob, levelNumber);
    levelWinAnim = new Win_Animation();
    player = new Player(levelIntroAnim, levelMob);
    statsScreen = new Menu_Screen_Stats(levelNumber);
  }

  void draw() {
    stopMenuMusic();
    hideCursor();
    image(levelOneMap, 0, (int) index);
    introHandler();
    drawGamePlay();
    playerLoseHandler();
    playerWinHandler(levelWinAnim);
    statsHandler();
  }
  
  // Hides the cursor
  void hideCursor(){
    if(hideCursor == false){
      hideCursor = true;
      noCursor();
    }
  }

  // Play level music
  void playLevelMusic() {
    if (levelMusicPlaying == false) {
      stopAllSFX();
      levelMusicPlaying = true;
      levelMusic.play();
    }
  }

  // Stops the main menu music
  void stopMenuMusic() {
    if (menuMusicStopped == false) {
      musicMainMenu.stop();
      menuMusicStopped = true;
    }
  }

  // Scrolls the map
  void scrollMap() {
    if ((index < 0) && (playerLose == false) && (playerWin == false)) {
      index += 0.5;
    }
  }

  // Draws the stats screen
  void statsHandler() {
    if ((displayStats == false) && (playerWin == true)) {
      displayStats = levelWinAnim.isAnimationOver();
    }
    if (displayStats == true) {
      statsScreen.draw();
    }
  }

  // draws the intro to the screen
  void introHandler() {
    if (levelIntroAnim.getIntroAnimOver() == false) {
      player.draw(userHUD);
      levelIntroAnim.draw();
    }
  }

  // Draws the gameplay part of the level to the screen
  void drawGamePlay() {
    if ((levelIntroAnim.getIntroAnimOver() == true) && (playerWin == false)) {
      setTimeBeforeGamePlay();
      playLevelMusic();
      scrollMap();
      player.draw(userHUD);
      levelMob.draw(player.getBulletPosition(), player, userHUD, playerLose);
      userHUD.draw(player);
    }
  }

  // Checks to see if the player has won and takes subsequent actions
  void playerWinHandler(Win_Animation winAnimation) {
    if (levelMob.areAllAliensDead() == true) {
      setTimeAfterGameplay();
      player.draw(userHUD);
      playerWin = true;
      winAnimation.playAnimation();
    }
    levelWinAnim.draw();
  }

  // Checks to see if the player has lost in any class and tells the other classes if it has
  void playerLoseHandler() {
    if (playerLose == false) {
      playerLose = player.getPlayerLose();
    }
    if (playerLose == false) {
      playerLose = levelMob.getPlayerLose();
    }
    if (playerLose == true) {
      playerWin = false;
      player.draw(userHUD);
      player.setPlayerLose();
      levelMob.setPlayerLose();
    }
  }
  
  // stores the amount of frames elapsed before gameplay
  void setTimeBeforeGamePlay(){
    if(timeBeforeGamePlayStored == false){
      timeBeforeGamePlayStored = true;
      timeBeforeGameplay = frameCount;
    }
  }
  
  // Stores the amount of frames elapsed after gameplay
  void setTimeAfterGameplay(){
    if(gamePlayStored == false){
      gamePlayStored = true;
      gamePlayTime = frameCount - timeBeforeGameplay;
    }
  }
  
  // Returns the amount of frames elapsed during gameplay
  int getGamePlayTime(){
    return gamePlayTime;
  }
}
