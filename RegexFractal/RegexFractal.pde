/* Made by Ben Switlick and Nick Condron
 * Inspired by ssodelta and christianp
 * Utilizes regex engine to generate repeating fractals
 * Can change depth and has various coloring modes
*/

//Size in pixels of the fractal window
//Must be a multiple of 2
static final int WINDOW_SIZE = 512;
int size = 512;
String[] ident;

String[] savedReg;
int regexIndex = 0;

PImage fractal;
String regex = "(.*)1(.*)";

//1 is black/white, 2 is depth, 3 is RGB capture, 4 is HSB capture
int coloringMode = 3;

PFont f;
String typing = "";
String saved = "";

boolean help = false;

void settings() {
  size(WINDOW_SIZE, WINDOW_SIZE + 100);
  noSmooth();
}

void setup() {
  ident = new String[size * size];
  populate("", 0, 0, size - 1, size - 1, ident);
  
  fractal = genFractal();
  
  typing = regex;
  saved = regex;
  
  //list of saved regexes that produce neat patterns
  //Page up/down used to cycle through
  savedReg = loadStrings("regexes.txt");
}

 void draw() {
   image(fractal, 0, 0, WINDOW_SIZE, WINDOW_SIZE);
   colorMode(RGB);
   fill(255, 0, 0);
   rect(0, height - 100, width, 100);
   fill(0);
   rect(15, height-85, width-30, 70);
   stroke(255);
   rect(15, height-85, 22,22);
   
     
   fill(255);
   f = createFont("Arial", 16, true);
   textAlign(CENTER);
   textFont(f);
   text(coloringMode,25,height-69); 
   text(typing, width/2, height-50);
   
   if(help) {
     helpScreen();
   }
 }

//recursivey fills the id for each pixel
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

PImage genFractal() {
  PImage f = new PImage(size, size);
  f.loadPixels();
  
  for (int i = 0; i < ident.length; i++) {
    String[] m;
    try {
      //catches user error for invalid regex syntax
      m = match(ident[i], regex);
    } catch(Exception e) {
      //prints syntax eror and returns unchanged fractal
      println(e.getMessage());
      return fractal;
    }
    f.pixels[i] = getColor(m);
  }
  
  f.updatePixels();
  return f;
}

int getColor(String[] m) {
  if (coloringMode == 1) {
    colorMode(RGB, 255);
    if (m == null) {
      return color(255);
    } else {
      return color(0);
    }
  }
  else if (coloringMode == 2) {
    colorMode(HSB, 255);
    if (m == null) {
      return color(255);
    } else {
      return color(150,20+20*m[0].length(),255);
    }
  }
  else if (coloringMode == 3) {
    colorMode(RGB,255);
    if (m == null) {
      return color(255);
      
    } else {
       int[] c = new int[3];
       for (int i = 1; i < m.length && i <= 3; i++) {
         int l = m[i].length();
         c[i - 1] = (int)(255 * (1 - (float)1/(l+1)));
       }
       return color(c[0], c[1], c[2]);
    }
  } 
  else if (coloringMode == 4) {
    if (m == null) {
      colorMode(RGB,255);
      return color(255);
      
    } else {
      colorMode(HSB, 360,100,100);
      int[] c = {360, 100, 100};
      
      for (int i = 1; i < m.length && i <= 3; i++) {
        int l = m[i].length();
        c[i - 1] = (int)(c[i-1] * (1 - (float)1/(l+1)));
      }
      return color(c[0], c[1], c[2]);
    }
  }
  else {
    colorMode(RGB,255);
    return color(255);
  }
}

void changeDepth(boolean increase) {
  boolean redraw = false;
  if (increase && size != WINDOW_SIZE) {
    redraw = true;
    size *= 2;
  } else if (!increase && size != 2) {
    redraw = true;
    size /= 2;
  }
  
  if (redraw) {
    ident = new String[size * size];
    populate("", 0, 0, size - 1, size - 1, ident);
    
    fractal = genFractal();
  }
}


void changeMode(int change) {
  coloringMode += change;
  while(coloringMode < 1) {
    coloringMode += 4;
  }
  while(coloringMode > 4) {
    coloringMode -= 4;
  }
  fractal = genFractal();
}

void keyPressed() {
  //CODED keys
  if (key == CODED) {
    if (keyCode == UP) {
      //increase depth by 1
      changeDepth(true);
    }
    else if (keyCode == DOWN) {
      //decrease depth by 1
      changeDepth(false);
    }
    else if (keyCode == LEFT) {
      //decrease coloringMode by 1
      changeMode(-1);
    }
    else if (keyCode == RIGHT) {
      //increase coloringMode by 1
      changeMode(1);
    }
    //PgUp key
    else if (keyCode == 33) { 
      regexIndex = (regexIndex + 1) % savedReg.length;
        
      saved = savedReg[regexIndex];
      typing = saved;
      regex = saved;
      fractal = genFractal();
    }
    //PgDown key
    else if (keyCode == 34) {
      regexIndex = (regexIndex - 1) % savedReg.length;
      if (regexIndex < 0) {
        regexIndex += savedReg.length;
      }
        
      saved = savedReg[regexIndex];
      typing = saved;
      regex = saved;
      fractal = genFractal();
    }
  }
  //non-CODED keys
  else {
    if (key == '\n' ) {
      saved = typing;
      regex = saved;
      
      fractal = genFractal();
    }
    else if (key == BACKSPACE) {
      if (typing.length() > 0) {
        typing = typing.substring(0,typing.length()-1);
      }
    }
    //save image with timestamp
    else if (key == 's' || key == 'S') {
      String timeStamp = nf(year(), 4) + nf(month(), 2) + nf(day(), 2)
          + "-" + nf(hour(), 2) +  nf(minute(), 2) + nf(second(), 2);
      
      fractal.save(savePath(timeStamp + ".jpg"));
      println("saved: " + timeStamp + ".jpg");
    }
    //clear regex
    else if (key == DELETE) {
      typing = "";
    }
    //toggle help
    else if (key == 'h' || key == 'H'){
      help = !help;
    }
    //print regex
    else if (key == 'p' || key == 'P'){
      println(regex);
    }
    //actual character is typed
    else {
      typing = typing + key;
      saved="";
    }
  }
}

//displays helpscreen over the regex
void helpScreen() {
  fill(0);
  rect(0,0,WINDOW_SIZE,WINDOW_SIZE);
  
  fill(255);
  f = createFont("Arial", 15, true);
  textAlign(LEFT);
  textFont(f);
  
  text("Cycle through saved regexs:",60,150);
  text("Save the current displayed regex:",60,180);
  text("Change the depth level:",60,210);
  text("Change the color Mode:",60,240);
  text("Print the current regex:",60,270);
  text("Close this help screen:",60,300);
  textAlign(RIGHT);
  text("Page Up/Page Down",WINDOW_SIZE-60,150);
  text("S",WINDOW_SIZE-60,180);
  text("Up/Down Arrow",WINDOW_SIZE-60,210);
  text("Left/Right Arrow",WINDOW_SIZE-60,240);
  text("P",WINDOW_SIZE-60,270);
  text("H",WINDOW_SIZE-60,300);
} 