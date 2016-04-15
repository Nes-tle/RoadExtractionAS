PImage img;
PImage img2, img3, img4;
int loc;
int vague = 8; 
int greyupperthreshold = 10;
int greylowerthreshold = 10;
int x, y, i, j;
int divide = 45;
float unit = 1.0;
int countermax = 10;
int iter;
float deltan = 12.0;
int corndelta = divide / 5;
BufferedReader reader;
String filename;
float r, g, b;
void setup()
{
  reader = createReader("a.txt");
  size(512, 512);
  iter = 0;
  img4 = createImage(2048, 2048, RGB);
  while (true)
  {
    iter++;
    try 
    {
      filename = reader.readLine();
    } 
    catch (IOException e) 
    {
      e.printStackTrace();
      filename = null;
    }
    if (filename == null) break;
    img3 = loadImage("/home/sensetime/Downloads/001/results/" + filename);
    img2 = createImage(512, 512, RGB);
    img = createImage(512, 512, RGB);
    for (x = 0; x < img3.width / vague; x++) {
      for (y = 0; y < img3.height / vague; y++ ) {
         r = 0.0;
         g = 0.0;
         b = 0.0;
         for (i = 0; i < vague; i++) {
           for (j = 0; j < vague; j++) {
             loc = x * vague + i + (y * vague + j) * img3.width;
             r += red   (img3.pixels[loc]);
             g += green (img3.pixels[loc]);
             b += blue  (img3.pixels[loc]);
           }
         }
        r /= (float)(vague * vague);
        g /= (float)(vague * vague);
        b /= (float)(vague * vague);
        r = constrain(r,0,255);
        g = constrain(g,0,255);
        b = constrain(b,0,255);
        if (r > greyupperthreshold) r = 255.0;
        if (g > greyupperthreshold) g = 255.0;
        if (b > greyupperthreshold) b = 255.0;
        if (r < greylowerthreshold) r = 0.0;
        if (g < greylowerthreshold) g = 0.0;
        if (b < greylowerthreshold) b = 0.0;
      // Make a new color and set pixel in the window
        color c = color(r,g,b);
        for (i = x * vague / 4; i < x * vague / 4 + vague / 4; i++)
          for (j = y * vague / 4; j < y * vague / 4 + vague / 4; j++)
            img.pixels[i + j * img.width] = c;
      }
    }
    img2 = img;
    img = createImage(512, 512, RGB);
    for (i = 0; i < img.width; i+=1)
      for (j = 0; j < img.height; j+=1)
      {
        img.pixels[i + j * img.width] = color(255, 255, 255);
        f(i, j);
      }
      
    for (i = 0; i < img.width; i++)
      for (j = 0; j < img.height; j++)
        for (int k = 0; k < 4; k++)
          for (int l = 0; l < 4; l++)
            img4.pixels[i * 4 + k + (j * 4 + l) * img3.width] = img.pixels[i + j * img.width];  
    img4.save("/home/sensetime/Downloads/002/Nes3/Simplified_" + filename);
    println(iter + "done");
  }
}

void draw() {
}

void mousePressed()
{
  f(mouseX, mouseY);
}

