pipeline {
	agent any
	stages {
	stage('Checkstyle') {
		steps {
			sh './mvnw checkstyle:checkstyle'
			archiveArtifacts artifacts: '**/target/checkstyle-result.xml', allowEmptyArchive: true
		}
	}
	
	stage('Test') {
		steps {
			sh './mvnw test'
		}
	}

	stage('Build') {
		steps {
		sh './mvnw clean install -DskipTests'
		}
	}

	stage('BuildDockerMrImage') {
		when {
			branch 'main'
		}
		steps {
			script {
				app = docker.build('mszymanski/spring-petclinic')
				app.inside {
					sh 'Docker built succesful'
				}
			}
		}
	}

	stage('PushDockerMrImage') {
		when {
			branch 'main'
		}
		steps {
			script {
				docker.withRegistry('https://registry.hub.docker.com', 'docker_hub_login') {
				app.push("${env.BUILD_NUMBER}")
				}
			}
		}
	}
	
	stage('CreateDockerMainImage') {
                when {
                        branch 'main'
                }
		steps {
			script {
				sh "docker build -t mszymanski/spring-petclinic:${env.BUILD_NUMBER} ."
				sh "docker push mszymanski/main:latest"
			}
		}
	}
}
}
