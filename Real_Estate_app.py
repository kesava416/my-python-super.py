import streamlit as st 
import pandas as pd 

# Loan Data 
df = pd.read_csv("india_housing_prices.csv") 

st.set_page_config(page_title="Real Estate Advisor", layout="wide") 

st.title("Real Estate Investment Advisor")

st.markdown("""
### Project Summary
This app analyzes housing data across India cities to:
- Explore Price Trends (EDA) 
- Predict Property Prices
- Identify good investment opportunities
""")

# Layout (2 columns) 
col1, col2 = st.columns(2) 

with col1: 
     city = st.selectbox("City", sorted(df['City'].unique())) 
     bhk = st.slider("BHK", 1, 5, 2) 
     size = st.number_input("Size (SqFt)", 500, 5000, 1000) 
     
with col2:
    furnished = st.selectbox("Furnished Status", df['Furnished_Status'].unique()) 
    parking =st.selectbox("parking", df['Parking_Space'].unique()) 
          
#Prediction Button 
if st.button("Predict Price"):
    # Dummy logic (we replace later) 
    estimated_price = size * 0.05 + bhk*10  
    st.success(f"Estimated Price: {estimated_price:,.2f} Lakhs") 
    
# Investment button 
if st.button("Good Investment?"):
    if size > 1500 and bhk >=2: 
        st.success("Good Investment") 
    else:
        st.warning("Not a good Investment") 
        
# Show data preview 
st.title("Real Estate Advisor") 
st.markdown("### Enter Property Details")

st.subheader("EDA Graphs")

st.image("graphs Re/1_price_distribution.png")
st.image("graphs Re/4_top_cities.png") 
st.image("graphs Re/12_heatmap_.png") 

st.markdown("---") 
st.markdown("Developed by kesavarao |Data Analyst Project")