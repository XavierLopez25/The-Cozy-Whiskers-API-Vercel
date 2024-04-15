
--Use only for subsequent runs
--DROP DATABASE the_cozy_whisker;

--Docker already does this line below:
--CREATE DATABASE the_cozy_whisker;

---SET TIMEZONE

SET timezone = 'America/Guatemala';



--Tables--
--Tables--
--Tables--
--Tables--
--Tables--
--Tables--


-- Table creation for 'Área'
CREATE TABLE Area (
    area_id SERIAL PRIMARY KEY,
    nombre TEXT,
    fumadores BOOL,
    mesaMovil BOOL
);

-- Table creation for 'Mesa'
CREATE TABLE Mesa (
    mesa_id SERIAL PRIMARY KEY,
    capacidadMesa INT,
    esMovil BOOL,
    area_id INT REFERENCES Area(area_id)
);

-- Table creation for 'Cuenta'
CREATE TABLE Cuenta (
    num_cuenta TEXT PRIMARY KEY,
	mesa_id INT REFERENCES Mesa(mesa_id),
    estado TEXT,
    fecha_inicio TIMESTAMP,
    fecha_fin TIMESTAMP,
    personas INT,
    cuenta_dividida BOOLEAN DEFAULT TRUE
);

-- Table creation for 'Empleado'
CREATE TABLE Empleado (
    empleado_id SERIAL PRIMARY KEY,
    nombre TEXT,
    rol TEXT,
    fechaEntrada TIMESTAMP
);

-- Table creation for 'Factura'
CREATE TABLE Factura (
    factura_id SERIAL PRIMARY KEY,
    cuenta_id TEXT REFERENCES Cuenta(num_cuenta),
    nit TEXT,
    direccion TEXT,
    nombre TEXT,
    fecha_emision TIMESTAMP
);


-- Table creation for 'Pago'
CREATE TABLE Pago (
    pago_id SERIAL PRIMARY KEY,
    factura_id INT REFERENCES Factura(factura_id),
    monto DECIMAL,
    tarjeta BOOL,
	efectivo BOOL
);

-- Table creation for 'PlatoBebida'
CREATE TABLE PlatoBebida (
    platoBebida_id SERIAL PRIMARY KEY,
    tipo TEXT,
    nombre TEXT,
    descripcion TEXT,
    precio DECIMAL,
    imagenLink TEXT
);

-- Table creation for 'Queja'
CREATE TABLE Queja (
    queja_id SERIAL PRIMARY KEY,
    nit TEXT,
    empleado_id INT REFERENCES Empleado(empleado_id),
    motivo TEXT,
    platoBebida_id INT REFERENCES PlatoBebida(platoBebida_id),
    clasificacion INT,
    fecha TIMESTAMP
);

-- Table creation for 'EncuestasSatisfaccion'
CREATE TABLE EncuestasSatisfaccion (
    encuesta_id SERIAL PRIMARY KEY,
    nit TEXT,
    empleado_id INT REFERENCES Empleado(empleado_id),
    amabilidad INT,
    exactitud INT,
    fecha TIMESTAMP,
    queja_id INT REFERENCES Queja(queja_id)
);

-- Table creation for 'Usuario'
CREATE TABLE Usuario (
    empleado_id INT REFERENCES Empleado(empleado_id),
    usuario TEXT,
    pwd_md5 TEXT
);

-- Table creation for 'Medida'
CREATE TABLE Medida (
    medida_id SERIAL PRIMARY KEY,
    tipo TEXT,
    descripcion TEXT
);

-- Table creation for 'MedidaComida'
CREATE TABLE MedidaComida (
    medC_id SERIAL PRIMARY KEY,
    platoBebida_id INT REFERENCES PlatoBebida(platoBebida_id),
    medida_id INT REFERENCES Medida(medida_id)
);

-- Table creation for 'Pedido'
CREATE TABLE Pedido (
    pedido_id SERIAL PRIMARY KEY,
    num_cuenta TEXT REFERENCES Cuenta(num_cuenta)
);

