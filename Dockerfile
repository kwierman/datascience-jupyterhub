FROM nvidia/cuda

RUN apt-get update && apt-get -qq -y install curl bzip2 gcc \
    && curl -sSL https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh -o /tmp/miniconda.sh \
    && bash /tmp/miniconda.sh -bfp /usr/local \
    && rm -rf /tmp/miniconda.sh \
    && conda install -y python=3.7 \
    && conda update conda \
    && conda install jupyterhub notebook jupyterlab ipykernel\
    && apt-get -qq -y remove curl bzip2 \
    && apt-get -qq -y autoremove \
    && apt-get autoclean \
    && rm -rf /var/lib/apt/lists/* /var/log/dpkg.log \
    && conda clean --all --yes

# Configure the jovyan user
RUN useradd -m jovyan && chmod -R 777 /home/jovyan
COPY docker_setup.sh /tmp/
USER jovyan
WORKDIR /tmp/
RUN bash docker_setup.sh

# Setup the environment for the user
ENV PATH /home/jovyan/.conda/envs/datascience/bin:/usr/local/condabin:/opt/conda/bin:/usr/local/nvidia/bin:/usr/local/cuda/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
ENV HOME=/home/jovyan
WORKDIR $HOME
CMD ["jupyterhub-singleuser"]