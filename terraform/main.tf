# terraform {
#   required_providers {
#     aws = {
#       source  = "hashicorp/aws"
#       version = "~> 6.0"
#     }
#   }
# }

# provider "aws" {
#   region = "ap-south-1"
# }

# resource "aws_instance" "app_server" {
#   ami           = "ami-0f5ee92e2d63afc18"
#   instance_type = "t2.micro"
#   key_name      = "devops-key"

#   tags = {
#     Name = "Prod-App-Server"
#   }
# }

# output "instance_public_ip" {
#   description = "Public IP of the EC2 instance"
#   value       = aws_instance.app_server.public_ip
# }

pipeline {
    agent any

    environment {
        DOTNET_ROOT = "/usr/bin/dotnet"
    }

    stages {

        stage('Checkout Code') {
            steps {
                git branch: 'main', url: 'https://github.com/Ganesh2306/devops-project.git'
            }
        }

        stage('Restore Dependencies') {
            steps {
                dir('app/dotnet-app') {
                    sh 'dotnet restore'
                }
            }
        }

        stage('Build Application') {
            steps {
                dir('app/dotnet-app') {
                    sh 'dotnet build --configuration Release'
                }
            }
        }

        stage('Run Tests') {
            steps {
                dir('app/dotnet-app') {
                    sh 'dotnet test'
                }
            }
        }

        stage('Publish App') {
            steps {
                dir('app/dotnet-app') {
                    sh 'dotnet publish -c Release -o publish'
                }
            }
        }

        stage('Terraform Infrastructure') {
            steps {
                dir('terraform') {

                    withCredentials([[
                        $class: 'AmazonWebServicesCredentialsBinding',
                        credentialsId: 'aws-creds'
                    ]]) {

                        sh '''
                        terraform init
                        terraform plan -out=tfplan
                        terraform apply -auto-approve tfplan
                        '''
                    }

                }
            }
        }

        stage('Deploy with Ansible') {
            steps {
                dir('ansible') {
                    sh '''
                    ansible-playbook deploy.yml
                    '''
                }
            }
        }

    }

    post {
        success {
            echo 'Pipeline executed successfully 🚀'
        }

        failure {
            echo 'Pipeline failed ❌'
        }
    }
}
