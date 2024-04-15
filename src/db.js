import conn from './conn.js';

//Get all tables
export async function getAllTables() {
  const result = await conn.query(
    `SELECT * FROM Factura f JOIN Cuenta c ON f.cuenta_id = c.num_cuenta WHERE c.mesa_id = 1 ORDER BY f.fecha_emision DESC LIMIT 1;;`,
  );
  return result.rows;
}

export async function loginUser(username, password) {
  const result = await conn.query(`SELECT usuario, pwd_md5 FROM user_login($1::TEXT, $2::TEXT);`, [
    username,
    password,
  ]);
  return result;
}

export async function registerNewEmployee(name, role, startDate, username, password) {
  const result = await conn.query(
    `SELECT * FROM register_new_employee($1::TEXT, $2::TEXT, $3::DATE, $4::TEXT, $5::TEXT);`,
    [name, role, startDate, username, password],
  );
  return result.rows;
}

export async function getRoleName(username, password) {
  const result = await conn.query(
    `SELECT e.empleado_id, e.nombre, e.rol FROM Empleado e INNER JOIN Usuario u ON e.empleado_id = u.empleado_id WHERE u.usuario = $1 AND u.pwd_md5 = MD5($2);`,
    [username, password],
  );

  return result;
}

export async function listEmployees() {
  const result = await conn.query(`SELECT empleado_id, nombre, rol FROM Empleado;`);
  return result.rows;
}

export async function insertNewCuenta(mesaId, personas) {
  await conn.query(`CALL insert_new_cuenta($1::INT, $2::INT);`, [mesaId, personas]);
}

export async function closeCuenta(mesaId, nit, dir, nombre, efectivo, tarjeta) {
  await conn.query(
    `CALL close_cuenta($1::INT, $2::TEXT, $3::TEXT, $4::TEXT, $5::BOOLEAN, $6::BOOLEAN);`,
    [mesaId, nit, dir, nombre, efectivo, tarjeta],
  );
}

export async function getFoodByType(type) {
  const result = await conn.query(`SELECT * FROM PlatoBebida WHERE tipo = $1;`, [type]);
  return result.rows;
}

export async function getFoodPlates() {
  const result = await conn.query(`SELECT * FROM PlatoBebida;`);
  return result.rows;
}

export async function getFoodById(id) {
  const result = await conn.query(`SELECT nombre FROM PlatoBebida WHERE platobebida_id = $1;`, [
    id,
  ]);
  return result.rows;
}

export async function getDetallePedidoByMesaId(mesa_id) {
  const result = await conn.query(
    `SELECT dp.*, pb.imagenLink, m.descripcion AS medidaDescripcion
    FROM DetallePedido dp
    JOIN Pedido p ON dp.pedido_id = p.pedido_id
    JOIN Cuenta c ON p.num_cuenta = c.num_cuenta
    LEFT JOIN PlatoBebida pb ON dp.platoB_id = pb.platoBebida_id
    LEFT JOIN Medida m ON dp.medidaC_id = m.medida_id
    WHERE c.mesa_id = $1 AND c.estado = 'Abierta';`,
    [mesa_id],
  );
  return result.rows;
}

export async function getFoodMeasures(comida_nombre, tamaño) {
  const result = await conn.query(
    `SELECT MC.medC_id AS medidaC_id
     FROM MedidaComida MC
     INNER JOIN PlatoBebida PB ON MC.platoBebida_id = PB.platoBebida_id
     INNER JOIN Medida M ON MC.medida_id = M.medida_id
     WHERE PB.nombre = $1 AND M.descripcion = $2;`,
    [comida_nombre, tamaño],
  );
  return result.rows;
}

export async function fetchAllOrders(tipo_comida) {
  const result = await conn.query(`SELECT * FROM fetch_detalle_by_tipo($1::TEXT);`, [tipo_comida]);
  return result.rows;
}

export async function createOrder(
  mesa_id_arg,
  platoB_id_arg,
  cantidad_arg,
  medidaC_id_arg,
  nota_arg,
) {
  await conn.query(
    `CALL create_pedido_and_detalle_with_mesa_id($1::INT, $2::INT, $3::INT, $4::INT, $5::TEXT);`,
    [mesa_id_arg, platoB_id_arg, cantidad_arg, medidaC_id_arg, nota_arg],
  );
}

export async function fetchOrderCheckout(mesa_id_arg) {
  const result = await conn.query(
    `SELECT * FROM calculate_order_details_for_latest_order($1::INT);`,
    [mesa_id_arg],
  );
  return result.rows;
}

