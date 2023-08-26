pipeline {
    agent any

    environment {
        AMI_NAME = '' // Initialize AMI_NAME as an empty string
        COMMIT_ID = '' // Define an environmental variable to store the commit ID
    }

    stages {
        stage('packer init') {
            when {
                expression { return !params.SKIP_STAGES } // Execute this stage unless SKIP_STAGES parameter is set
            }
            steps {
                dir('packer') {
                    sh 'whoami' // Print the username of the executing user
                    sh 'pwd' // Print the current working directory
                    sh 'packer init main.pkr.hcl' // Initialize Packer in the 'packer' directory
                }
            }
        }
        stage('packer build') {
            when {
                expression { return !params.SKIP_STAGES } // Execute this stage unless SKIP_STAGES parameter is set
            }
            steps {
                dir('packer') {
                    script {
                        def commitID = env.COMMIT_ID // Get the Git commit ID, provided by jenkins pipeline script
                        env.COMMIT_ID = commitID // Set the commit ID as an environmental variable
                        echo "Commit ID: ${commitID}"

                        // Run Packer build command with machine-readable format and commit_id variable
                        def packerOutput = sh(script: "packer build -machine-readable -var 'commit_id=${commitID}' main.pkr.hcl", returnStdout: true).trim()

                        // Packer_output.log contains the value of packerOutput which contains the output of Packer Build
                        writeFile file: 'packer_output.log', text: packerOutput

                        // Extract the AMI name from Packer output using regular expressions which defines the text pattern to be matched
                        def amiNameOutput = packerOutput =~ /demo_ami\.([^\n]+)/
                        if (amiNameOutput) {
                            AMI_NAME = "demo_ami.${amiNameOutput[0][1]}"
                            env.AMI_NAME_FIRST = "${AMI_NAME}${commitID}"
                            // Print the desired output format for the AMI name
                            echo "${AMI_NAME}${commitID}"
                            env.AMI_NAME = "${AMI_NAME}${commitID}"

                        } else {
                            error("Failed to retrieve the AMI name from Packer output.")
                        }
                    }
                }
            }
        }
    }
    post {
        success {
            script {
                echo "Triggering the next pipeline with AMI_NAME: ${AMI_NAME}"
                // Trigger another Jenkins job ('demo-terraform-infra') with the AMI_NAME parameter
                build job: 'demo-terraform-infra', parameters: [string(name: 'AMI_NAME', value: AMI_NAME)]
            }
        }
        failure {
            script {
                echo "Pipeline execution failed."
            }
        }
    }
}