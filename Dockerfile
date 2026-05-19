FROM python:3.14.5-alpine3.23 AS builder

WORKDIR /app

COPY requirements.txt .

RUN pip install --no-cache-dir --prefix=/install -r requirements.txt

FROM python:3.14.5-alpine3.23 AS runtime

WORKDIR /app

COPY --from=builder /install /usr/local

COPY . .

RUN apk add --no-cache curl \
    && addgroup --system app && adduser --system --ingroup app app

USER app

EXPOSE 8000

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8000"]
