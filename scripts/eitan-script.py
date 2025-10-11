import pandas as pd

print("Loading data...")
background = pd.read_csv('data/background-clean.csv')
interest = pd.read_csv('data/interest-clean.csv')

print("Data loaded successfully!")
print("Background data shape:", background.shape)
print("Interest data shape:", interest.shape)

## individual variable summaries
###############################

# one variable, one summary
print("\nFirst 5 rows of background data:")
print(background.head())