CREATE DATABASE m;

CREATE TABLE totals
(
DATE TEXT,
VIEWS INT
) ;

SELECT * FROM TOTALS; 

ALTER TABLE totals Modify column
date date;
ALTER TABLE totals Modify column views INT;
ALTER TABLE totals ADD PRIMARY KEY (date);

select * from totals;
SHOW COLUMNS from totals;

update totals set date = str_to_date(date, "%m/%d/%Y");

DELETE FROM totals WHERE date = 'H';

CREATE TABLE cont_chart
(
date TEXT,
content VARCHAR(20),
video_title VARCHAR(50),
video_publishtime TEXT,
views INT
);

SELECT * from cont_chart;
SHOW COLUMNS from cont_chart;
ALTER TABLE cont_chart add PRIMARY KEY (content, date);

update cont_chart set date = str_to_date(date, "%m/%d/%Y");
update cont_chart set video_publishtime = str_to_date(video_publishtime, "%m/%d/%Y");

ALTER TABLE cont_chart modify column date date;
ALTER TABLE cont_chart modify column video_publishtime date;
ALTER TABLE cont_chart modify column video_title VARCHAR(60);


CREATE TABLE cont_table
(
content VARCHAR(20),
video_title VARCHAR(60),
video_publishtime TEXT,
views INT,
watchtime_hrs FLOAT,
subscribers INT,
impressions INT,
impressions_ctr FLOAT
) ;

SELECT * from cont_table;
SHOW COLUMNS from cont_table;
ALTER TABLE cont_table add PRIMARY KEY (content);

update cont_table set video_publishtime = str_to_date(video_publishtime, "%m/%d/%Y");

ALTER TABLE cont_table modify column video_publishtime date;

CREATE TABLE geo_chart
(
date TEXT,
geography VARCHAR(5),
country VARCHAR(30),
views INT
) ;

SELECT * from geo_chart;
SHOW COLUMNS from geo_chart;
ALTER TABLE geo_chart add PRIMARY KEY (date, country);

update geo_chart set date = str_to_date(date, "%m/%d/%Y");

ALTER TABLE geo_chart modify column date date;

CREATE TABLE geo_table
(
geography VARCHAR(5),
country VARCHAR(30),
views INT,
watchtime_hrs FLOAT,
avgview_secs INT
) ;

DROP table geo_table;
SELECT * from geo_table;
SHOW COLUMNS from geo_table;
ALTER TABLE geo_table add PRIMARY KEY (country);

update geo_chart set date = str_to_date(date, "%m/%d/%Y");

ALTER TABLE geo_chart modify column date date;

CREATE TABLE traff_chart
(
date TEXT,
trafficsource VARCHAR(30),
views INT
) ;

SELECT * from traff_chart;
SHOW COLUMNS from traff_chart;
ALTER TABLE traff_chart add PRIMARY KEY (date, trafficsource);

update traff_chart set date = str_to_date(date, "%m/%d/%Y");

ALTER TABLE traff_chart modify column date date;

CREATE TABLE traff_table
(
trafficsource VARCHAR(30),
views INT,
watchtime_hrs FLOAT,
avgview_sec INT,
impressions INT,
impressions_ctr FLOAT
) ;

SELECT * from traff_table;
SHOW COLUMNS from traff_table;
ALTER TABLE traff_table add PRIMARY KEY (trafficsource);

update traff_chart set date = str_to_date(date, "%m/%d/%Y");

ALTER TABLE traff_chart modify column date date;

Select DISTINCT cc.video_title, ct.watchtime_hrs, ct.impressions, ct.impressions_ctr
from cont_chart cc INNER JOIN cont_table ct
on cc.content = ct.content
ORDER BY ct.watchtime_hrs desc;