-- Table creation for 'DetallePedido'
CREATE TABLE DetallePedido (
    detalle_id SERIAL PRIMARY KEY,
    pedido_id INT REFERENCES Pedido(pedido_id),
    platoB_id INT REFERENCES PlatoBebida(platoBebida_id),
    cantidad INT,
    medidaC_id INT REFERENCES MedidaComida(medC_id),
    fecha_ordenado TIMESTAMP,
    Nota TEXT
);


--Needed Insertions--
--Needed Insertions--
--Needed Insertions--
--Needed Insertions--
--Needed Insertions--
--Needed Insertions--


-- Insert measures for 'Plato'
INSERT INTO Medida (tipo, descripcion) VALUES
('Plato', 'Pequeño'),
('Plato', 'Mediano'),
('Plato', 'Grande'),
('Bebida', 'Pequeño'),
('Bebida', 'Mediano'),
('Bebida', 'Grande');


-- Insert Foods and Drinks
INSERT INTO PlatoBebida (tipo, nombre, descripcion, precio, imagenLink) VALUES
('Plato', 'Sándwich de Bulgogi', 'Un delicioso y abundante sándwich con bulgogi.', 96.06, 'https://i.pinimg.com/564x/60/e0/df/60e0df6fdeb188512cb389676679386d.jpg'),
('Plato', 'Crepas de Kimchi y Queso', 'Crepas saladas rellenas de kimchi picante y queso derretido.', 34.67, 'https://i.pinimg.com/564x/24/51/65/245165ff896e88cd8f592c13b3d11396.jpg'),
('Plato', 'Tostada de Huevo al Vapor con Cebolla Verde', 'Huevo al vapor sobre una tostada ligera y esponjosa, cubierto con cebollas verdes.', 39.65, 'https://i.pinimg.com/564x/94/fa/08/94fa0814b8ce605e501243d972907f10.jpg'),
('Plato', 'Ensalada de Fideos Fríos Coreanos (Naengmyeon)', 'Una refrescante ensalada de fideos fríos con una salsa picante.', 46.46, 'https://i.pinimg.com/564x/18/c4/8b/18c48b58df913c37f9ee0e25544ae354.jpg'),
('Plato', 'Pastel de Arroz Inflado con Sésamo y Miel', 'Pastel de arroz crujiente endulzado con miel y espolvoreado con semillas de sésamo.', 97.11, 'https://i.pinimg.com/564x/7b/2b/98/7b2b986acf3c55b7807795bb94599c3a.jpg'),
('Plato', 'Sándwich de Pavo con Salsa Gochujang', 'Sándwich jugoso de pavo con una salsa gochujang picante.', 54.38, 'https://i.pinimg.com/564x/59/5f/3d/595f3dae391e2c0ce18909046c9eeef1.jpg'),
('Plato', 'Croissant de Matcha y Frijoles Rojos', 'Croissant hojaldrado relleno de matcha y pasta dulce de frijoles rojos.', 96.59, 'https://i.pinimg.com/564x/fa/1d/31/fa1d31242226ca5f2bf89c6e6c4a50a7.jpg'),
('Plato', 'Bowl de Açaí con Frutas y Nueces', 'Bowl nutritivo de açaí cubierto con frutas frescas y nueces.', 97.22, 'https://i.pinimg.com/564x/61/d0/52/61d0525e6197ac32cc724c651463418c.jpg'),
('Plato', 'Mini Pancakes de Patata Dulce', 'Mini pancakes esponjosos hechos con batata.', 51.6, 'https://i.pinimg.com/564x/e7/5c/be/e75cbe98f2da7ced0474cd7b82a58554.jpg'),
('Plato', 'Pastel de Mochi de Té Verde', 'Pastel de mochi de té verde suave y masticable.', 96.33, 'https://i.pinimg.com/564x/da/0e/2b/da0e2bf8a7d3140ea259abd40b0d1d37.jpg'),
('Bebida', 'Café Dalgona', 'Café Dalgona batido, cremoso y rico.', 14.1, 'https://i.pinimg.com/564x/9e/e2/84/9ee2846b3085976e24d33655e43443f2.jpg'),
('Bebida', 'Té de Cereza Blossom', 'Té de flor de cerezo fragante, ligero y refrescante.', 38.71, 'https://i.pinimg.com/564x/3b/ca/ca/3bcacae54182a64dd02fc3ba95b9657b.jpg'),
('Bebida', 'Smoothie de Melón Coreano', 'Smoothie dulce y cremoso de melón coreano.', 32.3, 'https://i.pinimg.com/564x/95/92/65/95926532427bcee959f210cbcb5d6633.jpg'),
('Bebida', 'Latte de Taro Morado', 'Latte de taro morado suave y cremoso.', 45.63, 'https://i.pinimg.com/564x/5a/c3/d8/5ac3d8cc86c7c8df2abed2562963d0f4.jpg'),
('Bebida', 'Boba de Té Negro con Miel', 'Té negro clásico con miel y perlas de tapioca.', 37.52, 'https://i.pinimg.com/564x/43/17/c3/4317c3a2ca1f923b43d6d03e98b87351.jpg'),
('Bebida', 'Frappé de Café con Caramelo y Soja', 'Frappé de café helado con caramelo y un toque de soja.', 30.88, 'https://i.pinimg.com/564x/01/06/46/010646301747e2a765574b2415049621.jpg'),
('Bebida', 'Té Verde Frío con Limón y Jengibre', 'Refrescante té verde frío con limón y jengibre.', 10.41, 'https://i.pinimg.com/564x/ad/2b/b0/ad2bb02d518fc5158ad0a951b7d167cb.jpg'),
('Bebida', 'Smoothie de Arándanos y Yogur', 'Smoothie cremoso de yogur con arándanos frescos.', 11.92, 'https://i.pinimg.com/564x/69/76/f6/6976f625854b176bef23360a8771e244.jpg'),
('Bebida', 'Latte de Matcha con Espuma de Leche', 'Latte de matcha rico con espuma de leche.', 32.12, 'https://i.pinimg.com/564x/1a/16/86/1a1686ab7184012f7b5ae97ea10c7085.jpg'),
('Bebida', 'Sangría de Té Blanco y Frutas', 'Sangría ligera y afrutada de té blanco.', 11.81, 'https://i.pinimg.com/564x/c9/3f/7d/c93f7d4686fe511840584659f59b75a6.jpg');


