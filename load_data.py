import requests
import pandas as pd
from sqlalchemy import create_engine
import io
import os

# Get environment variables
db_user = os.getenv('DB_USER')
db_password = os.getenv('DB_PASSWORD')
db_host = os.getenv('DB_HOST', 'postgres')  # Use the 'postgres' service name as the host
db_name = os.getenv('DB_NAME')

# URL of the dataset
dataset_url = 'https://opendata.dc.gov/api/download/v1/items/c5a9f33ffca546babbd91de1969e742d/csv?layers=6'  # Replace with the actual URL of the dataset

# Download the dataset (assuming it's in CSV format)
response = requests.get(dataset_url)
if response.status_code == 200:
    print("Dataset successfully downloaded.")
    dataset_csv = io.StringIO(response.text)  # Use StringIO to load the data into pandas directly

    # Load the dataset into a pandas DataFrame
    df = pd.read_csv(dataset_csv)

    # Print out the first few rows to inspect
    print(df.head())
else:
    print(f"Failed to download the dataset. Status code: {response.status_code}")
    exit()

# Define the table name
schema_name = 'raw'
table_name = 'crime_incidents_2024'

# Create a PostgreSQL connection string (using SQLAlchemy)
connection_string = f'postgresql+psycopg2://{db_user}:{db_password}@{db_host}:5432/{db_name}'

# Create a SQLAlchemy engine
engine = create_engine(connection_string)

# If the table already exists, you can choose to append or replace it
# Use "replace" to overwrite or "append" to add new records
df.to_sql(table_name, engine, schema=schema_name, if_exists='replace', index=False)

print(f"Data loaded into PostgreSQL table '{table_name}' successfully.")
