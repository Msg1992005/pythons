FROM ubuntu:20.04

# Install system dependencies
RUN apt-get update && apt-get install -y \
    python3-pip python3-dev build-essential sudo

# Create the jovyan user with sudo privileges
RUN adduser --disabled-password --gecos "" jovyan && \
    echo "jovyan:111111" | chpasswd && \
    adduser jovyan sudo

# Set the working directory
WORKDIR /home/jovyan

# Create the .jupyter directory as root (before switching users)
RUN mkdir /home/jovyan/.jupyter

# Install Jupyter Notebook and dependencies
RUN pip install --upgrade pip
RUN pip install --no-cache-dir notebook jupyterlab

# Copy files to the working directory
COPY . .

# Set user ownership
RUN chown -R jovyan:jovyan /home/jovyan

# Switch to jovyan user
USER jovyan

# Set Jupyter server options (now the directory exists)
RUN echo "c.NotebookApp.allow_root = False" >> /home/jovyan/.jupyter/jupyter_notebook_config.py

# Expose port for Jupyter server
EXPOSE 8888

# Start the Jupyter server
CMD ["jupyter", "lab"]
