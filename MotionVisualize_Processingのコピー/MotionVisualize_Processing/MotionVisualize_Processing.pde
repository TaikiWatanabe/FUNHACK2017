//import http.requests.*;
import websockets.*;

int circleResolution;
float radius, theta;
int a=20;
int b=40;
int h =10;
int w=10;
int dx=1;
int a1=0;
int b1=0;
int qwe=0;


class Particle2 {
  int x, y;        
  float vx, vy;    
  float slowLevel;
   
 
  Particle2() {
    x = (int)random(width);
    y = (int)random(height);
    slowLevel = random(100) + 5;
  }
 
  void move(float targetX, float targetY) {
    vx = (targetX - x) ;
    vy = (targetY - y) ;
 
    x = (int)(x + vx);
    y = (int)(y + vy);
  }
}
Particle2 p = new Particle2();
 
final int LIGHT_FORCE_RATIO = 5;  
final int  LIGHT_DISTANCE= 75 * 75;  
final int  BORDER = 400;  
float baseRed, baseGreen, baseBlue;  
float baseRedAdd, baseGreenAdd, baseBlueAdd;  
final float RED_ADD = 1.2;   
final float GREEN_ADD = 1.7;  
final float BLUE_ADD = 2.3;  
/*******************************************************************************
 * SparkChime: Drag the mouse to release a colorful spray of sparks that produce
 * musical tones as they bounce.
 *
 * Sound is not enabled in this version.
 *
 * @author Gregory Bush
 */

/*
 * The maximum number of particles to display at once.  Lowering this will
 * improve performance on slow systems.
 */
int PARTICLE_COUNT = 256;

/*
 * The number of events that must occur before a spark is emitted.  Increasing
 * this will improve video and sound performance as well as change the
 * aesthetics.
 */
int EMISSION_PERIOD = 0;

/*
 * The lowest ratio of vertical speed retained after a spark bounces.
 */
float LOW_BOUNCE = 0.5;

/*
 * The highest ratio of vertical speed retained after a spark bounces.
 */
float HIGH_BOUNCE = 0.8;

/*
 * The variation in velocity of newly-created sparks.
 */
float SPRAY_SPREAD = 2.0;

/*
 * Some predefined gravity settings to play with.
 */
float EARTH_GRAVITY = 1.0 / 16.0;
float MOON_GRAVITY = EARTH_GRAVITY / 6.0;
float JUPITER_GRAVITY = EARTH_GRAVITY * 2.5;

/*
 * The amount of acceleration due to gravity.
 */
float GRAVITY = EARTH_GRAVITY;

/*
 * The amount of error allowed in model coordinate measurements.  Lowering
 * this will let sparks have tiny bounces longer.
 */
float TOLERANCE = 0.3;

/**
 * The focal length from the viewer to the screen in model coordinates.
 */
float FOCAL_LENGTH = 1000.0;

/**
 * The distance in model coordinates from the viewer to where new sparks are
 * created.  Increasing this number will move the created sparks further away.
 */
float INTERACTION_DISTANCE = 4 * FOCAL_LENGTH;

/*
 * A custom 3D canvas used to draw the world.
 */
Canvas3D canvas;

/*
 * A collection of Particles that represent the spraying sparks.
 */
Particle sparks[] = new Particle[PARTICLE_COUNT];

/*
 * The index of the Particle to use for the next spark created.
 */
int nextSpark = 0;

/*
 * The number of drag events that have passed without emitting a spark.
 */
int skipCount = 0;

long lastFrameDrawn = millis();

float averageElapsedMillis = 20.0;

/**
 * Perform initial setup needed for the sketch.
 *
 * @author Gregory Bush
 */

