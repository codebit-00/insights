
SELECT age, COUNT(age) AS count, 
CONCAT(ROUND(count(age)*100.00/499.00), '%') AS percentage
FROM clients
GROUP BY age ORDER BY age;