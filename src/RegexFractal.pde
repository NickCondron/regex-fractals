import java.util.regex.PatternSyntaxException;

//Size in pixels of the fractal window
//Must be a power of 2
static final int WINDOW_SIZE = 512;
int size = 4;
String[] ident;

String[] savedReg;
int regexIndex=0;

PImage fractal;
String regex = "1";

//1 is black/white, 2 is color intensity
int coloringMode = 1;

PFont f;
String typing = "";
String saved = "";

void setup()
{
  
  size(WINDOW_SIZE, WINDOW_SIZE+100);
 
  ident = new String[size * size];
  populate("", 0, 0, size - 1, size - 1, ident);
  
  fractal = genFractal();
  
  noSmooth();
  
  saved = regex;
  f = createFont("Arial", 16, true);
  textAlign(CENTER);
  textFont(f);
  
  savedReg=loadStrings("regexes.txt");
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
   text(coloringMode,25,height-69); 
   text(typing, width/2, height-50); 
   //text(saved, width/2, height-50);
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

PImage genFractal() {
  PImage f = new PImage(size, size);
  f.loadPixels();
  for (int i = 0; i < ident.length; i++) {
    String[] m;
    try {
      m = match(ident[i], regex);
    } catch(PatternSyntaxException pse) {
      println(pse.getDescription());
      return fractal;
    }
    
    f.pixels[i] = getColor(m);
  }
  f.updatePixels();
  return f;
  
}

int getColor(String[] m) {
  if (coloringMode == 1) {
    colorMode(RGB);
    if (m == null) {
      return color(255);
    } else {
      return color(0);
    }
  }
  else if (coloringMode == 2) {
     colorMode(HSB);
    if (m == null) {
      return color(255);
    } else {
      return color(150,20+20*m[0].length(),255);
    }
  }
  else if (coloringMode == 3) {
    colorMode(RGB);
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
  } else {
    return color(255);
  }
}

void changeDepth(boolean increase) {
  if (increase) {
    size = min(size * 2, WINDOW_SIZE);
  } else {
    size = max(size / 2, 2);
  }
  
  ident = new String[size * size];
  populate("", 0, 0, size - 1, size - 1, ident);
  
  fractal = genFractal();
}

void changeMode(boolean increase) {
  if(increase) {
    coloringMode--;
    if(coloringMode < 1) {
      coloringMode = 3;
    }
  } else {
    coloringMode++;
    if(coloringMode > 3) {
      coloringMode = 1;
    }
  }
  
  fractal = genFractal();
}

void keyPressed() {
  
  if (key == '\n' ) 
  {
    saved = typing;
    regex = saved;
    
    fractal = genFractal();
    
    //typing = ""; 
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
      else if (keyCode == LEFT) {
        changeMode(true);
      }
      else if (keyCode == RIGHT) {
        changeMode(false);
      }
      else if (keyCode == 33)
      {  
        regexIndex++;
        if(regexIndex>=savedReg.length)
          regexIndex=0;
          
        saved = savedReg[regexIndex];
        typing=saved;
        regex = saved;
        fractal = genFractal();
          
      }
      else if (keyCode == 34)
      {
         regexIndex--;
        if(regexIndex<0)
          regexIndex=savedReg.length-1;
          
        saved = savedReg[regexIndex];
        typing=saved;
        regex = saved;
        fractal = genFractal();
      }
    }
  }  
}