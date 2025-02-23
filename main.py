from fastapi import FastAPI
from selenium import webdriver
from webdriver_manager.chrome import ChromeDriverManager

app = FastAPI()

@app.get("/")
def read_root():
    return {"message": "FastAPI con Selenium en Railway"}

@app.get("/scrape")
def scrape_website(url: str = "https://www.google.com"):
    options = webdriver.ChromeOptions()
    options.add_argument("--headless")  # Modo sin interfaz gráfica
    options.add_argument("--no-sandbox")
    options.add_argument("--disable-dev-shm-usage")

    driver = webdriver.Chrome(ChromeDriverManager().install(), options=options)
    driver.get(url)
    title = driver.title
    driver.quit()

    return {"url": url, "title": title}
