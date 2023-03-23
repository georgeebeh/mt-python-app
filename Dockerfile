# Build stage
FROM python:3.9-slim-buster AS build

# Set a non-root user
RUN useradd --create-home devops
USER devops

WORKDIR /app

# Install dependencies
COPY requirements.txt .
RUN pip install --trusted-host pypi.python.org -r requirements.txt

# Copy the relevant files
COPY app.py .

# Production stage
FROM python:3.9-slim-buster

# Set a non-root user
RUN useradd --create-home devops
USER devops

WORKDIR /app

# Copy only the necessary files from the build stage
COPY --from=build --chown=devops:devops /usr/local/lib/python3.9/site-packages /usr/local/lib/python3.9/site-packages
COPY --from=build --chown=devops:devops /app/app.py .

# Expose the port
EXPOSE 80

# Start the app
CMD ["python", "app.py"]
