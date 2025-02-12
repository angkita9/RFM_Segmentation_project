SELECT DATE_FORMAT(STR_TO_DATE(ORDERDATE, '%d/%m/%y'), '%Y-%m-%d') AS converted_date 
 FROM SALES_SAMPLE_DATA;

SELECT ORDERDATE FROM SALES_SAMPLE_DATA LIMIT 5;
SELECT STR_TO_DATE(ORDERDATE, '%d/%m/%y') AS `Date` FROM SALES_SAMPLE_DATA LIMIT 5;

SELECT MAX(STR_TO_DATE(ORDERDATE, '%d/%m/%y')) AS LATESTDATE from SALES_SAMPLE_DATA; -- 2005-05-31: Last Transaction Date
SELECT MIN(STR_TO_DATE(ORDERDATE, '%d/%m/%y')) AS EARLIESTDATE from SALES_SAMPLE_DATA; -- 2003-01-06 : First Transaction Date

SELECT 
    DATEDIFF(MAX(STR_TO_DATE(ORDERDATE, '%d/%m/%y')), MIN(STR_TO_DATE(ORDERDATE, '%d/%m/%y'))) AS 'Range' 
    FROM SALES_SAMPLE_DATA; -- Range of Transaction is 876 Days

-- RFM SEGMENTATION: SEGMENTING YOUR CUSTOMER BASEN ON RECENCY (R), FREQUENCY (F), AND MONETARY (M) SCORES


SELECT
    CUSTOMERNAME,
    ROUND(SUM(SALES),0) AS MonetaryValue,
    COUNT(DISTINCT ORDERNUMBER) AS Frequency,
    -- MAX(STR_TO_DATE(ORDERDATE,' %d/%m/%y')) AS EACH_CUSTOMERS_LAST_TRANSACTION_DATE,
    -- (SELECT MAX(STR_TO_DATE(ORDERDATE, '%d/%m/%y')) FROM SALES_SAMPLE_DATA) AS BUSINESS_LAST_TRANSACTION_DATE,
    DATEDIFF(MAX(STR_TO_DATE(ORDERDATE, '%d/%m/%y')), (SELECT MAX(STR_TO_DATE(ORDERDATE, '%d/%m/%y')) FROM SALES_SAMPLE_DATA))   AS Recency
FROM SALES_SAMPLE_DATA
GROUP BY CUSTOMERNAME;


SELECT * FROM SALES_SAMPLE_DATA where  CUSTOMERNAME LIKE "Alpha%";
CREATE OR REPLACE VIEW RFM_SEGMENT AS 

    WITH RFM_INITIAL_CALC AS (
   SELECT
    CUSTOMERNAME,
    ROUND(SUM(SALES),0) AS MonetaryValue,
    COUNT(DISTINCT ORDERNUMBER) AS Frequency,
    -- MAX(STR_TO_DATE(ORDERDATE,' %d/%m/%y')) AS EACH_CUSTOMERS_LAST_TRANSACTION_DATE,
    -- (SELECT MAX(STR_TO_DATE(ORDERDATE, '%d/%m/%y')) FROM SALES_SAMPLE_DATA) AS BUSINESS_LAST_TRANSACTION_DATE,
    DATEDIFF(MAX(STR_TO_DATE(ORDERDATE, '%d/%m/%y')), (SELECT MAX(STR_TO_DATE(ORDERDATE, '%d/%m/%y')) FROM SALES_SAMPLE_DATA)) * (-1) AS Recency
FROM SALES_SAMPLE_DATA
GROUP BY CUSTOMERNAME
),
RFM_SCORE_CALC AS (
    SELECT 
        C.*,
        NTILE(4) OVER (ORDER BY C.Recency DESC) AS RFM_RECENCY_SCORE,
        NTILE(4) OVER (ORDER BY C.Frequency ASC) AS RFM_FREQUENCY_SCORE,
        NTILE(4) OVER (ORDER BY C.MonetaryValue ASC) AS RFM_MONETARY_SCORE
    FROM 
        RFM_INITIAL_CALC AS C
)
SELECT
    R.CUSTOMERNAME,
    (R.RFM_RECENCY_SCORE + R.RFM_FREQUENCY_SCORE + R.RFM_MONETARY_SCORE) AS TOTAL_RFM_SCORE,
    CONCAT_WS(
		'', R.RFM_RECENCY_SCORE, R.RFM_FREQUENCY_SCORE, R.R.RFM_MONETARY_SCORE
    ) AS RFM_CATEGORY_COMBINATION