export async function fetchTotalFinalOrder(mesa_id_arg) {
  const result = await conn.query(
    `SELECT SUM(subtotal) * 1.10 AS total_final FROM calculate_order_details_for_latest_order($1::INT);`,
    [mesa_id_arg],
  );
  return result.rows;
}

export async function fetchIndividualPayments(mesa_id_arg) {
  const result = await conn.query(
    `SELECT monto FROM Pago WHERE Pago.factura_id = (SELECT factura_id FROM Factura WHERE cuenta_id = (SELECT num_cuenta FROM Cuenta WHERE mesa_id = $1 AND estado = 'Cerrada' ORDER BY fecha_fin DESC LIMIT 1) ORDER BY fecha_emision DESC LIMIT 1)`,
    [mesa_id_arg],
  );
  return result.rows;
}

export async function getAvailableMesas() {
  const result = await conn.query(
    `SELECT mesa_id, esmovil, Area.nombre, capacidadmesa AS nombre_area FROM Mesa INNER JOIN Area ON Mesa.area_id = Area.area_id WHERE NOT EXISTS (SELECT 1 FROM Cuenta WHERE Cuenta.mesa_id = Mesa.mesa_id AND Cuenta.estado = 'Abierta');`,
  );
  return result.rows;
}

export async function getOccupiedMesas() {
  const result = await conn.query(
    `SELECT mesa_id, esmovil, Area.nombre, capacidadmesa AS nombre_area FROM Mesa INNER JOIN Area ON Mesa.area_id = Area.area_id WHERE EXISTS (SELECT 1 FROM Cuenta WHERE Cuenta.mesa_id = Mesa.mesa_id AND Cuenta.estado = 'Abierta');`,
  );
  return result.rows;
}

export async function submitQuejaEncuesta(
  nit_arg,
  empleado_id_arg,
  empleado_id_arg_sat,
  platoBebida_id_arg,
  motivo_arg,
  clasificacion_arg,
  amabilidad_arg,
  exactitud_arg,
) {
  await conn.query(
    `CALL submit_queja_encuesta($1::TEXT, $2::INT, $3::INT, $4::INT, $5::TEXT, $6::INT, $7::INT, $8::INT);`,
    [
      nit_arg,
      empleado_id_arg,
      empleado_id_arg_sat,
      platoBebida_id_arg,
      motivo_arg,
      clasificacion_arg,
      amabilidad_arg,
      exactitud_arg,
    ],
  );
}

export async function reportMostOrderedDishes(fecha_inicio, fecha_fin) {
  const result = await conn.query(`SELECT * FROM report_most_ordered_dishes($1::DATE, $2::DATE);`, [
    fecha_inicio,
    fecha_fin,
  ]);
  return result.rows;
}

export async function reportMostOrdersTimeSlot(fecha_inicio, fecha_fin) {
  const result = await conn.query(
    `SELECT * FROM report_most_orders_time_slot($1::DATE, $2::DATE);`,
    [fecha_inicio, fecha_fin],
  );
  return result.rows;
}

export async function reportAverageDiningTime(fecha_inicio, fecha_fin) {
  const result = await conn.query(`SELECT * FROM report_average_dining_time($1::DATE, $2::DATE);`, [
    fecha_inicio,
    fecha_fin,
  ]);
  return result.rows;
}

export async function reportComplaintsByPerson(fecha_inicio, fecha_fin) {
  const result = await conn.query(
    `SELECT * FROM report_complaints_by_person($1::DATE, $2::DATE);`,
    [fecha_inicio, fecha_fin],
  );
  return result.rows;
}

export async function reportComplaintsByDish(fecha_inicio, fecha_fin) {
  const result = await conn.query(`SELECT * FROM report_complaints_by_dish($1::DATE, $2::DATE);`, [
    fecha_inicio,
    fecha_fin,
  ]);
  return result.rows;
}

export async function reportServerEfficiencyLast6Months() {
  const result = await conn.query(`SELECT * FROM report_server_efficiency_last_6_months();`);
  return result.rows;
}

export async function getLastInvoiceByMesaId(mesa_id) {
  const result = await conn.query(
    `SELECT *, Pago.tarjeta, Pago.efectivo FROM Factura f JOIN Cuenta c ON f.cuenta_id = c.num_cuenta INNER JOIN Pago ON Pago.factura_id = f.factura_id WHERE c.mesa_id = $1 ORDER BY f.fecha_emision DESC LIMIT 1;`,
    [mesa_id],
  );
  return result.rows[0];
}

//SELECT table_name FROM information_schema.tables WHERE table_schema = 'public'