WebsocketClient wsc;
String message = "";
int time = 0;
int t = 0;
/*
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
Triangle[] triangle = new Triangle[SIZE];
*/
void setup() {
  //通信先指定
  wsc= new WebsocketClient(this, "ws://motionvisualizer.herokuapp.com");
  
  //色々設定
  fullScreen();
  //colorMode(HSB, 100);
  background(0);
  smooth();
  frameRate(60);
  noCursor();
  baseRed = 0;
  baseRedAdd = RED_ADD;
 
  baseGreen = 0;
  baseGreenAdd = GREEN_ADD;
 
  baseBlue = 0;
  baseBlueAdd = BLUE_ADD;

  /*
   * Create the 3D canvas to draw on.
   */
  canvas = new Canvas3D(FOCAL_LENGTH, INTERACTION_DISTANCE);

  /*
   * Get a soundbank to select bounce sounds from.
   */
  SoundBank soundBank = new SilentSoundBank();

  /*
   * Initialize the array of Particles to be used in the animation.  They will be
   * each be randomly colored and have a random sound from the SoundBank.
   */
  for (int i = 0; i < PARTICLE_COUNT; i++) {
    sparks[i] = new Particle(random(256), random(256), random(256), soundBank.getRandomSound());
  }
/*
  //各円のインスタンス作成
  for (int i=0; i<SIZE; i++) {
    circle[i] = new Circle();
    rect[i] = new Rect();
    star[i] = new Star();
    triangle[i] = new Triangle();
  }
  for (int i=0; i<MAX; i++) {
    heart[i] = new Heart();
  }
  */
}

