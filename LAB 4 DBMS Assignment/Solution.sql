-- Q1 Display the total number of customers based on gender who have placed orders of worth at least Rs.3000.
-- need to display customer details and gender who placed order of worth >=3000
SELECT cus.cus_gender AS CUSTOMER_GENDER,count(cus.cus_id) AS CUSTOMER_ID  FROM customer cus 
JOIN orders o ON cus.cus_id=o.cus_id 
AND o.ord_amount>=3000 
GROUP BY(cus.cus_gender); 

-- Q2 Display all the orders along with product name ordered by a customer having Customer_Id=2
SELECT o.ord_id AS ORDER_ID,o.ord_amount as ORDER_AMOUNT,o.ord_DATE as ORDER_DATE, pro.pro_name AS PRODUCT_NAME  FROM orders AS o 
JOIN supplier_pricing AS sp ON sp.pricing_id=o.pricing_id 
JOIN product AS pro ON pro.pro_id=sp.pro_id where o.cus_id=2;

-- Q3 Display the Supplier details who can supply more than one product.
SELECT sup.* FROM supplier_pricing as sp
JOIN supplier as sup on sup.supp_id=sp.supp_id
group by sp.supp_id having count(sp.supp_id)>1;

-- Q4 Find the least expensive product from each category and print the table with category id, name, product name and price of the product.

SELECT c.cat_id ,c.cat_name as Category_Name,t2.pro_name as Product_Name,t2.supp_price as Price
from category c
inner JOIN 
(SELECT p.pro_id,p.pro_name,p.cat_id,min(supp_price) as supp_price FROM supplier_pricing sp inner JOIN product p ON sp.pro_id=p.pro_id GROUP BY (p.pro_id) order by supp_price ) as t2
 ON c.cat_id=t2.cat_id GROUP BY c.cat_id,c.cat_name,t2.pro_name,t2.supp_price;

-- Q5. Display the Id and Name of the Product ordered after “2021-10-05”.

SELECT pro.pro_id,pro.pro_name,o.ord_date
FROM orders o 
JOIN supplier_pricing sp
ON o.pricing_id= sp.pricing_id
JOIN product pro 
ON sp.pro_id=pro.pro_id
WHERE o.ord_date>"2021-10-05" ;

-- Q6. Display customer name and gender whose names start or end with character 'A'.

SELECT cus_name as CUSTOMER_NAME ,cus_gender as CUSTOMER_GENDER
FROM customer 
WHERE cus_name LIKE "A%" OR cus_name LIKE "%A";

-- Q7. Create a stored procedure to display supplier id, name, rating and Type_of_Service. For Type_of_Service, If rating =5, print “Excellent Service”,If rating >4 print “Good Service”, If rating >2 print “Average Service” else print “Poor Service”.

DROP PROCEDURE IF EXISTS supplier_ratings ;
DELIMITER &&  
CREATE PROCEDURE supplier_ratings ()  
BEGIN  
    SELECT sup.supp_id as Supplier_ID,sup.supp_name as Supplier_Name,AVG(rate.rat_ratstars) as Average_Rating,
    CASE 
    WHEN AVG(rate.rat_ratstars)=5 then "Excellent Service"
    WHEN AVG(rate.rat_ratstars)>4 then "Good Service"
    WHEN AVG(rate.rat_ratstars)>2 then "Average Service"
    ELSE "Poor Service"
    END as type_of_services
    FROM supplier sup 
    JOIN supplier_pricing sp
	ON sup.supp_id = sp.supp_id 
    JOIN orders o
    ON sp.pricing_id=o.pricing_id
    JOIN rating rate
    ON o.ord_id=rate.ord_id GROUP BY (sup.supp_id );
END &&  
DELIMITER ;  
call supplier_ratings();