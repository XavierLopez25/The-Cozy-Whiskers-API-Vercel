import express from 'express';
import cors from 'cors';

import {
  getAllTables,
  registerNewEmployee,
  loginUser,
  insertNewCuenta,
  closeCuenta,
  getFoodByType,
  getRoleName,
  fetchAllOrders,
  createOrder,
  getFoodPlates,
  fetchOrderCheckout,
  fetchTotalFinalOrder,
  fetchIndividualPayments,
  getAvailableMesas,
  getOccupiedMesas,
  submitQuejaEncuesta,
  getFoodById,
  getDetallePedidoByMesaId,
  getFoodMeasures,
  listEmployees,
  reportMostOrderedDishes,
  reportMostOrdersTimeSlot,
  reportAverageDiningTime,
  reportComplaintsByPerson,
  reportComplaintsByDish,
  reportServerEfficiencyLast6Months,
  getLastInvoiceByMesaId,
} from './db.js';
import bodyParser from 'body-parser';

// Inicializar la aplicación Express
const app = express();
// Habilitar el middleware para parsear JSON en el cuerpo de las solicitudes
app.use(express.json());
app.use(bodyParser.json());
app.use(cors());

const port = 5000;

app.get('/', async (req, res) => {
  const posts = await getAllTables();
  console.log(posts);
  res.send('Hello World from API!');
});

// User Registration Endpoint
app.post('/register', async (req, res) => {
  const { name, role, startDate, username, password } = req.body;
  try {
    const result = await registerNewEmployee(name, role, startDate, username, password);
    console.log('TEST', result);
    res.status(201).json({
      status: 'success',
      employeeId: result.rows[0].register_new_employee,
    });
  } catch (error) {
    console.error('Error executing register_new_employee function >', error.stack);
    res.status(500).json({ status: 'error', message: 'Internal Server Error' });
  }
});

// User Login Endpoint
app.post('/login', async (req, res) => {
  const { username, password } = req.body;
  try {
    const result = await loginUser(username, password);
    if (result.rows.length > 0) {
      res.status(201).json({ status: 'success', user: result.rows[0] });
    } else {
      res.status(401).json({ status: 'fail', message: 'Invalid username or password' });
    }
  } catch (error) {
    console.error('Error executing user_login function > ', error.stack);
    res.status(500).json({ status: 'error', message: 'Internal Server Error' });
  }
});

app.post('/get-role-name', async (req, res) => {
  const { username, password } = req.body;
  try {
    const result = await getRoleName(username, password);
    console.log('TEST', result.rows[0]);
    if (result.rows.length > 0) {
      res.status(200).json({ status: 'success', data: result.rows[0] });
    } else {
      res.status(401).json({ status: 'fail', message: 'Invalid username or password' });
    }
  } catch (error) {
    console.error('Error executing getRoleName function > ', error.stack);
    res.status(500).json({ status: 'error', message: 'Internal Server Error' });
  }
});

app.get('/list-employees', async (req, res) => {
  try {
    const result = await listEmployees();
    console.log(result);
    res.status(200).json({ status: 'success', data: result });
  } catch (error) {
    console.error('Error executing listEmployees function > ', error.stack);
    res.status(500).json({ status: 'error', message: 'Internal Server Error' });
  }
});

app.post('/insert-new-cuenta', async (req, res) => {
  const { mesa_id_arg, personas_arg } = req.body;

  try {
    await insertNewCuenta(mesa_id_arg, personas_arg);
    res.status(200).json({ status: 'success', message: 'Cuenta creada con éxito' });
  } catch (error) {
    console.error * ('Error executing insert_new_cuenta procedure > ', error.stack);
    res.status(500).json({ status: 'error', message: 'Internal Server Error' });
  }
});

app.post('/close-cuenta', async (req, res) => {
  const { mesa_id_arg, nit_arg, dir_arg, nombre_arg, efectivo_arg, tarjeta_arg } = req.body;

  try {
    await closeCuenta(mesa_id_arg, nit_arg, dir_arg, nombre_arg, efectivo_arg, tarjeta_arg);
    res.status(200).json({ status: 'success', message: 'Cuenta cerrada con éxito' });
  } catch (error) {
    console.error('Error executing close_cuenta procedure > ', error.stack);
    res.status(500).json({ status: 'error', message: 'Internal Server Error' });
  }
});

app.post('/food-by-type', async (req, res) => {
  const { type } = req.body;

  try {
    const result = await getFoodByType(type);
    console.log(result);
    res.status(200).json({ status: 'success', data: result });
  } catch (error) {
    console.error('Error executing getFoodByType function > ', error.stack);
    res.status(500).json({ status: 'error', message: 'Internal Server Error' });
  }
});

