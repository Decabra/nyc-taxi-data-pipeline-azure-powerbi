-- Run in the database that we need access to via SQL Authentication
CREATE USER sarmadcute83 FOR LOGIN sarmadcute83;
ALTER ROLE db_owner ADD MEMBER sarmadcute83;