void draw() {
  t++;
  
 if (keyPressed == true) {
   background(0);
  } 
  if(time<=20){
  /*
   * Determine how long it has been since we last drew a frame.
   */
  long now = millis();
  long elapsedMillis = now - lastFrameDrawn;
  lastFrameDrawn = now;
  averageElapsedMillis = .90 * averageElapsedMillis + .10 * elapsedMillis; 

  /*
   * Fade the screen's current contents a bit more toward black.
   */
  noStroke();    
  fill(0, 0, 0, constrain(2 * elapsedMillis, 0, 255));
  rect(0, 0, width, height);

  /*
   * Draw any active sparks and evolve them one time step.
   *
   * TODO: I'd like to draw these z-ordered from furthest to
   * closest, but the built-in Processing sorts don't
   * facilitate this.
   */
  for (Particle spark : sparks) {
    if (spark.isActive()) {
      spark.paint(elapsedMillis);
      spark.evolve(elapsedMillis);
    }
  }
  /*
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
    if (triangle[i].getFlag()) {
      triangle[i].move();
      triangle[i].triangleDraw();
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
  */
  }else if(20<time&&time<=40){
    if(qwe==0){
     background(0);
     qwe=1;
    }
    
    stroke (random (600),random (500),random (400));
    noFill ();
    ellipse (a1,b1,h,w);
    h=h-1;
    w=w-1;
 
  }else if(40<time){
    if(qwe==1){
     background(0);
     qwe=0;
    }
    baseRed += baseRedAdd;
  baseGreen += baseGreenAdd;
  baseBlue += baseBlueAdd;
 
  colorOutCheck();
  
/////////////////////////////////////// //here
   p.move(a, b);
  
 
   int tRed = (int)baseRed;
  int tGreen = (int)baseGreen;
  int tBlue = (int)baseBlue;
 
  tRed *= tRed;
  tGreen *= tGreen;
  tBlue *= tBlue;
 
  
  loadPixels();
 
    int left = max(0, p.x - BORDER);
    int right = min(width, p.x + BORDER);
    int top = max(0, p.y - BORDER);
    int bottom = min(height, p.y + BORDER);
 
   
    for (int y = top; y < bottom; y++) {
      for (int x = left; x < right; x++) {
        int pixelIndex = x + y * width;
 
        int r = pixels[pixelIndex] >> 16 & 0xFF;
        int g = pixels[pixelIndex] >> 8 & 0xFF;
        int b = pixels[pixelIndex] & 0xFF;
 
      
        int dx = x - p.x;
        int dy = y - p.y;
        int distance = (dx * dx) + (dy * dy);  
 
       
        if (distance < LIGHT_DISTANCE) {
          int fixFistance = distance * LIGHT_FORCE_RATIO;
         
          if (fixFistance == 0) {
            fixFistance = 1;
          }   
          r = r + tRed / fixFistance;
          g = g + tGreen / fixFistance;
          b = b + tBlue / fixFistance;
        }
        pixels[x + y * width] = color(r, g, b);
      }
    }
  
  updatePixels();
    
  }/*else if(21<time&&time<=28){
    
  }else if(20<time&&time<=25){
    
  }else if(25<time&&time<=30){
    
  }*/
  
  println(time);
  if(t%60==0)time++;
  //if(time==30)time=0;
}
/*
// 右クリックしたら各円のフラグを立てる
void mousePressed() {
  for (int i=SIZE-1; i>0; i--) {
    circle[i] = new Circle(circle[i-1]);
    rect[i] = new Rect(rect[i-1]);
    triangle[i] = new Triangle(triangle[i-1]);
  }
  circle[0].init(mouseX, mouseY, random(5, 15), int(random(10, 80)));
  rect[0].init(mouseX, mouseY, random(5, 15), int(random(10, 80)));
  triangle[0].init(mouseX, mouseY, random(5, 15), int(random(10, 80)));
  
}

// キーボードを押すと各円のフラグを立てる
void keyPressed() {
  for (int i=SIZE-1; i>0; i--) {
    circle[i] = new Circle(circle[i-1]);
  }
  circle[0].init(int(random(0, width)), int(random(0, height)), random(5, 15), int(random(10, 80)));
}
*/
//サーバからデータを受信したら呼び出される
void webSocketEvent(String msg){
 //println(msg);
 //message += msg + "\n";
 //int test = int(msg);
 int []array = new int[2];
 array=int(split(msg,","));
 if (skipCount >= EMISSION_PERIOD) {
  /*
     * Reset the skip count.
     */
    skipCount = 0;

    /*
     * Convert the prior and current mouse screen coordinates to model coordinates.
     */
    Point3D prior = canvas.toModelCoordinates(displayWidth/2+displayWidth*array[0]/100, displayHeight/2+displayHeight*array[1]/100);
    Point3D current = canvas.toModelCoordinates(displayWidth/2+displayWidth*array[0]/100, displayHeight/2+displayHeight*array[1]/100);
    a1=displayWidth/2+displayWidth*array[0]/100;
    b1=displayHeight/2+displayHeight*array[1]/100;
    a=displayWidth/2+displayWidth*array[0]/100;
    b=displayHeight/2+displayHeight*array[1]/100;
    

    /*
     * The spark's initial velocity is the difference between the current and prior
     * points, randomized a bit to create a "spray" effect and scaled by the elapsed
     * time.
     */
    Vector3D velocity = current.diff(prior);
    velocity.shift(new Vector3D(random(-SPRAY_SPREAD, SPRAY_SPREAD), 0, random(-SPRAY_SPREAD, SPRAY_SPREAD) * velocity.x));
    velocity.scale(10.0 / averageElapsedMillis);

    /*
     * Set the spark's intital motion and queue up the next particle.
     */
    sparks[nextSpark].initializeMotion(current, velocity);
    nextSpark = (nextSpark + 1) % PARTICLE_COUNT;
  } 
  else {
    /*
     * Increase the skip count.
     */
    skipCount++;
  }
 /*
 println(array);
 for (int i=SIZE-1; i>0; i--) {
    circle[i] = new Circle(circle[i-1]);
  }
circle[0].init(displayWidth*array[0]/100, displayHeight*array[1]/100, random(5, 15), int(random(10, 80)));
*/
}

/******************************************************************************
 * A rudimentary 3D graphics library.
 *
 * I realized recently that Processing already has 3D graphics capabilities,
 * so much of this could be done natively.  However, this way does load quite
 * quickly comparatively.
 *
 * @author Gregory Bush
 */

