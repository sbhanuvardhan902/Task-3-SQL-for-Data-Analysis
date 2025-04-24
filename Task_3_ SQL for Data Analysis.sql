-- A. SELECT, WHERE, ORDER BY, GROUP BY
-- 1. Total revenue per product
SELECT p.Product, SUM(s.Amount) AS TotalRevenue
FROM sales s
JOIN products p ON s.PID = p.PID
GROUP BY p.Product
ORDER BY TotalRevenue DESC;

-- 2. Sales after January 1, 2018
SELECT *
FROM sales
WHERE Saledate > '2018-01-01'
ORDER BY Saledate;

-- B. JOINS: INNER, LEFT, RIGHT
-- 1. INNER JOIN: Sales info with product and salesperson names
SELECT s.Saledate, s.Amount, p.Product, ppl.Salesperson
FROM sales s
JOIN products p ON s.PID = p.PID
JOIN people ppl ON s.SPID = ppl.SPID;

-- 2. LEFT JOIN: All products and their sales (if sold)
SELECT p.Product, s.Amount
FROM products p
LEFT JOIN sales s ON s.PID = p.PID;

-- 3. RIGHT JOIN: All regions and their sales
-- Emulated RIGHT JOIN using LEFT JOIN
SELECT g.Region, s.Amount
FROM geo g
LEFT JOIN sales s ON s.GeoID = g.GeoID;

-- C. Subqueries
-- Products with total sales above average
SELECT Product
FROM products
WHERE PID IN (
  SELECT PID
  FROM sales
  GROUP BY PID
  HAVING SUM(Amount) > (
    SELECT AVG(Amount) FROM sales
  )
);

-- D. Aggregate Functions: SUM, AVG
-- Average sale amount per region
SELECT g.Region, AVG(s.Amount) AS AvgSales
FROM sales s
JOIN geo g ON s.GeoID = g.GeoID
GROUP BY g.Region;

-- Total boxes sold by salesperson
SELECT ppl.Salesperson, SUM(s.Boxes) AS TotalBoxes
FROM sales s
JOIN people ppl ON s.SPID = ppl.SPID
GROUP BY ppl.Salesperson;

-- E. Views for Analysis
-- View: Monthly sales summary
CREATE VIEW monthly_sales_summary AS
SELECT 
  DATE_FORMAT(Saledate, '%Y-%m') AS Month,
  SUM(Amount) AS TotalSales,
  SUM(Customers) AS TotalCustomers,
  SUM(Boxes) AS TotalBoxes
FROM sales
GROUP BY Month;

-- View: Salesperson performance
CREATE VIEW salesperson_performance AS
SELECT 
  ppl.Salesperson,
  COUNT(*) AS TotalSales,
  SUM(s.Amount) AS Revenue
FROM sales s
JOIN people ppl ON s.SPID = ppl.SPID
GROUP BY ppl.Salesperson;

-- F. Indexes for Optimization
CREATE INDEX idx_sales_pid ON sales(PID(20));
CREATE INDEX idx_sales_spid ON sales(SPID(20));
CREATE INDEX idx_sales_geoid ON sales(GeoID(20));
