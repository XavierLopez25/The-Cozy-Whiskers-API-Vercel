# Use the official PostgreSQL image as the base image
FROM postgres:latest

# Set environment variables for MySQL
ENV POSTGRES_DB=the_cozy_whisker    
ENV POSTGRES_USER=dbadmin
ENV POSTGRES_PASSWORD=1234

# Add your schema SQL script to the docker-entrypoint-initdb.d directory
COPY schema.sql /docker-entrypoint-initdb.d/

# Expose port 5432 for PostgreSQL connections
EXPOSE 5432

# When the container starts, MySQL will automatically execute
# scripts in /docker-entrypoint-initdb.d/ to initialize the database