/**
 * A point in 2D screen coordinates.
 *
 * @author Gregory Bush
 */
public static class Point2D {
  public final float x;
  public final float y;

  public Point2D(float x, float y) {
    this.x = x;
    this.y = y;
  }
}

/**
 * A vector in 3D model coordinates.
 *
 * @author Gregory Bush
 */
public static class Vector3D {
  public float x;
  public float y;
  public float z;

  public Vector3D(float x, float y, float z) {
    this.x = x;
    this.y = y;
    this.z = z;
  }

  public void shift(Vector3D v) {
    x += v.x;
    y += v.y;
    z += v.z;
  }

  public Vector3D add(Vector3D v) {
    return new Vector3D(x + v.x, y + v.y, z + v.z);
  }

  public void scale(float c) {
    x *= c;
    y *= c;
    z *= c;
  }

  public Vector3D mul(float c) {
    return new Vector3D(c * x, c * y, c * z);
  }
}

/**
 * A point in 3D model coordinates.
 *
 * @author Gregory Bush
 */
public static class Point3D {
  public float x;
  public float y;
  public float z;

  public Point3D(float x, float y, float z) {
    this.x = x;
    this.y = y;
    this.z = z;
  }

  public void shift(Vector3D v) {
    x += v.x;
    y += v.y;
    z += v.z;
  }

  public Point3D add(Vector3D v) {
    return new Point3D(x + v.x, y + v.y, z + v.z);
  }

  public Vector3D diff(Point3D p) {
    return new Vector3D(x - p.x, y - p.y, z - p.z);
  }
}

/**
 * A Canvas3D allows drawing graphics primitives in a 3D coordinate system.
 *
 * @author Gregory Bush
 */
public class Canvas3D {
  private final float focalLength;

  private final float interactionPlane;

  public Canvas3D(float focalLength, float interactionPlane) {
    this.focalLength = focalLength;
    this.interactionPlane = interactionPlane;
  }

  /**
   * Convert a point in the 3D model to a point on the 2D screen.
   */
  public Point2D toScreenCoordinates(Point3D p) {
    float scale = focalLength / p.z;

    return new Point2D(p.x * scale + width / 2, p.y * scale + height / 2);
  }

  /**
   * Convert a point on the 2D screen to a point in the 3D model, projected on
   * the interaction plane.
   */
  public Point3D toModelCoordinates(float x, float y) {
    float scale = interactionPlane / focalLength;

    return new Point3D((x - width / 2) * scale, (y - height / 2) * scale, interactionPlane);
  }

  /**
   * Scale the diameter of a sphere whose center is at a particular Z distance to
   * its diameter on the screen.
   */
  public float scaleToScreen(float diameter, float distance) {
    return diameter * focalLength / distance;
  }

  private void drawLine(Point2D from, Point2D to) {
    line(from.x, from.y, to.x, to.y);
  }

  private void drawPoint(Point2D p) {
    point(p.x, p.y);
  }

  /**
   * Draw a line between 3D points.
   */
  public void drawLine(Point3D from, Point3D to, float weight) {
    strokeWeight(scaleToScreen(weight, to.z));
    drawLine(toScreenCoordinates(from), toScreenCoordinates(to));
  }

  /**
   * Draw a point in 3D.
   */
  public void drawPoint(Point3D p, float weight) {
    strokeWeight(scaleToScreen(weight, p.z));
    drawPoint(toScreenCoordinates(p));
  }

  /**
   * Draw a circle with vertical normal vector.
   */
  public void drawHorizontalCircle(Point3D center, float radius) {
    float screenRadius = canvas.scaleToScreen(radius, center.z);
    Point2D p = toScreenCoordinates(center);
    /*
     * This is a cheat, but it looks fine and is faster than
     * doing it right.
     */
    ellipse(p.x, p.y, screenRadius, screenRadius * .3);
  }
}