-- Association for platos with medidas 'pequeño', 'mediano', 'grande' (IDs 1, 2, 3)
INSERT INTO MedidaComida (platoBebida_id, medida_id) VALUES
(1, 1), (1, 2), (1, 3),
(2, 1), (2, 2), (2, 3),
(3, 1), (3, 2), (3, 3),
(4, 1), (4, 2), (4, 3),
(5, 1), (5, 2), (5, 3),
(6, 1), (6, 2), (6, 3),
(7, 1), (7, 2), (7, 3),
(8, 1), (8, 2), (8, 3),
(9, 1), (9, 2), (9, 3),
(10, 1), (10, 2), (10, 3);

INSERT INTO MedidaComida (platoBebida_id, medida_id) VALUES
(11, 4), (11, 5), (11, 6),
(12, 4), (12, 5), (12, 6),
(13, 4), (13, 5), (13, 6),
(14, 4), (14, 5), (14, 6),
(15, 4), (15, 5), (15, 6),
(16, 4), (16, 5), (16, 6),
(17, 4), (17, 5), (17, 6),
(18, 4), (18, 5), (18, 6),
(19, 4), (19, 5), (19, 6),
(20, 4), (20, 5), (20, 6);


-- Insert Areas
INSERT INTO Area (nombre, fumadores, mesaMovil) VALUES
('Patio Exterior', TRUE, TRUE),
('Sala Principal', FALSE, FALSE),
('Terraza', TRUE, TRUE),
('Jardín', FALSE, TRUE),
('Salón VIP', FALSE, FALSE),
('Barra', FALSE, TRUE),
('Balcón', TRUE, FALSE),
('Área de Descanso', FALSE, TRUE),
('Salón de Eventos', FALSE, FALSE),
('Terraza VIP', FALSE, TRUE);



-- Mesas for 'Patio Exterior' (area_id = 1)
INSERT INTO Mesa (capacidadMesa, esMovil, area_id) VALUES
(4, TRUE, 1),
(2, FALSE, 1),
(6, TRUE, 1),
(4, FALSE, 1),
(8, TRUE, 1);

