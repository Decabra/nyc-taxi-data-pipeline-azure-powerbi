-- Run in the database that we need access to via SQL Authentication
CREATE USER <USERNAME> FOR LOGIN <USERNAME>;
ALTER ROLE db_owner ADD MEMBER <USERNAME>;