/**
 * Increase the intensity of a color value.
 */
float amplify(float n) {
  return constrain(4 * n, 0, 255);
}

/******************************************************************************
 * A Particle is a representation of a bouncing, colored spark that plays a
 * sound when it strikes the ground.
 *
 * @author Gregory Bush
 */
public class Particle {
  /*
   * The coordinates of the particle's current location.
   */
  private Point3D location;

  /*
   * The particle's velocity.
   */
  private Vector3D velocity;

  /*
   * The particle's color.
   */
  private float red;
  private float green;
  private float blue;

  /*
   * The sound that will be played when the particle strikes the ground.
   */
  private Sound sound;

  /*
   * Was the particle drawn off the left of the screen?
   */
  private boolean pastLeftWall;

  /*
   * Was the particle drawn off the right of the screen?
   */
  private boolean pastRightWall;

  /**
   * Create a Particle with a specified color and characteristic sound.
   */
  public Particle(float red, float green, float blue, Sound sound) {
    this.red = red;
    this.green = green;
    this.blue = blue;
    this.sound = sound;
  }

  /**
   * Initialize or reset all variables describing the motion of the particle to
   * the specified values.
   */
  public void initializeMotion(Point3D location, Vector3D velocity) {
    this.location = location;
    this.velocity = velocity;
  }

  /**
   * Returns true if the Particle should still be actively evolving in time.
   */
  public boolean isActive() {
    /*
     * We will consider the Particle active as long as it is on the other side
     * of the screen than the viewer. 
     */
    return location != null && location.z >= FOCAL_LENGTH;
  }

  /*
   * Draw a motion-blurred trajectory of a particular stroke weight and opacity.
   * The stroke weight will be scaled based on the Particle's distance from the
   * viewer.
   */
  private void drawMotion(Point3D from, Point3D to, float weight, float opacity) {
    stroke(red, green, blue, opacity);
    canvas.drawLine(from, to, weight);
  }

  /**
   * Draw the Particle on the screen.
   */
  public void paint(float elapsedMillis) {
    Point3D from = location;
    Point3D to = location.add(velocity.mul(elapsedMillis));

    /*
     * Draw three motion blurs, successively narrower and brighter.
     */
    drawMotion(from, to, 64, 8);
    drawMotion(from, to, 32, 32);
    drawMotion(from, to, 8, 255);

    /*
     * Draw a splash and play the Particle's characteristic note if it has
     * struck the ground.
     */
    if (isUnderground(elapsedMillis)) {
      splash(to);
    }

    /*
     * Remember if we drew off of the left or right of the screen.  This is
     * a bit awkward.  Bouncing off geometry in the model coordinates would
     * be better.
     */
    Point2D p = canvas.toScreenCoordinates(to);
    pastLeftWall = p.x < 0;
    pastRightWall = p.x >= width;
  }

  /*
   * Draw the splash when the Particle strikes the ground and play the
   * Particle's characteristic note if sound is enabled.
   */
  private void splash(Point3D to) {
    /*
     * The splash is a circle on the ground with dim illumination in its
     * interior and a bright ring on its circumference.
     */
    stroke(red, green, blue, 128);
    fill(red, green, blue, 64);
    canvas.drawHorizontalCircle(to, 128);

    /*
     * At the point where the Particle touched the ground, draw a small
     * but bright flash of light.
     */
    stroke(amplify(red), amplify(green), amplify(blue), 255);
    canvas.drawPoint(to, 16);

    /*
     * Play the splash sound at a volume relative to how fast the
     * particle collided.
     */
    sound.play(map(-velocity.y, 0, 6, 0, 1));
  }

  /*
   * Is the Particle's next position beneath the surface of the ground?
   */
  private boolean isUnderground(float elapsedMillis) {
    return location.y + velocity.y * elapsedMillis > height;
  }