FROM 
RFM_SCORE_CALC AS R; 



-- What was the best month for sales in a specific year? How much was earned that month? 
select  MONTH_ID, sum(sales) Revenue, count(ORDERNUMBER) Frequency
from SALES_SAMPLE_DATA
where YEAR_ID = 2004 -- change year to see the rest
group by  MONTH_ID
order by 2 desc;

-- Who is our best customer (this could be best answered with RFM)
-- SELECT DATE_FORMAT(STR_TO_DATE(ORDERDATE, '%d/%m/%y'), '%Y-%m-%d') AS converted_date 
-- FROM SALES_SAMPLE_DATA;


SELECT ORDERDATE FROM SALES_SAMPLE_DATA LIMIT 5;
SELECT STR_TO_DATE(ORDERDATE, '%d/%m/%y') AS `Date` FROM SALES_SAMPLE_DATA LIMIT 5;

SELECT MAX(STR_TO_DATE(ORDERDATE, '%d/%m/%y')) AS LATESTDATE from SALES_SAMPLE_DATA; -- 2005-05-31: Last Transaction Date
SELECT MIN(STR_TO_DATE(ORDERDATE, '%d/%m/%y')) AS EARLIESTDATE from SALES_SAMPLE_DATA; -- 2003-01-06 : First Transaction Date

SELECT 
    DATEDIFF(MAX(STR_TO_DATE(ORDERDATE, '%d/%m/%y')), MIN(STR_TO_DATE(ORDERDATE, '%d/%m/%y'))) AS 'Range' 
    FROM SALES_SAMPLE_DATA; -- Range of Transaction is 876 Days

-- RFM SEGMENTATION: SEGMENTING YOUR CUSTOMER BASEN ON RECENCY (R), FREQUENCY (F), AND MONETARY (M) SCORES


SELECT
    CUSTOMERNAME,
    ROUND(SUM(SALES),0) AS MonetaryValue,
    COUNT(DISTINCT ORDERNUMBER) AS Frequency,
    -- MAX(STR_TO_DATE(ORDERDATE,' %d/%m/%y')) AS EACH_CUSTOMERS_LAST_TRANSACTION_DATE,
    -- (SELECT MAX(STR_TO_DATE(ORDERDATE, '%d/%m/%y')) FROM SALES_SAMPLE_DATA) AS BUSINESS_LAST_TRANSACTION_DATE,
    DATEDIFF(MAX(STR_TO_DATE(ORDERDATE, '%d/%m/%y')), (SELECT MAX(STR_TO_DATE(ORDERDATE, '%d/%m/%y')) FROM SALES_SAMPLE_DATA))   AS Recency
FROM SALES_SAMPLE_DATA
GROUP BY CUSTOMERNAME;

