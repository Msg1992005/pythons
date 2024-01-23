# Use the official NVIDIA CUDA image as base image
FROM nvidia/cuda:11.4.2-base-ubuntu20.04


# Install some dependencies
RUN apt-get update && apt-get install -y  \
    python3-pip 

# Install Jupyter notebook
RUN pip3 install --no-cache-dir jupyterhub

# Set the working directory
WORKDIR /notebooks
ARG NB_USER=manoj
ARG NB_UID=1000
ENV USER ${NB_USER}
ENV NB_UID ${NB_UID}
ENV HOME /home/${NB_USER}
RUN adduser --disabled-password  --gecos "Default user"  --uid ${NB_UID}  ${NB_USER}

# Make sure the contents of our repo are in ${HOME}
COPY . ${HOME}
USER root
RUN chown -R ${NB_UID} ${HOME}
RUN adduser 
USER ${NB_USER}

# Expose the port for Jupyter notebook
EXPOSE 8888

USER ${NB_USER}
CMD ["jupyter", "notebook", "--ip=0.0.0.0", "--no-browser", "--allow-root"]