-- Mesas for 'Sala Principal' (area_id = 2)
INSERT INTO Mesa (capacidadMesa, esMovil, area_id) VALUES
(4, FALSE, 2),
(6, FALSE, 2),
(8, FALSE, 2),
(10, FALSE, 2),
(2, FALSE, 2);

-- Mesas for 'Terraza' (area_id = 3)
INSERT INTO Mesa (capacidadMesa, esMovil, area_id) VALUES
(2, TRUE, 3),
(4, TRUE, 3),
(6, FALSE, 3),
(8, TRUE, 3),
(10, FALSE, 3);

-- Mesas for 'Jardín' (area_id = 4)
INSERT INTO Mesa (capacidadMesa, esMovil, area_id) VALUES
(2, TRUE, 4),
(4, TRUE, 4),
(6, TRUE, 4),
(8, TRUE, 4),
(10, FALSE, 4);

-- Mesas for 'Salón VIP' (area_id = 5)
INSERT INTO Mesa (capacidadMesa, esMovil, area_id) VALUES
(2, FALSE, 5),
(4, FALSE, 5),
(6, FALSE, 5),
(8, FALSE, 5),
(10, FALSE, 5);

-- Mesas for 'Barra' (area_id = 6)
INSERT INTO Mesa (capacidadMesa, esMovil, area_id) VALUES
(1, TRUE, 6),
(2, TRUE, 6),
(3, TRUE, 6),
(4, TRUE, 6),
(5, TRUE, 6);

-- Mesas for 'Balcón' (area_id = 7)
INSERT INTO Mesa (capacidadMesa, esMovil, area_id) VALUES
(2, FALSE, 7),
(4, FALSE, 7),
(6, FALSE, 7),
(2, FALSE, 7),
(4, FALSE, 7);

-- Mesas for 'Área de Descanso' (area_id = 8)
INSERT INTO Mesa (capacidadMesa, esMovil, area_id) VALUES
(2, TRUE, 8),
(4, TRUE, 8),
(2, TRUE, 8),
(4, TRUE, 8),
(6, TRUE, 8);

-- Mesas for 'Salón de Eventos' (area_id = 9)
INSERT INTO Mesa (capacidadMesa, esMovil, area_id) VALUES
(8, FALSE, 9),
(10, FALSE, 9),
(12, FALSE, 9),
(14, FALSE, 9),
(16, FALSE, 9);

-- Mesas for Cafetería (area_id = 10)
INSERT INTO Mesa (capacidadMesa, esMovil, area_id) VALUES
(2, TRUE, 10),
(4, TRUE, 10),
(6, TRUE, 10),
(8, TRUE, 10),
(10, TRUE, 10);



---Functions---
---Functions---
---Functions---
---Functions---
---Functions---
---Functions---


--USER LOGIN
CREATE OR REPLACE FUNCTION user_login(p_username VARCHAR, p_password VARCHAR)
RETURNS SETOF Usuario AS
$$
BEGIN
  RETURN QUERY SELECT * FROM Usuario WHERE usuario = p_username AND pwd_md5 = MD5(p_password);
END;
$$ LANGUAGE plpgsql;

--USER REGISTER
CREATE OR REPLACE FUNCTION register_new_employee(_name TEXT, _role TEXT, _startDate DATE, _username TEXT, _password TEXT)
RETURNS INT AS $$
DECLARE
  _employeeId INT;
BEGIN
  INSERT INTO Empleado (nombre, rol, fechaEntrada)
  VALUES (_name, _role, _startDate)
  RETURNING empleado_id INTO _employeeId;
  
  INSERT INTO Usuario (empleado_id, usuario, pwd_md5)
  VALUES (_employeeId, _username, MD5(_password));
  
  RETURN _employeeId;
END;
$$ LANGUAGE plpgsql;

--Add Administator
SELECT register_new_employee('Administrator'::TEXT, 'Administrator'::TEXT, '2024-04-08'::DATE, 'Admin'::TEXT, '1234'::TEXT) AS empleado_id;


