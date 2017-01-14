import http.requests.*;

//表示できる文字の最大数
int SIZE = 20;
int MAX = 100;
int time = 0;
int hc = 0;
int sc = 0;
Circle[] circle = new Circle[SIZE];
Rect[] rect = new Rect[SIZE];
Heart[] heart = new Heart[MAX];
Star[] star = new Star[SIZE];

void setup() {
  //色々設定
  fullScreen();
  colorMode(HSB, 100);
  background(0);
  smooth();
  frameRate(60);

  //各円のインスタンス作成
  for (int i=0; i<SIZE; i++) {
    circle[i] = new Circle();
    rect[i] = new Rect();
    star[i] = new Star();
  }
  for (int i=0; i<MAX; i++) {
    heart[i] = new Heart();
  }
}

void draw() {
  background(0);
  //各円のインスタンスのフラグがたったら円表示
  for (int i=0; i<SIZE; i++) {
    if (circle[i].getFlag()) {
      circle[i].move();
      circle[i].circleDraw();
    }
    if (rect[i].getFlag()) {
      rect[i].move();
      rect[i].rectDraw();
    }
    if (star[i].getFlag()) {
      star[i].move();
      star[i].starDraw();
    }
  }
  
    for (int i=0; i<MAX; i++) {
    if (heart[i].getFlag()) {
      heart[i].move();
      heart[i].heartDraw();
    }
  }

  if (time%8==0){
    heart[hc].init(displayWidth/2+int(random(-100,100)), displayHeight/2+int(random(-20,20)), random(5, 15), int(random(10, 80)), random(-PI,PI), random(-PI,PI));
    hc++;
  }
  if(time%100==0){
    star[0].init(int(random(displayWidth)), 0, random(5, 15), int(random(10, 80)), random(PI,2*PI), random(PI,2*PI));
    sc++;
  }
  if (hc==99)hc=0;
  if(sc==29)sc=0;
  time++;
}

// 右クリックしたら各円のフラグを立てる
void mousePressed() {
  for (int i=SIZE-1; i>0; i--) {
    circle[i] = new Circle(circle[i-1]);
    rect[i] = new Rect(rect[i-1]);
  }
  circle[0].init(mouseX, mouseY, random(5, 15), int(random(10, 80)));
  rect[0].init(mouseX, mouseY, random(5, 15), int(random(10, 80)));
  
}

// キーボードを押すと各円のフラグを立てる
void keyPressed() {
  for (int i=SIZE-1; i>0; i--) {
    circle[i] = new Circle(circle[i-1]);
  }
  circle[0].init(int(random(0, width)), int(random(0, height)), random(5, 15), int(random(10, 80)));
}