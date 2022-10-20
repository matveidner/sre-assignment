# SRE-Assignment

## Task: Automate the installation and setup of a NGINX Reverse Proxy with automatic Letsencrypt Certificate Generation
Examplary project for automatization of NGINX Reverse Proxy with automatic Letsencrypt Certificate Generation with Ansible & Docker-compose. Bi-monthly cron job is defined for periodic certificate renewal.

### Justification for all tool decisions
*Ansible*: Declarative configuration management allows for more complex & cleaner multi-host deployment definitions compared to bash scripting. In some rare cases when ansible is lacking a built-in functionality that is needed, bash scripts may be used as a resolution. In this case, ansible docker-compose plugin is lacking execution of commands from within containers. The use of bash scripts should be kept at minimal & should have conditional triggers for shell tasks in ansible's declarative fashion.

*Docker-compose*: Less resource & administration intensive solution for multi-service, single-node & interdependent deployments as opposed to container orchestration tools.

*Gitlab-ci*: For complete automation simple Gitlab-ci manifest as an example. In most cases, more elaborate pipelines would be recommended.

### Document and present design
1. On first deployment, reverse proxy is started without any certificates in directories defined in app configuration. For this reason the container fails.
2. Certbot container, which shares volumes with reverse proxy, is used to generate self-signed certificates into their shared volume with openssl.
3. Reverse proxy service is restarted. Because the certificate path is now present in its container, it starts accepting requests.
4. Mock certificates can be removed and certbot can be triggered to generate proper Let's encrypt validation of defined domain(s).
5. Reverse proxy server has to be reloaded to register the correct certificates.
6. Cron job is set in bi-monthly intervals for certificate renewal. Let's encrypt certificates last for three months, so bi-monthly renewal should suffice. Alternatively, respective containers can be started with entrypoints, that renew certificates/reload nginx on loop. 
