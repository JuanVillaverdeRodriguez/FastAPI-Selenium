ARG PORT=443

FROM cypress/browsers:latest

# Instalar Python y dependencias necesarias
RUN apt-get update && apt-get install -y \
    build-essential \
    python3 \
    python3-dev \
    python3-pip \
    python3.11-venv \
    libffi-dev \
    gcc \
    g++

# Crear un entorno virtual para evitar problemas con el entorno administrado
RUN python3 -m venv /venv

# Activar el entorno virtual e instalar dependencias
ENV PATH="/venv/bin:$PATH"

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY . .

CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "443"]