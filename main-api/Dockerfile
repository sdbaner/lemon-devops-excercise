FROM python:3.9.1-buster

# Set working dir
WORKDIR /app

# Install dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy the application code
COPY api/ .
COPY tests/ .

# Expose the port the app runs on
EXPOSE 80

# Command to run the FastAPI application
CMD ["python", "-m", "uvicorn", "main:app", "--host", "0.0.0.0", "--port", "80", "--timeout-keep-alive", "10"]
