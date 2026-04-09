const express = require('express');
const mongoose = require('mongoose');

const app = express();
app.use(express.json());
app.use(express.static('public'));

// Conexión a MongoDB (la URL vendrá del docker-compose)
const MONGO_URI = process.env.MONGO_URI || 'mongodb://localhost:27017/tareas';
mongoose.connect(MONGO_URI)
  .then(() => console.log('Conectado a MongoDB'))
  .catch(err => console.error('Error conectando a MongoDB:', err));

// Modelo de datos
const Tarea = mongoose.model('Tarea', new mongoose.Schema({
  titulo: String,
  completada: { type: Boolean, default: false }
}));

// --- CRUD ---
// CREATE: Crear tarea
app.post('/tareas', async (req, res) => {
  const nuevaTarea = new Tarea(req.body);
  await nuevaTarea.save();
  res.status(201).json(nuevaTarea);
});

// READ: Leer todas las tareas
app.get('/tareas', async (req, res) => {
  const tareas = await Tarea.find();
  res.json(tareas);
});

// UPDATE: Actualizar tarea
app.put('/tareas/:id', async (req, res) => {
  const tareaActualizada = await Tarea.findByIdAndUpdate(req.params.id, req.body, { new: true });
  res.json(tareaActualizada);
});

// DELETE: Borrar tarea
app.delete('/tareas/:id', async (req, res) => {
  await Tarea.findByIdAndDelete(req.params.id);
  res.json({ mensaje: 'Tarea eliminada' });
});

const PORT = 3000;
app.listen(PORT, () => console.log(`Servidor corriendo en el puerto ${PORT}`));