import subprocess
import pathlib
import socket
import shutil
import glob
import os


# General Settings
c.JupyterHub.bind_url = 'http://:8888/jupyter/'
c.LocalAuthenticator.create_system_users = True
c.JupyterHub.spawner_class = 'dockerspawner.DockerSpawner'
c.JupyterHub.allow_named_servers = True

# Spawner Settings
c.DockerSpawner.image = 'kwierman/jupyterhub_datascience:latest'
c.DockerSpawner.hub_ip_connect = socket.gethostname()  # :8000
c.Spawner.default_url = '/lab'
c.Spawner.http_timeout = 120
c.DockerSpawner.use_internal_ip = False
c.JupyterHub.hub_ip = '0.0.0.0'
c.JupyterHub.hub_port = 8080
c.DockerSpawner.notebook_dir = '/home/jovyan/persistent/'
c.DockerSpawner.volumes = {'/home/{username}': c.DockerSpawner.notebook_dir}


def new_user_hook(spawner):
    # Pre-spawn hook
    username = spawner.user.name
    home_dir = os.path.join('/home', username)
    if not os.path.exists(home_dir):
        pathlib.Path(home_dir).mkdir(parents=True, exist_ok=True)
        os.chmod(home_dir, 0o777)

c.Spawner.pre_spawn_hook = new_user_hook
