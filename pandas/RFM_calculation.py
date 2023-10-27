# This code retrieves data from a MySQL database using SQLAlchemy and stores it in a Pandas DataFrame.
# It calculates quartiles (percentiles) for the Recency, Frequency, and Monetary values based on the data in the DataFrame.
# It assigns customer segments (Low, Medium, or High) based on the quartiles to each customer in the DataFrame.
# It inserts the segmented data back into a MySQL table named "RFM_Segmented."

import pandas as pd
from sqlalchemy import create_engine

# Set up a connection to your MySQL database
db_url = 'mysql://root:ElTea1994!@localhost:3306/ecommerce'
engine = create_engine(db_url)

# Load data from MySQL into a DataFrame
query = """
    SELECT CustomerID, 
           DATEDIFF(NOW(), LastPurchaseDate) AS Recency, 
           TransactionCount AS Frequency, 
           TotalPurchaseValue AS Monetary 
    FROM RFM_Aggregated
"""

data = pd.read_sql_query(query, engine)

# Calculate quartiles (percentiles) using pandas
# The quartiles represent the distribution of the Recency, Frequency, and Monetary values across your customer base.
quartiles = data.quantile([0.25, 0.50, 0.75])

# Define segmentation criteria based on quartiles
R25, R50, R75 = quartiles['Recency'][0.25], quartiles['Recency'][0.50], quartiles['Recency'][0.75]
F25, F50, F75 = quartiles['Frequency'][0.25], quartiles['Frequency'][0.50], quartiles['Frequency'][0.75]
M25, M50, M75 = quartiles['Monetary'][0.25], quartiles['Monetary'][0.50], quartiles['Monetary'][0.75]

# Create a new column in your DataFrame to store the segment for each customer
data['Segment'] = 'Low'  # Initialize all customers to 'Low' segment

# Apply conditional logic to assign customers to different segments based on their RFM values
data.loc[data['Recency'] <= R25, 'Segment'] = 'Low'
data.loc[(data['Recency'] > R25) & (data['Recency'] <= R50), 'Segment'] = 'Medium'
data.loc[data['Recency'] > R50, 'Segment'] = 'High'

data.loc[data['Frequency'] <= F25, 'Segment'] = 'Low'
data.loc[(data['Frequency'] > F25) & (data['Frequency'] <= F50), 'Segment'] = 'Medium'
data.loc[data['Frequency'] > F50, 'Segment'] = 'High'

data.loc[data['Monetary'] <= M25, 'Segment'] = 'Low'
data.loc[(data['Monetary'] > M25) & (data['Monetary'] <= M50), 'Segment'] = 'Medium'
data.loc[data['Monetary'] > M50, 'Segment'] = 'High'

# Insert the segmented data into the RFM_Segmented table in MySQL
data.to_sql('RFM_Segmented', con=engine, if_exists='replace', index=False)

print("Data has been inserted into RFM_Segmented table.")