-- SELECT * FROM SALES_SAMPLE_DATA where  CUSTOMERNAME LIKE "Alpha%";
CREATE OR REPLACE VIEW RFM_SEGMENT AS 
WITH RFM_INITIAL_CALC AS (
   SELECT
    CUSTOMERNAME,
    ROUND(SUM(SALES),0) AS MonetaryValue,
    COUNT(DISTINCT ORDERNUMBER) AS Frequency,
    -- MAX(STR_TO_DATE(ORDERDATE,' %d/%m/%y')) AS EACH_CUSTOMERS_LAST_TRANSACTION_DATE,
    -- (SELECT MAX(STR_TO_DATE(ORDERDATE, '%d/%m/%y')) FROM SALES_SAMPLE_DATA) AS BUSINESS_LAST_TRANSACTION_DATE,
    DATEDIFF(MAX(STR_TO_DATE(ORDERDATE, '%d/%m/%y')), (SELECT MAX(STR_TO_DATE(ORDERDATE, '%d/%m/%y')) FROM SALES_SAMPLE_DATA)) * (-1) AS Recency
FROM SALES_SAMPLE_DATA
GROUP BY CUSTOMERNAME
),
RFM_SCORE_CALC AS (
    SELECT 
        C.*,
        NTILE(4) OVER (ORDER BY C.Recency DESC) AS RFM_RECENCY_SCORE,
        NTILE(4) OVER (ORDER BY C.Frequency ASC) AS RFM_FREQUENCY_SCORE,
        NTILE(4) OVER (ORDER BY C.MonetaryValue ASC) AS RFM_MONETARY_SCORE
    FROM 
        RFM_INITIAL_CALC AS C
)
SELECT
    R.CUSTOMERNAME,
    (R.RFM_RECENCY_SCORE + R.RFM_FREQUENCY_SCORE + R.RFM_MONETARY_SCORE) AS TOTAL_RFM_SCORE,
    CONCAT_WS(
		'', R.RFM_RECENCY_SCORE, R.RFM_FREQUENCY_SCORE, R.R.RFM_MONETARY_SCORE
    ) AS RFM_CATEGORY_COMBINATION
FROM 
    RFM_SCORE_CALC AS R; 
    
    
SELECT * FROM RFM_SEGMENT;    

SELECT * FROM RFM_SEGMENT;

SELECT DISTINCT
    RFM_CATEGORY_COMBINATION
FROM
    RFM_SEGMENT
ORDER BY 1 DESC;

SELECT 
    CUSTOMERNAME,
    CASE
        WHEN RFM_CATEGORY_COMBINATION IN (111, 112, 121, 132, 211, 211, 212, 114, 141) THEN 'CHURNED CUSTOMER'
        WHEN RFM_CATEGORY_COMBINATION IN (133, 134, 143, 24, 334, 343, 344, 144) THEN 'SLIPPING AWAY, CANNOT LOSE'
        WHEN RFM_CATEGORY_COMBINATION IN (311, 411, 331) THEN 'NEW CUSTOMERS'
        WHEN RFM_CATEGORY_COMBINATION IN (222, 231, 221,  223, 233, 322) THEN 'POTENTIAL CHURNERS'
        WHEN RFM_CATEGORY_COMBINATION IN (323, 333,321, 341, 422, 332, 432) THEN 'ACTIVE'
        WHEN RFM_CATEGORY_COMBINATION IN (433, 434, 443, 444) THEN 'LOYAL'
    ELSE 'CANNOT BE DEFINED'
    END AS CUSTOMER_SEGMENT

FROM RFM_SEGMENT;


WITH CTE1 AS
(SELECT 
    CUSTOMERNAME,
    CASE
        WHEN RFM_CATEGORY_COMBINATION IN (111, 112, 121, 123, 132, 211, 211, 212, 114, 141) THEN 'CHURNED CUSTOMER'
        WHEN RFM_CATEGORY_COMBINATION IN (133, 134, 143, 244, 334, 343, 344, 144) THEN 'SLIPPING AWAY, CANNOT LOSE'
        WHEN RFM_CATEGORY_COMBINATION IN (311, 411, 331) THEN 'NEW CUSTOMERS'
        WHEN RFM_CATEGORY_COMBINATION IN (222, 231, 221,  223, 233, 322) THEN 'POTENTIAL CHURNERS'
        WHEN RFM_CATEGORY_COMBINATION IN (323, 333,321, 341, 422, 332, 432) THEN 'ACTIVE'
        WHEN RFM_CATEGORY_COMBINATION IN (433, 434, 443, 444) THEN 'LOYAL'
    ELSE 'CANNOT BE DEFINED'
    END AS CUSTOMER_SEGMENT
FROM RFM_SEGMENT)

SELECT 
    CUSTOMER_SEGMENT, count(*) as Number_of_Customers
FROM CTE1
GROUP BY 1
ORDER BY 2 DESC;









