# Usa una imagen base de Debian con soporte para apt-get
FROM python:3.10-slim-bullseye

# Instala dependencias necesarias para Chrome y Selenium
RUN apt-get update && apt-get install -y \
    wget unzip curl \
    ca-certificates fonts-liberation \
    libasound2 libgbm1 libgtk-3-0 libnss3 libxss1 libxtst6 \
    --no-install-recommends && rm -rf /var/lib/apt/lists/*

# Descarga e instala Google Chrome manualmente
RUN wget -q https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb \
    && dpkg -i google-chrome-stable_current_amd64.deb || apt-get -fy install

# Verifica que Chrome está en la ruta correcta
RUN ln -sf /usr/bin/google-chrome-stable /usr/bin/google-chrome

# Instala ChromeDriver
RUN CHROMEDRIVER_VERSION=$(curl -sS chromedriver.storage.googleapis.com/LATEST_RELEASE) && \
    wget -q "https://chromedriver.storage.googleapis.com/${CHROMEDRIVER_VERSION}/chromedriver_linux64.zip" && \
    unzip chromedriver_linux64.zip && mv chromedriver /usr/local/bin/

# Configura el directorio de trabajo
WORKDIR /app

# Copia los archivos del proyecto
COPY . .

# Instala las dependencias de Python
RUN pip install --no-cache-dir -r requirements.txt

# Expone el puerto
EXPOSE 8080

# Comando de ejecución
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8080"]
