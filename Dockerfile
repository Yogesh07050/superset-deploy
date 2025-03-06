# Use the latest official Apache Superset image
FROM apache/superset:latest

# Set environment variables
ENV SUPERSET_SECRET_KEY="2326ae05c32a515ebff42f0c18aa2576a7f2844610daa5a57479195bc540a218"
ENV SUPERSET_CONFIG_PATH="/app/superset_config.py"

# Initialize the database
RUN superset db upgrade

# Create an admin user (customize username, email, password)
RUN superset fab create-admin \
    --username admin \
    --firstname Superset \
    --lastname Admin \
    --email admin@superset.com \
    --password admin || true

# Load example dashboards (optional)
RUN superset load_examples || true

# Initialize roles and permissions
RUN superset init

# Expose port 8088 (Superset's default)
EXPOSE 8088

# Add a simple health check
HEALTHCHECK CMD curl --fail http://localhost:8088/health || exit 1

# Start the Superset server
CMD ["superset", "run", "--host", "0.0.0.0", "--port", "8088", "--with-threads", "--reload", "--debugger"]
