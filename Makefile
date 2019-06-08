.PHONY: docker install

docker:
	docker build -t kwierman/jupyterhub_datascience:latest .

clean:
	rm -rf /srv/jupyterhub/

install: clean docker
	mkdir -p /srv/jupyterhub
	cp jupyterhub_config.py /srv/jupyterhub/.
	python3 -m venv /srv/jupyterhub/env
	source /srv/jupyterhub/env/bin/activate
	pip install nodeenv jupyterhub notebook jupyterlab dockerspawner
	python3 -m nodeenv /srv/jupyterhub/node
	source /srv/jupyterhub/node/bin/activate
	npm install -g configurable-http-proxy
	cp jupyterhub.supervisor /etc/supervisor/conf.d/jupyterhub.conf
	mkdir -p /var/log/jupyter/
	supervisorctl reload
	supervisorctl restart jupyterhub
	cp jupyterhub.nginx /etc/nginx/sites-available/jupyterhub
	ln -s /etc/nginx/sites-available/jupyterhub /etc/nginx/sites-enabled/jupyterhub
	service nginx restart