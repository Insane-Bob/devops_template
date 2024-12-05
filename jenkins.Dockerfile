FROM jenkins/jenkins:latest

# Switch to root user to install dependencies
USER root

# Install Ansible & OpenSSH server
RUN apt-get update && apt-get install -y \
    ansible \
    openssh-client \
    && apt-get clean

# Create the .ssh directory if it does not exist
RUN mkdir -p /var/jenkins_home/.ssh

# Copy public key to authorized_keys for SSH access
COPY id_rsa /var/jenkins_home/.ssh/id_rsa

# Set the correct permissions and ownership
RUN chmod 600 /var/jenkins_home/.ssh/id_rsa && \
    chown -R jenkins:jenkins /var/jenkins_home/.ssh

# SSH configuration to disable strict host key checking
RUN echo "StrictHostKeyChecking no" >> /etc/ssh/ssh_config

# Switch back to Jenkins user
USER jenkins

# Expose the necessary port for SSH
EXPOSE 22
