
USE AdventureWorks2025


/* 1: Antal produkter per kategori
Affärsfråga: Hur många produkter finns i varje kategori?
    Krav på data:
        • Använd tabeller: Production.ProductCategory, Production.ProductSubcategory, Production.Product
        • Räkna unika produkter per kategori */

SELECT * FROM Production.Product
SELECT * FROM Production.ProductCategory
SELECT * FROM Production.ProductSubcategory

SELECT
    pc.Name AS CategoryName,
    COUNT(DISTINCT p.ProductID) AS ProductCount
FROM Production.ProductCategory pc
INNER JOIN Production.ProductSubcategory psc 
    ON pc.ProductCategoryID = psc.ProductCategoryID
INNER JOIN Production.Product p
    ON psc.ProductSubcategoryID = p.ProductSubcategoryID
GROUP BY pc.Name
ORDER BY ProductCount DESC



/*2: Försäljning per produktkategori
Affärsfråga: Vilka produktkategorier genererar mest intäkter?
Krav på data:
• Använd tabeller: Production.ProductCategory, Production.ProductSubcategory, Production.Product, Sales.SalesOrderDetail
• Sortera från högst till lägst försäljning*/

SELECT * FROM Production.Product
SELECT * FROM Production.ProductCategory
SELECT * FROM Production.ProductSubcategory
SELECT * FROM Sales.SalesOrderDetail

SELECT 
    pc.Name AS CategoryName,
    SUM(so.LineTotal) AS TotalSales
FROM Production.ProductCategory pc
INNER JOIN Production.ProductSubcategory psc 
    ON pc.ProductCategoryID = psc.ProductCategoryID
INNER JOIN Production.Product p
    ON psc.ProductSubcategoryID = p.ProductSubcategoryID
INNER JOIN Sales.SalesOrderDetail so
    ON p.ProductID = so.ProductID
GROUP BY pc.Name
ORDER BY TotalSales DESC;



/*3: Försäljningstrend över tid
Affärsfråga: Hur har försäljningen utvecklats över tid?
Krav på data:
• Använd tabeller: Sales.SalesOrderHeader
• Aggregera per månad (minst 12 månader data)
• Sortera kronologiskt (äldst först)*/


SELECT * FROM Sales.SalesOrderHeader

SELECT
    CAST(FORMAT(OrderDate, 'yyyy-MM-01')AS date) AS MonthStart,
    SUM(TotalDue) AS TotalSales
FROM Sales.SalesOrderHeader soh
GROUP BY FORMAT(OrderDate, 'yyyy-MM-01')
ORDER BY MonthStart ASC;


/*4: Försäljning och antal ordrar per år
Affärsfråga: Hur ser total försäljning och antal ordrar ut per år?
Krav på data:
• Använd tabeller: Sales.SalesOrderHeader
• Visa både total försäljning OCH antal ordrar
• Gruppera per år
• Sortera kronologiskt*/

SELECT * FROM Sales.SalesOrderHeader

SELECT
    DATEPART(year, OrderDate) AS SalesYear,
    SUM(TotalDue) AS TotalSales,
    COUNT(SalesOrderID) AS TotalOrders
FROM Sales.SalesOrderHeader
GROUP BY DATEPART(year, OrderDate)
ORDER BY DATEPART(year, OrderDate) ASC;

/*5: Top 10 produkter
Affärsfråga: Vilka 10 produkter genererar mest försäljning?
Krav på data:
• Använd tabeller: Production.Product, Sales.SalesOrderDetail
• Visa endast TOP 10 produkter
• Sortera från högst till lägst försäljning*/



SELECT * FROM Production.Product
SELECT * FROM Sales.SalesOrderDetail

SELECT TOP (10)
    p.Name AS ProductCategory,
    SUM(so.LineTotal) AS TotalSales    
FROM Production.Product p
INNER JOIN Sales.SalesOrderDetail so
    ON p.ProductID = so.ProductID
GROUP BY p.Name
ORDER BY SUM(so.LineTotal) DESC;

/*6: Försäljning och antal kunder per region
Affärsfråga: Hur skiljer sig försäljningen mellan olika regioner, och hur många unika kunder har varje region?
Krav på data:
• Använd tabeller: Sales.SalesTerritory, Sales.SalesOrderHeader, Sales.Customer
• Visa total försäljning OCH antal unika kunder per region
Sortera från högst till lägst försäljning*/

SELECT * FROM Sales.SalesTerritory
SELECT * FROM Sales.SalesOrderHeader
SELECT * FROM Sales.Customer

SELECT 
    st.Name AS Regions,
    SUM(soh.TotalDue) AS TotalSales,
    COUNT(DISTINCT sc.CustomerID) AS TotalClients 
FROM Sales.SalesTerritory st
INNER JOIN Sales.SalesOrderHeader soh
    ON st.TerritoryID = soh.TerritoryID
INNER JOIN Sales.Customer sc
    ON soh.CustomerID = sc.CustomerID
GROUP BY st.Name
ORDER BY SUM(soh.TotalDue) DESC;  