CREATE OR REPLACE FUNCTION generate_factura(
    mesa_id_arg INT,
    nit_arg TEXT,
    direccion_arg TEXT,
    nombre_arg TEXT,
    total_pedido DECIMAL,
    persons_quantity INT
)
RETURNS INT AS $$
DECLARE
    num_cuenta_var TEXT;
    factura_id_generated INT;
BEGIN
    -- Fetch the num_cuenta associated with the given mesa_id
    SELECT num_cuenta INTO num_cuenta_var
    FROM Cuenta
    WHERE mesa_id = mesa_id_arg AND estado = 'Abierta'
    ORDER BY fecha_inicio DESC
    LIMIT 1;

    -- Check if a num_cuenta has been found
    IF num_cuenta_var IS NULL THEN
        RAISE EXCEPTION 'No active Cuenta found for mesa_id %.', mesa_id_arg;
    END IF;

    -- Insert a new record into the Factura table using the fetched num_cuenta
    INSERT INTO Factura(cuenta_id, nit, direccion, nombre, fecha_emision)
    VALUES (num_cuenta_var, nit_arg, direccion_arg, nombre_arg, NOW())
    RETURNING factura_id INTO factura_id_generated;

    -- Return the generated factura_id
    RETURN factura_id_generated;
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION generate_pagos(
    factura_id_arg INT, 
    total_pedido DECIMAL, 
    persons_quantity INT, 
    split_payment BOOLEAN, 
    efectivo BOOLEAN, 
    tarjeta BOOLEAN
)
RETURNS VOID AS $$
DECLARE
    amount_per_person NUMERIC;
BEGIN
    IF split_payment THEN
        -- When splitting the payment, divide total_pedido by persons_quantity
        amount_per_person := total_pedido / persons_quantity;
        
        -- Generate individual Pagos for each person
        FOR i IN 1..persons_quantity LOOP
            INSERT INTO Pago(factura_id, monto, tarjeta, efectivo)
            VALUES (factura_id_arg, amount_per_person, tarjeta, efectivo);
        END LOOP;
    ELSE
        -- If not splitting, create one Pago with the total amount
        INSERT INTO Pago(factura_id, monto, tarjeta, efectivo)
        VALUES (factura_id_arg, total_pedido, tarjeta, efectivo);
    END IF;
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION calculate_order_details_for_latest_order(mesa_id_arg INT)
RETURNS TABLE(platoBebida_id INT, platoBebidaNombre TEXT, precio_unitario DECIMAL, cantidad INT, subtotal DECIMAL) AS $$
DECLARE
    num_cuenta_var TEXT;
BEGIN
    -- Obtener el num_cuenta con la fecha de cierre más reciente para la mesa_id dada
    SELECT num_cuenta INTO num_cuenta_var
    FROM Cuenta
    WHERE mesa_id = mesa_id_arg AND estado = 'Cerrada'
    ORDER BY fecha_fin DESC
    LIMIT 1;

    IF num_cuenta_var IS NULL THEN
        RAISE EXCEPTION 'No closed Cuenta found for mesa_id %.', mesa_id_arg;
    END IF;
    
    -- Calcula los detalles del pedido para el num_cuenta obtenido
    RETURN QUERY 
    SELECT pb.platoBebida_id, pb.nombre, pb.precio, dp.cantidad, (dp.cantidad * pb.precio) as subtotal
    FROM DetallePedido dp
    JOIN Pedido p ON dp.pedido_id = p.pedido_id
    JOIN PlatoBebida pb ON dp.platoB_id = pb.platoBebida_id
    WHERE p.num_cuenta = num_cuenta_var
    ORDER BY pb.platoBebida_id;
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION fetch_detalle_by_tipo(tipo_comida TEXT)
RETURNS TABLE(
    detalle_id INT, 
    pedido_id INT, 
    platoB_id INT, 
    cantidad INT, 
    medidaC_id INT, 
    fecha_ordenado TIMESTAMP, 
    Nota TEXT, 
    imagenLink TEXT, 
    descripcion_medida TEXT,
    nombre_comida TEXT
) AS $$
BEGIN
    IF tipo_comida NOT IN ('Plato', 'Bebida') THEN
        RAISE EXCEPTION 'Invalid tipo_comida. Must be ''Plato'' or ''Bebida''.';
    END IF;

    RETURN QUERY 
    SELECT 
        d.detalle_id, 
        d.pedido_id, 
        d.platoB_id, 
        d.cantidad, 
        d.medidaC_id, 
        d.fecha_ordenado, 
        d.Nota, 
        pb.imagenLink, 
        m.descripcion AS descripcion_medida, 
        pb.nombre AS nombre_comida
    FROM DetallePedido d
    INNER JOIN Pedido p ON d.pedido_id = p.pedido_id
    INNER JOIN Cuenta c ON p.num_cuenta = c.num_cuenta
    INNER JOIN PlatoBebida pb ON d.platoB_id = pb.platoBebida_id
    INNER JOIN MedidaComida mc ON d.medidaC_id = mc.medC_id
    INNER JOIN Medida m ON mc.medida_id = m.medida_id
    WHERE pb.tipo = tipo_comida AND c.estado = 'Abierta'
    ORDER BY d.fecha_ordenado ASC;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION get_empleado_id_by_username_password(_username TEXT, _password TEXT)
