import select
import streamlit as st
import pandas as pd

import requests 
@st.cache_data(ttl=300)
def fetch_data():
    response = requests.get(url, headers=headers, timeout=10)
    response.raise_for_status()
    return response.json()
st.title("IPL LiveDashboard")
#side bar
st.sidebar.header("Filter")
team = st.sidebar.selectbox(
    "Select Team",
    ["CSK", "MI", "RCB", "SRH"]
)
st.write(f"Selected Team: {team}")

# sample data  
data = {
    "Team": ["CSK", "MI", "RCB", "SRH"],
    "Runs": [180, 200, 190, 170]
}

df = pd.DataFrame(data)
# Filter 
filtered_df = df[df["Team"] == team]

st.subheader("Team Runs Data")
st.dataframe(filtered_df)
# Chart 
st.subheader("Run Chart")
st.bar_chart(filtered_df.set_index("Team"))

import requests
# API URL (cricbuzz RapidAPI)
url = "https://cricbuzz-cricket.p.rapidapi.com/matches/v1/live"
headers = {
    "X-RapidAPI-Key": "698a6a8936msh26d522c71593174p1154f5jsnfe065f9b77a8"
    "X-RapidAPI-Host" "cricbuzz-cricket.p.rapidapi.com"
}
response = requests.get(url, headers=headers, timeout=10)
data =response.json()

matches =[]
try:
    data = fetch_data() 
    for match in data .get("typeMatches",[]):
        for series in match.get("seriesMatches",[]):
            for m in series.get("seriesAdWrapper", {}).get("matches", []):
                info = m.get("matchInfo", {})
                team1 = info.get("team1", {}).get("teamName")
                team2 = info.get("team2", {}).get("teamName")
                status = info.get("status")
                
                matches.append({
                    "team 1": team1,
                    "team 2": team2,
                    "Status": status
                })
except Exception as e:
    st.error("API limit reached, showing sample data")
#fallback data
matches = [
        {"Team 1": "CSK", "Team 2": "MI", "Status": "CSK WON"},
        {"Team 1": "RCB", "Team 2": "SRH", "Status": "Live"},
       ] 
import pandas as pd
if len(matches) == 0:
    st.warnin("No match data available")
else:
    df = pd.DataFrame(matches)
    st.subheader("Live Match Data")
    st.dataframe(df)

import psycopg2 
conn = psycopg2.connect(
    host="localhost",
    database="cricbuzz_analysis_db",
    user = "postgres",
    password = "admin123",    
)
st.success("connected to postgreSQL")
cursor = conn.cursor()

import pandas as pd
query = "select * from matches;"
df = pd.read_sql(query, conn)

st.subheader("Data from PostgreSQL")
st.dataframe(df)


query = """
select  
       m.team1_name, 
       m.team2_name, 
       ms.runs,
       ms.wickets, 
       ms.overs
from matches m 
left join match_scores ms 
on m."matchId" = ms."matchId";
"""
cursor.execute("""
 INSERT INTO match_scores ("matchId", "runs", "wickets", "overs")
 values
 (150305, 250, 8, 50);
 """)
df = pd.read_sql(query, conn)
st.dataframe(df)

# null values 
df["runs"] = df["runs"].fillna(0)
df["wickets"] = df["wickets"].fillna(0)
df["overs"] = df["overs"].fillna(0)

# KPI Cards
col1, col2,col3 = st.columns(3)

col1.metric("Total Matches", len(df))
col2.metric("avg runs", int(df["runs"].mean()))
col3.metric("max runs", df["runs"].max())  

import plotly.express as px 
fig = px.bar(df, x="team1_name", y="runs", title="Team Performance")
st.plotly_chart(fig)

st.write("### Insights")
st.write(f"Highest score: {df['runs'].max()}")
st.write(f"lowest score: {df['runs'].min()}") 

fig = px.bar(
     df,
     x="team1_name",
     y="runs",
     title="Team Runs Comparison",
     color="team1_name"
)

st.metric("Total Matches", len(df))