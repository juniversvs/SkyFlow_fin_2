CREATE DATABASE skyflow;
USE skyflow;
-- ======================
-- USUARIOS
-- ======================
CREATE TABLE usuarios (
   id BIGINT AUTO_INCREMENT PRIMARY KEY,
   nombre VARCHAR(100) NOT NULL,
   apellido VARCHAR(100) NOT NULL,
   correo VARCHAR(150) NOT NULL UNIQUE,
   password VARCHAR(255) NOT NULL,
   fecha_registro TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
-- ======================
-- PROYECTOS
-- ======================
CREATE TABLE proyectos (
   id BIGINT AUTO_INCREMENT PRIMARY KEY,
   nombre VARCHAR(150) NOT NULL,
   descripcion TEXT,
   fecha_inicio DATE NOT NULL,
   fecha_fin DATE NOT NULL,
   estado ENUM('PENDIENTE','COMPLETADO')
   DEFAULT 'PENDIENTE',
   fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
-- ======================
-- MIEMBROS DEL PROYECTO
-- ======================
CREATE TABLE miembros_proyecto (
   id BIGINT AUTO_INCREMENT PRIMARY KEY,
   proyecto_id BIGINT NOT NULL,
   usuario_id BIGINT NOT NULL,
   rol ENUM('LIDER','SUBORDINADO') NOT NULL,
   fecha_union TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
   CONSTRAINT fk_mp_proyecto
       FOREIGN KEY (proyecto_id)
       REFERENCES proyectos(id)
       ON DELETE CASCADE,
   CONSTRAINT fk_mp_usuario
       FOREIGN KEY (usuario_id)
       REFERENCES usuarios(id)
       ON DELETE CASCADE,
   UNIQUE (proyecto_id, usuario_id)
);
-- ======================
-- TAREAS
-- ======================
CREATE TABLE tareas (
   id BIGINT AUTO_INCREMENT PRIMARY KEY,
   proyecto_id BIGINT NOT NULL,
   titulo VARCHAR(200) NOT NULL,
   descripcion TEXT,
   fecha_inicio DATE NOT NULL,
   fecha_fin DATE NOT NULL,
   prioridad ENUM('BAJA','MEDIA','ALTA') NOT NULL,
   estado ENUM('PENDIENTE','COMPLETADA')
   DEFAULT 'PENDIENTE',
   fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
   CONSTRAINT fk_tarea_proyecto
       FOREIGN KEY (proyecto_id)
       REFERENCES proyectos(id)
       ON DELETE CASCADE
);
-- ======================
-- NOTAS DEL PROYECTO
-- ======================
CREATE TABLE notas_proyecto (
   id BIGINT AUTO_INCREMENT PRIMARY KEY,
   proyecto_id BIGINT NOT NULL,
   usuario_id BIGINT NOT NULL,
   contenido TEXT NOT NULL,
   fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
   CONSTRAINT fk_np_proyecto
       FOREIGN KEY (proyecto_id)
       REFERENCES proyectos(id)
       ON DELETE CASCADE,
   CONSTRAINT fk_np_usuario
       FOREIGN KEY (usuario_id)
       REFERENCES usuarios(id)
       ON DELETE CASCADE
);
-- ======================
-- NOTAS DE TAREAS
-- ======================
CREATE TABLE notas_tarea (
   id BIGINT AUTO_INCREMENT PRIMARY KEY,
   tarea_id BIGINT NOT NULL,
   usuario_id BIGINT NOT NULL,
   contenido TEXT NOT NULL,
   fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
   CONSTRAINT fk_nt_tarea
       FOREIGN KEY (tarea_id)
       REFERENCES tareas(id)
       ON DELETE CASCADE,
   CONSTRAINT fk_nt_usuario
       FOREIGN KEY (usuario_id)
       REFERENCES usuarios(id)
       ON DELETE CASCADE
);

-- ======================
-- USUARIOS (password en texto plano, como lo valida el login actual)
-- ======================
INSERT INTO usuarios (id, nombre, apellido, correo, password, fecha_registro) VALUES
(1, 'Carlos',  'Ramirez',  'carlos@skyflow.com',  '1234', '2026-08-01 09:00:00'),
(2, 'Lucia',   'Fernandez','lucia@skyflow.com',   '1234', '2026-08-02 10:15:00'),
(3, 'Andrea',  'Torres',   'andrea@skyflow.com',  '1234', '2026-08-03 11:30:00'),
(4, 'Diego',   'Mendoza',  'diego@skyflow.com',   '1234', '2026-08-05 14:00:00'),
(5, 'Valeria', 'Quispe',   'valeria@skyflow.com', '1234', '2026-08-06 16:45:00'),
(6, 'Jorge',   'Salazar',  'jorge@skyflow.com',   '1234', '2026-08-08 08:20:00');

-- ======================
-- PROYECTOS
-- ======================
INSERT INTO proyectos (id, nombre, descripcion, fecha_inicio, fecha_fin, estado, fecha_creacion) VALUES
(1, 'Rediseno sitio web corporativo', 'Renovacion completa del sitio web de la empresa con nuevo diseno responsive.', '2026-09-01', '2026-12-15', 'PENDIENTE',  '2026-09-01 09:00:00'),
(2, 'App movil de delivery',          'Desarrollo de la aplicacion movil para pedidos y seguimiento de entregas.',    '2026-09-15', '2027-02-28', 'PENDIENTE',  '2026-09-15 10:00:00'),
(3, 'Migracion a la nube',            'Migracion de los servidores locales a infraestructura en la nube.',            '2026-07-01', '2026-09-30', 'COMPLETADO', '2026-07-01 08:30:00'),
(4, 'Campana de marketing Q4',        'Campana publicitaria para el ultimo trimestre del ano.',                       '2026-10-01', '2026-12-31', 'PENDIENTE',  '2026-10-01 09:30:00'),
(5, 'Sistema de inventario',          'Sistema para controlar el stock de almacen. Proyecto recien creado.',          '2026-10-15', '2027-01-31', 'PENDIENTE',  '2026-10-15 11:00:00');

-- ======================
-- MIEMBROS DEL PROYECTO (1 LIDER por proyecto)
-- ======================
INSERT INTO miembros_proyecto (id, proyecto_id, usuario_id, rol, fecha_union) VALUES
-- Proyecto 1: lider Carlos
(1,  1, 1, 'LIDER',       '2026-09-01 09:00:00'),
(2,  1, 2, 'SUBORDINADO', '2026-09-02 09:10:00'),
(3,  1, 5, 'SUBORDINADO', '2026-09-02 09:15:00'),
-- Proyecto 2: lider Lucia
(4,  2, 2, 'LIDER',       '2026-09-15 10:00:00'),
(5,  2, 1, 'SUBORDINADO', '2026-09-16 08:00:00'),
(6,  2, 3, 'SUBORDINADO', '2026-09-16 08:05:00'),
(7,  2, 6, 'SUBORDINADO', '2026-09-16 08:10:00'),
-- Proyecto 3: lider Andrea
(8,  3, 3, 'LIDER',       '2026-07-01 08:30:00'),
(9,  3, 4, 'SUBORDINADO', '2026-07-02 09:00:00'),
(10, 3, 5, 'SUBORDINADO', '2026-07-02 09:05:00'),
(11, 3, 1, 'SUBORDINADO', '2026-07-02 09:05:00'),
-- Proyecto 4: lider Diego
(12, 4, 4, 'LIDER',       '2026-10-01 09:30:00'),
(13, 4, 1, 'SUBORDINADO', '2026-10-02 10:00:00'),
(14, 4, 6, 'SUBORDINADO', '2026-10-02 10:05:00'),
-- Proyecto 5: lider Valeria
(15, 5, 5, 'LIDER',       '2026-10-15 11:00:00'),
(16, 5, 1, 'SUBORDINADO', '2026-10-16 09:00:00');

-- ======================
-- TAREAS
-- (Proyecto 3 con todas COMPLETADA => proyecto COMPLETADO; Proyecto 5 sin tareas)
-- ======================
INSERT INTO tareas (id, proyecto_id, titulo, descripcion, fecha_inicio, fecha_fin, prioridad, estado, fecha_creacion) VALUES
-- Proyecto 1 (50%)
(1,  1, 'Levantamiento de requerimientos', 'Reunion con las areas para definir secciones y funcionalidades del sitio.', '2026-09-01', '2026-09-12', 'ALTA',  'COMPLETADA', '2026-09-01 10:00:00'),
(2,  1, 'Disenar mockups en Figma',        'Crear prototipos de las paginas principales: inicio, servicios y contacto.',  '2026-09-13', '2026-10-05', 'MEDIA', 'COMPLETADA', '2026-09-02 10:00:00'),
(3,  1, 'Maquetacion HTML y CSS',          'Convertir los mockups aprobados a plantillas responsive.',                    '2026-10-06', '2026-10-30', 'ALTA',  'PENDIENTE',  '2026-09-02 10:30:00'),
(4,  1, 'Pruebas y publicacion',           'Pruebas en distintos navegadores y despliegue a produccion.',                 '2026-11-01', '2026-12-10', 'BAJA',  'PENDIENTE',  '2026-09-02 11:00:00'),
-- Proyecto 2 (20%)
(5,  2, 'Definir arquitectura de la app',  'Elegir tecnologias y definir la arquitectura del backend y la app movil.',    '2026-09-15', '2026-09-30', 'ALTA',  'COMPLETADA', '2026-09-15 10:30:00'),
(6,  2, 'Disenar flujo de pedidos',        'Pantallas de catalogo, carrito y confirmacion del pedido.',                   '2026-10-01', '2026-10-25', 'MEDIA', 'PENDIENTE',  '2026-09-15 11:00:00'),
(7,  2, 'Integrar pasarela de pagos',      'Conectar la app con la pasarela de pagos en linea.',                          '2026-11-01', '2026-12-15', 'ALTA',  'PENDIENTE',  '2026-09-15 11:30:00'),
(8,  2, 'Modulo de seguimiento en mapa',   'Mostrar la ubicacion del repartidor en tiempo real.',                         '2026-12-01', '2027-01-20', 'MEDIA', 'PENDIENTE',  '2026-09-15 12:00:00'),
(9,  2, 'Pruebas de aceptacion',           'Pruebas con usuarios reales antes del lanzamiento.',                          '2027-01-25', '2027-02-20', 'BAJA',  'PENDIENTE',  '2026-09-15 12:30:00'),
-- Proyecto 3 (100% - proyecto COMPLETADO)
(10, 3, 'Inventario de servidores',        'Listar servidores, servicios y dependencias existentes.',                      '2026-07-01', '2026-07-15', 'MEDIA', 'COMPLETADA', '2026-07-01 09:00:00'),
(11, 3, 'Migrar base de datos',            'Migrar las bases de datos al servicio administrado en la nube.',              '2026-07-16', '2026-08-31', 'ALTA',  'COMPLETADA', '2026-07-01 09:30:00'),
(12, 3, 'Apagar servidores antiguos',      'Verificar la operacion y dar de baja la infraestructura local.',              '2026-09-01', '2026-09-28', 'BAJA',  'COMPLETADA', '2026-07-01 10:00:00'),
-- Proyecto 4 (67%)
(13, 4, 'Definir publico objetivo',        'Segmentacion y analisis del publico al que ira dirigida la campana.',         '2026-10-01', '2026-10-10', 'MEDIA', 'COMPLETADA', '2026-10-01 10:00:00'),
(14, 4, 'Crear piezas graficas',           'Banners, videos cortos y publicaciones para redes sociales.',                 '2026-10-11', '2026-10-20', 'ALTA',  'COMPLETADA', '2026-10-01 10:30:00'),
(15, 4, 'Lanzar campana en redes',         'Programar y publicar los anuncios en las plataformas elegidas.',              '2026-10-21', '2026-11-15', 'ALTA',  'PENDIENTE',  '2026-10-01 11:00:00');

-- ======================
-- NOTAS DEL PROYECTO
-- ======================
INSERT INTO notas_proyecto (id, proyecto_id, usuario_id, contenido, fecha_creacion) VALUES
(1, 1, 1, 'Reunion de kickoff realizada. Se aprobo el cronograma general.',                    '2026-09-03 15:00:00'),
(2, 1, 2, 'El cliente solicito agregar una seccion de blog; la evaluaremos para la fase 2.',   '2026-09-20 11:30:00'),
(3, 1, 5, 'Ya tengo la paleta de colores y tipografias definidas.',                            '2026-09-25 17:10:00'),
(4, 2, 2, 'Se decidio usar Flutter para la app movil.',                                        '2026-09-18 10:00:00'),
(5, 2, 3, 'Pendiente confirmar costos de la pasarela de pagos con finanzas.',                  '2026-10-02 09:45:00'),
(6, 3, 3, 'Migracion finalizada sin incidentes. Proyecto cerrado.',                            '2026-09-29 18:00:00'),
(7, 3, 4, 'Se documentaron los accesos y la configuracion final de la nube.',                  '2026-09-30 10:20:00'),
(8, 4, 4, 'Presupuesto aprobado para publicidad en redes sociales.',                           '2026-10-03 12:00:00'),
(9, 4, 6, 'Las piezas graficas ya estan listas para revision.',                                '2026-10-19 16:30:00'),
(10,5, 5, 'Se creo el proyecto. Falta que el lider registre las primeras tareas.',             '2026-10-15 11:30:00');

-- ======================
-- NOTAS DE TAREAS
-- ======================
INSERT INTO notas_tarea (id, tarea_id, usuario_id, contenido, fecha_creacion) VALUES
(1,  1,  2, 'Se entrevisto a las areas de ventas y soporte.',                          '2026-09-08 10:00:00'),
(2,  2,  5, 'Mockups de la pagina de inicio listos para revision.',                    '2026-09-28 14:20:00'),
(3,  3,  2, 'Avance del 40% en la maquetacion; falta la pagina de contacto.',          '2026-10-14 09:00:00'),
(4,  5,  3, 'Arquitectura aprobada: API REST con Spring Boot y app en Flutter.',       '2026-09-29 16:00:00'),
(5,  6,  1, 'Faltan definir los estados del pedido (recibido, en camino, entregado).', '2026-10-10 11:15:00'),
(6,  7,  6, 'Se evaluan dos proveedores de pago; envio comparativo manana.',           '2026-10-12 15:40:00'),
(7,  11, 4, 'Migracion de datos validada con pruebas de integridad.',                  '2026-08-30 13:00:00'),
(8,  12, 5, 'Servidores apagados y respaldos guardados por 90 dias.',                  '2026-09-27 17:00:00'),
(9,  14, 6, 'Se entregaron 12 piezas entre banners y videos.',                         '2026-10-19 12:00:00'),
(10, 15, 1, 'Anuncios programados, falta aprobacion final del lider.',                 '2026-10-17 10:30:00');
