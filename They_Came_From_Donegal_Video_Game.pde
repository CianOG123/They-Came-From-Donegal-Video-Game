/*
/ Main is responsible for loading in all asset and libraries, declaring, and initialising assets.
 */

// Libraries
import processing.sound.*;

// Useful settings
int difficultyLevel = MEDIUM;        // Difficulty Level (EASY, MEDIUM, HARD)
boolean enableSuperAffraics = true;      // Enables super Affraics
float musicVolume = 0.8;                // Volume level of the music on start
float soundEffectVolume = 1;          // Volume level of sound effects on start

// Level Specific Variable Options
// Dificulty
static final int EASY = 1;
static final int MEDIUM = 2;
static final int HARD = 3;
static final int LOW_POINTS = 1;
static final int MEDIUM_POINTS = 2;
static final int HIGH_POINTS = 3;
// Affraic types
static final int AFFRAIC_NORMAL = 0;
static final int AFFRAIC_PIRATE = 1;
static final int AFFRAIC_TOUGH = 2;
static final int AFFRAIC_RAINBOW = 3;
static final int AFFRAIC_ROBOT = 4;
static final int AFFRAIC_ALIEN = 5;
static final int AFFRAIC_QUEEN = 6;

// Images and sprites to load
// Main menu related images and sprites
PImage gameLogo;
PImage menuButtonBlank;
PImage menuButtonPlay;
PImage menuButtonOptions;
PImage menuButtonExit;
PImage menuButtonHover;
PImage menuEarth;
PImage menuClouds;
PImage menuStar;
PImage menuOptionsPanel;
PImage mouseCursor;
// Options Panel
PImage optionsEasyHover;
PImage optionsEasyPressed;
PImage optionsMediumHover;
PImage optionsMediumPressed;
PImage optionsHardHover;
PImage optionsHardPressed;
PImage optionsMusicPlusHover;
PImage optionsMusicPlusPressed;
PImage optionsMusicMinusHover;
PImage optionsMusicMinusPressed;
PImage optionsSFXPlusHover;
PImage optionsSFXPlusPressed;
PImage optionsSFXMinusHover;
PImage optionsSFXMinusPressed;
PImage optionsNoHover;
PImage optionsNoPressed;
PImage optionsYesHover;
PImage optionsYesPressed;
PImage optionsReturnHover;

// Affraics
PImage affraicNormal;
PImage affraicPirate;
PImage affraicAlien;
PImage affraicTough;
PImage affraicRobot;
PImage affraicRainbow;
PImage affraicBlank;
PImage affraicCustard;
PImage affraicToughHit;
PImage affraicRainbowHit;
PImage affraicAlienHit;
PImage affraicRobotHit;
// Affraic Ship
PImage affraicShipBase;
PImage affraicShipEyes;
PImage affraicShipMouth;
PImage affraicShipFlames;

// Ships
PImage currentShip;
PImage shipWarhead;
PImage shipWarheadHit;
PImage shipExplode;
PImage shipWarheadInvisible;

// Ammunition and items
PImage bulletNormal;
PImage bulletRed;
PImage bulletCannonBall;
PImage bulletRainbow;
PImage bulletPlasma;
PImage bulletLaser;
PImage bulletPlayerRainbow;
PImage bulletPlayerLaser;
PImage bulletPlayerSecondaryLaser;
PImage ammoDrop;

// Heads-up Display
PImage interfaceHealth;
PImage interfaceScore;
PImage interfaceLevel;
PImage logoStart;
PImage logoYouLose;
PImage highScoresBoard;

// Stats Screen
PImage menuStatsBoard;

// Maps
PImage levelOneMap;

// Text Boxes
PImage textBoxWinLevelOne;

// Fonts
PFont optionsPanelFont;
PFont hudHealthFont;
PFont hudScoreFontLarge;
PFont pressSpaceFont;
PFont statsHeadingFont;
PFont statsBonusFont;
PFont statsNormalFont;

// Music to be loaded
SoundFile musicMainMenu;
SoundFile musicLevelOne;
SoundFile musicSpaceDeGrey;

// Sound Effects
// Main Menu
SoundFile buttonPress;
SoundFile buttonHover;
// Intro Animation
SoundFile shipMove;
SoundFile mouthOpen;
SoundFile shipTalk;
SoundFile alienMove;
SoundFile alienPosition;
SoundFile start;
// Player Lose
SoundFile playerLoseSound;
SoundFile alienDescend;
SoundFile youLose;
// statistics Screen
SoundFile statsScreen;
SoundFile countScore;
SoundFile scoreCounted;
SoundFile pressSpace;
// Gameplay
SoundFile alienCannon;
SoundFile alienExplode;
SoundFile alienHit;
SoundFile alienLaser;
SoundFile alienPlasma;
SoundFile alienRainbow;
SoundFile alienShoot;
SoundFile playerCannon;
SoundFile playerHit;
SoundFile playerLaser;
SoundFile playerPickup;
SoundFile playerPlasma;
SoundFile playerRainbow;
SoundFile playerShoot;
SoundFile queenHit;
SoundFile rainbowHit;
SoundFile robotHit;
SoundFile toughHit;
// Player Win
SoundFile playerWin;

