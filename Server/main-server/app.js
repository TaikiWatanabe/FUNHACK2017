var WebSocketServer = require('ws').Server;
var wss = new WebSocketServer({ port: process.env.PORT });

console.log("listening port :" + process.env.PORT);
var connections = [];
wss.on('connection', function (ws) {
    console.log('ws');
    console.log('connection');
    connections.push(ws);
    ws.on('message', function (message) {
     /*
      var id;
      var max = connections.length;
        for(var i = 0; i<max; i++){
          if(connections[i]==ws){
            id = ws;
          }
        }*/

        var split = message.split(",");
        x = parseFloat(split[0],10)-parseInt(split[0],10);
        y = parseFloat(split[1],10)-parseInt(split[1],10);
        x = Math.floor(x*100/2);//Math.floor(Math.pow(parseInt(split[0], 10),2) / parseInt(split[0],10)*10);
        y = Math.floor(y*100/2);//Math.floor(Math.pow(parseInt(split[1], 10),2) / parseInt(split[1],10)*10);
        var message = x+","+y;
        console.log('received:'+message);
        broadcast(message);
    });

    ws.on('close', function() {
        console.log('close');
        connections = connections.filter(function (conn, i) {
            return (conn === ws) ? false : true;
    });
});
});

//ブロードキャストを行う
function broadcast(message) {
    connections.forEach(function (con, i) {
        con.send(message);
    });
};
