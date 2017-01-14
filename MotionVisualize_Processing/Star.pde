public class Star {
  int x, y;//円のx,y座標
  float dia;//円の半径
  float speed;//円の透明度
  int colorH;//円の色彩
  boolean flag;//円が起こった時のフラグ
  int vertex_num = 5*2; //頂点数(星を描画、トゲの数*2)
  int R; //中心から頂点までの距離(半径)
  int R_out = 150; //中心からとげまでの距離(半径)
  int R_in = R_out/2; //中心から谷までの距離(半径)

  //円のインスタンスが生成された際に成り行きであるイニシャライザ
  Star() {
    init(0, 0, 0, 0);
    flag = false;
  }

  //set
  public Star(Star src) {
    this.x = src.x;
    this.y = src.y;
    this.speed = src.speed;
    this.colorH = src.colorH;
    this.dia = src.dia;
    this.flag = src.flag;
  }

  //円が起こるときに起こるもの
  public void init(int _x, int _y, float _speed, int _colorH) {
    x = _x;
    y = _y;
    speed = _speed;
    colorH = _colorH;
    dia = 0.0;
    flag = true;
  }

  //円の描写
  //上から順に大きい円、中ぐらいの円、小さい円
  public void starDraw() {
    noFill();


    //stroke(色相、彩度、明るさ、透明度)
    stroke(colorH, 60, 99, 100*(speed-1)/3);
    strokeWeight(4);
    ellipse(x, y, dia, dia);
    pushMatrix();
    translate(x, y);
    rotate(radians(-90));
    beginShape();
    for (int i = 0; i < vertex_num; i++) {
      if (i%2 == 0) {
        R = R_out;
      } else {
        R = R_in;
      }
      vertex(R*cos(radians(360*i/vertex_num)), R*sin(radians(360*i/vertex_num)));
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