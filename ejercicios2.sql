--distinct

-- Se quiere saber a qué paises se les vende usar la tabla de clientes
SELECT DISTINCT country
FROM customers;


-- Se quiere saber a qué ciudades se les vende usar la tabla de clientes
SELECT DISTINCT city
FROM customers;

-- Se quiere saber a qué ciudades se les ha enviado una orden
SELECT DISTINCT ship_city
FROM orders;

--Se quiere saber a qué ciudades se les vende en el pais USA usar la tabla de clientes
SELECT DISTINCT city
FROM customers
WHERE Country = 'USA';


--Agrupacion

-- Se quiere saber a qué paises se les vende usar la tabla de clientes nota hacerla usando group by
SELECT country FROM Customers GROUP BY country;

--Cuantos clientes hay por pais
SELECT country, COUNT(customer_id) AS NumCustomers FROM Customers GROUP BY country;

--Cuantos clientes hay por ciudad en el pais USA
SELECT city, COUNT(customer_id) AS NumCustomers FROM customers WHERE country = 'USA' GROUP BY city;

--Cuantos productos hay por proveedor de la categoria 1
SELECT supplier_id, COUNT(*) AS NumProducts FROM Products WHERE category_id = 1 GROUP BY supplier_id;


--Filtro con having

-- Cuales son los proveedores que nos surten más de 1 producto, mostrar el proveedor mostrar la cantidad de productos
SELECT supplier_id, COUNT(supplier_id) AS NumProducts
FROM Products
GROUP BY supplier_id
HAVING COUNT(supplier_id) > 1;

-- Cuales son los proveedores que nos surten más de 1 producto, mostrar el proveedor mostrar la cantidad de productos, pero únicamente de la categoria 1
SELECT supplier_id, COUNT(supplier_id) AS NumProducts
FROM Products
WHERE category_id = 1
GROUP BY supplier_id
HAVING COUNT(supplier_id) > 1;

--CONTAR LAS ORDENES POR EMPLEADO DE LOS PAISES USA, CANADA, SPAIN (ShipCountry) MOSTRAR UNICAMENTE LOS EMPLEADOS CUYO CONTADOR DE ORDENES SEA MAYOR A 20
SELECT employee_id, COUNT(order_id) AS NumOrders
FROM Orders
WHERE ship_country IN ('USA', 'Canada', 'Spain')
GROUP BY employee_id
HAVING COUNT(order_id) > 20;

--OBTENER EL PRECIO PROMEDIO DE LOS PRODUCTOS POR PROVEEDOR UNICAMENTE DE AQUELLOS CUYO PROMEDIO SEA MAYOR A 20
	SELECT supplier_id, AVG(unit_price) AS AvgPrice
FROM Products
GROUP BY supplier_id
HAVING AVG(unit_price) > 20;

--OBTENER LA SUMA DE LAS UNIDADES EN EXISTENCIA (UnitsInStock) POR CATEGORIA, Y TOMANDO EN CUENTA UNICAMENTE LOS PRODUCTOS CUYO PROVEEDOR (SupplierID) SEA IGUAL A 17, 19, 16 DICIONALMENTE CUYA SUMA POR CATEGORIA SEA MAYOR A 300--
SELECT category_id, SUM(units_in_stock) AS SumUnits
FROM Products
WHERE supplier_id IN (16, 17, 19)
GROUP BY category_id
HAVING SUM(units_in_stock) > 300;

--CONTAR LAS ORDENES POR EMPLEADO DE LOS PAISES (ShipCountry) SA, CANADA, SPAIN cuYO CONTADOR SEA MAYOR A 25
SELECT employee_id, COUNT(order_id) AS NumOrders
FROM Orders
WHERE ship_country IN ('USA', 'Canada', 'Spain')
GROUP BY employee_id
HAVING COUNT(order_id) > 25;

