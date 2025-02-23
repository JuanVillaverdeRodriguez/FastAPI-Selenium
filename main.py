from fastapi import FastAPI
from selenium import webdriver
from selenium.webdriver.chrome.service import Service
from webdriver_manager.chrome import ChromeDriverManager
import traceback
import os

app = FastAPI()

@app.get("/")
def read_root():
    return {"message": "FastAPI con Selenium en Railway"}

@app.get("/scrape")
def scrape_website(url: str = "https://www.google.com"):
    try:
        # Configuración de Chrome
        options = webdriver.ChromeOptions()
        options.add_argument("--headless")
        options.add_argument("--no-sandbox")
        options.add_argument("--disable-dev-shm-usage")

        # Forzar el uso de la ruta correcta de Chrome en Railway
        options.binary_location = "/usr/bin/google-chrome"

        # Crear el servicio con ChromeDriver
        service = Service("/usr/local/bin/chromedriver")
        driver = webdriver.Chrome(service=service, options=options)

        # Abrir la página y obtener el título
        driver.get(url)
        title = driver.title
        driver.quit()

        return {"url": url, "title": title}

    except Exception as e:
        error_message = traceback.format_exc()
        return {"error": "Ocurrió un error", "details": error_message}
