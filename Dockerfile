FROM node:lts AS frontend-builder
WORKDIR /app/frontend

COPY frontend/package*.json ./
RUN npm ci

COPY frontend/ .
RUN npm run build

FROM python:3.11
WORKDIR /app



COPY backend/requirements.txt ./backend/
COPY backend/dev-requirements.txt ./backend/
RUN pip install --no-cache-dir -r backend/requirements.txt -r backend/dev-requirements.txt
RUN pip install --no-cache-dir -r backend/requirements.txt

COPY backend/ ./backend/

COPY --from=frontend-builder /app/frontend/dist ./frontend/dist

ENV HOST=0.0.0.0

EXPOSE 8000

WORKDIR /app/backend

CMD ["python", "-m", "app"]