void f(int x11, int y11) {
  int x1 = x11;
  int y1 = y11;
 // ellipse(x1, y1, 5, 5);
  int i1, loc2;
  float x2;
  float y2;
  int n1 = 0;
  int n2 = 0;
  int n11 = 0;
  int n22 = 0;
  int max = 0;
  int counter;
  int maxi = 0;
  int maxn1 = 0;
  int maxn2 = 0;
  int tmp;
  loc2 = x1 + y1 * img2.width;
  float r1 =  red(img2.pixels[loc2]);
  if (r1 > 10.0) return;
  for (i1 = 0; i1 < divide; i1++)
  {
     x2 = (float)x1;
     y2 = (float)y1;
     counter = 0;
     n1 = 0;
     n11= 0;
     while ((x2 < img2.width) && (y2 < img2.height) && (x2 >= 0) && (y2 >= 0))
     {
       loc2 = (int)x2 + (int)y2 * img2.width;
       r1 = red(img2.pixels[loc2]);
       if (r1 > 100.0) 
       {
         counter++;
         n11--;
       }
       else 
       {
          counter = 0;
          n11++;
       }
       n1 += 1;
       if (counter > countermax)
       {
         n1 -= counter;
         break;
       }
       x2 += unit * cos(TWO_PI / (float)(divide * 2) * (float)i1);
       y2 += unit * sin(TWO_PI / (float)(divide * 2) * (float)i1);
     }
     x2 = (float)x1;
     y2 = (float)y1;
     counter = 0;
     n2 = 0;
     n22 = 0;
     while ((x2 < img2.width) && (y2 < img2.height) && (x2 >= 0) && (y2 >= 0))
     {
       loc2 = (int)x2 + (int)y2 * img2.width;
       r1 = red(img2.pixels[loc2]);
       if (r1 > 100.0) 
       {
         counter++;
         n22--;
       }
       else 
       {
         counter = 0;
         n22++;
       }
       n2 += 1;
       if (counter > countermax)
       {
         n2 -= counter;
         break;
       }
       x2 -= unit * cos(TWO_PI / (float)(divide * 2) * (float)i1);
       y2 -= unit * sin(TWO_PI / (float)(divide * 2) * (float)i1);
     }
     if (n11 + n22 > max)
     {
       max = n11 + n22;
       maxn1 = n1;
       maxn2 = n2;
       maxi = i1;
     }
  }
  stroke(255, 0, 0);
  if (deltan < maxn2)
  {
    tmp = (int)deltan;
    while (tmp > 0)
    {
      tmp--;
      x2 = x1 - tmp * unit * cos(TWO_PI / (float)(divide * 2) * (float)maxi);
      y2 = y1 - tmp * unit * sin(TWO_PI / (float)(divide * 2) * (float)maxi);
      img.pixels[(int)x2 + (int)y2 * img.width] = color(0, 0, 0);
    }
  }
  else
  {
    //line(x1 - maxn2 * unit * cos(TWO_PI / (float)(divide * 2) * (float)maxi),
    //     y1 - maxn2 * unit * sin(TWO_PI / (float)(divide * 2) * (float)maxi),
    //     x1,
     //    y1);
  }
  
  
  if (deltan < maxn1)
  {
    tmp = (int)deltan;
    while (tmp > 0)
    {
      tmp--;
      x2 = x1 + tmp * unit * cos(TWO_PI / (float)(divide * 2) * (float)maxi);
      y2 = y1 + tmp * unit * sin(TWO_PI / (float)(divide * 2) * (float)maxi);
      img.pixels[(int)x2 + (int)y2 * img.width] = color(0, 0, 0);
    }
  }
  else
  {
    //line(x1 + maxn1 * unit * cos(TWO_PI / (float)(divide * 2) * (float)maxi),
     //    y1 + maxn1 * unit * sin(TWO_PI / (float)(divide * 2) * (float)maxi),
      //   x1,
      //   y1);
  }
  //if (deltan < maxn2) corn(x1 - deltan * unit * cos(TWO_PI / (float)(divide * 2) * (float)maxi), 
 //                          y1 - deltan * unit * sin(TWO_PI / (float)(divide * 2) * (float)maxi), 
  //                         maxi + divide);
 // if (deltan < maxn1) corn(x1 + deltan * unit * cos(TWO_PI / (float)(divide * 2) * (float)maxi),
 //                          y1 + deltan * unit * sin(TWO_PI / (float)(divide * 2) * (float)maxi),
 //                          maxi);
}

void corn(float x1, float y1, int i0)
{
  int i1, loc2;
  float x2, y2;
  int n1 = 0;
  int n11 = 0;
  int max = 0;
  int maxn1 = 0;
  int counter;
  int maxi = 0;
  loc2 = (int)x1 + (int)y1 * img2.width;
  float r1 =  red(img2.pixels[loc2]);
  for (i1 = i0 - corndelta; i1 < i0 + corndelta; i1++)
  {
     x2 = (float)x1;
     y2 = (float)y1;
     counter = 0;
     n1 = 0;
     n11= 0;
     while ((x2 < img2.width) && (y2 < img2.height) && (x2 >= 0) && (y2 >= 0))
     {
       loc2 = (int)x2 + (int)y2 * img2.width;
       r1 = red(img2.pixels[loc2]);
       if (r1 > 100.0) 
       {
         counter++;
         n11--;
       }
       else 
       {
         counter = 0;
         n11++;
       }
       n1 += 1;
       if (counter > countermax)
       {
         n1 -= counter;
         break;
       }
       x2 += unit * cos(TWO_PI / (float)(divide * 2) * (float)i1);
       y2 += unit * sin(TWO_PI / (float)(divide * 2) * (float)i1);
     }
     if (n11 > max) 
     {
       max = n11;
       maxn1 = n1;
       maxi = i1;
     }
  }
  
  if (deltan < maxn1)
  {
    line(x1 + deltan * unit * cos(TWO_PI / (float)(divide * 2) * (float)maxi),
         y1 + deltan * unit * sin(TWO_PI / (float)(divide * 2) * (float)maxi),
         x1,
         y1);
  }
  else
  {
    //line(x1 + maxn1 * unit * cos(TWO_PI / (float)(divide * 2) * (float)maxi),
    //     y1 + maxn1 * unit * sin(TWO_PI / (float)(divide * 2) * (float)maxi),
    //     x1,
     //    y1);
  }
  if (deltan < maxn1) corn(x1 + deltan * unit * cos(TWO_PI / (float)(divide * 2) * (float)maxi),
                         y1 + deltan * unit * sin(TWO_PI / (float)(divide * 2) * (float)maxi),
                         maxi);
}