// Button Event Constants
// Main Menu
final int BUTTON_SPAWN_MENU = 1;
final int MENU_BUTTON_PLAY_EVENT = 2;
final int MENU_BUTTON_OPTIONS_EVENT = 3;
final int MENU_BUTTON_EXIT_EVENT = 4;
// Options Panel
final int OPTIONS_BUTTON_EASY_EVENT = 10;
final int OPTIONS_BUTTON_MEDIUM_EVENT = 11;
final int OPTIONS_BUTTON_HARD_EVENT = 12;
final int OPTIONS_BUTTON_MUSIC_PLUS_EVENT = 13;
final int OPTIONS_BUTTON_MUSIC_MINUS_EVENT = 14;
final int OPTIONS_BUTTON_SFX_PLUS_EVENT = 15;
final int OPTIONS_BUTTON_SFX_MINUS_EVENT = 16;
final int OPTIONS_BUTTON_NO_EVENT = 17;
final int OPTIONS_BUTTON_YES_EVENT = 18;
final int OPTIONS_BUTTON_RETURN_EVENT = 19;


// Display variables and constants
float imageResizer;

// Objects Declaration
Event_Logger eventLogger;

// Setup to be run on start up of program
void setup() {
  fullScreen();
  frameRate(60);
  background(100);

  // Initialising music
  musicMainMenu = new SoundFile(this, "musicMainTheme.aiff");
  musicLevelOne = new SoundFile(this, "testTrack.aiff");
  musicSpaceDeGrey = new SoundFile(this, "musicSpaceDeGrey.aiff");

  // initialisng SFX
  buttonPress = new SoundFile(this, "Button_Press.aiff");
  buttonHover = new SoundFile(this, "Button_Hover.aiff");
  alienMove = new SoundFile(this, "Alien_Move.aiff");
  alienPosition = new SoundFile(this, "Alien_Position.aiff");
  mouthOpen = new SoundFile(this, "Mouth_Open.aiff");
  shipMove = new SoundFile(this, "Ship_Move.aiff");
  shipTalk = new SoundFile(this, "Ship_Talk.aiff");
  start = new SoundFile(this, "Start.aiff");
  alienDescend = new SoundFile(this, "Alien_Descend.aiff");
  playerLoseSound = new SoundFile(this, "Player_Lose.aiff");
  youLose = new SoundFile(this, "You_Lose.aiff");
  countScore = new SoundFile(this, "Count_Score.aiff");
  pressSpace = new SoundFile(this, "Press_Space.aiff");
  scoreCounted = new SoundFile(this, "Score_Counted.aiff");
  statsScreen = new SoundFile(this, "Stats_Screen.aiff");
  alienCannon = new SoundFile(this, "Alien_Cannon.aiff");
  alienExplode = new SoundFile(this, "Alien_Explode.aiff");
  alienHit = new SoundFile(this, "Alien_Hit.aiff");
  alienLaser = new SoundFile(this, "Alien_Laser.aiff");
  alienPlasma = new SoundFile(this, "Alien_Plasma.aiff");
  alienRainbow = new SoundFile(this, "Alien_Rainbow.aiff");
  alienShoot = new SoundFile(this, "Alien_Shoot.aiff");
  playerCannon = new SoundFile(this, "Player_Cannon.aiff");
  playerHit = new SoundFile(this, "Player_Hit.aiff");
  playerLaser = new SoundFile(this, "Player_Laser.aiff");
  playerPickup = new SoundFile(this, "Player_Pickup.aiff");
  playerPlasma = new SoundFile(this, "Player_Plasma.aiff");
  playerRainbow = new SoundFile(this, "Player_Rainbow.aiff");
  playerShoot = new SoundFile(this, "Player_Shoot.aiff");
  queenHit = new SoundFile(this, "Queen_Hit.aiff");
  rainbowHit = new SoundFile(this, "Rainbow_Hit.aiff");
  robotHit = new SoundFile(this, "Robot_Hit.aiff");
  toughHit = new SoundFile(this, "Tough_Hit.aiff");
  playerWin = new SoundFile(this, "Player_Win.aiff");


  // Loading Images
  // Main Menu
  gameLogo = loadImage("Game_Logo.png");
  menuButtonBlank = loadImage("Menu_Button_Blank.png");
  menuButtonPlay = loadImage("Menu_Button_Play.png");
  menuButtonOptions = loadImage("Menu_Button_Options.png");
  menuButtonExit = loadImage("Menu_Button_Exit.png");
  menuButtonHover = loadImage("Menu_Button_Hover.png");
  menuEarth = loadImage("Menu_Earth.png");
  menuClouds = loadImage("Menu_Clouds.png");
  menuStar = loadImage("Menu_Star.png");
  mouseCursor = loadImage("Mouse_Cursor.png");
  // Options Panel
  menuOptionsPanel = loadImage("Menu_Options_Panel.png");
  optionsEasyHover = loadImage("Options_Easy_Hover.png");
  optionsEasyPressed = loadImage("Options_Easy_Pressed.png");
  optionsMediumHover = loadImage("Options_Medium_Hover.png");
  optionsMediumPressed = loadImage("Options_Medium_Pressed.png");
  optionsHardHover = loadImage("Options_Hard_Hover.png");
  optionsHardPressed = loadImage("Options_Hard_Pressed.png");
  optionsMusicPlusHover = loadImage("Options_Music_Plus_Hover.png");
  optionsMusicPlusPressed = loadImage("Options_Music_Plus_Pressed.png");
  optionsMusicMinusHover = loadImage("Options_Music_Minus_Hover.png");
  optionsMusicMinusPressed = loadImage("Options_Music_Minus_Pressed.png");
  optionsSFXPlusHover = loadImage("Options_SFX_Plus_Hover.png");
  optionsSFXPlusPressed = loadImage("Options_SFX_Plus_Pressed.png");
  optionsSFXMinusHover = loadImage("Options_SFX_Minus_Hover.png");
  optionsSFXMinusPressed = loadImage("Options_SFX_Minus_Pressed.png");
  optionsNoHover = loadImage("Options_No_Hover.png");
  optionsNoPressed = loadImage("Options_No_Pressed.png");
  optionsYesHover = loadImage("Options_Yes_Hover.png");
  optionsYesPressed = loadImage("Options_Yes_Pressed.png");
  optionsReturnHover = loadImage("Options_Return_Hover.png");
  // Fonts
  optionsPanelFont = loadFont("Digital-7MonoItalic-50.vlw");
  hudHealthFont = loadFont("Digital-7Italic-23.vlw");
  hudScoreFontLarge = loadFont("Digital-7-30.vlw");
  pressSpaceFont = loadFont("Pixeboy-48.vlw");
  statsHeadingFont = loadFont("DisposableDroidBB-120.vlw");
  statsBonusFont = loadFont("ArcadeClassic-90.vlw");
  statsNormalFont = loadFont("DisposableDroidBB-70.vlw");
  // Ships
  shipWarhead = loadImage("Ship_Warhead.png");
  shipWarheadHit = loadImage("Ship_Warhead_Hit.png");
  shipWarheadInvisible = loadImage("Ship_Warhead_Invisible.png");
  shipExplode = loadImage("Ship_Explode.png");
  currentShip = shipWarhead;
  // Ammunition and items
  bulletNormal = loadImage("Bullet_Normal.png");
  bulletRed = loadImage("Bullet_Red.png");
  bulletCannonBall = loadImage("Bullet_CannonBall.png");
  bulletRainbow = loadImage("Bullet_Rainbow.png");
  bulletLaser = loadImage("Bullet_Laser.png");
  bulletPlasma = loadImage("Bullet_Plasma.png");
  bulletPlayerRainbow = loadImage("Bullet_Player_Rainbow.png");
  bulletPlayerLaser = loadImage("Bullet_Player_Laser.png");
  bulletPlayerSecondaryLaser = loadImage("Bullet_Player_Secondary_Laser.png");
  ammoDrop = loadImage("Item_Drop.png");
  // Affraics
  affraicNormal = loadImage("Affraic_Normal.png");
  affraicPirate = loadImage("Affraic_Pirate.png");
  affraicAlien = loadImage("Affraic_Alien.png");
  affraicTough = loadImage("Affraic_Tough.png");
  affraicRobot = loadImage("Affraic_Robot.png");
  affraicRainbow = loadImage("Affraic_Rainbow.png");
  affraicBlank = loadImage("Affraic_Blank.png");
  affraicCustard = loadImage("Affraic_Custard.png");
  affraicToughHit = loadImage("Affraic_Tough_Hit.png");
  affraicRainbowHit = loadImage("Affraic_Rainbow_Hit.png");
  affraicAlienHit = loadImage("Affraic_Alien_Hit.png");
  affraicRobotHit = loadImage("Affraic_Robot_Hit.png");
  // Affraic ship
  affraicShipBase = loadImage("Affraic_Ship_Base.png");
  affraicShipMouth = loadImage("Affraic_Ship_Mouth.png");
  affraicShipEyes = loadImage("Affraic_Ship_Eyes.png");
  affraicShipFlames = loadImage("Affraic_Ship_Flames.png");
  // Head-up Display
  interfaceHealth = loadImage("Interface_Health.png");
  interfaceScore = loadImage("Interface_Score.png");
  interfaceLevel = loadImage("Interface_Level.png");
  logoStart = loadImage("Logo_Start.png");
  logoYouLose = loadImage("You_Lose.png");
  highScoresBoard = loadImage("Score_Board.png");
  // Stats Screen
  menuStatsBoard = loadImage("Menu_Stats_Board.png");
  // Maps
  levelOneMap = loadImage("Map_DublinLiffey_Blur.png");
  // Text boxes
  textBoxWinLevelOne = loadImage("Text_Box_Win_Level_One.png");

  // Scaling size of images to fit screen
  setImageResizeValue();

  // Objects
  eventLogger = new Event_Logger();
}

