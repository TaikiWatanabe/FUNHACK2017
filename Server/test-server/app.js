var WebSocketServer = require('ws').Server;
var wss = new WebSocketServer({ port: process.env.PORT });
var flag = false;

console.log("listening port :" + process.env.PORT);

wss.on('connection', function connection(ws) {
  console.log('connection');
  flag = true;

  var ID = setInterval(function() {
    if (flag) {
      var ram = Math.floor((Math.random() * 99) + 1);
      console.log(ram);
      ws.send(ram);
    } else {
      clearInterval(ID);
    }
  }, 1000);

  ws.on('message', function incoming(message) {
    console.log('received: %s', message);
    ws.send('Hello from ws');
  });

  ws.on('close', function() {
    console.log('close');
    flag = false;
  });
});
