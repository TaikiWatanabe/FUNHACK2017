import http.requests.*;

//表示できる文字の最大数
int SIZE = 20;
Circle[] circle = new Circle[SIZE];
Heart[] heart = new Heart[SIZE];

void setup() {
  //色々設定
  fullScreen();
  colorMode(HSB,100);
  background(0);
  smooth();
  frameRate(60);
  
  //各円のインスタンス作成
  for(int i=0;i<SIZE;i++) {
    circle[i] = new Circle();
    heart[i] = new Heart();
  }
}

void draw() {
  background(0);
  //各円のインスタンスのフラグがたったら円表示
  for(int i=0;i<SIZE;i++) {
    if(circle[i].getFlag()) {
      circle[i].move();
      circle[i].circleDraw();
      heart[i].move();
      heart[i].getFlag();
    }
  }
}

// 右クリックしたら各円のフラグを立てる
void mousePressed() {
  for(int i=SIZE-1;i>0;i--) {
    circle[i] = new Circle(circle[i-1]);
    heart[i] = new Heart(heart[i-1]);
  }
  circle[0].init(mouseX,mouseY,random(5,15),int(random(10,80)));
  heart[0].init(mouseX,mouseY,random(5,15),int(random(10,80)));
}

// キーボードを押すと各円のフラグを立てる
void keyPressed() {
  for(int i=SIZE-1;i>0;i--) {
    circle[i] = new Circle(circle[i-1]);
  }
  circle[0].init(int(random(0,width)),int(random(0,height)),random(5,15),int(random(10,80)));
}