# LEVO-Oil-Data-Manipulation-Postgres

PostgreSQL scripts for the following tasks:

levo-schema-&-all-order-data.sql

* Create the 'levo' schema
* Create the 'all_order_data' table
* Import 51,000+ line-item records, from https://docs.google.com/spreadsheets/d/1b9MmwR1VZUwMBoP0cveXe7ZZZUc2V3Hy/edit#gid=1915852792, into the 'all_order_data' table

levo-sas-churn-dataset-creation.sql

* Create a new 'sas_churn_dataset' table to be used in SAS Analysis
* Aggregate important information to create 16 columns describing customers
* Leverage subquery to determine the number of product types purchased