RETURNS INT AS $$
DECLARE
    found_empleado_id INT;
BEGIN
    -- Example without password hashing
    -- In production, compare hashed passwords instead
    SELECT empleado_id INTO found_empleado_id
    FROM Usuario
    WHERE usuario = _username AND pwd_md5 = md5(_password); -- Replace _password with the hash function if using hashed passwords

    -- Return the found empleado_id, or NULL if no match was found
    RETURN found_empleado_id;
EXCEPTION WHEN NO_DATA_FOUND THEN
    -- Return NULL if no employee matches the username and password
    RETURN NULL;
END;
$$ LANGUAGE plpgsql STRICT SECURITY DEFINER;


CREATE OR REPLACE FUNCTION report_most_ordered_dishes(fecha_inicio DATE, fecha_final DATE)
RETURNS TABLE(platoB_id INT, nombre TEXT, cantidad_pedidos INT) AS $$
BEGIN
    RETURN QUERY 
    SELECT dp.platoB_id, pb.nombre, COUNT(*)::INT AS cantidad_pedidos
    FROM DetallePedido dp
    JOIN Pedido p ON dp.pedido_id = p.pedido_id
    JOIN PlatoBebida pb ON dp.platoB_id = pb.platoBebida_id
    WHERE dp.fecha_ordenado BETWEEN fecha_inicio AND fecha_final
    GROUP BY dp.platoB_id, pb.nombre
    ORDER BY cantidad_pedidos DESC;
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION report_most_orders_time_slot(fecha_inicio DATE, fecha_final DATE)
RETURNS TABLE(hora INT, cantidad_pedidos INT) AS $$
BEGIN
    RETURN QUERY 
    SELECT EXTRACT(HOUR FROM dp.fecha_ordenado)::INT AS hora, COUNT(*)::INT AS cantidad_pedidos
    FROM Pedido p
    JOIN DetallePedido dp ON p.pedido_id = dp.pedido_id
    WHERE dp.fecha_ordenado BETWEEN fecha_inicio AND fecha_final
    GROUP BY hora
    ORDER BY cantidad_pedidos DESC
    LIMIT 1;
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION report_average_dining_time(_fecha_inicio DATE, _fecha_final DATE)
RETURNS TABLE(personas INT, tiempo_promedio INTERVAL) AS $$
BEGIN
    RETURN QUERY 
    SELECT cuenta.personas, AVG(cuenta.fecha_fin - cuenta.fecha_inicio) AS tiempo_promedio
    FROM Cuenta
    WHERE cuenta.fecha_inicio BETWEEN _fecha_inicio AND _fecha_final
      AND cuenta.fecha_fin IS NOT NULL
    GROUP BY cuenta.personas
    ORDER BY cuenta.personas;
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION report_complaints_by_person(fecha_inicio DATE, fecha_final DATE)
RETURNS TABLE(nit TEXT, total_quejas INT) AS $$
BEGIN
    RETURN QUERY 
    SELECT q.nit, COUNT(*)::INT AS total_quejas
    FROM Queja q
    WHERE fecha BETWEEN fecha_inicio AND fecha_final
    GROUP BY q.nit
    ORDER BY total_quejas DESC;
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION report_complaints_by_dish(fecha_inicio DATE, fecha_final DATE)
RETURNS TABLE(platoBebida_id INT, nombre TEXT, total_quejas INT) AS $$
BEGIN
    RETURN QUERY 
    SELECT Queja.platoBebida_id, pb.nombre, COUNT(*)::INT AS total_quejas
    FROM Queja
    JOIN PlatoBebida pb ON Queja.platoBebida_id = pb.platoBebida_id
    WHERE fecha BETWEEN fecha_inicio AND fecha_final
    GROUP BY Queja.platoBebida_id, pb.nombre
    ORDER BY total_quejas DESC;
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION report_server_efficiency_last_6_months()
RETURNS TABLE(año INT, mes INT, empleado_id INT, prom_amabilidad NUMERIC, prom_exactitud NUMERIC) AS $$
BEGIN
    RETURN QUERY 
    SELECT EXTRACT(YEAR FROM fecha)::INT AS año, EXTRACT(MONTH FROM fecha)::INT AS mes, EncuestasSatisfaccion.empleado_id, AVG(amabilidad) AS prom_amabilidad, AVG(exactitud) AS prom_exactitud
    FROM EncuestasSatisfaccion
    WHERE fecha >= NOW() - INTERVAL '6 months'
    GROUP BY EXTRACT(YEAR FROM fecha), EXTRACT(MONTH FROM fecha), EncuestasSatisfaccion.empleado_id
    ORDER BY año, mes, EncuestasSatisfaccion.empleado_id;
