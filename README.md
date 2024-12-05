 ### Lancer le docker
 `docker compose up --build -d`

 ### Lancer le container
 `docker exec -it jenkins bash`

 ### Se connecter en SSH à debian via jenkins
 `ssh -i chemin_clé_ssh nom_user@ip_debian`

 ### Créer l'environnement Ansible
` ansible-galaxy init nom_role`

 ### Créer deux dossiers inventory & playbooks dans le dossier ansible que vous avez créer
 - Créer le fichier `inventory.ini` et mettre ce contenu :
`monitoring ansible_host=172.30.0.3 => l'ip après le = étant une adresse valide du sous-réseau défini dans votre docker-compose
 web ansible_host=172.30.0.4`

 ### Créer un rôle prometheus
 `ansible-galaxy init promotheus`

### Aller dans le dossier prometheus
`cd prometheus`
'nano | vim main.yml'

### Ajouter ce contenu dans le fichier main.yml
`- name: Install dependencies
  become: true
  ansible.buildin.apt:
    name:
      - wget
      - tax
      - adduser
      - libfontconfig

- name: Create Prometheus user
  become: true
  ansible.buildin.user:
    name: prometheus
    shell: /bin/false
    system: true
    create_home: false

- name: Download Prometheus
  become: true
  ansible.buildin.get_url:
    url: "{{ install_prometheus_download_url }}"
    dest: "/tmp/prometheus{{ install_prometheus_version }}.tar.gz"
    mode: "0644"`

### Ajouter ce contenu dans le dossier defaults/main.yml
`install_prometheus_version: "2.45.0"
# install_prometheus_port: 9090
# install_prometheus_data_dir: "/var/lib/prometheus"
install_prometheus_download_url: "https://github.com/prometheus/prometheus/releases/download/v%7B%7B install_prometheus_version }}/prometheus-{{ install_prometheus_version }}.linux-amd64.tar.gz"`
