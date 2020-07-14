class Menu_Screen_Main {

  // Useful Settings
  static final int AMOUNT_OF_STARS = 40;

  // Local constants
  static final int BACKGROUND_SPAWN = 0;
  final float OPTIONS_BUTTON_WIDTH = displayWidth * 0.09479;          // 182px
  final float OPTIONS_BUTTON_HEIGHT = displayHeight * 0.06299;        // 62px
  final float OPTIONS_BUTTON_VOLUME_WIDTH = displayWidth * 0.0177083; // 34px
  final float OPTIONS_BUTTON_VOLUME_HEIGHT = displayHeight * 0.0629;  // 68px


  // Image Position Spawn Constants And Variables
  final float GAME_LOGO_SPAWN_X = displayWidth * 0.1354;
  final float GAME_LOGO_SPAWN_Y = displayHeight * 0.0556;
  final float MENU_EARTH_SPAWN_X = displayWidth * 0.6875;
  final float MENU_EARTH_SPAWN_Y = displayHeight * 0.6111;
  final float MENU_BUTTON_EXIT_Y = displayHeight * 0.7778;      // 840px
  final float MENU_BUTTON_OPTIONS_Y = displayHeight * 0.6574;   // 710px
  final float MENU_BUTTON_PLAY_Y = displayHeight * 0.537;       // 580px
  final float MENU_BUTTON_BLANK_X = (displayWidth / 2) - (menuButtonBlank.width / 2); 

  // options Panel
  final float OPTIONS_PANEL_X = (displayWidth / 2) - (menuButtonBlank.width / 2); 
  final float OPTIONS_PANEL_Y = displayHeight * 0.4907;           // 530px
  final float OPTIONS_DIFFICULTY_Y = displayHeight * 0.5222;      // 564px
  final float OPTIONS_EASY_X = displayWidth * 0.35;               // 672px
  final float OPTIONS_MEDIUM_X = displayWidth * 0.452083;         // 868px
  final float OPTIONS_HARD_X = displayWidth * 0.5552;             // 1066px
  final float OPTIONS_ENABLE_Y = displayHeight * 0.8305;          // 897px
  final float OPTIONS_NO_X = displayWidth * 0.37552;              // 721px
  final float OPTIONS_YES_X = displayWidth * 0.53177;             // 1021px
  final float OPTIONS_RETURN_Y = displayHeight * 0.904629 ;       // 977px
  final float OPTIONS_RETURN_X = displayWidth * 0.4563125;        // 870px
  final float OPTIONS_MUSIC_Y = displayHeight * 0.6259;           // 676px
  final float OPTIONS_SFX_Y = displayHeight * 0.726851;           // 785px
  final float OPTIONS_VOLUME_MINUS_X = displayWidth * 0.434375;   // 834px
  final float OPTIONS_VOLUME_PLUS_X = displayWidth * 0.55052083;  // 1057px
  final float OPTIONS_TEXT_X = (displayWidth / 2) ;               // 960px
  final float OPTIONS_VOLUME_TEXT_Y = displayHeight * 0.6574;     // 710px
  final float OPTIONS_SFX_TEXT_Y = displayHeight * 0.759259;      // 820px


  // Buttons
  Button buttonPlay;
  Button buttonOptions;
  Button buttonExit;
  Button buttonEasy;
  Button buttonMedium;
  Button buttonHard;
  Button buttonMusicPlus;
  Button buttonMusicMinus;
  Button buttonSFXPlus;
  Button buttonSFXMinus;
  Button buttonNo;
  Button buttonYes;
  Button buttonReturn;

  // Colors
  static final color SPACE_BACKGROUND_COLOR = #202035;
  static final color ORANGE_TEXT_COLOR = #FB8A00;

  // Local Variables
  int screenWidth;
  int screenHeight;

  // Animation Variables and constants
  static final int GAME_LOGO_SPEED = 30;
  static final int GAME_LOGO_DISTANCE = 30;
  static final int CLOUD_SPEED = 240;
  static final int CLOUD_DISTANCE = 15;
  float gameLogoAnimOffset = 0;
  float cloudAnimOffset = 0;

  // Arrays
  int[][] starSpawnPosition = new int[AMOUNT_OF_STARS][2];

  // Booleans
  boolean displayMainButtons = true;
  boolean displayOptionsScreen = false;
  boolean mouseDisplayed = false;


  Menu_Screen_Main() {
    setStarSpawnPosition();
    musicMainMenu.loop();
    musicMainMenu.amp(musicVolume);
    buttonPlay = new Button(MENU_BUTTON_BLANK_X, MENU_BUTTON_PLAY_Y, menuButtonHover.width, menuButtonHover.height, MENU_BUTTON_PLAY_EVENT, menuButtonHover);
    buttonOptions = new Button(MENU_BUTTON_BLANK_X, MENU_BUTTON_OPTIONS_Y, menuButtonHover.width, menuButtonHover.height, MENU_BUTTON_OPTIONS_EVENT, menuButtonHover);
    buttonExit = new Button(MENU_BUTTON_BLANK_X, MENU_BUTTON_EXIT_Y, menuButtonHover.width, menuButtonHover.height, MENU_BUTTON_EXIT_EVENT, menuButtonHover);
    buttonEasy = new Button(OPTIONS_EASY_X, OPTIONS_DIFFICULTY_Y, OPTIONS_PANEL_X, OPTIONS_PANEL_Y, OPTIONS_BUTTON_WIDTH, OPTIONS_BUTTON_HEIGHT, OPTIONS_BUTTON_EASY_EVENT, optionsEasyHover);
    buttonMedium = new Button(OPTIONS_MEDIUM_X, OPTIONS_DIFFICULTY_Y, OPTIONS_PANEL_X, OPTIONS_PANEL_Y, OPTIONS_BUTTON_WIDTH, OPTIONS_BUTTON_HEIGHT, OPTIONS_BUTTON_MEDIUM_EVENT, optionsMediumHover);
    buttonHard = new Button(OPTIONS_HARD_X, OPTIONS_DIFFICULTY_Y, OPTIONS_PANEL_X, OPTIONS_PANEL_Y, OPTIONS_BUTTON_WIDTH, OPTIONS_BUTTON_HEIGHT, OPTIONS_BUTTON_HARD_EVENT, optionsHardHover);
    buttonNo = new Button(OPTIONS_NO_X, OPTIONS_ENABLE_Y, OPTIONS_PANEL_X, OPTIONS_PANEL_Y, OPTIONS_BUTTON_WIDTH, OPTIONS_BUTTON_HEIGHT, OPTIONS_BUTTON_NO_EVENT, optionsNoHover);
    buttonYes = new Button(OPTIONS_YES_X, OPTIONS_ENABLE_Y, OPTIONS_PANEL_X, OPTIONS_PANEL_Y, OPTIONS_BUTTON_WIDTH, OPTIONS_BUTTON_HEIGHT, OPTIONS_BUTTON_YES_EVENT, optionsYesHover);
    buttonReturn = new Button(OPTIONS_RETURN_X, OPTIONS_RETURN_Y, OPTIONS_PANEL_X, OPTIONS_PANEL_Y, OPTIONS_BUTTON_WIDTH, OPTIONS_BUTTON_HEIGHT, OPTIONS_BUTTON_RETURN_EVENT, optionsReturnHover);
    buttonMusicMinus = new Button(OPTIONS_VOLUME_MINUS_X, OPTIONS_MUSIC_Y, OPTIONS_PANEL_X, OPTIONS_PANEL_Y, OPTIONS_BUTTON_VOLUME_WIDTH, OPTIONS_BUTTON_VOLUME_HEIGHT, OPTIONS_BUTTON_MUSIC_MINUS_EVENT, optionsMusicMinusHover);
    buttonMusicPlus = new Button(OPTIONS_VOLUME_PLUS_X, OPTIONS_MUSIC_Y, OPTIONS_PANEL_X, OPTIONS_PANEL_Y, OPTIONS_BUTTON_VOLUME_WIDTH, OPTIONS_BUTTON_VOLUME_HEIGHT, OPTIONS_BUTTON_MUSIC_PLUS_EVENT, optionsMusicPlusHover);
    buttonSFXMinus = new Button(OPTIONS_VOLUME_MINUS_X, OPTIONS_SFX_Y, OPTIONS_PANEL_X, OPTIONS_PANEL_Y, OPTIONS_BUTTON_VOLUME_WIDTH, OPTIONS_BUTTON_VOLUME_HEIGHT, OPTIONS_BUTTON_SFX_MINUS_EVENT, optionsSFXMinusHover);
    buttonSFXPlus = new Button(OPTIONS_VOLUME_PLUS_X, OPTIONS_SFX_Y, OPTIONS_PANEL_X, OPTIONS_PANEL_Y, OPTIONS_BUTTON_VOLUME_WIDTH, OPTIONS_BUTTON_VOLUME_HEIGHT, OPTIONS_BUTTON_SFX_PLUS_EVENT, optionsSFXPlusHover);
  }

  void draw() {
    musicMainMenu.amp(musicVolume);
    fill(SPACE_BACKGROUND_COLOR);
    rect(0, 0, displayWidth, displayHeight);

    // Drawing Stars
    drawStars();

    // Drawing the game logo
    gameLogoAnimOffset = sinAnimator(gameLogoAnimOffset, GAME_LOGO_SPEED, GAME_LOGO_DISTANCE);
    image(gameLogo, GAME_LOGO_SPAWN_X, GAME_LOGO_SPAWN_Y + gameLogoAnimOffset);

    // Drawing earth
    cloudAnimOffset = sinAnimator(cloudAnimOffset, CLOUD_SPEED, CLOUD_DISTANCE);
    image(menuEarth, MENU_EARTH_SPAWN_X, MENU_EARTH_SPAWN_Y);
    image(menuClouds, MENU_EARTH_SPAWN_X + cloudAnimOffset + 100, MENU_EARTH_SPAWN_Y);

    // Drawing Buttons
    if (displayMainButtons == true) {
      image(menuButtonBlank, MENU_BUTTON_BLANK_X, MENU_BUTTON_EXIT_Y);
      buttonExit.draw();
      image(menuButtonExit, MENU_BUTTON_BLANK_X, MENU_BUTTON_EXIT_Y);
      image(menuButtonBlank, MENU_BUTTON_BLANK_X, MENU_BUTTON_OPTIONS_Y);
      buttonOptions.draw();
      image(menuButtonOptions, MENU_BUTTON_BLANK_X, MENU_BUTTON_OPTIONS_Y);
      image(menuButtonBlank, MENU_BUTTON_BLANK_X, MENU_BUTTON_PLAY_Y);
      buttonPlay.draw();
      image(menuButtonPlay, MENU_BUTTON_BLANK_X, MENU_BUTTON_PLAY_Y);
    }

    // Drawing option screen
    if (displayOptionsScreen == true) {
      image(menuOptionsPanel, OPTIONS_PANEL_X, OPTIONS_PANEL_Y);
      buttonEasy.draw();
      buttonMedium.draw();
      buttonHard.draw();
      buttonNo.draw();
      buttonYes.draw();
      buttonReturn.draw();
      buttonMusicMinus.draw();
      buttonMusicPlus.draw();
      buttonSFXMinus.draw();
      buttonSFXPlus.draw();
      textFont(optionsPanelFont);
      fill(ORANGE_TEXT_COLOR);
      textAlign(CENTER, CENTER);
      text(((int) (musicVolume * 100)) + "%", OPTIONS_TEXT_X, OPTIONS_VOLUME_TEXT_Y);
      text(((int) (soundEffectVolume * 100)) + "%", OPTIONS_TEXT_X, OPTIONS_SFX_TEXT_Y);

      // Drawing set settings
      // Difficulty
      if (difficultyLevel == EASY) {
        image(optionsEasyPressed, OPTIONS_PANEL_X, OPTIONS_PANEL_Y);
      } else if (difficultyLevel == MEDIUM) {
        image(optionsMediumPressed, OPTIONS_PANEL_X, OPTIONS_PANEL_Y);
      } else if (difficultyLevel == HARD) {
        image(optionsHardPressed, OPTIONS_PANEL_X, OPTIONS_PANEL_Y);
      }
      // Enable Super Affraics?
      if (enableSuperAffraics == false) {
        image(optionsNoPressed, OPTIONS_PANEL_X, OPTIONS_PANEL_Y);
      } else if (enableSuperAffraics == true) {
        image(optionsYesPressed, OPTIONS_PANEL_X, OPTIONS_PANEL_Y);
      }
    }

    displayMouse();
  }

  // Displays the mouse
  void displayMouse() {
    image(mouseCursor, mouseX, mouseY);
    noCursor();
  }


  // Randomly sets the x and y spawn position of each star
  void setStarSpawnPosition() {
    for (int j = 0; j < starSpawnPosition[0].length; j++) {
      for (int i = 0; i < starSpawnPosition.length; i++) {
        if (j < 1) {
          starSpawnPosition[i][j] = (int) random(1, displayWidth);
        } else {
          starSpawnPosition[i][j] = (int) random(1, displayHeight);
        }
      }
    }
  }


  // Draws the stars onto the screen
  void drawStars() {
    for (int i = 0; i < starSpawnPosition.length; i++) {
      image(menuStar, starSpawnPosition[i][0], starSpawnPosition[i][1]);
    }
  }


  // Animates the logo on the menu screen
  float sinAnimator(float animVariable, int speed, int distance) {
    float hoverSpeed = ((float) frameCount) / speed;
    animVariable = distance * sin(hoverSpeed);
    return animVariable;
  }


  // Animates the clouds above earth
  float cloudAnimator(float animVariable) {
    float hoverSpeed = ((float) frameCount) / 240;
    animVariable = 15 * sin(hoverSpeed);
    return animVariable;
  }


  // Actions taken when mouse is pressed
  void mousePressed() {
    // Main Menu Screen
    if (displayMainButtons == true) {
      // Actions taken when play button is pressed
      if (buttonPlay.getEvent(mouseX, mouseY) == MENU_BUTTON_PLAY_EVENT) {
        buttonPress.stop();
        buttonPress.play();
        eventLogger.displayMainMenu = false;
        eventLogger.displayLevelOne = true;
      }
      // Actions taken when options button is pressed
      else if (buttonOptions.getEvent(mouseX, mouseY) == MENU_BUTTON_OPTIONS_EVENT) {
        buttonPress.stop();
        buttonPress.play();
        displayOptionsScreen = true;
        displayMainButtons = false;
      }
      // Actions taken when exit button is pressed
      else if (buttonExit.getEvent(mouseX, mouseY) == MENU_BUTTON_EXIT_EVENT) {
        buttonPress.stop();
        buttonPress.play();
        exit();
      }
    }

    // Options Panel
    if (displayOptionsScreen == true) {
      // Difficulty
      if (buttonEasy.getEvent(mouseX, mouseY) == OPTIONS_BUTTON_EASY_EVENT) {
        buttonPress.stop();
        buttonPress.play();
        difficultyLevel = EASY;
        eventLogger.difficultySettings();
      } else if (buttonMedium.getEvent(mouseX, mouseY) == OPTIONS_BUTTON_MEDIUM_EVENT) {
        buttonPress.stop();
        buttonPress.play();
        difficultyLevel = MEDIUM;
        eventLogger.difficultySettings();
      } else if (buttonHard.getEvent(mouseX, mouseY) == OPTIONS_BUTTON_HARD_EVENT) {
        buttonPress.stop();
        buttonPress.play();
        difficultyLevel = HARD;
        eventLogger.difficultySettings();
      }
      // Music
      if (buttonMusicMinus.getEvent(mouseX, mouseY) == OPTIONS_BUTTON_MUSIC_MINUS_EVENT) {
        buttonPress.stop();
        buttonPress.play();
        image(optionsMusicMinusPressed, OPTIONS_PANEL_X, OPTIONS_PANEL_Y);
        if (musicVolume > 0) {
          musicVolume = musicVolume - 0.05;
        }
      } else if (buttonMusicPlus.getEvent(mouseX, mouseY) == OPTIONS_BUTTON_MUSIC_PLUS_EVENT) {
        buttonPress.stop();
        buttonPress.play();
        image(optionsMusicPlusPressed, OPTIONS_PANEL_X, OPTIONS_PANEL_Y);
        if (musicVolume < 1) {
          musicVolume = musicVolume + 0.05;
        }
      }
      // SFX
      if (buttonSFXMinus.getEvent(mouseX, mouseY) == OPTIONS_BUTTON_SFX_MINUS_EVENT) {
        buttonPress.stop();
        buttonPress.play();
        image(optionsSFXMinusPressed, OPTIONS_PANEL_X, OPTIONS_PANEL_Y);
        if (soundEffectVolume > 0) {
          soundEffectVolume = soundEffectVolume - 0.05;
        }
      } else if (buttonSFXPlus.getEvent(mouseX, mouseY) == OPTIONS_BUTTON_SFX_PLUS_EVENT) {
        buttonPress.stop();
        buttonPress.play();
        image(optionsSFXPlusPressed, OPTIONS_PANEL_X, OPTIONS_PANEL_Y);
        if (soundEffectVolume < 1) {
          soundEffectVolume = soundEffectVolume + 0.05;
        }
      }
      // Super Affraics Enabled?
      if (buttonNo.getEvent(mouseX, mouseY) == OPTIONS_BUTTON_NO_EVENT) {
        buttonPress.stop();
        buttonPress.play();
        enableSuperAffraics = false;
        updateSuperAffraics();
      } else if (buttonYes.getEvent(mouseX, mouseY) == OPTIONS_BUTTON_YES_EVENT) {
        buttonPress.play();
        enableSuperAffraics = true;
        updateSuperAffraics();
      }
      // Return
      if (buttonReturn.getEvent(mouseX, mouseY) == OPTIONS_BUTTON_RETURN_EVENT) {
        buttonPress.stop();
        buttonPress.play();
        displayOptionsScreen = false;
        displayMainButtons = true;
      }
    }
  }

  // Used for enabling and disabling super Affraics
  void updateSuperAffraics() {
    eventLogger.levelOne.levelMob.alienArrayFill();
    eventLogger.levelTwo.levelMob.alienArrayFill();
    eventLogger.levelThree.levelMob.alienArrayFill();
    eventLogger.levelFour.levelMob.alienArrayFill();
    eventLogger.levelFive.levelMob.alienArrayFill();
  }
}
