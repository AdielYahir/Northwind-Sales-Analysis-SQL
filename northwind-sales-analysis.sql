-- ============================================================
-- NORTHWIND SALES ANALYSIS
-- SQL Business Analysis
-- ============================================================

-- Business Objective:
-- Analyze Northwind's sales performance to identify
-- temporal trends, category performance, top-selling products,
-- employee performance, and the cities generating the most revenue.


-- ============================================================
-- 01. SALES PERFORMANCE OVER TIME
-- ============================================================

-- Business Question:
-- How did total sales evolve across the years?

-- Original Exercise #35:
-- Calcular las ventas totales, clasificadas por año.

SELECT
    strftime('%Y', OrderDate) AS Año,
    SUM(UnitPrice * Quantity * (1 - Discount)) AS Ventas_totales
FROM Orders o
JOIN "Order Details" od
    ON od.OrderID = o.OrderID
GROUP BY strftime('%Y', OrderDate)
ORDER BY Año;


-- ============================================================
-- 02. CATEGORY PERFORMANCE
-- ============================================================

-- Business Question:
-- How did the sales of Beverages and Confections
-- compare month by month during 1997?

-- Original Exercise #39:
-- Mostrar la facturación mensual del año 1997,
-- comparando las categorías 'Beverages' y 'Confections'.

SELECT
    strftime('%m', i.OrderDate) AS Mes,
    ROUND(
        SUM(
            CASE
                WHEN c.CategoryName = 'Beverages'
                THEN i.ExtendedPrice
                ELSE 0
            END
        ),
        2
    ) AS Facturacion_Bebidas,
    ROUND(
        SUM(
            CASE
                WHEN c.CategoryName = 'Confections'
                THEN i.ExtendedPrice
                ELSE 0
            END
        ),
        2
    ) AS Facturacion_Confections
FROM Invoices i
JOIN Products p
    ON p.ProductID = i.ProductID
JOIN Categories c
    ON p.CategoryID = c.CategoryID
WHERE
    i.OrderDate >= '1997-01-01'
    AND i.OrderDate < '1998-01-01'
    AND c.CategoryName IN ('Beverages', 'Confections')
GROUP BY strftime('%m', i.OrderDate)
ORDER BY Mes;


-- ============================================================
-- 03. TOP 5 PRODUCTS BY UNITS SOLD
-- ============================================================

-- Business Question:
-- Which products sold the highest number of units?

-- Original Exercise #28:
-- Presentar el top 5 de productos por unidades vendidas.

SELECT
    p.ProductName,
    SUM(Quantity) AS Unidades_Vendidas
FROM Products p
JOIN "Order Details" od
    ON od.ProductID = p.ProductID
GROUP BY p.ProductName
ORDER BY Unidades_Vendidas DESC
LIMIT 5;


-- ============================================================
-- 04. EMPLOYEE SALES PERFORMANCE
-- ============================================================

-- Business Question:
-- Which employees generated the highest total revenue?

-- Original Exercise #26:
-- Presentar una lista de los IDs de empleados,
-- sus nombres completos, y la suma total de facturación
-- que ha logrado cada uno.

SELECT
    e.EmployeeID,
    e.FirstName || ' ' || e.LastName AS Employee_Name,
    SUM(i.ExtendedPrice) AS Facturación_Total
FROM Employees e
JOIN Orders o
    ON e.EmployeeID = o.EmployeeID
JOIN Invoices i
    ON i.OrderID = o.OrderID
GROUP BY
    e.EmployeeID,
    e.FirstName,
    e.LastName
ORDER BY e.EmployeeID ASC;


-- ============================================================
-- 05. TOP 5 SHIPPING CITIES BY REVENUE
-- ============================================================

-- Business Question:
-- Which shipping cities generated the highest revenue?

-- Original Exercise #27:
-- Presentar el top 5 de las ciudades de envío por facturación.

SELECT
    o.ShipCity,
    SUM(i.ExtendedPrice) AS Facturacion_Total
FROM Orders o
JOIN Invoices i
    ON i.OrderID = o.OrderID
GROUP BY o.ShipCity
ORDER BY Facturacion_Total DESC
LIMIT 5;
