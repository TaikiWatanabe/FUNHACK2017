import websockets.*; //<>//

WebsocketClient wsc;
String message = "";

void setup(){
  size(400,400);

  wsc= new WebsocketClient(this, "ws://rsserver.herokuapp.com");
}

void draw(){
  background(255);
  fill(0);
  text(message, 20, 20);

  if(frameCount % 60 == 0) {
    wsc.sendMessage("Hello from P5");
  }
}

void keyPressed() {
  wsc.sendMessage("press key"+key);
}

void webSocketEvent(String msg){
 println(msg);
 message += msg + "\n";
}