END;
$$ LANGUAGE plpgsql;

---Procedures---
---Procedures---
---Procedures---
---Procedures---
---Procedures---
---Procedures---

CREATE OR REPLACE PROCEDURE insert_new_cuenta(mesa_id_arg int, personas_arg int)
LANGUAGE plpgsql
AS $$
DECLARE
  new_num_cuenta TEXT;
BEGIN
  	SELECT INTO new_num_cuenta COALESCE(MAX(CAST(num_cuenta AS INTEGER)), 0) + 1 FROM public.cuenta;
  
  	INSERT INTO public.cuenta(num_cuenta, mesa_id, estado, fecha_inicio, personas)
	VALUES (CAST(new_num_cuenta AS TEXT), mesa_id_arg, 'Abierta', NOW(), personas_arg);
	RAISE NOTICE 'Cuenta Creada para la mesa %', mesa_id_arg;

END;
$$;


CREATE OR REPLACE PROCEDURE close_cuenta(mesa_id_arg INT, nit_arg TEXT, direccion_arg TEXT, nombre_arg TEXT, _efectivo BOOLEAN, _tarjeta BOOLEAN)
LANGUAGE plpgsql
AS $$
DECLARE
    num_cuenta_var TEXT;
    factura_id_generated INT;
    total_pedido DECIMAL;
    persons_quantity INT;
    split_payment BOOLEAN;
BEGIN
    -- Fetch the num_cuenta and relevant details based on the provided mesa_id_arg
    SELECT num_cuenta, personas, cuenta_dividida INTO num_cuenta_var, persons_quantity, split_payment
    FROM Cuenta
    WHERE mesa_id = mesa_id_arg AND estado = 'Abierta'
    ORDER BY fecha_inicio DESC
    LIMIT 1;
    
    IF num_cuenta_var IS NULL THEN
        RAISE EXCEPTION 'No active Cuenta found for mesa_id %.', mesa_id_arg;
    END IF;

    -- Calculate total_pedido for the specified Cuenta (if applicable)
    SELECT SUM(dp.cantidad * pb.precio) INTO total_pedido
    FROM DetallePedido dp
    JOIN Pedido p ON dp.pedido_id = p.pedido_id
    JOIN PlatoBebida pb ON dp.platoB_id = pb.platoBebida_id
    WHERE p.num_cuenta = num_cuenta_var;

    total_pedido := total_pedido + (total_pedido * 0.10);

    -- Generate factura
    factura_id_generated := generate_factura(mesa_id_arg, nit_arg, direccion_arg, nombre_arg, total_pedido, persons_quantity);

    -- Close the Cuenta
    UPDATE Cuenta SET estado = 'Cerrada', fecha_fin = NOW() WHERE num_cuenta = num_cuenta_var;

    -- Generate Pagos based on split_payment and persons_quantity
    PERFORM generate_pagos(factura_id_generated, total_pedido, persons_quantity, split_payment, _efectivo, _tarjeta);

    RAISE NOTICE 'Cuenta % closed, Factura ID: % generated.', num_cuenta_var, factura_id_generated;
