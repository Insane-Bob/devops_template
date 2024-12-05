FROM jenkins/jenkins:lts

# Passer à l'utilisateur root pour installer les dépendances
USER root

# Installer sudo 
RUN apt-get update && apt-get install -y sudo && apt-get clean

# Créer un nouvel utilisateur "ansible"
ARG USERNAME=ansible
RUN useradd -m -s /bin/bash ${USERNAME} && \
    usermod -aG sudo ${USERNAME}


# Installer Ansible et OpenSSH client
RUN sudo apt-get update && apt-get install -y \
    ansible \
    openssh-client \
    && apt-get clean

# Configurer le répertoire SSH pour Jenkins
RUN mkdir -p /var/jenkins_home/.ssh && \
    chmod 700 /var/jenkins_home/.ssh && \
    chown -R jenkins:jenkins /var/jenkins_home/.ssh

# Copier la clé privée dans le conteneur
COPY id_rsa /var/jenkins_home/.ssh/id_rsa
RUN chmod 600 /var/jenkins_home/.ssh/id_rsa && \
    chown jenkins:jenkins /var/jenkins_home/.ssh/id_rsa

# Configurer SSH pour ignorer les vérifications des clés hôtes
RUN echo "StrictHostKeyChecking no" >> /etc/ssh/ssh_config

# Donne tous les droits aux users
RUN chmod -R 777 /var/jenkins_home && \
    chmod -R 777 /home/ansible

RUN echo "ansible ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
RUN echo "jenkins ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

# Exposer le port SSH
EXPOSE 22
