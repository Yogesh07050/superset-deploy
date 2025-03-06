# Use the latest official Apache Superset image
FROM apache/superset:latest

# Set environment variables
ENV SUPERSET_SECRET_KEY='2uji5hc3ybR-gC482DIbP5cHqWeIHWiliTQI_i5ytglf6vFXS6JghoajXf8JD9zHfLNEuT49u4qnmBrpet-YBg'
ENV SUPERSET_CONFIG_PATH='/app/superset_config.py'

# Initialize the database
RUN superset db upgrade

# Create an admin user (customize username, email, password)
RUN superset fab create-admin \
    --username admin \
    --firstname Superset \
    --lastname Admin \
    --email admin@superset.com \
    --password admin

# Load example dashboards (optional)
RUN superset load_examples

# Initialize roles and permissions
RUN superset init

# Expose port 8088 (Superset's default)
EXPOSE 8088

# Start the Superset server
CMD ["superset", "run", "-p", "8088", "--host", "0.0.0.0", "--with-threads", "--reload", "--debugger"]
