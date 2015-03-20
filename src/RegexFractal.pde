static final int SIZE = 4;
String[] ident;
void setup()
{
   size(SIZE, SIZE);
   String s = "";
   ident = new String[SIZE * SIZE];
   
   populate(s, 0, 0, SIZE - 1, SIZE - 1, iden);
   for(int x = 0; x < 16; x++)
    println(iden[x]);
    
}
static void populate(String soFar, int x1, int y1, int x2, int y2, String[] idnt)
{
  if(x1 + 1 == x2 && y1 +1 == y2)  
  {
      idnt[x1 + y1 * SIZE] = soFar + "0";
      idnt[x2 + y1 * SIZE] = soFar + "1";
      idnt[x2 + y2 * SIZE] = soFar + "2";
      idnt[x1 + y2 * SIZE] = soFar + "3";
     
     
  }
  else
  {
      populate(soFar + "0", x1, y1, x2/2, y2/2, idnt);
      populate(soFar + "1", x2/2+1, y1, x2, y2/2, idnt);
      populate(soFar + "2", x2/2+1, y2/2+1, x2, y2, idnt);
      populate(soFar + "3", x1, y2/2+1, x2/2, y2, idnt);  
  }
  
}
