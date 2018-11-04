```
<!-- 1. 全表扫描 -->
<!-- mysql -->
SELECT p.*
FROM products as p;

<!-- neo4j -->
MATCH (p:Product)
RETURN p;


<!-- 2. 查询价格最贵的10个商品，只返回商品名字和单价 -->
<!-- mysql -->
SELECT p.ProductName, p.UnitPrice
FROM products as p
ORDER BY p.UnitPrice DESC
LIMIT 10;

<!-- neo4j -->
MATCH (p:Product)
RETURN p.productName, p.unitPrice
ORDER BY p.unitPrice DESC
LIMIT 10;


<!-- 3. 按照商品名字筛选 -->
<!-- mysql -->
SELECT p.ProductName, p.UnitPrice
FROM products AS p
WHERE p.ProductName = 'Chocolade';

<!-- neo4j -->
MATCH (p:Product)
WHERE p.productName = "Chocolade"
RETURN p.productName, p.unitPrice;

<!-- 其他的写法 -->
MATCH (p:Product {productName:"Chocolade"})
RETURN p.productName, p.unitPrice;

<!-- 4. 按照商品名字筛选2 -->
<!-- mysql -->
SELECT p.ProductName, p.UnitPrice
FROM products as p
WHERE p.ProductName IN ('Chocolade','Chai');

<!-- neo4j -->
MATCH (p:Product)
WHERE p.productName IN ['Chocolade','Chai']
RETURN p.productName, p.unitPrice;


<!-- 5. 模糊查询和数值过滤 -->
<!-- mysql -->
SELECT p.ProductName, p.UnitPrice
FROM products AS p
WHERE p.ProductName LIKE 'C%' AND p.UnitPrice > 100;

<!-- neo4j -->
MATCH (p:Product)
WHERE p.productName STARTS WITH "C" AND p.unitPrice > 100
RETURN p.productName, p.unitPrice;


<!-- 6. 多表联合查询-->
<!-- mysql -->
SELECT DISTINCT c.CompanyName
FROM customers AS c
JOIN orders AS o ON (c.CustomerID = o.CustomerID)
JOIN order_details AS od ON (o.OrderID = od.OrderID)
JOIN products AS p ON (od.ProductID = p.ProductID)
WHERE p.ProductName = 'Chocolade';

<!-- neo4j -->
MATCH (p:Product {productName:"Chocolade"})<-[:PRODUCT]-(:Order)<-[:PURCHASED]-(c:Customer)
RETURN distinct c.companyName;


<!-- 7.  -->
<!-- mysql -->
SELECT e.EmployeeID, count(*) AS Count
FROM Employee AS e
JOIN Order AS o ON (o.EmployeeID = e.EmployeeID)
GROUP BY e.EmployeeID
ORDER BY Count DESC LIMIT 10;

<!-- neo4j -->
MATCH (:Order)<-[:SOLD]-(e:Employee)
RETURN e.name, count(*) AS cnt
ORDER BY cnt DESC LIMIT 10

```