# Base image selection 1
FROM ubuntu:20.04

# Install system dependencies in a single layer for efficiency 2
RUN apt-get update && apt-get install -y \
    python3 python3-pip python3-dev build-essential sudo wget curl coreutils xz-utils tar

# Create a non-root user 3 4 5
RUN adduser --disabled-password --gecos "" jovyan
RUN echo "jovyan:111111" | chpasswd
RUN adduser jovyan sudo

# Set the working directory 4
WORKDIR /home/jovyan

# Create the .jupyter directory as root 5
RUN mkdir /home/jovyan/.jupyter


# Install Jupyter Notebook and dependencies 7 8
RUN pip install --upgrade pip
RUN pip install --no-cache-dir notebook jupyterlab

# Copy application files 9
COPY . .

# Download needed files (assuming modules.py is part of the application) 10
RUN python3 modules.py

# Set user ownership of the home directory (already owned by jovyan, so this can be removed)
# RUN chown -R jovyan:jovyan /home/jovyan 11

# Set Jupyter server options 12
RUN echo "c.NotebookApp.allow_root = True" >> /home/jovyan/.jupyter/jupyter_notebook_config.py
# Setup code server 13
RUN python3 code-server.py
# Expose port for Jupyter server 14
# Switch to the non-root user for subsequent commands 6
USER jovyan
EXPOSE 8888

# Start the Jupyter server (using root is generally discouraged, consider alternatives) 15
CMD ["jupyter", "lab", "--allow-root"]
