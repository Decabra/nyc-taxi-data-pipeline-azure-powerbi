-- Create database scoped credentials, drop any data source if it is already using the creds
-- Drop the data source that was using this creds before
DROP EXTERNAL DATA SOURCE yellow_taxis_csv_blob_data_source;
-- Drop the creds if already exists
DROP DATABASE SCOPED CREDENTIAL yellow_taxis_csv_blob_sas_cred;
-- Create new creds with updated secret if applies
CREATE DATABASE SCOPED CREDENTIAL yellow_taxis_csv_blob_sas_cred
WITH IDENTITY = 'SHARED ACCESS SIGNATURE',
SECRET = '<TOKEN>';
