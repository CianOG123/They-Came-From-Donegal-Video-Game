class Button { 
  // Button Constants
  final int EVENT_NULL = 0;
  
  // Button Variables
  float xButtonSpawn, yButtonSpawn, xImageSpawn, yImageSpawn;
  int width, height;
  String label;
  int event;
  color buttonColor, labelColor;
  PFont buttonFont;
  PImage hoverImage;
  
  // SFX
  boolean hoverSoundPlayed = false;
  
  Button(float x, float y, int width, int height, int event, PImage hoverImage) { 
    this.xButtonSpawn = x;
    this.yButtonSpawn = y;
    this.xImageSpawn = x;
    this.yImageSpawn = y;
    this.width = width;
    this.height= height;
    this.event = event;
    this.hoverImage = hoverImage;
  }
  Button(float xActivation, float yActivation, float xImageSpawn, float yImageSpawn, float width, float height, int event, PImage hoverImage) { 
    this.xButtonSpawn = xActivation;
    this.yButtonSpawn = yActivation;
    this.xImageSpawn = xImageSpawn;
    this.yImageSpawn = yImageSpawn;
    this.width = (int) width;
    this.height= (int) height;
    this.event = event;
    this.hoverImage = hoverImage;
  }

  // Drawing the button to the screen
  void draw() { 
    // Drawing the hover image to the screen 
    if (hover(mouseX, mouseY)){
      image(hoverImage, xImageSpawn, yImageSpawn);
      if(hoverSoundPlayed == false){
        hoverSoundPlayed = true;
        buttonHover.stop();
        buttonHover.play();
      }
    }
    else{
      hoverSoundPlayed = false;
    }
  } 

  // Checks if the mouse is hovering over the button.
  private boolean hover(int mouseXValue, int mouseYValue){
    return ((mouseXValue > xButtonSpawn) && (mouseXValue < xButtonSpawn + width) && (mouseYValue > yButtonSpawn) && (mouseYValue < yButtonSpawn + height));
  }
  
  // Gets the event of the button and returns it. Returns button event if mouse is hovering over it, otherwise returns null.
  int getEvent(int mouseXValue, int mouseYValue){ 
    if (hover(mouseXValue, mouseYValue)) { 
      return event;
    } 
    return EVENT_NULL;
  }
}
