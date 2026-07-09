const express = require('express');
const cors = require('cors');

const app = express();
const PORT = process.env.PORT || 3000;

app.use(cors());
app.use(express.json());

let formData = [];
let nextId = 1;

app.get('/', (req, res) => {
  res.json({ status: 'ok', message: 'Server is running' });
});

app.post('/api/form', (req, res) => {
  const payload = req.body;

  if (!payload || Object.keys(payload).length === 0) {
    return res.status(400).json({ error: 'Request body cannot be empty' });
  }

  const record = {
    id: nextId++,
    ...payload,
    createdAt: new Date().toISOString(),
  };

  formData.push(record);

  return res.status(201).json({
    message: 'Data saved successfully',
    data: record,
  });
});

app.get('/api/form', (req, res) => {
  return res.status(200).json({
    count: formData.length,
    data: formData,
  });
});

app.get('/api/form/:id', (req, res) => {
  const id = parseInt(req.params.id, 10);
  const record = formData.find((item) => item.id === id);

  if (!record) {
    return res.status(404).json({ error: `Record with id ${id} not found` });
  }

  return res.status(200).json({ data: record });
});

app.delete('/api/form/:id', (req, res) => {
  const id = parseInt(req.params.id, 10);
  const index = formData.findIndex((item) => item.id === id);

  if (index === -1) {
    return res.status(404).json({ error: `Record with id ${id} not found` });
  }

  const removed = formData.splice(index, 1);
  return res.status(200).json({ message: 'Record deleted', data: removed[0] });
});

app.use((req, res) => {
  res.status(404).json({ error: 'Route not found' });
});

app.listen(PORT, () => {
  console.log(`Server running on http://localhost:${PORT}`);
});

module.exports = app;