----OBTENER LAS VENTAS (Quantity * UnitPrice) AGRUPADAS POR PRODUCTO (Orders details) Y CUYA SUMA DE VENTAS SEA MAYOR A 50.000
SELECT product_id, SUM(quantity * unit_price) AS TotalSales
FROM order_details
GROUP BY product_id
HAVING SUM(quantity * unit_price) > 50000;

--Mas de una tabla 
--OBTENER EL NUMERO DE ORDEN, EL ID EMPLEADO, NOMBRE Y APELLIDO DE LAS TABLAS DE ORDENES Y EMPLEADOS
SELECT o.order_id, e.employee_id, e.first_name, e.last_name
FROM Orders o
JOIN Employees e ON o.employee_id = e.employee_id;

--OBTENER EL PRODUCTID, PRODUCTNAME, SUPPLIERID, COMPANYNAME DE LAS TABLAS DE PRODUCTOS Y PROVEEDORES (SUPPLIERS)
SELECT p.product_id, p.product_name, p.supplier_id, s.company_name
FROM Products p
JOIN Suppliers s ON p.supplier_id = s.supplier_id;

--OBTENER LOS DATOS DEL DETALLE DE ORDENES CON EL NOMBRE DEL PRODUCTO DE LAS TABLAS DE DETALLE DE ORDENES Y DE PRODUCTOS
SELECT od.*, p.product_name
FROM Order_details od
JOIN Products p ON od.product_id = p.product_id;

--OBTENER DE LAS ORDENES EL ID, SHIPPERID, NOMBRE DE LA COMPAÑÍA DE ENVIO (SHIPPERS)
SELECT o.order_id, o.ship_via, s.company_name
FROM Orders o
JOIN Shippers s ON o.ship_via = s.shipper_id;

--Obtener el número de orden, país de envío (shipCountry) y el nombre del empleado de la tabla ordenes y empleados Queremos que salga el Nombre y Apellido del Empleado en una sola columna.
SELECT o.order_id, o.ship_country, CONCAT(e.first_name, ' ', e.last_name) AS EmployeeName
FROM Orders o
JOIN Employees e ON o.employee_id = e.employee_id;

--Combinando la mayoría de conceptos

--CONTAR EL NUMERO DE ORDENES POR EMPLEADO OBTENIENDO EL ID EMPLEADO Y EL NOMBRE COMPLETO DE LAS TABLAS DE ORDENES Y DE EMPLEADOS join y group by / columna calculada
SELECT e.employee_id, CONCAT(e.first_name, ' ', e.last_name) AS EmployeeName, COUNT(o.order_id) AS OrderCount
FROM Employees e
JOIN Orders o ON e.employee_id = o.employee_id
GROUP BY o.order_id,e.employee_id;

--OBTENER LA SUMA DE LA CANTIDAD VENDIDA Y EL PRECIO PROMEDIO POR NOMBRE DE PRODUCTO DE LA TABLA DE ORDERS DETAILS Y PRODUCTS
SELECT p.product_name, SUM(od.quantity) AS TotalSold, AVG(od.unit_price) AS AvgPrice
FROM Products p
JOIN order_details od ON p.product_id = od.product_id
GROUP BY p.product_name;

--OBTENER LAS VENTAS (UNITPRICE * QUANTITY) POR CLIENTE DE LAS TABLAS ORDER DETAILS, ORDERS
SELECT c.customer_id, c.company_name, SUM(od.unit_price * od.quantity) AS TotalSales
FROM Customers c
JOIN Orders o ON c.customer_id = o.customer_id
JOIN order_details od ON o.order_id = od.order_id
GROUP BY c.customer_id, c.company_name;


--OBTENER LAS VENTAS (UNITPRICE * QUANTITY) POR EMPLEADO MOSTRANDO EL APELLIDO (LASTNAME)DE LAS TABLAS EMPLEADOS, ORDENES, DETALLE DE ORDENES
SELECT e.last_name, SUM(od.unit_price * od.quantity) AS TotalSales
FROM Employees e
JOIN Orders o ON e.employee_id = o.employee_id
JOIN order_details od ON o.order_id = od.order_id
GROUP BY e.last_name;

