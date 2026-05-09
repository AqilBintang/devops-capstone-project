FROM python:3.9-slim

# Create working directory
WORKDIR /app

# Install dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir --upgrade pip wheel \
    && pip install --no-cache-dir -r requirements.txt

# Copy application source
COPY service/ ./service/

# Create a non-root user
RUN useradd --uid 1000 --create-home --shell /bin/bash appuser \
    && chown -R appuser:appuser /app
USER appuser

# Expose port
ENV PORT 8080
EXPOSE $PORT

# Run the service
CMD ["gunicorn", "--bind", "0.0.0.0:8080", "--access-logfile", "-", "service:app"]
