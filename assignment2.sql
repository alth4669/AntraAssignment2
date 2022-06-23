use AdventureWorks2019

--Question 1
select cr.Name as Country, sp.Name as Province
from Person.CountryRegion cr inner join Person.StateProvince sp
on cr.CountryRegionCode = sp.CountryRegionCode
order by Country

--Question 2
select cr.Name as Country, sp.Name as Province
from Person.CountryRegion cr inner join Person.StateProvince sp
on cr.CountryRegionCode = sp.CountryRegionCode
where cr.Name in ('Germany', 'Canada')
order by Country

use Northwind

--Question 3
select distinct p.ProductName
from Orders o inner join "Order Details" od on o.OrderID = od.OrderID inner join Products p on od.ProductID = p.ProductID
where OrderDate between '1997-01-01' and getdate()

--Question 4
select top 5 ShipPostalCode, count(*) as TotalOrders
from Orders where OrderDate between '1997-01-01' and getdate()
group by ShipPostalCode
order by TotalOrders desc

--Question 5
select City, count(*) as TotalCustomers
from Customers
group by City

--Question 6
select City, count(*) as TotalCustomers
from Customers
group by City
having count(*) > 2

--Question 7
select c.CompanyName, isnull(sum(od.Quantity), 0) as BoughtProducts
from Orders o inner join "Order Details" od on o.OrderID = od.OrderID right join Customers c on o.CustomerID = c.CustomerID
group by c.CompanyName

--Question 8
select c.CustomerID, isnull(sum(od.Quantity), 0) as BoughtProducts
from Orders o inner join "Order Details" od on o.OrderID = od.OrderID right join Customers c on o.CustomerID = c.CustomerID
group by c.CustomerID
having sum(od.Quantity) > 100

--Question 9
select distinct sup.CompanyName as SupplierName, sh.CompanyName as ShipperName from
Orders o inner join "Order Details" od on o.OrderID = od.OrderID inner join Products p on od.ProductID = p.ProductID
inner join Suppliers sup on p.SupplierID = sup.SupplierID inner join Shippers sh on o.ShipVia = sh.ShipperID
order by sup.CompanyName

--Question 10
select distinct format(o.OrderDate, 'yyyy-MM-dd') as Date, p.ProductName from
Orders o inner join "Order Details" od on o.OrderID = od.OrderID inner join Products p on od.ProductID = p.ProductID

select distinct o.OrderDate, p.ProductName from
Orders o inner join "Order Details" od on o.OrderID = od.OrderID inner join Products p on od.ProductID = p.ProductID

--Question 11
select distinct e1.FirstName + ' ' + e1.LastName as Employee1, e2.FirstName + ' ' + e2.LastName as Employee2, e1.Title from
Employees e1 inner join Employees e2 on e1.Title = e2.Title
where e1.FirstName + ' ' + e1.LastName != e2.FirstName + ' ' + e2.LastName

--Question 12
select e2.FirstName + ' ' + e2.LastName as Manager, count(*) as Subordinates
from Employees e1 inner join Employees e2 on e1.ReportsTo = e2.EmployeeID
group by e2.FirstName + ' ' + e2.LastName
having count(*) > 2

--Question 13
select City, CompanyName, ContactName, 'Customer' as Type from Customers
union
select City, CompanyName, ContactName, 'Supplier' as Type from Suppliers
order by City

--Question 14
select distinct City from Customers
where City in (
select distinct City from Employees
)

--Question 15
--a. using sub-query
select distinct City from Customers
where City not in (
select distinct City from Employees
)
--b. not using sub-query
select distinct c.City
from Customers c left join Employees e on c.City = e.City
where e.City is null

--Question 16
select p.ProductName, sum(od.Quantity) as TotalOrderQuantity
from Orders o inner join "Order Details" od on o.OrderID = od.OrderID inner join Products p on od.ProductID = p.ProductID
group by p.ProductName

--Question 17
--a. using union

--b. using sub-query and no union
select City
from Customers
group by City
having count(*) >= 2

--Question 18
select c.City, count(distinct p.ProductID) as DistinctProductsOrdered from
Orders o inner join "Order Details" od on o.OrderID = od.OrderID inner join Customers c on o.CustomerID = c.CustomerID
inner join Products p on od.ProductID = p.ProductID
group by c.City
having count(distinct p.ProductID) >= 2

--Question 19
select top 5 p.ProductID,
(
select sum(od.Quantity)
from "Order Details" od where p.ProductID = od.ProductID
) as QuantityOrdered,
(
select avg(od.UnitPrice)
from "Order Details" od where p.ProductID = od.ProductID
) as AveragePrice,
(
select City from
(
select top 1 c.City, sum(Quantity) as QuantityOrdered
from Orders o inner join "Order Details" od on o.OrderID = od.OrderID inner join Customers c on o.CustomerID = c.CustomerID
where ProductID = p.ProductID
group by c.City
order by QuantityOrdered desc
) dt
) as MostPopularCity
from Products p
order by QuantityOrdered desc;

--Question 20
with orderSummaryCTE
as
(
select distinct e2.City,
(
select count(*)
from Orders o inner join Employees e1 on o.EmployeeID = e1.EmployeeID
where e1.City = e2.City
) as TotalOrders,
(
select sum(od.Quantity)
from Orders o inner join "Order Details" od on o.OrderID = od.OrderID inner join Employees e1 on o.EmployeeID = e1.EmployeeID
where e1.City = e2.City
) as TotalProductQuantity
from Employees e2
)
select City from orderSummaryCTE
where TotalOrders = (select max(TotalOrders) from OrderSummaryCTE) and TotalProductQuantity = (select max(TotalProductQuantity) from OrderSummaryCTE)

--Question 21
/*
You could delete duplicate entries in a table using window functions and partitions. You could create partitions in the table based on the values
of every column. Specifically, any rows that have identical values in all columns would be placed into the same partition. Once in the same partition,
window functions such as rank() or row_number() could be applied and any row that has a window function != 1 (in the case of rank or row_number()
could simply be deleted from the table.
*/