// Draw loop to be repeatedly run
void draw() {
  eventLogger.draw();
  ampSFX();
}

// Sets value to multiply all images by for setting resolution
void setImageResizeValue() {
  final int DISPLAY_CONTROL_WIDTH = 1920;
  imageResizer = displayWidth / DISPLAY_CONTROL_WIDTH;
}

// Sets the volume of all sound effects
void ampSFX() {
  // Main Menu
  buttonPress.amp(soundEffectVolume);
  buttonHover.amp(soundEffectVolume);
  // Intro Animation
  shipMove.amp(soundEffectVolume);
  mouthOpen.amp(soundEffectVolume);
  shipTalk.amp(soundEffectVolume);
  alienMove.amp(soundEffectVolume);
  alienPosition.amp(soundEffectVolume);
  start.amp(soundEffectVolume);
  // Player Lose
  playerLoseSound.amp(soundEffectVolume);
  alienDescend.amp(soundEffectVolume);
  youLose.amp(soundEffectVolume);
  // statistics Screen
  statsScreen.amp(soundEffectVolume);
  countScore.amp(soundEffectVolume);
  scoreCounted.amp(soundEffectVolume);
  pressSpace.amp(soundEffectVolume);
  // Gameplay
  alienCannon.amp(soundEffectVolume);
  alienExplode.amp(soundEffectVolume);
  alienHit.amp(soundEffectVolume);
  alienLaser.amp(soundEffectVolume);
  alienPlasma.amp(soundEffectVolume);
  alienRainbow.amp(soundEffectVolume);
  alienShoot.amp(soundEffectVolume);
  playerCannon.amp(soundEffectVolume);
  playerHit.amp(soundEffectVolume);
  playerLaser.amp(soundEffectVolume);
  playerPickup.amp(soundEffectVolume);
  playerPlasma.amp(soundEffectVolume);
  playerRainbow.amp(soundEffectVolume);
  playerShoot.amp(soundEffectVolume);
  queenHit.amp(soundEffectVolume);
  rainbowHit.amp(soundEffectVolume);
  robotHit.amp(soundEffectVolume);
  toughHit.amp(soundEffectVolume);
  // Player Win
  playerWin.amp(soundEffectVolume);
}

