CREATE DATABASE Epro;
alter database Epro set single_user with rollback immediate;
go
alter database Epro collate sql_latin1_general_cp1_ci_ai;
go
alter database Epro set multi_user;
quit