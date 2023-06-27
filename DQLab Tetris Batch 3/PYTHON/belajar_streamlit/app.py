import streamlit as st
from lorem_text import lorem

#DAY 1
st.set_page_config(
    page_title='Mari Belajar Streamlit',
    layout='wide'
)

#Menulis text di streamlit
"Hello World" # <- magic
st.write('Hello World')

#Mengeluarkan dataframe cukup tulis "df"

"_Hello World miring_"

"**Hello World tebal**"

"# ini Header"
"## sub header"

st.title("Ini judul")
st.header("ini header ver.2")\

st.caption("ini caption")

st.code("import streamlit as st")

st.code('''
import pandas as pd
import streamlit as st

#ini komentar
''')

#Latex
st.latex("ax^2 + bx + c = 0")

#WIDGET
ini_tombol = st.button("BUTTON")
ini_tombol

saya_setuju = st.checkbox("Centang jika setuju")
if saya_setuju:
    st.write("anda setuju")
else:
    st.write(lorem.paragraphs(1))


