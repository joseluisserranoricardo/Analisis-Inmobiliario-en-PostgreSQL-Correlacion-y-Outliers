CREATE TABLE houses (
    id BIGINT,
    date_sold VARCHAR(50),
    price NUMERIC,
    bedrooms INT,
    bathrooms NUMERIC,
    sqft_living INT,
    sqft_lot INT,
    floors NUMERIC,
    waterfront INT,
    view INT,
    condition INT,
    grade INT,
    sqft_above INT,
    sqft_basement INT,
    yr_built INT,
    yr_renovated INT,
    zipcode VARCHAR(20),
    lat NUMERIC,
    long NUMERIC,
    sqft_living15 INT,
    sqft_lot15 INT
);
COPY houses 
FROM 'C:\kc_house_data.csv' 
WITH (FORMAT csv, HEADER true, DELIMITER ',');
select * from houses

SELECT corr(price, sqft_living) AS correlacion_precio_tamaño
FROM houses;

SELECT id, price, sqft_living
FROM houses
WHERE price > (
    SELECT AVG(price) + (3 * stddev(price)) 
    FROM houses
)
ORDER BY price DESC;
