#!/usr/bin/bash


conda create -n datascience python=3.7 -y
source activate datascience
pip --no-cache-dir install Pillow h5py matplotlib numpy pandas scipy sklearn jupyterlab notebook jupyterhub tensorflow-gpu torch pyro-ppl ipykernel
python -m ipykernel install --user --name datascience --display-name "Python3 (Data Science)"
jupyter serverextension enable --py jupyterlab
