import ddf.minim.*;

Minim minim;
AudioPlayer player;

int n = 20;
float ground[] = new float[1024];

int gx = -1, gy = -1, sy = 150;
int catchCount = 0;
int tryCount = 0;

float colorR[] = new float[n];
float colorG[] = new float[n];
float colorB[] = new float[n];

Particle[] p = new Particle[n];

void setup()
{
  size(600, 500);
  noStroke();
  minim = new Minim(this);
  player = minim.loadFile("WingsYouAreTheHero.mp3");
  player.play();
  fill(255);
  for(int i = 0; i < n; i++) {
    p[i] = new Particle(random(0,width-100),random(0,height),12,random(-1,1),random(-1,1)); 
    colorR[i] = random(150, 255);
    colorG[i] = random(150, 255);
    colorB[i] = random(150, 255);
  }
}
void draw()  
{
  background(0);

  stroke(0, 80, 240);
  for(int i = 0; i < player.bufferSize() - 1; i++) {
    ground[i] = 450 + player.left.get(i)*100;
    line(i, 450 + player.left.get(i)*100, i+1, 450 + player.left.get(i+1)*100);
  }
  
  for(int j = 0; j < n; j++) {
    fill(colorR[j], colorG[j], colorB[j]);
    p[j].update();
    p[j].display();
    if (gy != -1 && p[j].y > gy - p[j].d && p[j].y < gy + p[j].d) {
      if (!p[j].catched) catchCount++;
      p[j].catched = true;
    }
  }
  strokeWeight(1.8);
  stroke(250, 50, 50);
  
  fill(192, 192, 192);
  rect(500, 0, 100, 500);
  fill(140, 50, 50);
  rect(500, 0, 100, 300);
  
  if (gx > 0 && gy > 0) {
    line(0, gy, 500, gy);
    gx = -1;
    gy = -1;
  }
  
  fill(50);
  textSize(19);
  text("Try", 530, 330);
  text(tryCount, 535, 370);
  text("Catch", 525, 420);
  text(catchCount, 535, 460);
  
  line (530, 0, 530, 300);
  if (mouseX > 500 && mouseX < 540 && mouseY > 15 && mouseY < 285)
    sy = mouseY;
  ellipse(520, sy, 40, 40);
}

void mouseReleased() {
}

void mousePressed() {
  if (mouseX > 500 && mouseX < 540 && mouseY > 15 && mouseY < 285) {
    tryCount++;
    gx = mouseX;
    gy = mouseY;
    line(0, gy, 500, gy);
  }
}

class Particle {
  float x = 0;
  float y = 0;
  float d = 0;
  float vx;
  float vy;
  float m = 1;
  float e = 0.5;
  float startPointX = 0;
  float startPointY = 0;
  boolean catched = false;
  
  Particle(float _x, float _y, float _d, float _vx, float _vy) {
    x = _x;
    y = _y;
    d = _d;
    vx = _vx;
    vy = _vy;
  }
  
  void display() {
    noStroke();
    ellipse(x,y,d,d);
  }
  
  void update() {
    if (catched) {
      d = 0;
    }
    if (y + d / 2 == ground[int(x)]) {
      vy += (450 - ground[int(x)]) / 2.5;
      if (450 - ground[int(x)] > 5)
          vx = random(-3, 3);
    }
    
    if((x + d / 2 >= width-100 && vx > 0) || (x - d / 2 <= 0 && vx < 0)) {
      vx *= -1 * e;
    }
    if(y + d / 2 >= ground[int(x)] && vy > 0 || (y - d / 2 <= 0 && vy < 0)) {
      vy *= -1 * e;
    }
    
    vy += 9.8 / frameRate;
    
    vx = abs(vx) < 0.1 ? 0 : vx;
    vy = abs(vy) < 0.1 ? 0 : vy;
    x += vx;
    y += vy;
    if(x - d / 2 < 0) {   
      x = d / 2;
    } else if(x + d / 2 > width-100) {
      x = width-100 - d / 2;
    } else if(y + d / 2 > ground[int(x)]) {
      y = ground[int(x)] - d / 2;
      vx *= 0.95;
    } else if (y - d / 2 < 0) { 
      y = d / 2;
    }
  }
}

void stop()
{
  player.close();
  minim.stop();
  super.stop();
}
