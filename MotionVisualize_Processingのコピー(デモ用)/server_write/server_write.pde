import websockets.*; //<>//
import processing.net.*;

Client myClient;

void setup() {
    size(100, 100); //<>//

    myClient = new Client(this, "rsserver.herokuapp.com", 80); //<>//
    
    //接続確認
    if(myClient.active()){
        println("Success.");
    }
    else{
        println("Connection refused.");
        exit();
    }
}

void draw() {}

void clientEvent(Client c){
  String s = c.readString();
  if(s != null){
    println("client received: " + s);
  }
}

void mouseClicked(){
  String s = "(" + mouseX + "," + mouseY + ") was clicked";
  println(s);
  myClient.write(s);
}