# Usa una imagen base compatible con apt-get
FROM python:3.10-slim-bullseye

# Instala dependencias del sistema necesarias para Selenium y Chrome
RUN apt-get update && apt-get install -y \
    wget unzip curl \
    xvfb libxi6 libgconf-2-4 \
    libnss3 libxss1 libappindicator1 \
    fonts-liberation libatk-bridge2.0-0 libgtk-3-0 \
    --no-install-recommends && rm -rf /var/lib/apt/lists/*

# Descarga e instala Google Chrome
RUN wget -q https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb \
    && dpkg -i google-chrome-stable_current_amd64.deb || apt-get -fy install

# Instala ChromeDriver
RUN CHROMEDRIVER_VERSION=$(curl -sS chromedriver.storage.googleapis.com/LATEST_RELEASE) && \
    wget -q "https://chromedriver.storage.googleapis.com/${CHROMEDRIVER_VERSION}/chromedriver_linux64.zip" && \
    unzip chromedriver_linux64.zip && mv chromedriver /usr/local/bin/

# Crea un directorio de trabajo
WORKDIR /app

# Copia los archivos del proyecto
COPY . .

# Instala las dependencias de Python
RUN pip install --no-cache-dir -r requirements.txt

# Expone el puerto
EXPOSE 8000

# Comando de ejecución
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]
