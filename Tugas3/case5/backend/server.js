const express = require('express');
const mongoose = require('mongoose');
const bodyParser = require('body-parser');
const cors = require('cors');

const app = express();
app.use(bodyParser.json());
app.use(cors()); // Enable CORS

mongoose.connect('mongodb://database:27017/chat', { useNewUrlParser: true, useUnifiedTopology: true });

const MessageSchema = new mongoose.Schema({
  username: String,
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

app.post('/messages', async (req, res) => {
  const message = new Message(req.body);
  await message.save();
  console.log('Message saved:', message); // Add logging
  res.status(201).json(message);
});

app.listen(3000, () => {
  console.log('Backend server started on port 3000');
});