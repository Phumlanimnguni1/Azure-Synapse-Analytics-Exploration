# Azure Data Engineering: End-to-End Analytics with Azure Synapse

## Overview
This project explores utilizing Azure Synapse Analytics as a single, consolidated data analytics platform to perform end-to-end data analytics. The objective is to provision a workspace and explore various ways to ingest, process, and query data using Serverless SQL, Apache Spark, Dedicated SQL pools, and Data Explorer.

___
## Problem Statement

Enterprise data often resides in disparate formats—ranging from unstructured files to structured relational tables and time-series telemetry. Analyzing this data typically requires maintaining separate, siloed platforms for data ingestion, big data processing, and traditional data warehousing. This fragmentation creates complex integration challenges, increases operational overhead, and delays time-to-insight for business intelligence reporting. 

___
## Problem Reframing & Requirements
<img width="1920" height="1080" alt="copyDataPipeline" src="https://github.com/user-attachments/assets/2398fc3f-4e6f-44b0-af08-dc4099ce7bea" />

To establish a highly efficient analytics environment, the solution requires a central point for managing data and data processing runtimes. The platform must support:
* Automated provisioning of cloud resources using repeatable DevOps practices (scripts and templates).
* Pipeline integration to transfer and transform data from external HTTP sources into a data lake.
* On-demand, serverless exploration of raw files using standard SQL commands.
* Distributed data processing utilizing programming languages like Python for data preparation.
* High-performance relational data warehousing to support business intelligence workloads.
* Time-series data analysis optimized for real-time log or telemetry data.

___
## Solution & Tool Tradeoffs

The chosen solution implements Azure Synapse Analytics and its web-based interface, Synapse Studio, to consolidate these requirements into a unified workspace.

**Tradeoffs Considered:**
* **Serverless SQL vs. Dedicated SQL:** The built-in Serverless SQL pool is utilized on-demand to explore data directly within the data lake without provisioning infrastructure, whereas the Dedicated SQL pool is utilized to host a permanent relational data warehouse for structured business intelligence queries.
* **Apache Spark vs. SQL:** While SQL is ideal for querying structured datasets, Apache Spark pools provide a distributed processing engine that allows data analysts to use languages like Python (PySpark) to explore and prepare unstructured data for analysis.
* **Data Explorer vs. Standard Relational Databases:** A Data Explorer pool is chosen for specific datasets because it utilizes Kusto Query Language (KQL), which is highly optimized for analyzing data containing a time-series component, such as IoT device output or log files, outperforming standard SQL on these workloads.

___
## Architecture
<img width="1920" height="1080" alt="infrastructure" src="https://github.com/user-attachments/assets/9fa70a25-8d79-4ff8-920b-48d7af52c2c8" />

* **Management Interface:** Synapse Studio, a web-based portal used to manage resources, define scripts, and observe data processing jobs.
* **Compute Runtimes:**
  * **Built-in Serverless SQL Pool:** For on-demand file querying.
  * **Dedicated SQL Pool:** Hosting a relational data warehouse database.
  * **Apache Spark Pool:** For programmatic PySpark data processing.
  * **Data Explorer Pool:** For Kusto Query Language (KQL) time-series analytics.
* **Storage:** Azure Data Lake Storage Gen 2 for raw file ingestion.
* **Integration:** Synapse Pipelines utilizing the Copy Data tool to ingest data.

___
## Data Assets & Schemas

The project utilizes diverse datasets to demonstrate multi-engine capabilities:
* **Product Data (Data Lake):** A raw `products.csv` file ingested from a GitHub HTTP source into the data lake, containing dimensions such as `ProductID`, `ProductName`, `Category`, and `ListPrice`.
* **Internet Sales Data (Relational):** Structured tables (`FactInternetSales`, `DimDate`, `DimProduct`) permanently stored in the Dedicated SQL pool.
* **Time-Series Sales Data (Data Explorer):** A `sales` table created within a Data Explorer database and loaded via an HTTP source to facilitate datetime-based aggregation.

___
## Pipeline Execution Flow

The implementation follows a structured progression through the Synapse Studio interface:

1. **Automated Provisioning:** Utilized Azure Cloud Shell with PowerShell (`setup.ps1`) and ARM templates to automatically deploy the Synapse workspace, data lake storage, and compute pools.
2. **Data Ingestion:** Created a pipeline using the Copy Data tool to connect to an external HTTP source and ingest a `products.csv` file into Azure Data Lake Storage Gen 2.
3. **Serverless SQL Exploration:** Executed a SQL script utilizing the `OPENROWSET` function on the built-in pool to directly query the raw CSV file in the data lake and aggregate product counts by category.
4. **Spark DataFrame Analysis:** Attached a PySpark notebook to the Spark pool, loaded the data lake CSV into a DataFrame, and executed Python code to group and visualize the data.
5. **Relational Data Warehousing:** Resumed the Dedicated SQL pool and executed a query joining `FactInternetSales` with `DimDate` and `DimProduct` to calculate units sold by year and month.
6. **Time-Series Analytics:** Resumed the Data Explorer pool, provisioned a `sales-data` database, ingested data, and utilized KQL to filter revenue based on specific datetime boundaries.

___
## Security & Roles

* **Environment Access:** Deployment requires an Azure subscription with administrative-level access.
* **Authentication:** A secure password was explicitly configured for the Azure Synapse SQL pool during the automated PowerShell provisioning phase.
* **Resource Management:** Compute pools (Dedicated SQL and Data Explorer) are manually paused when not in use to ensure secure resource management and cost control.

___
## Business Outcomes & Analytical Outputs

* **Unified Data Visualization:** Successfully generated column charts natively within the Synapse Studio Results pane for both Serverless SQL and PySpark workloads, enabling immediate visual analysis without exporting to external BI tools.
* **Optimized Compute Costs:** Demonstrated the ability to pause dedicated compute pools (SQL and Data Explorer) when idle, while relying on the serverless SQL pool for ad-hoc, cost-efficient data lake exploration.
* **Seamless Multi-Language Analytics:** Proven capability to seamlessly transition between SQL for structured data, Python for exploratory DataFrame operations, and KQL for time-series filtering within a single integrated environment.
