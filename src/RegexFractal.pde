//Size in pixels of the fractal window
//Must be a power of 2
static final int SIZE = 512;
static final int WINDOW_SIZE = max(SIZE, 512);
String[] ident;

PImage fractal;
String regex;

PFont f;
String typing = "";
String saved = "";

void setup()
{
  size(WINDOW_SIZE, WINDOW_SIZE+100);
  
  f = createFont("Arial", 16, true);
  textAlign(CENTER);
  textFont(f);
 
  ident = new String[SIZE * SIZE];
  populate("", 0, 0, SIZE - 1, SIZE - 1, ident);
   
  fractal = new PImage(SIZE, SIZE);
  fractal.filter(INVERT);
  
  regex = "1";
  matchPixels();
  saved = regex;
   
}

void draw() {
  image(fractal, 0, 0, WINDOW_SIZE, WINDOW_SIZE);
  
  fill(255, 0, 0);
  rect(0, height - 100, width, 100);
  fill(0);
  rect(15, height-85, width-30, 70);
    
  fill(255);
  text(typing, width/2, height-50); 
  text(saved, width/2-30, height-50);
}

void populate(String soFar, int x1, int y1, int x2, int y2, String[] id) {
  if(x1 + 1 == x2 && y1 +1 == y2) {
      id[x1 + y1 * SIZE] = soFar + "0";
      id[x2 + y1 * SIZE] = soFar + "1";
      id[x2 + y2 * SIZE] = soFar + "2";
      id[x1 + y2 * SIZE] = soFar + "3";
      return;
  }
  else {
      populate(soFar + "0", x1, y1, x2-(1+x2-x1)/2, y2-(1+y2-y1)/2, id);
      populate(soFar + "1", x2-(1+x2-x1)/2+1, y1, x2, y2-(1+y2-y1)/2, id);
      populate(soFar + "2", x2-(1+x2-x1)/2+1, y2-(1+y2-y1)/2+1, x2, y2, id);
      populate(soFar + "3", x1, y2-(1+y2-y1)/2+1, x2-(1+x2-x1)/2, y2, id);  
  }
 
}

void matchPixels() {
  fractal.loadPixels();
  for (int i = 0; i < ident.length; i++) {
    String[] m = match(ident[i], regex);
    if (m != null) {
      fractal.pixels[i] = color(0);
    }
    else{
      fractal.pixels[i] = color(255);
    }
  }
  fractal.updatePixels();
  
  
}
void keyPressed() {
  
  if (key == '\n' ) 
  {
    saved = typing;
    regex = saved;
    matchPixels();
    typing = ""; 
  } 
  else 
  {
    if(key == BACKSPACE && typing.length()>0)
    {
      typing = typing.substring(0,typing.length()-1);
      
    }
    else
    {
      if(key != BACKSPACE && key != CODED)
      {
        typing = typing + key; 
      }
      saved="";
    }
  }
   
}