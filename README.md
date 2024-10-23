# BoxStore Database Project

## Overview
This project focuses on creating and managing a database system for an inventory and product management system, referred to as **BoxStore**. The database was designed and implemented using SQL, with an accompanying Entity Relationship Diagram (ERD) for visualization.

## 🚀Key Features
- **Database Creation**: The SQL script (`hk_0398817_boxstore.sql`) contains all necessary commands to create the tables and relationships for managing products, orders, and inventory.
- **Entity Relationship Diagram (ERD)**: The ERD file (`hk_0398817_boxstore.drawio`) illustrates the database structure, showing relationships between tables and entities.
- **Database Functions**:
  - Manage product details (e.g., product name, SKU, price).
  - Track inventory levels and changes.
  - Handle customer orders and purchases.

## 💡Project Files
- **SQL Script**: Contains the commands for table creation, relationships, and queries (`hk_0398817_boxstore.sql`).
- **ERD Diagram**: Visual representation of the database structure (`hk_0398817_boxstore.drawio`).

## ⚙️How to Use
1. Clone the repository or download the files.
2. Use the SQL script to create the database in your preferred SQL environment (e.g., MySQL, PostgreSQL).
3. View the ERD diagram with any diagram software that supports the `.drawio` format (e.g., Draw.io or Lucidchart).

## 🛠️Libraries and Tools
- **SQL**: For database management and query execution.
- **Draw.io**: For designing the ERD diagram.

## 🎯Database Normalization
This project also includes the normalization of data to ensure an efficient, scalable database structure. The normalization process reduced redundancy and improved data integrity by organizing data into the appropriate normal forms.

### 🖥️Normalization Process
- **Unnormalized Form (UNF)**: Raw data that may contain redundancy.
- **First Normal Form (1NF)**: Ensured atomicity by removing duplicate rows and repeating groups.
- **Second Normal Form (2NF)**: Removed partial dependencies by separating data based on functional dependencies.
- **Third Normal Form (3NF)**: Removed transitive dependencies, ensuring that non-key attributes are only dependent on the primary key.

The **Excel file** (`COMP-1701_Fina1l_SQL_Competency_F-Database-Normalization-wp.xlsx`) provides detailed steps and examples of the normalization process.