app.post('/food-by-id', async (req, res) => {
  const { id } = req.body;

  try {
    const result = await getFoodById(id);
    console.log(result);
    res.status(200).json({ status: 'success', data: result });
  } catch (error) {
    console.error('Error executing getFoodById function > ', error.stack);
    res.status(500).json({ status: 'error', message: 'Internal Server Error' });
  }
});

app.post('/detalle-pedido', async (req, res) => {
  const { mesa_id } = req.body; // Obtiene el mesa_id de los parámetros de ruta
  try {
    const detalles = await getDetallePedidoByMesaId(mesa_id);
    if (detalles.length > 0) {
      res.status(200).json({ status: 'success', data: detalles });
    } else {
      res.status(404).json({ status: 'fail', message: 'No detail orders found for this table' });
    }
  } catch (error) {
    console.error('Error fetching detail orders:', error);
    res.status(500).json({ status: 'error', message: 'Internal Server Error' });
  }
});

app.get('/food-plates', async (req, res) => {
  try {
    const result = await getFoodPlates();
    console.log(result);
    res.status(200).json({ status: 'success', data: result });
  } catch (error) {
    console.error('Error executing getFoodPlates function > ', error.stack);
    res.status(500).json({ status: 'error', message: 'Internal Server Error' });
  }
});

app.post('/food-measures', async (req, res) => {
  const { comida_nombre, tamaño } = req.body;
  try {
    if (!comida_nombre || !tamaño) {
      return res.status(400).json({ status: 'error', message: 'Missing comida_id or tamaño' });
    }
    const result = await getFoodMeasures(comida_nombre, tamaño);
    console.log(result);
    if (result.length > 0) {
      res.status(200).json({ status: 'success', data: result });
    } else {
      res.status(404).json({ status: 'fail', message: 'No matching medidaC_id found' });
    }
  } catch (error) {
    console.error('Error executing getFoodMeasures function > ', error.stack);
    res.status(500).json({ status: 'error', message: 'Internal Server Error' });
  }
});

app.post('/create-order', async (req, res) => {
  const { mesa_id_arg, platoB_id_arg, cantidad_arg, medidaC_id_arg, nota_arg } = req.body;

  try {
    await createOrder(mesa_id_arg, platoB_id_arg, cantidad_arg, medidaC_id_arg, nota_arg);
    res.status(201).json({ status: 'success', message: 'Pedido creado con éxito' });
  } catch (error) {
    console.error('Error executing createOrder procedure > ', error.stack);
    res.status(500).json({ status: 'error', message: 'Internal Server Error' });
  }
});

app.post('/fetch-all-orders', async (req, res) => {
  const { tipo_comida } = req.body;
  console.log(tipo_comida);
  try {
    const result = await fetchAllOrders(tipo_comida);
    console.log(result);
    res.status(200).json({ status: 'success', data: result });
  } catch (error) {
    console.error('Error executing fetchAllOrders function > ', error.stack);
    res.status(500).json({ status: 'error', message: 'Internal Server Error' });
  }
});

app.post('/fetch-order-checkout', async (req, res) => {
  const { mesa_id_arg } = req.body;
  console.log(mesa_id_arg);
  try {
    const result = await fetchOrderCheckout(mesa_id_arg);
    console.log(result);
    res.status(200).json({ status: 'success', data: result });
  } catch (error) {
    console.error('Error executing fetchOrderCheckout function > ', error.stack);
    res.status(500).json({ status: 'error', message: 'Internal Server Error' });
  }
});

app.post('/fetch-total-final-order', async (req, res) => {
  const { mesa_id_arg } = req.body;
  console.log(mesa_id_arg);
  try {
    const result = await fetchTotalFinalOrder(mesa_id_arg);
    console.log(result);
    res.status(200).json({ status: 'success', data: result });
  } catch (error) {
    console.error('Error executing fetchTotalFinalOrder function > ', error.stack);
    res.status(500).json({ status: 'error', message: 'Internal Server Error' });
  }
});

app.post('/fetch-individual-payments', async (req, res) => {
  const { mesa_id_arg } = req.body;
  console.log(mesa_id_arg);
  try {
    const result = await fetchIndividualPayments(mesa_id_arg);
    console.log(result[0]);
    res.status(200).json({ status: 'success', data: result });
  } catch (error) {
    console.error('Error executing fetchIndividualPayments function > ', error.stack);
    res.status(500).json({ status: 'error', message: 'Internal Server Error' });
  }
});

app.get('/get-available-mesas', async (req, res) => {
  try {
    const result = await getAvailableMesas();
    console.log(result);
    res.status(200).json({ status: 'success', data: result });
  } catch (error) {
    console.error('Error executing getAvailableMesas function > ', error.stack);
    res.status(500).json({ status: 'error', message: 'Internal Server Error' });
  }
});