// Stops all current sound effects from playing
void stopAllSFX(){
  musicSpaceDeGrey.stop();
    // Main Menu
  buttonPress.stop();
  buttonHover.stop();
  // Intro Animation
  shipMove.stop();
  mouthOpen.stop();
  shipTalk.stop();
  alienMove.stop();
  alienPosition.stop();
  start.stop();
  // Player Lose
  playerLoseSound.stop();
  alienDescend.stop();
  youLose.stop();
  // statistics Screen
  statsScreen.stop();
  countScore.stop();
  scoreCounted.stop();
  pressSpace.stop();
  // Gameplay
  alienCannon.stop();
  alienExplode.stop();
  alienHit.stop();
  alienLaser.stop();
  alienPlasma.stop();
  alienRainbow.stop();
  alienShoot.stop();
  playerCannon.stop();
  playerHit.stop();
  playerLaser.stop();
  playerPickup.stop();
  playerPlasma.stop();
  playerRainbow.stop();
  playerShoot.stop();
  queenHit.stop();
  rainbowHit.stop();
  robotHit.stop();
  toughHit.stop();
  // Player Win
  playerWin.stop();
}

void mousePressed() {
  if (eventLogger.displayMainMenu == true) {
    eventLogger.menuScreenMain.mousePressed();
  }
}
