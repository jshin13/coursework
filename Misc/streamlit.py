import numpy as np
import streamlit as st
import time

st.title('test project')

st_text = st.text('hello world')
time.sleep(2)
st_text.text('good bye')

st.subheader('subheading')
st.write(['data1', 'data2'])

values = np.random.rand(1,10)
st.bar_chart(values)