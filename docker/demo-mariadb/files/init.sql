GRANT ALL PRIVILEGES ON *.* TO 'root'@'%';

create database demo1;

use demo1;

create table t1A (pk int primary key, v varchar(20));
insert into t1A values(1, 'Table A Row One');
insert into t1A values(2, 'Table A Row Two');
insert into t1A values(3, 'Table A Row Three');
insert into t1A values(4, 'Table A Row Four');

create table t1B (pk int primary key, v varchar(20));
insert into t1B values(1, 'Table B Row One');
insert into t1B values(2, 'Table B Row Two');
insert into t1B values(3, 'Table B Row Three');
insert into t1B values(4, 'Table B Row Four');
