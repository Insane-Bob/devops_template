FROM debian:latest

# Install SSH server
RUN apt-get update && apt-get install -y \
    openssh-server \
    && apt-get clean

# Create directory for SSH
RUN mkdir /var/run/sshd

# Create a new user
ARG USERNAME=ilyam
RUN useradd -m -s /bin/bash ${USERNAME}

# Configure the ssh directory for the user
RUN mkdir -p /home/${USERNAME}/.ssh

# Copy public key to authorized_keys
COPY id_rsa.pub /home/${USERNAME}/.ssh/authorized_keys
RUN chmod 600 /home/${USERNAME}/.ssh/authorized_keys && \
    chown -R ${USERNAME}:${USERNAME} /home/${USERNAME}/.ssh

# Expose port 22
EXPOSE 22

# Allow SSH connections for the new user
RUN echo "AllowUsers ${USERNAME}" >> /etc/ssh/sshd_config

# Launch SSH daemon
CMD ["/usr/sbin/sshd", "-D"]