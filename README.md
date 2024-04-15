# API-The-Cozy-Whisker

A restaurant API for The Cozy Whisker Cat Café.

## Running the API Node App with Docker

This guide walks you through the process of setting up and running your API Node application with Docker, including handling a PostgreSQL database container.

## Prerequisites

- Docker installed on your system
- Windows Subsystem for Linux (WSL) set up for Windows users
- Node.js and npm installed for running the Node application

## Instructions

### Setting Up Your Node Application

1. **Open a WSL terminal.**
2. **Navigate to your project directory** where the `package.json` is located.
3. Run your Node application:

   ```bash
   npm start
   ```

### Setting Up PostgreSQL with Docker

1. **Open a second WSL terminal**.
2. Build your **PostgreSQL Docker image**:

   ```bash
   docker build -t postgres_image .
   ```

3. Run your **PostgreSQL container**:

   ```bash
   docker run --name postgresql -p 5432:5432 postgres_image
   ```
4. After you run your image you'll see the PostgreSQL logs, when you for somewhat reason you stop it using `Ctrl + C` in the bash, you can run it again, as explained below, but you won't be able to see the logs again, so you will have to do:

   ```bash
      docker logs -f CONTAINER_ID
   ```
   The flag `-f` keeps the PostgreSQL logs on screen, so you don't have to be doing `docker logs CONTAINER_ID` every time you want to see the database logs.

### Managing Your PostgreSQL Container

- Check Running Containers: If your container stops and

  ```bash
  docker ps
  ```

  shows no running containers, follow these steps to restart it:

  3.1 List all containers (stopped and running):

  ```bash
  docker ps -a
  ```

  3.2. Find the Process ID (CONTAINER ID) of your PostgreSQL container.

  3.3. Restart the container:

  ```bash
  docker start PROCESSID

  ```

  3.4. Verify it's running:

  ```bash
  docker ps

  ```

### Commenting Out Database Creation:

- After the initial database creation, you may want to comment out the CREATE DATABASE line in your Docker setup to prevent errors on subsequent starts.

- Dropping a Database:

  - Ensure your PostgreSQL container is running, then execute:

  ```bash
  docker exec PROCESSID dropdb -U dbadmin DATABASENAME
  ```

## Starting Over with a New Docker Setup

- To remove your current Docker setup and start fresh:

  1. List all containers:

  ```bash
  docker ps -a
  ```

  2. Copy the Process ID (CONTAINER ID) of the container you wish to remove.

  3. Stop the container:

  ```bash
  docker stop PROCESSID
  ```

  4. Remove the container:

  ```bash
  docker rm PROCESSID
  ```

  5. You can now proceed with the build process again as described in the setup instructions.

## Handling PostgreSQL Database Operations in Docker

This guide provides steps to follow if you encounter errors like "CANNOT DROP DATABASE" or "DATABASE ALREADY EXISTS" when working with PostgreSQL inside a Docker container.

### Steps to Resolve Common Errors

1. **List All Containers**

   Use this command to list all Docker containers, including their IDs and statuses:

   ```bash
   docker ps -a
   ```

2. **Select the Container ID**

   Identify and note down the container ID of the PostgreSQL container from the list provided by the previous command.

3. **Start the Container (If Not Running)**

   If the container is not already running, start it with the following command, replacing `containerID` with your actual container ID:

   ```bash
   docker start containerID
   ```

4. **Access the Container's Bash Shell**

   Use this command to enter the bash shell of your container:

   ```bash
   docker exec -it containerID bash
   ```

5. **Inside the Bash Shell**

   Once inside the container's bash shell, execute the following command to create a temporary database. This step is necessary for performing certain operations like dropping another database, as you cannot drop a database while connected to it.

   ```bash
   createdb -U dbadmin tempdb
   ```

6. **Execute the Drop Database Command**

   Exit the bash shell to return to your host machine's command line. Then, execute the following command to drop the desired database, in this case, `the_cozy_whisker`:

   ```bash
   docker exec -it containerID psql -U dbadmin -d tempdb -c "DROP DATABASE IF EXISTS the_cozy_whisker;" -W
   ```

   When prompted, enter the password for the `dbadmin` user.

### Notes

- Replace `containerID` with the actual ID of your Docker container.
- Replace `the_cozy_whisker` with the name of the database you wish to drop, if different.
- These instructions assume `dbadmin` as the PostgreSQL user. Adjust accordingly if you use a different username.

# Conclusion

Follow these steps carefully to ensure a smooth setup and operation of your API Node app with Docker. Remember to substitute PROCESSID, dbadmin, and DATABASENAME with your actual process ID, database admin username, and database name, respectively.
