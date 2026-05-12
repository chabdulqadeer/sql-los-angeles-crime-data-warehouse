/* 
    This stored procedure is designed to load crime data from a CSV file into the bronze.crimedata table. 
    It uses the BULK INSERT command with specific options to handle modern CSV formats, including quoted fields and proper line terminators.
    Error handling is implemented to catch and report any issues that occur during the loading process.
*/
CREATE OR ALTER PROCEDURE BRONZE_LOAD_CRIMEDATA AS
BEGIN
      BEGIN TRY
        TRUNCATE TABLE bronze.crimedata;
        BULK INSERT bronze.crimedata
        FROM 'D:\Crime Database\Dataset\crimedata.csv'
        WITH (
            FORMAT = 'CSV',         -- Crucial for modern CSV handling
            FIRSTROW = 2,
            FIELDQUOTE = '"',       -- Handles values like "New York, NY"
            FIELDTERMINATOR = ',',
            ROWTERMINATOR = '0x0a', -- Uses hex for Line Feed (handles both \n and \r\n better)
            TABLOCK
        )
       END TRY
       BEGIN CATCH
       PRINT 'ERROR HAS BEEN OCCURED.';
       PRINT 'ERORR MESSAGE : ' + ERROR_MESSAGE();
       PRINT 'ERROR LINE : ' + ERROR_LINE();
       PRINT 'ERROR NUMBER : ' + ERROR_NUMBER();
       END CATCH
    END
;

