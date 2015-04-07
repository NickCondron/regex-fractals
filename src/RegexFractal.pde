//Size in pixels of the fractal window
//Must be a power of 2
static final int WINDOW_SIZE = 512;
int size = 512;
String[] ident;
int[] matchLength;

PImage fractal;
String regex = "0";

//1 is black/white, 2 is color intensity
int coloringMode = 1;

PFont f;
String typing = "";
String saved = "";

void setup()
{
  size(WINDOW_SIZE, WINDOW_SIZE+100);
 
  ident = new String[size * size];
  matchLength = new int [size * size];
  populate("", 0, 0, size - 1, size - 1, ident);
  
  colorPixels(matchPixels());
  
  noSmooth();
  
  saved = regex;
  f = createFont("Arial", 16, true);
  textAlign(CENTER);
  textFont(f);
}

void draw() {
  image(fractal, 0, 0, WINDOW_SIZE, WINDOW_SIZE);
  
  fill(255, 0, 0);
  rect(0, height - 100, width, 100);
  fill(0);
  rect(15, height-85, width-30, 70);
    
  fill(255);
  text(typing, width/2, height-50); 
  text(saved, width/2, height-50);
}

void populate(String soFar, int x1, int y1, int x2, int y2, String[] id) {
  if(x1 + 1 == x2 && y1 +1 == y2) {
      id[x1 + y1 * size] = soFar + "0";
      id[x2 + y1 * size] = soFar + "1";
      id[x2 + y2 * size] = soFar + "2";
      id[x1 + y2 * size] = soFar + "3";
      return;
  }
  else {
      populate(soFar + "0", x1, y1, x2-(1+x2-x1)/2, y2-(1+y2-y1)/2, id);
      populate(soFar + "1", x2-(1+x2-x1)/2+1, y1, x2, y2-(1+y2-y1)/2, id);
      populate(soFar + "2", x2-(1+x2-x1)/2+1, y2-(1+y2-y1)/2+1, x2, y2, id);
      populate(soFar + "3", x1, y2-(1+y2-y1)/2+1, x2-(1+x2-x1)/2, y2, id);  
  }
 
}

//returns the length of the regex captures
//-1 if no match and 0 if match and no captures
int[] matchPixels() {
  int[] matchLength = new int[size * size];
  
  for (int i = 0; i < ident.length; i++) {
    String[] m = match(ident[i], regex);
    if (m == null) {
      matchLength[i] = -1;
    } else {
      for (int j = 1; j < m.length; j++) {
        matchLength[i] += m[j].length();
      }
    }
  }
  
  return matchLength;
}

void colorPixels(int[] matchLength) {
  fractal = new PImage(size, size);
  fractal.filter(INVERT);
  
  fractal.loadPixels();
  for (int i = 0; i < matchLength.length; i++) {
    if (coloringMode == 1) {
      if (matchLength[i] >= 0) {
        colorMode(RGB);
        fractal.pixels[i] = color(0);
      }
    }
  }
  fractal.updatePixels();
}

void changeDepth(boolean increase) {
  if (increase) {
    size = min(size * 2, WINDOW_SIZE);
  } else {
    size = max(size / 2, 2);
  }
  
  ident = new String[size * size];
  matchLength = new int [size * size];
  populate("", 0, 0, size - 1, size - 1, ident);
  
  colorPixels(matchPixels());
}

void keyPressed() {
  
  if (key == '\n' ) 
  {
    saved = typing;
    regex = saved;
    colorPixels(matchPixels());
    typing = ""; 
  } 
  else 
  {
    if(key == BACKSPACE)
    
    {
      if (typing.length() > 0)
      {
        typing = typing.substring(0,typing.length()-1);
      }
    }
    else
    {
      if (key != CODED)
      {
        typing = typing + key;
        saved="";
      }
      else if (keyCode == UP)
      {
        changeDepth(true);
      } else if (keyCode == DOWN) {
        changeDepth(false);
      }
    }
  }
   
}