app.get('/get-occupied-mesas', async (req, res) => {
  try {
    const result = await getOccupiedMesas();
    console.log(result);
    res.status(200).json({ status: 'success', data: result });
  } catch (error) {
    console.error('Error executing getOccupiedMesas function > ', error.stack);
    res.status(500).json({ status: 'error', message: 'Internal Server Error' });
  }
});

app.post('/submit-queja-encuesta', async (req, res) => {
  const {
    nit_arg,
    empleado_id_arg,
    empleado_id_arg_sat,
    platoBebida_id_arg,
    motivo_arg,
    clasificacion_arg,
    amabilidad_arg,
    exactitud_arg,
  } = req.body;

  try {
    await submitQuejaEncuesta(
      nit_arg,
      empleado_id_arg,
      empleado_id_arg_sat,
      platoBebida_id_arg,
      motivo_arg,
      clasificacion_arg,
      amabilidad_arg,
      exactitud_arg,
    );
    res.status(201).json({ status: 'success', message: 'Queja y encuesta enviada con éxito' });
  } catch (error) {
    console.error('Error executing submitQuejaEncuesta procedure > ', error.stack);
    res.status(500).json({ status: 'error', message: 'Internal Server Error' });
  }
});

app.post('/report-most-ordered-dishes', async (req, res) => {
  const { fecha_inicio, fecha_fin } = req.body;

  try {
    const result = await reportMostOrderedDishes(fecha_inicio, fecha_fin);
    console.log(result);
    res.status(200).json({ status: 'success', data: result });
  } catch (error) {
    console.error('Error executing reportMostOrderedDishes function > ', error.stack);
    res.status(500).json({ status: 'error', message: 'Internal Server Error' });
  }
});

app.post('/report-most-orders-time-slot', async (req, res) => {
  const { fecha_inicio, fecha_fin } = req.body;

  try {
    const result = await reportMostOrdersTimeSlot(fecha_inicio, fecha_fin);
    console.log(result);
    res.status(200).json({ status: 'success', data: result });
  } catch (error) {
    console.error('Error executing reportMostOrdersTimeSlot function > ', error.stack);
    res.status(500).json({ status: 'error', message: 'Internal Server Error' });
  }
});

app.post('/report-average-dining-time', async (req, res) => {
  const { fecha_inicio, fecha_fin } = req.body;

  try {
    const result = await reportAverageDiningTime(fecha_inicio, fecha_fin);
    console.log(result);
    res.status(200).json({ status: 'success', data: result });
  } catch (error) {
    console.error('Error executing reportAverageDiningTime function > ', error.stack);
    res.status(500).json({ status: 'error', message: 'Internal Server Error' });
  }
});

app.post('/report-complaints-by-person', async (req, res) => {
  const { fecha_inicio, fecha_fin } = req.body;

  try {
    const result = await reportComplaintsByPerson(fecha_inicio, fecha_fin);
    console.log(result);
    res.status(200).json({ status: 'success', data: result });
  } catch (error) {
    console.error('Error executing reportComplaintsByPerson function > ', error.stack);
    res.status(500).json({ status: 'error', message: 'Internal Server Error' });
  }
});

app.post('/report-complaints-by-dish', async (req, res) => {
  const { fecha_inicio, fecha_fin } = req.body;

  try {
    const result = await reportComplaintsByDish(fecha_inicio, fecha_fin);
    console.log(result);
    res.status(200).json({ status: 'success', data: result });
  } catch (error) {
    console.error('Error executing reportComplaintsByDish function > ', error.stack);
    res.status(500).json({ status: 'error', message: 'Internal Server Error' });
  }
});

app.get('/report-server-efficiency-last-6-months', async (req, res) => {
  try {
    const result = await reportServerEfficiencyLast6Months();
    console.log(result);
    res.status(200).json({ status: 'success', data: result });
  } catch (error) {
    console.error('Error executing reportServerEfficiencyLast6Months function > ', error.stack);
    res.status(500).json({ status: 'error', message: 'Internal Server Error' });
  }
});

app.post('/last-invoice', async (req, res) => {
  const { mesa_id } = req.body;
  try {
    const invoice = await getLastInvoiceByMesaId(mesa_id);
    console.log(invoice);
    if (invoice) {
      res.status(200).json({ status: 'success', data: invoice });
    } else {
      res.status(404).json({ status: 'fail', message: 'Invoice not found for this table' });
    }
  } catch (error) {
    console.error('Error fetching last invoice:', error);
    res.status(500).json({ status: 'error', message: 'Internal Server Error' });
  }
});

app.listen(port, () => {
  console.log(`Server listening at http://127.0.0.1:${port}`);
});
