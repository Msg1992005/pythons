FROM ubuntu:20.04

# Install system dependencies
RUN apt-get update && apt-get install -y \
    python3-pip python3-dev build-essential sudo

# Set the working directory
WORKDIR /app

# Install Jupyter Notebook and dependencies
RUN pip install --upgrade pip
RUN pip install jupyterlab


# Expose port for Jupyter server
EXPOSE 8888

# Start the Jupyter server
CMD ["jupyter", "lab","ip=0.0.0.0","--port=8080","--no-browser","--allow-root","--NotebookApp.token=''"]
