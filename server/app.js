const { timeStamp } = require('console');
const express = require('express');
const app = express();
const http = require('http');
const server = http.createServer(app);
const { Server } = require("socket.io");
const io = new Server(server);


io.on('connection', (socket) => {
  // event to join a room
  socket.on('joinRoom', (room) => {
    // Join the specified room
    socket.join(room);
    console.log('room joined')
  });
  
  socket.on('message', (data) => {
    console.log(data)
    const message = {
      message: data.message,
      sender_name: data.sender_name,
      sender_id: data.sender_id,
      room_id: data.room_id,
      timestamp: Date.now()
    }
    console.log(message)
    // event to send message to flutter app
    io.to(data.room_id).emit('message', message);
  })
});


server.listen(3000, '0.0.0.0', () => {
  console.log('listening on *:3000');
});