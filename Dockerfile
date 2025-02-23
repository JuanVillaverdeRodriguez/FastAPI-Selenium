ARG PORT=443

FROM cypress/browsers:latest

# Instalar Python y dependencias necesarias
RUN apt-get update && apt-get install -y python3 python3-venv python3-pip

# Crear un entorno virtual para evitar problemas con el entorno administrado
RUN python3 -m venv /venv

# Activar el entorno virtual e instalar dependencias
ENV PATH="/venv/bin:$PATH"

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY . .

CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "443"]