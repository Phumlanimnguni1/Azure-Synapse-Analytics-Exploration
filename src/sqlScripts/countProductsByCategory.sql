-- This is auto-generated code
SELECT
    Category, COUNT(*) AS ProductCount
FROM
    OPENROWSET(
        BULK 'https://datalakeo6ejbiz.dfs.core.windows.net/files/product_data/products.csv',
        FORMAT = 'CSV',
        PARSER_VERSION = '2.0',
        HEADER_ROW = TRUE
    ) AS [result]
 GROUP BY Category;