/*7: Genomsnittligt ordervärde per region och kundtyp
Affärsfråga: Vilka regioner har högst/lägst genomsnittligt ordervärde, och skiljer det sig mellan individuella kunder och företagskunder?
Krav på data:
• Använd tabeller: Sales.SalesTerritory, Sales.SalesOrderHeader, Sales.Customer, Sales.Store
• Beräkna: Total försäljning / Antal ordrar per region
• Dela upp på kundtyp: Store (företag) vs Individual (privatperson)
• Sortera från högst till lägst genomsnitt*/

SELECT * FROM Sales.SalesTerritory
SELECT * FROM Sales.SalesOrderHeader
SELECT * FROM Sales.Customer
SELECT * FROM Sales.Store


SELECT
    st.Name AS Region,
    SUM(CASE WHEN sc.PersonID IS NOT NULL THEN so.TotalDue END)
    / NULLIF(COUNT(CASE WHEN sc.PersonID IS NOT NULL THEN so.SalesOrderID END),0)
    AS AvgOrderValue_Individual,
    SUM(CASE WHEN sc.StoreID IS NOT NULL THEN so.TotalDue END)
    / NULLIF(COUNT(CASE WHEN sc.StoreID IS NOT NULL THEN so.SalesOrderID END),0)
    AS AvgOrderValue_Store,
    SUM(so.TotalDue) * 1.0 / COUNT(so.SalesOrderID) AS AvgOrderValue_Total
FROM Sales.SalesTerritory st 
INNER JOIN Sales.SalesOrderHeader so
    ON st.TerritoryID = so.TerritoryID
INNER JOIN Sales.Customer sc
    ON so.CustomerID = sc.CustomerID
LEFT JOIN Sales.Store s
    ON sc.StoreID = s.BusinessEntityID
GROUP BY st.Name
ORDER BY AvgOrderValue_Total DESC;  

/*DJUPANALYS (för VG)
För VG ska du göra allt från G-delen PLUS välja EN av följande djupanalyser:

ALTERNATIV A: Regional försäljningsoptimering
Analysfrågor:
•	Vilken region presterar bäst/sämst?
•	Vilka produktkategorier säljer bäst var?
•	Finns säsongsmönster per region?
•	Rekommendationer för förbättring?
Du behöver:
•	3-4 nya SQL-queries för att svara på dessa frågor
•	Minst 1 pivot tables i pandas för att analysera data från olika vinklar
•	3 nya visualiseringar (t.ex. heatmap region×kategori, linjediagram säsongsmönster, grupperat stapeldiagram)*/


SELECT * FROM Sales.SalesTerritory
SELECT * FROM Sales.SalesOrderHeader
SELECT * FROM Production.Product
SELECT * FROM Production.ProductCategory
SELECT * FROM Sales.SalesOrderHeader
SELECT * FROM Production.ProductSubcategory
SELECT * FROM Sales.SalesOrderDetail

--------------------------------------------------------------------------------------------------------------

-- Vilken region presterar bäst/sämst?

SELECT 
    st.Name AS Regions,
    SUM(soh.TotalDue) AS TotalSales
FROM Sales.SalesTerritory st
INNER JOIN Sales.SalesOrderHeader soh
    ON st.TerritoryID = soh.TerritoryID
GROUP BY st.Name
ORDER BY SUM(soh.TotalDue) DESC;  

-----------------------------------------------------------------------------------------------------------

-- Vilka produktkategorier säljer bäst var?

SELECT 
    pc.Name AS CategoryName,
    st.Name AS Regions,
    SUM(soh.TotalDue) AS TotalSales    
FROM Production.ProductCategory pc
LEFT JOIN Production.ProductSubcategory ps
    ON pc.ProductCategoryID = ps.ProductCategoryID
INNER JOIN Production.Product p
    ON ps.ProductSubcategoryID = p.ProductSubcategoryID
INNER JOIN Sales.SalesOrderDetail so
    ON p.ProductID = so.ProductID
INNER JOIN Sales.SalesOrderHeader soh
    ON so.SalesOrderID = soh.SalesOrderID
INNER JOIN Sales.SalesTerritory st
    ON soh.TerritoryID = st.TerritoryID
GROUP BY pc.Name, st.Name
ORDER BY TotalSales;


-----------------------------------------------------------------------------------------------------------

-- Finns säsongsmönster per region?

SELECT * FROM Sales.SalesTerritory
SELECT * FROM Sales.SalesOrderHeader

SELECT
    st.Name AS Region,
    CAST(FORMAT(soh.OrderDate, 'yyyy-MM-01') AS date) AS MonthStart,
    SUM(soh.TotalDue) AS TotalSales
FROM Sales.SalesOrderHeader soh
INNER JOIN Sales.SalesTerritory st
    ON soh.TerritoryID = st.TerritoryID
GROUP BY
    st.Name,
    FORMAT(soh.OrderDate, 'yyyy-MM-01')
ORDER BY
    st.Name,
    MonthStart;