  /*
   * Various functions to determine the direction of the Particle's motion.
   */

  private boolean isMovingLeft() {
    return velocity.x <= -TOLERANCE;
  }

  private boolean isMovingRight() {
    return velocity.x >= TOLERANCE;
  }

  private boolean isMovingUp() {
    return velocity.y <= -TOLERANCE;
  }

  private boolean isMovingDown() {
    return velocity.y >= TOLERANCE;
  }

  private boolean isMovingVertically() {
    return isMovingUp() || isMovingDown();
  }

  /*
   * Reverse the horizontal motion of the Particle.
   */
  private void bounceHorizontal() {
    velocity.x = -velocity.x;
  }

  /*
   * Reverse the vertical motion of the Particle.
   */
  private void bounceVertical() {
    /*
     * The Particle's kinetic energy will be scaled down randomly.  It
     * will lose energy with every bounce.
     */
    velocity.y = -velocity.y * random(LOW_BOUNCE, HIGH_BOUNCE);
  }

  /*
   * Give the particle an inactive status, indicating it no longer needs to be
   * evolved in time.
   */
  private void deactivate() {
    location.z = 0;
  }

  /**
   * Evolve the Particle's motion over the specified amount of time in millis.
   */
  public void evolve(float elapsedMillis) {
    /*
     * Bounce off of the left or right borders of the screen if the Particle
     * has gone off.
     */
    if ((pastLeftWall && isMovingLeft()) || (pastRightWall && isMovingRight())) {
      bounceHorizontal();
    } 

    /*
     * If the Particle has struck the ground, bounce vertically.  Deactivate
     * the particle if it has lost so much energy it is no longer
     * really bouncing.
     */
    if (isUnderground(elapsedMillis) && isMovingDown()) {
      bounceVertical();
      if (!isMovingVertically()) {
        deactivate();
      }
    } 

    /*
     * Add the Particle's velocity times elapsed time to its current location.
     */
    location.shift(velocity.mul(elapsedMillis));

    /*
     * Apply the accleration due to gravity.
     */
    velocity.y += GRAVITY;
  }
}

/*******************************************************************************
 * Since Maxim audio is not working on OpenProcessing, these are just stubs.
 */
 
/*******************************************************************************
 * A Sound is a very simple abstraction of a sound that can be played at
 * a specified volume.  The baseline volume is 1.0.
 *
 * @author Gregory Bush
 */
public interface Sound {
  public void play(float volume);
}

/*******************************************************************************
 * You can randomly select a Sound from a SoundBank.
 *
 * @author Gregory Bush
 */
public interface SoundBank {
  public Sound getRandomSound();
}

/*******************************************************************************
 * Hello, darkness, my old friend...
 *
 * THE_SOUND_OF_SILENCE is inaudible when played.
 *
 * @author Gregory Bush
 */
Sound THE_SOUND_OF_SILENCE = new Sound() {
  public void play(float volume) {
  }
};

/*******************************************************************************
 * A SilentSoundBank contains only THE_SOUND_OF_SILENCE.
 *
 * @author Gregory Bush
 */
public class SilentSoundBank implements SoundBank {
  public Sound getRandomSound() {
    return THE_SOUND_OF_SILENCE;
  }
}
  void colorOutCheck() {
  if (baseRed < 10) {
    baseRed = 10;
    baseRedAdd *= -1;
  }
  else if (baseRed > 255) {
    baseRed = 255;
    baseRedAdd *= -1;
  }
 
  if (baseGreen < 10) {
    baseGreen = 10;
    baseGreenAdd *= -1;
  }
  else if (baseGreen > 255) {
    baseGreen = 255;
    baseGreenAdd *= -1;
  }
 
  if (baseBlue < 10) {
    baseBlue = 10;
    baseBlueAdd *= -1;
  }
  else if (baseBlue > 255) {
    baseBlue = 255;
    baseBlueAdd *= -1;
  }
  }