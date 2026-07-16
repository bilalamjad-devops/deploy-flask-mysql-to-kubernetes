# ---------- Build Stage ----------
FROM python:3.12-slim AS builder

WORKDIR /app

COPY requirements.txt .

RUN pip install --no-cache-dir --prefix=/install -r requirements.txt

# ---------- Runtime Stage ----------
FROM python:3.12-slim

WORKDIR /app

# Copy installed Python packages
COPY --from=builder /install /usr/local

# Copy application source code
COPY . .

EXPOSE 5000

CMD ["python", "app.py"]
