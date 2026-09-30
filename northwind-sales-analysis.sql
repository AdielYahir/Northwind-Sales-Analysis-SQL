-- Northwind Sales Analysis

-- 1. Sales performance over time
-- How did total sales evolve across the years?

SELECT
    strftime('%Y', OrderDate) as Año,
    SUM(UnitPrice * Quantity * (1 - Discount)) as Ventas_totales
FROM Orders o
JOIN "Order Details" od ON od.OrderID = o.OrderID
GROUP BY strftime('%Y', OrderDate)
ORDER BY Año;


-- 2. Category performance
-- How did the sales of Beverages and Confections
-- compare month by month during 1997?

SELECT
    strftime('%m', i.OrderDate) AS Mes,
    ROUND(
        SUM(
            CASE
                WHEN c.CategoryName = 'Beverages'
                THEN i.ExtendedPrice
                ELSE 0
            END
        ), 2
    ) AS Facturacion_Bebidas,
    ROUND(
        SUM(
            CASE
                WHEN c.CategoryName = 'Confections'
                THEN i.ExtendedPrice
                ELSE 0
            END
        ), 2
    ) AS Facturacion_Confections
FROM Invoices i
JOIN Products p ON p.ProductID = i.ProductID
JOIN Categories c ON p.CategoryID = c.CategoryID
WHERE i.OrderDate >= '1997-01-01'
  AND i.OrderDate < '1998-01-01'
  AND c.CategoryName IN ('Beverages', 'Confections')
GROUP BY strftime('%m', i.OrderDate)
ORDER BY Mes;


-- 3. Top 5 products by units sold
-- Which products sold the highest number of units?

SELECT
    p.ProductName,
    sum(Quantity) as Unidades_Vendidas
FROM Products p
JOIN "Order Details" od ON od.ProductID = p.ProductID
GROUP BY p.ProductName
ORDER BY Unidades_Vendidas DESC
LIMIT 5;


-- 4. Employee sales performance
-- How much revenue did each employee generate?

SELECT
    e.EmployeeID,
    e.FirstName || ' ' || e.LastName AS Employee_Name,
    sum(i.ExtendedPrice) as Facturación_Total
FROM Employees e
JOIN Orders o ON e.EmployeeID = o.EmployeeID
JOIN Invoices i ON i.OrderID = o.OrderID
GROUP BY e.EmployeeID, e.FirstName, e.LastName
ORDER BY e.EmployeeID ASC;


-- 5. Top 5 shipping cities by revenue
-- Which shipping cities generated the highest revenue?

SELECT
    o.ShipCity,
    sum(i.ExtendedPrice) As Facturacion_Total
FROM Orders o
JOIN Invoices i on i.OrderID = o.OrderID
GROUP BY o.ShipCity
ORDER BY Facturacion_Total desc
LIMIT 5;
