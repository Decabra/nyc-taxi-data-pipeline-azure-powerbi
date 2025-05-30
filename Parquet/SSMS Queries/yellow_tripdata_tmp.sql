-- Create temporary table at cloud for data upload
CREATE TABLE yellow_tripdata_tmp (
    record_id INT PRIMARY KEY,
    tpep_pickup_datetime DATETIME,
    tpep_dropoff_datetime DATETIME,
    passenger_count FLOAT,
    trip_distance FLOAT,
    PULocationID INT,
    DOLocationID INT,
    payment_type INT,
    fare_amount FLOAT,
    extra FLOAT,
    mta_tax FLOAT,
    tip_amount FLOAT,
    tolls_amount FLOAT,
    total_amount FLOAT,
    congestion_surcharge FLOAT,
    Airport_fee FLOAT,
    created_at DATETIME DEFAULT GETDATE(),
    updated_at DATETIME
);
