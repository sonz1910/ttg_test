const express = require('express');
const bodyParser = require('body-parser');

const app = express();
const PORT = 3000;

// Middleware
app.use(bodyParser.json());

// Dummy data
let data = [
  { id: 1, name: 'Data 1' },
  { id: 2, name: 'Data 2' },
  { id: 3, name: 'Data 3' }
];

// Get all data
app.get('/api/data', (req, res) => {
  res.json(data);
});

// Get one data by id
app.get('/api/data/:id', (req, res) => {
  const id = parseInt(req.params.id);
  const datum = data.find(d => d.id === id);
  if (datum) {
    res.json(datum);
  } else {
    res.status(404).send('Data not found');
  }
});

// Create new data
app.post('/api/data', (req, res) => {
  const newDatum = req.body;
  data.push(newDatum);
  res.status(201).send('Data created successfully');
});

// Update data by id
app.put('/api/data/:id', (req, res) => {
  const id = parseInt(req.params.id);
  const updatedDatum = req.body;
  data = data.map(d => (d.id === id ? updatedDatum : d));
  res.send('Data updated successfully');
});

// Delete data by id
app.delete('/api/data/:id', (req, res) => {
  const id = parseInt(req.params.id);
  data = data.filter(d => d.id !== id);
  res.send('Data deleted successfully');
});

app.listen(PORT, () => {
  console.log(`Server is running on http://localhost:${PORT}`);
});
