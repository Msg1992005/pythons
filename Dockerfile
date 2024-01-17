FROM ubuntu:20.04

# Install system dependencies (as root)
RUN apt-get update && apt-get install -y \
    python3-pip npm curl build-essential

# Install VS Code Server (as root)
RUN npm install -g vscode-server

# Set working directory (as root)
WORKDIR /root

# Expose port for VS Code Server
EXPOSE 8080

# Start VS Code Server (as root, security implications!)
CMD ["code-server", "--host", "0.0.0.0", "--port", "8080", "--auth", "none"]
