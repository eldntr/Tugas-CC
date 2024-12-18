const express = require('express');
const jwt = require('jsonwebtoken');
const mongoose = require('mongoose');
const http = require('http');
const { Server } = require('socket.io');
const bodyParser = require('body-parser');
const cors = require('cors');

const app = express();
const server = http.createServer(app);
const io = new Server(server, {
  cors: {
    origin: '*',
    methods: ['GET', 'POST'],
    credentials: true
  }
});

app.use(bodyParser.json());
app.use(cors());

mongoose.connect('mongodb://mongo-backend:27017/chat', { useNewUrlParser: true, useUnifiedTopology: true });

const MessageSchema = new mongoose.Schema({
  from: String,
  to: String,
  message: String,
  timestamp: { type: Date, default: Date.now }
});

const Message = mongoose.model('Message', MessageSchema);

app.get('/', (req, res) => {
  res.send('Backend server is running');
});

app.get('/messages', async (req, res) => {
  const messages = await Message.find().sort({ timestamp: 1 });
  res.json(messages);
});

app.get('/messages/:otherUser', async (req, res) => {
    try {
        const token = req.headers.authorization.split(' ')[1];
        const decoded = jwt.verify(token, 'secretkey');
        const messages = await Message.find({
            $or: [
                { from: decoded.username, to: req.params.otherUser },
                { from: req.params.otherUser, to: decoded.username }
            ]
        }).sort({ timestamp: 1 });
        res.json(messages);
    } catch (error) {
        res.status(401).json({ message: 'Unauthorized' });
    }
});

app.post('/messages', async (req, res) => {
  const message = new Message(req.body);
  await message.save();
  res.status(201).json(message);
});

io.use((socket, next) => {
  const token = socket.handshake.auth.token;
  jwt.verify(token, 'secretkey', (err, decoded) => {
    if (err) return next(new Error('Authentication error'));
    socket.username = decoded.username;
    next();
  });
});

io.on('connection', (socket) => {
    socket.join(socket.username);

    socket.on('private message', async (data) => {
        try {
            const { to, message } = data;
            const chatMessage = new Message({
                from: socket.username,
                to,
                message,
                timestamp: new Date(),
            });
            await chatMessage.save();

            io.to(to).emit('private message', {
                from: socket.username,
                message,
            });

            socket.emit('message sent', {
                to,
                message,
            });
        } catch (error) {
            socket.emit('error', { message: 'Failed to send message' });
        }
    });
});

server.listen(3001, () => {
  console.log('Backend server running on port 3001');
});