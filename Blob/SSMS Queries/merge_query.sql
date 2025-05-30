MERGE yellow_tripdata_tmp AS target
        USING staging_chunk AS source
        ON target.record_id = source.record_id
        WHEN MATCHED THEN
            UPDATE SET
                target.tpep_pickup_datetime = source.tpep_pickup_datetime,
                target.tpep_dropoff_datetime = source.tpep_dropoff_datetime,
                target.passenger_count = source.passenger_count,
                target.trip_distance = source.trip_distance,
                target.PULocationID = source.PULocationID,
                target.DOLocationID = source.DOLocationID,
                target.payment_type = source.payment_type,
                target.fare_amount = source.fare_amount,
                target.extra = source.extra,
                target.mta_tax = source.mta_tax,
                target.tip_amount = source.tip_amount,
                target.tolls_amount = source.tolls_amount,
                target.total_amount = source.total_amount,
                target.congestion_surcharge = source.congestion_surcharge,
                target.Airport_fee = source.Airport_fee,
                target.updated_at = GETDATE()
        WHEN NOT MATCHED THEN
            INSERT (
                record_id,
                tpep_pickup_datetime,
                tpep_dropoff_datetime,
                passenger_count,
                trip_distance,
                PULocationID,
                DOLocationID,
                payment_type,
                fare_amount,
                extra,
                mta_tax,
                tip_amount,
                tolls_amount,
                total_amount,
                congestion_surcharge,
                Airport_fee,
                created_at
            )
            VALUES (
                source.record_id,
                source.tpep_pickup_datetime,
                source.tpep_dropoff_datetime,
                source.passenger_count,
                source.trip_distance,
                source.PULocationID,
                source.DOLocationID,
                source.payment_type,
                source.fare_amount,
                source.extra,
                source.mta_tax,
                source.tip_amount,
                source.tolls_amount,
                source.total_amount,
                source.congestion_surcharge,
                source.Airport_fee,
                GETDATE()
            );