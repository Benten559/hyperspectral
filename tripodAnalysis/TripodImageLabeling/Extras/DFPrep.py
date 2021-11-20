import pandas as pd

"""TO DO:
    Produce a difference set of coordinates by fitering out standards

"""

# Load CSV
df =  pd.read_csv("Bens_WORKFILE_ST_07.csv")

# Grab all those which are labeled as STD (calibration standard)
std = df[ df['Plant #'] == 'STD' ]

# Create a new CSV to provide coordinates for a GIS layer type
std.to_csv('Bens_CalibrationStandards.csv', index = False)
