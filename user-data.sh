#!/bin/bash

# Update and install Docker and AWS CLI
dnf install -y docker awscli

# Enable and start Docker
systemctl enable --now docker

# Create deployment script
cat > /opt/deploy.sh <<'EOS'
#!/bin/bash

# Set AWS region
export AWS_DEFAULT_REGION=ap-southeast-2

# Your AWS ECR Registry URL
R=123456789012.dkr.ecr.ap-south-1.amazonaws.com

# Login to AWS ECR
aws ecr get-login-password --region "$AWS_DEFAULT_REGION" | docker login -u AWS --password-stdin "$R"

# Pull the latest Docker image
docker pull "$R/hello-jenkins:latest"

# Remove old container if it exists
docker rm -f web || true

# Run the new container
docker run -d --name web -p 80:80 "$R/hello-jenkins:latest"

EOS

# Make deployment script executable
chmod +x /opt/deploy.sh

# Execute deployment script
/opt/deploy.sh
