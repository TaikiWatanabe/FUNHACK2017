//円の拡大する際の加速度(減少率)
float FRICTION = 0.97;

public class Circle{
  int x,y;//円のx,y座標
  float dia;//円の半径
  float speed;//円の透明度
  int colorH;//円の色彩
  boolean flag;//円が起こった時のフラグ
  
  //円のインスタンスが生成された際に成り行きであるイニシャライザ
  Circle() {
    init(0,0,0,0);
    flag = false;
  }
  
//set
  public Circle(Circle src) {
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
  public void circleDraw() {
    noFill();
  
    if(speed > 1.0) {
      //stroke(色相、彩度、明るさ、透明度)
      stroke(colorH, 60, 99, 100*(speed-1)/3);
      strokeWeight(4);
      ellipse(x,y,dia,dia);
    }
    if(speed > 1.5) {
      stroke(colorH, 60, 99, 100*(speed-1.5)/3);
      strokeWeight(2);
      ellipse(x,y,dia*0.7,dia*0.7);
    }
    if(speed > 2.0) {
      stroke(colorH, 60, 99, 100*(speed-2)/3);
      strokeWeight(1);
      ellipse(x,y,dia*0.6,dia*0.6);
    }
  }

  public void move() {
    //diaは半径、speedは円の半径の加速度(減少していく)
    dia += speed;
    speed *= FRICTION;
    //全ての円の透明度が0になったら（見えなくなったら）フラグをおる
    if(speed < 0.5) {
      flag = false;
    }
  }
  
//get
  public boolean getFlag() {
    return flag;
  }
}