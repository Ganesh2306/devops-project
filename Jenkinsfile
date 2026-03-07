// pipeline {
//   agent any

//   stages {

//     stage('Checkout') {
//       steps {
//         git branch: 'main',
//             url: 'https://github.com/Ganesh2306/devops-project.git'
//       }
//     }

//     stage('Build') {
//       steps {
//         echo 'Building application'
//       }
//     }

//     stage('Test') {
//       steps {
//         echo 'Running tests'
//       }
//     }

//    stage('Terraform Deploy') {
//   steps {
//     sh '''
//     cd terraform
//     terraform init
//     terraform plan -out=tfplan
//     terraform apply -input=false -auto-approve tfplan
//     '''
//   }
// }
  
//     stage('Ansible Deploy') {
//       steps {
//         sh '''
//         cd ansible
//         ansible-playbook -i inventory.ini setup.yml
//         '''
//       }
//     }
//   }
// }

pipeline {
    agent any

    environment {
        DOTNET_ROOT = "/usr/share/dotnet"
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

                        terraform output -raw instance_public_ip > ../ansible/ip.txt

                        echo "[appserver]" > ../ansible/inventory.ini
                        echo "$(cat ../ansible/ip.txt) ansible_user=ubuntu ansible_ssh_private_key_file=/home/ubuntu/.ssh/id_rsa" >> ../ansible/inventory.ini
                        '''
                    }

                }
            }
        }
        stage('Check Dotnet') {
            steps {
                sh 'dotnet --version'
            }
        }


        stage('Deploy with Ansible') {
            steps {
                dir('ansible') {
                    sh '''
                    ansible-playbook -i inventory.ini setup.yml
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