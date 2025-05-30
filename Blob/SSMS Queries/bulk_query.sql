BULK INSERT staging_chunk
FROM 'yellow-taxis.csv' -- blob filename
WITH (
    DATA_SOURCE = 'yellow_taxis_csv_blob_data_source',
    FORMAT = 'CSV',
    FIRSTROW = 2, -- assuming first row has headers
    FIELDTERMINATOR = ',', 
    ROWTERMINATOR = '0x0A',
    TABLOCK
);
