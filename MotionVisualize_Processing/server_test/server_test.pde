import websockets.*; //<>//

import processing.net.*;

Client myClient;

void setup() {
    size(100, 100); //<>//

    myClient = new Client(this, "rsserver.herokuapp.com", 80); //<>//
    
    if(myClient.active()){ //<>//
        println("Success."); //<>//
    } //<>//
    else{
        println("Connection refused.");
        exit();
    }
}

void draw() {
}