const http = require('http');
const WebSocket = require('ws');
const io = require('socket.io')(server, {
  cors: {
    origin: '*',
  }
});

const server = http.createServer((req, res) => {
  res.writeHead(200);
  res.end('WebSocket server is running');
});

// Authenticate WebSocket connections
io.use((socket, next) => {
  const token = socket.handshake.auth.token;
  jwt.verify(token, 'secretkey', (err, decoded) => {
    if (err) return next(new Error('Authentication error'));
    socket.username = decoded.username;
    next();
  });
});

const wss = new WebSocket.Server({ server });

wss.on('connection', ws => {
  console.log('Client connected');
  ws.on('message', message => {
    const data = JSON.parse(message);
    console.log('Received:', data); // Ensure the message is treated as JSON
    wss.clients.forEach(client => {
      if (client !== ws && client.readyState === WebSocket.OPEN) {
        console.log('Broadcasting message:', data);
        client.send(JSON.stringify(data));
      }
    });
  });

  ws.on('close', () => {
    console.log('Client disconnected');
  });
});

// Handle connections
io.on('connection', (socket) => {
  console.log('User connected:', socket.username);
  socket.join(socket.username);

  socket.on('private message', async (data) => {
    try {
      const { to, message } = data;
      console.log('New message:', { from: socket.username, to, message });

      const chatMessage = new Message({
        from: socket.username,
        to,
        message,
        timestamp: new Date(),
      });
      await chatMessage.save();

      // Send to recipient
      io.to(to).emit('message', {
        from: socket.username,
        message,
      });

      // Send back to sender
      socket.emit('message sent', {
        to,
        message,
      });
    } catch (error) {
      console.error('Error sending message:', error);
      socket.emit('error', { message: 'Failed to send message' });
    }
  });
});

// Start server
server.listen(3002, () => {
  console.log('WebSocket server running on port 3002');
});