END;
$$;


CREATE OR REPLACE PROCEDURE create_pedido_and_detalle_with_mesa_id(
    mesa_id_arg INT, 
    platoB_id_arg INT, 
    cantidad_arg INT, 
    medidaC_id_arg INT, 
    nota_arg TEXT
)
LANGUAGE plpgsql
AS $$
DECLARE
  num_cuenta_var TEXT;
  pedido_id INT;
BEGIN
  -- Buscar la última cuenta abierta para la mesa_id dada
  SELECT num_cuenta INTO num_cuenta_var
  FROM Cuenta
  WHERE mesa_id = mesa_id_arg AND estado = 'Abierta'
  ORDER BY fecha_inicio DESC
  LIMIT 1;

  -- Si no existe tal cuenta, crear una nueva
  IF num_cuenta_var IS NULL THEN
    SELECT INTO num_cuenta_var COALESCE(MAX(CAST(num_cuenta AS INTEGER)), 0) + 1 FROM Cuenta;
    INSERT INTO Cuenta(num_cuenta, mesa_id, estado, fecha_inicio, personas)
    VALUES (num_cuenta_var, mesa_id_arg, 'Abierta', NOW(), 1);
  END IF;
  
  -- Verificar si existe un Pedido para esta cuenta. Si no, crear uno nuevo.
  SELECT Pedido.pedido_id INTO pedido_id FROM Pedido WHERE num_cuenta = num_cuenta_var LIMIT 1;
  IF pedido_id IS NULL THEN
    INSERT INTO Pedido(num_cuenta) VALUES (num_cuenta_var) RETURNING Pedido.pedido_id INTO pedido_id;
  END IF;
  
  -- Insertar en DetallePedido
  INSERT INTO DetallePedido(pedido_id, platoB_id, cantidad, medidaC_id, fecha_ordenado, Nota) 
  VALUES (pedido_id, platoB_id_arg, cantidad_arg, medidaC_id_arg, NOW(), nota_arg);
  
  RAISE NOTICE 'DetallePedido added for Pedido ID: %', pedido_id;
END;
$$;


CREATE OR REPLACE PROCEDURE submit_queja_encuesta(
    nit_arg TEXT,
    empleado_id_arg INT,
    empleado_id_arg_sat INT,
    platoBebida_id_arg INT,
    motivo_arg TEXT,
    clasificacion_arg INT,
    amabilidad_arg INT,
    exactitud_arg INT
) LANGUAGE plpgsql AS $$
DECLARE
    new_queja_id INT;
BEGIN
    -- Insert into Queja
    INSERT INTO Queja(nit, empleado_id, platoBebida_id, motivo, clasificacion, fecha)
    VALUES (nit_arg, 
            NULLIF(empleado_id_arg, 0), -- Assuming 0 indicates no employee involved
            NULLIF(platoBebida_id_arg, 0), -- Assuming 0 indicates no Plato/Bebida involved
            motivo_arg, 
            clasificacion_arg, 
            CURRENT_TIMESTAMP)
    RETURNING queja_id INTO new_queja_id;

    -- Insert into EncuestasSatisfaccion linking the new Queja
    INSERT INTO EncuestasSatisfaccion(nit, empleado_id, amabilidad, exactitud, fecha, queja_id)
    VALUES (nit_arg, 
            NULLIF(empleado_id_arg_sat, 0), -- Assuming 0 indicates no employee to rate, adjust as needed
            amabilidad_arg, 
            exactitud_arg, 
            CURRENT_TIMESTAMP,
            new_queja_id);
EXCEPTION WHEN OTHERS THEN
    RAISE;
END;
$$;
