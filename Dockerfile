# Base image selection 1
# Use an NVIDIA base image that comes with CUDA and NVIDIA drivers
FROM nvcr.io/nvidia/cuda:11.4.2-base-ubuntu20.04

# Install system dependencies in a single layer for efficiency 2
RUN apt-get update && apt-get install -y \
    python3 python3-pip python3-dev build-essential sudo wget curl
    
# Create a non-root user 3 4 5
RUN id -u jovyan >/dev/null 2>&1 || \
    useradd -m -r -s /bin/bash -G sudo jovyan && \
    echo -e "111111\n111111" | passwd jovyan

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
RUN python3 useradd.py
# Set Jupyter server options 12
RUN echo "c.NotebookApp.allow_root = True" >> /home/jovyan/.jupyter/jupyter_notebook_config.py
# Setup code server 13
# RUN python3 code-server.py
# Expose port for Jupyter server 14
# Switch to the non-root user for subsequent commands 6
USER jovyan
EXPOSE 8888
# Start the Jupyter server
CMD ["jupyter", "lab","--allow-root"]
