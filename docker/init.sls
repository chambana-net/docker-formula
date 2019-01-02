# -*- coding: utf-8 -*-
# vim: ft=sls

{% from "docker/map.jinja" import docker with context %}
{% set codename = grains['lsb_distrib_codename'] %}

{% if grains['os'] == 'Debian' %}
docker_repo_packages:
  pkg.installed:
    - pkgs:
      - apt-transport-https
      - ca-certificates

sources_list_docker:
  pkgrepo.managed:
    - humanname: Docker packages
    - name: deb https://download.docker.com/linux/debian {{ codename }} stable
    - file: /etc/apt/sources.list.d/docker.list
    - gpgcheck: 1
    - key_url: https://download.docker.com/linux/debian/gpg
    - require:
      - pkg: docker_repo_packages
{% endif %}

docker_packages:
  pkg.installed:
    - pkgs:
      - {{ docker.package }}
      - {{ docker.python-package }}

docker:
  service.running:
    - name: docker
    - enable: true
    - require:
      - pkg: docker_packages
