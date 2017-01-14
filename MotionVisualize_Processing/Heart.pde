public class Heart {
  int x, y;//円のx,y座標
  float dia;//円の半径
  float speed;//円の透明度
  int colorH;//円の色彩
  boolean flag;//円が起こった時のフラグ
  float pix,piy;

  //円のインスタンスが生成された際に成り行きであるイニシャライザ
  Heart() {
    init(0, 0, 0, 0,0,0);
    flag = false;
  }

  //set
  public Heart(Heart src) {
    this.x = src.x;
    this.y = src.y;
    this.speed = src.speed;
    this.colorH = src.colorH;
    this.dia = src.dia;
    this.flag = src.flag;
  }

  //円が起こるときに起こるもの
  public void init(int _x, int _y, float _speed, int _colorH,float _pix,float _piy) {
    x = _x;
    y = _y;
    speed = _speed;
    colorH = _colorH;
    dia = 0.0;
    flag = true;
    pix = _pix;
    piy = _piy;
  }

  //円の描写
  //上から順に大きい円、中ぐらいの円、小さい円
  public void heartDraw() {
    noFill();
    
    //stroke(色相、彩度、明るさ、透明度)
    stroke(colorH, 60, 99, 100*(speed-1)/3);
    strokeWeight(4);
    //ellipse(x, y, dia, dia);
    strokeJoin(ROUND); //線のつなぎ目について設定
    //translate(1*pix, 1*piy);
    pushMatrix();
    x += pix;
    y += piy;
    translate(x, y);
    beginShape();
    for (int theta = 0; theta < 360; theta++) {
      float x1 = 0.5 * (16 * sin(radians(theta)) * sin(radians(theta)) * sin(radians(theta)));
      float y1 = (-1) * 0.5 * (13 * cos(radians(theta)) - 5 * cos(radians(2 * theta)) 
        - 2 * cos(radians(3 * theta)) - cos(radians(4 * theta)));

      vertex(x1, y1);
    }
    endShape(CLOSE);
    popMatrix();
    
  }

  public void move() {
    //diaは半径、speedは円の半径の加速度(減少していく)
    dia += speed;
    speed *= FRICTION;
    //全ての円の透明度が0になったら（見えなくなったら）フラグをおる
    if (speed < 0.5) {
      flag = false;
    }
  }

  //get
  public boolean getFlag() {
    return flag;
  }
}