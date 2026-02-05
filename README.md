### 🏠 Análisis Inmobiliario en PostgreSQL: Correlación y Outliers
Este proyecto realiza un análisis estadístico avanzado sobre el dataset de ventas de casas en King County (Seattle). El objetivo es identificar la relación entre las características físicas de las viviendas y su precio, además de detectar valores atípicos (outliers) mediante métodos estadísticos.

📊 Dataset Utilizado
Nombre: House Sales in King County, USA.

Origen: Kaggle.

Volumen: ~21,600 registros.

## 🛠️ 1. Configuración del Entorno
Crear la tabla en PostgreSQL

Ejecuta el siguiente script en el Query Tool de pgAdmin para preparar la base de datos:

```sql
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
 ```
##2. Ingesta de Datos (ETL)

Para cargar el archivo CSV directamente desde el disco local. Nota: Se utiliza '/' para evitar errores de escape de caracteres en Windows.
```sql
COPY houses 
FROM 'C:/kc_house_data.csv' 
WITH (FORMAT csv, HEADER true, DELIMITER ',');
```
-- Verificación de carga
```sql
SELECT COUNT(*) AS total_registros FROM houses;
```
## 📈 Análisis Estadístico

## 3. Cálculo de Correlación

Utilizamos la función nativa corr() para medir la relación lineal entre el precio y la superficie habitable. El coeficiente de Pearson varía entre -1 y 1.
```sql
SELECT 
    ROUND(corr(price, sqft_living)::numeric, 4) AS correlacion_precio_tamaño
FROM houses;
```
![correlacion](https://github.com/user-attachments/assets/744f5199-309a-4ff6-98a6-f2546fcb8ee1)
Con esto se identificó que el tamaño de la propiedad influye fuertemente en el precio de la vivienda.

## 4. Detección de Outliers (Z-Score)

Identificamos propiedades que se desvían significativamente de la media. En este caso, buscamos precios que superan 3 desviaciones estándar por encima del promedio.
```sql
SELECT 
    id, 
    price, 
    sqft_living,
    ROUND((price - (SELECT AVG(price) FROM houses)) / (SELECT STDDEV(price) FROM houses), 2) AS z_score
FROM houses
WHERE price > (
    SELECT AVG(price) + (3 * stddev(price)) 
    FROM houses
)
ORDER BY price DESC;
```
Este análisis ayuda a separar propiedades de lujo o posibles errores de entrada de datos del mercado general.
![outliers](https://github.com/user-attachments/assets/1aa5e150-3e2c-4a72-8991-12f2bc2acd62)
# 🛠️ Requisitos

PostgreSQL 12 o superior.

pgAdmin 4 (opcional, para visualización).

El archivo kc_house_data.csv debe estar ubicado en la raíz C:/ para evitar conflictos de permisos.
