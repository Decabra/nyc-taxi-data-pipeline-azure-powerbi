
# TLC NYC YELLOW TAXIS DATASET | Azure Cloud | Power BI

This project demonstrates two full data engineering pipelines for loading and visualizing large-scale datasets (80M+ rows) into Azure SQL and Power BI using two distinct approaches:

- **Approach 1:** Parquet + Staging Tables + MERGE (Classic ETL)
- **Approach 2:** Azure Blob Storage + BULK INSERT (Modern Cloud ETL)

Both pipelines were fully tested using the TLC NYC Yellow Taxis Dataset.

---

## Dataset

**TLC NYC Yellow Taxis Dataset**  
- ~80 Million Rows  
- Source format: Parquet  
- Schema: TripID, Pickup/Dropoff Datetime, LocationID, Fare, Tip, Passenger Count, Trip Distance, etc.
- Link: [TLC Trip Record Data](https://www.nyc.gov/site/tlc/about/tlc-trip-record-data.page)

---

# Approach 1: Parquet + Staging Tables + MERGE (Classic ETL)

## Architecture Summary

- Local Machine: Reads parquet chunks, uploads to Azure SQL Staging Table.
- Azure SQL Database: Serverless (General Purpose, 2 vCore, 32GB Max Storage)
- MERGE Query: Deduplicates and merges records into main production table.

## Step-by-Step Process

1. **Connect to Azure SQL Server**
   - Create SQL Server instance on Azure.
   - Create database and required tables.

2. **Read Parquet Files**
   - Use Python libraries like `pandas` and `pyarrow` to load parquet files locally.

3. **Create SQL Tables**
   - Create two tables:
     - Staging Table (temporary load area)
     - Main Table (final production table)

4. **Define Chunk Size & Loop**
   - Split large dataframe into smaller chunks (ex: 500K rows per chunk).
   - Upload each chunk to Staging Table using SQL Alchemy or pyodbc.

5. **Checkpointing**
   - Save loop progress after each batch.
   - On failure, resume from last successful checkpoint.

6. **MERGE Query Logic**

```sql
MERGE INTO main_table AS target
USING staging_table AS source
ON target.record_id = source.record_id
WHEN MATCHED THEN UPDATE SET ...
WHEN NOT MATCHED THEN INSERT (...);
```

## Pros

- Ensures no duplication even after network interruptions.
- Easy to resume interrupted uploads.
- Requires minimal Azure-specific configuration.

## Cons

- Slow for very large datasets (millions of rows).
- Heavy read/write I/O on local machine.
- Long runtime (hours for 80M rows).

---

# Approach 2: Azure Blob Storage + BULK INSERT (Modern Cloud ETL)

## Architecture Summary

- Azure Blob Storage: Centralized cloud storage layer.
- Azure SQL Database: Directly pulls data from Blob using BULK INSERT.
- Python Preprocessing: Consolidates data into final CSV.

## Step-by-Step Process

1. **Create Azure Blob Storage Account**
   - Create storage account on Azure.
   - Create container (logical storage bucket).

2. **Read & Cleanse Data**
   - Use Python to read parquet files.
   - Standardize schema, clean nulls, optimize datatypes.
   - Consolidate into one large parquet file.

3. **Convert to CSV**
   - Use `pyarrow` to convert parquet file into CSV format for BULK INSERT compatibility.

4. **Upload to Blob**
   - Use `azure-storage-blob` Python package to upload CSV file into Azure Blob container.

5. **Configure Azure SQL Permissions**
   - Generate Shared Access Signature (SAS) Token for the uploaded CSV file.
   - Create Database Master Key:

```sql
CREATE MASTER KEY ENCRYPTION BY PASSWORD = 'your_password';
```

   - Create Database Scoped Credential:

```sql
CREATE DATABASE SCOPED CREDENTIAL blob_credential
WITH IDENTITY='SHARED ACCESS SIGNATURE',
SECRET = 'your_sas_token';
```

   - Create External Data Source:

```sql
CREATE EXTERNAL DATA SOURCE blob_data_source
WITH (TYPE = BLOB_STORAGE, LOCATION = 'https://youraccount.blob.core.windows.net/container', CREDENTIAL= blob_credential);
```

6. **BULK INSERT Command**

```sql
BULK INSERT dbo.main_table
FROM 'yourfile.csv'
WITH (
    DATA_SOURCE = 'blob_data_source',
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    TABLOCK
);
```

## Pros

- Enterprise-grade architecture.
- Highly scalable for huge datasets (50M+ rows handled in minutes).
- Minimal local compute resource required.
- Fully cloud native.

## Cons

- Requires deeper Azure Blob + SQL configurations.
- More moving parts (SAS Token, External Data Source, etc).
- Initial setup more complex than Parquet-Merge approach.

---

# Comparison Table

| Feature | Parquet + MERGE | Blob + BULK INSERT |
|---------|------------------|--------------------|
| Complexity | Simple | Medium |
| Speed | Slow | Very Fast |
| Resumable Uploads | Yes (Checkpointing) | No (Needs full file ready) |
| Cloud Native | Partial | Fully |
| Suitable for | Small-Medium Datasets | Very Large Datasets |
| Setup Effort | Low | Medium |
| Real-world Enterprise Fit | Moderate | High |

---

# Power BI Visualization

- Dataset (~80M rows) fully loaded into Azure SQL.
- Power BI connected via Direct Query / Import mode.
- Model includes:
  - Trip counts over time
  - Average fare amounts
  - Heatmap of trip pickup locations
  - Peak hours vs off-hours comparisons
  - Passenger count distribution

- Live Dashboard Link: **[NYC Yellow Taxis](https://github.com/Decabra/nyc-taxi-data-pipeline-azure-powerbi/edit/main/README.md)**

---

# Conclusion

This project demonstrates end-to-end large scale ETL pipelines into Azure SQL with two contrasting architectures. While both approaches are fully functional and production-ready, the second approach using Azure Blob and BULK INSERT is highly scalable for true enterprise workloads.

Future enhancements may include:

- Azure Data Factory orchestration
- Azure Functions automation
- Advanced partitioning for further Power BI optimizations
- Dynamic incremental refresh in Power BI for near real-time reporting

---

> Built as a real-world simulation of enterprise data ingestion pipelines and cloud-based BI reporting using Azure & Power BI.
