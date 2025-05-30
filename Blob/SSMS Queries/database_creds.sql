-- Create database scoped credentials, drop any datasource if it is already using the creds
-- Drop the data source that was using this creds before
DROP EXTERNAL DATA SOURCE yellow_taxis_csv_blob_data_source;
-- Drop the creds if already exists
DROP DATABASE SCOPED CREDENTIAL yellow_taxis_csv_blob_sas_cred;
-- Create new creds with updated secret if applies
CREATE DATABASE SCOPED CREDENTIAL yellow_taxis_csv_blob_sas_cred
WITH IDENTITY = 'SHARED ACCESS SIGNATURE',
SECRET = 'sp=r&st=2025-05-29T22:57:24Z&se=2025-05-30T06:57:24Z&spr=https&sv=2024-11-04&sr=b&sig=wQUutiGWuvVzyhq200ujp%2FEtyA%2FRtHQ%2Bb86focuSbO0%3D';
