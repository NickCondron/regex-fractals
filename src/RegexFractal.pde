//Size in pixels of the fractal window
//Must be a power of 2
static final int SIZE = 512;
static final int WINDOW_SIZE = max(SIZE, 512);
String[] ident;

PImage fractal;
String regex;
void setup()
{
   size(WINDOW_SIZE, WINDOW_SIZE);
   
   ident = new String[SIZE * SIZE];
   populate("", 0, 0, SIZE - 1, SIZE - 1, ident);
   
   fractal = new PImage(SIZE, SIZE);
   fractal.filter(INVERT);
   regex = "0";
   matchPixels();
   
}

void draw() {
  image(fractal, 0, 0, WINDOW_SIZE, WINDOW_SIZE);
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
  }
  fractal.updatePixels();
}

