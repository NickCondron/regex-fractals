int WINDOW_SIZE = 512;
int fractalSize = 512;
String[] ident;

PImage fractal;
String regex = "(.*)1(.*)";

//1 is black/white, 2 is depth, 3 is RGB capture, 4 is HSB capture
int coloringMode = 3;

void setup() {
  size(512, 512);
  noSmooth();
  
  ident = new String[fractalSize * fractalSize];
  populate("", 0, 0, fractalSize - 1, fractalSize - 1, ident);
  
  fractal = genFractal();
}

void draw() {
  image(fractal, 0, 0, WINDOW_SIZE, WINDOW_SIZE);
}

void populate(String soFar, int x1, int y1, int x2, int y2, String[] id) {
  if(x1 + 1 == x2 && y1 +1 == y2) {
      id[x1 + y1 * fractalSize] = soFar + "0";
      id[x2 + y1 * fractalSize] = soFar + "1";
      id[x2 + y2 * fractalSize] = soFar + "2";
      id[x1 + y2 * fractalSize] = soFar + "3";
      return;
  }
  else {
      populate(soFar + "0", x1, y1, x2-(int)((1+x2-x1)/2), y2-(int)((1+y2-y1)/2), id);
      populate(soFar + "1", x2-(int)((1+x2-x1)/2)+1, y1, x2, y2-(int)((1+y2-y1)/2), id);
      populate(soFar + "2", x2-(int)((1+x2-x1)/2)+1, y2-(int)((1+y2-y1)/2)+1, x2, y2, id);
      populate(soFar + "3", x1, y2-(int)((1+y2-y1)/2)+1, x2-(int)((1+x2-x1)/2), y2, id);
  }
}

PImage genFractal() {
  PImage f = new PImage(fractalSize, fractalSize);
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
  if (increase && fractalSize != WINDOW_SIZE) {
    redraw = true;
    fractalSize *= 2;
  } else if (!increase && fractalSize != 2) {
    redraw = true;
    fractalSize /= 2;
  }
  
  if (redraw) {
    ident = new String[fractalSize * fractalSize];
    populate("", 0, 0, fractalSize - 1, fractalSize - 1, ident);
    
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