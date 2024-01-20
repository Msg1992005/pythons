FROM ubuntu:20.04

# Install system dependencies
RUN apt-get update && apt-get install -y \
    python3 python3-pip python3-dev build-essential sudo wget curl coreutils xz-utils tar 

RUN curl -s https://ngrok-agent.s3.amazonaws.com/ngrok.asc | sudo tee /etc/apt/trusted.gpg.d/ngrok.asc >/dev/null && echo "deb https://ngrok-agent.s3.amazonaws.com buster main" | sudo tee /etc/apt/sources.list.d/ngrok.list && sudo apt update && sudo apt install ngrok
RUN ngrok config add-authtoken 2YIuT9FzD7HiiNChcG26SJRoaVM_2eDMorgHgeyDpHWGf49C4
RUN curl -fsSL https://code-server.dev/install.sh | sh
RUN ngrok http 8080 &
RUN code-server &
RUN cat /root/.config/code-server/config.yaml

# Create a non-root user
RUN adduser --disabled-password --gecos "" jovyan

RUN adduser jovyan sudo

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

# Switch to non-root user
USER jovyan

# Set Jupyter server options (now the directory exists)
RUN echo "c.NotebookApp.allow_root = False" >> /home/jovyan/.jupyter/jupyter_notebook_config.py

# Expose port for Jupyter server
EXPOSE 8888
# Start the Jupyter server
CMD ["jupyter", "lab","--allow-root"]
