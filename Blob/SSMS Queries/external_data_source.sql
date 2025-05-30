CREATE EXTERNAL DATA SOURCE yellow_taxis_csv_blob_data_source
WITH (
    TYPE = BLOB_STORAGE,
    LOCATION = '<URL>',
    CREDENTIAL = yellow_taxis_csv_blob_sas_cred
);
