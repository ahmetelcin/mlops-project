# Step 1: Select the Base Image
# We start with a clean Linux system that has Python 3.9 pre-installed.
# The "-slim" variant is smaller and faster, which is great for production.
FROM python:3.11-slim

FROM tensorflow/tensorflow:2.16.1

# Step 2: Set the Working Directory
# Create a directory named /app inside the container and set it as the
# current working directory for all subsequent commands.
WORKDIR /app

# Step 3: Copy the Dependencies List First
# Copy only the requirements.txt file into the container. This is a key
# optimization that leverages Docker's layer caching.
COPY requirements.txt .

# Step 4: Install the Dependencies
# Install all the Python libraries listed in requirements.txt.
# --no-cache-dir keeps the final image size smaller.
RUN pip install --default-timeout=1000 --no-cache-dir -r requirements.txt

# Step 5: Copy the Rest of the Project
# Copy all the other project files (main.py, kedi_kopek_modeli.h5, etc.)
# into the container's working directory (/app).
COPY . .

# Step 6: Define the Command to Run
# Specify the default command that will be executed when the container starts.
# This command launches our Uvicorn server.
# --host 0.0.0.0 makes the server accessible from outside the container.
# --port 8000 specifies the port to listen on.
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]