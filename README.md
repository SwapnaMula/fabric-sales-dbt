# Fabric Sales — End-to-End Data Pipeline with dbt

## Overview

An end-to-end data engineering pipeline built using Microsoft Fabric, dbt (data build tool), Snowflake, and SQL Server (SSMS), following the Medallion Architecture (Bronze → Silver → Gold).
Raw sales data from two different source systems is ingested into Microsoft Fabric Lakehouse, progressively cleaned and transformed using dbt SQL models, and stored as analysis-ready Gold tables.

## Architecture Workflow

<img width="1422" height="459" alt="Fabric Workflow" src="https://github.com/user-attachments/assets/f1bdcdb2-c84e-41cd-8050-96e01ebf899e" />

## Tech Stack

|      Tool            |                    Purpose                                 |
|----------------------|----------------------------------------------------------- |
| Microsoft Fabric     |   Data Pipeline (ingestion) + Lakehouse (storage & compute)|
| dbt (dbt-fabricspark)|  SQL transformations on Fabric Spark via Livy              |    
| Snowflake            |  Source system — Orders and Sales dataSQL                  |
| Server / SSMS        |  Source system — Customers and Products data               |
| Azure CLI            |  Authentication for Fabric connection                      |
| GitHub               |  Version control for all dbt models                        |

## Data Sources
  
|  Table    |      Source        |  Rows    |
|-----------|--------------------|----------|
| Customers |  SQL Server (SSMS) |  10,000  |
| Products  |  SQL Server (SSMS) |  10,000  |
| Orders    |  Snowflake         |  15,000  |
| Sales     |  Snowflake         |  15,000  |

## Medallion Architecture

### 🥉 Bronze Layer — Raw Ingestion

Data landed as-is from source systems via Fabric Data Pipeline copy activities. No transformations applied.

|    Table         |             Description                 |
|------------------|-----------------------------------------|
| Bronze_Customers |   Raw customer records from SSMS        |
| Bronze_Products  |   Raw product catalog from SSMS         |
| Bronze_Orders    |   Raw order transactions from Snowflake |
| Bronze_Sales     |   Raw sales records from Snowflake      |

### 🥈 Silver Layer — Cleaned & Enriched

dbt SQL models that clean, standardize, and enrich the Bronze data.

|      Model              |         Key Transformations                                     |
|-------------------------|---------------------------------------------------------------- | 
| Silver_Customers        |  INITCAP on names/city, UPPER on region, null filtering         |
| Silver_Products         |  INITCAP on category, ROUND on unit_price, filter zero prices   |
| Silver_Orders           |  CAST to DATE, derived order_year and order_month columns       |
| Silver_Sales            |  ROUND amounts, calculate net_sales after discount, UPPER status|

### 🥇 Gold Layer — Business Aggregations

Business-ready fact and summary tables built by joining Silver models.

|     Model            |              Description                                  |
|----------------------|-----------------------------------------------------------|
|Gold_Sales_Summary    |  Full fact table joining all four Silver models           |
|Gold_Customer_Summary |  Customer KPIs — total orders, revenue, avg order value   |
|Gold_Product_Summary  |  Product KPIs — quantity sold, total revenue, avg discount|

## Project Structure

```
fabric_sales/
├── models/
│   ├── sources.yml                    # Bronze source table declarations
│   ├── silver/
│   │   ├── Silver_Customers.sql
│   │   ├── Silver_Products.sql
│   │   ├── Silver_Orders.sql
│   │   └── Silver_Sales.sql
│   └── gold/
│       ├── Gold_Sales_Summary.sql
│       ├── Gold_Customer_Summary.sql
│       └── Gold_Product_Summary.sql
├── dbt_project.yml                    # Project config and materialization settings
└── .gitignore                         # Excludes profiles.yml, target/, logs/
```
## Setup & Run

### Prerequisites

- Python 3.11+
- Azure CLI installed
- Microsoft Fabric workspace with a Lakehouse
- Snowflake account
- SQL Server (SSMS)

**Step 1 — Install dependencies**

```
bashpip install dbt-core==1.9.0 dbt-fabricspark==1.9.5
```

**Step 2 — Configure profiles.yml**

Create C:\Users\<your_username>\.dbt\profiles.yml:
```
yaml
fabric_sales:
  target: dev
  outputs:
    dev:
      type: fabricspark
      method: livy
      authentication: CLI
      endpoint: https://api.fabric.microsoft.com/v1
      workspaceid: <your_workspace_id>
      lakehouse: <your_lakehouse_name>
      lakehouseid: <your_lakehouse_id>
      schema: dbo
      threads: 4
      spark_config:
        name: fabric_sales
```

**Step 3 — Authenticate**

```
bash
az login --allow-no-subscriptions
```
**Step 4 — Run dbt**

```
bash
dbt run
```
**Expected Output**

```
1 of 7 OK created sql table model dbo.Silver_Customers
2 of 7 OK created sql table model dbo.Silver_Orders
3 of 7 OK created sql table model dbo.Silver_Products
4 of 7 OK created sql table model dbo.Silver_Sales
5 of 7 OK created sql table model dbo.Gold_Customer_Summary
6 of 7 OK created sql table model dbo.Gold_Product_Summary
7 of 7 OK created sql table model dbo.Gold_Sales_Summary

PASS=7 WARN=0 ERROR=0 SKIP=0 TOTAL=7
```

## Key Learnings

- Connecting dbt to Microsoft Fabric Spark via the Livy protocol
- spark_config: name is a required but undocumented field in dbt-fabricspark 1.9.5
- Version pairing: dbt-core 1.9.0 must match dbt-fabricspark 1.9.5
- Medallion Architecture for progressive data refinement
- Using ref() for model dependencies and source() for Bronze table references
- Azure CLI authentication with az login --allow-no-subscriptions

## Results

All 7 Delta tables successfully created in Microsoft Fabric Lakehouse under:

Data_Storing → Tables → dbo


### Using the starter project

Try running the following commands:
- dbt run
- dbt test


### Resources:
- Learn more about dbt [in the docs](https://docs.getdbt.com/docs/introduction)
- Check out [Discourse](https://discourse.getdbt.com/) for commonly asked questions and answers
- Join the [chat](https://community.getdbt.com/) on Slack for live discussions and support
- Find [dbt events](https://events.getdbt.com) near you
- Check out [the blog](https://blog.getdbt.com/) for the latest news on dbt's development and best practices
