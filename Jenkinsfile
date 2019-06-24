@Library('jenkins-ci-library') _

 pipeline {
  agent { node { label 'executor' } }
  environment {
    APP_NAME = 'bwip-js'
    NAMESPACE = 'wms'
  }

   options {
    disableConcurrentBuilds()
    disableResume()
    timeout time: 100, unit: 'MINUTES'
  }

   parameters {
    booleanParam name: 'BA_PUSH_IMAGES',
        defaultValue: env.BRANCH_NAME == 'master',
        description: 'Push image to the Docker registry?'

     booleanParam name: 'BA_DEPLOY',
        defaultValue: env.BRANCH_NAME == 'master',
        description: 'Deploy image to the selected environment?'

     booleanParam name: 'BA_REPULL_BASE_IMG',
        defaultValue: false,
        description: 'Force base image pulling? Makes sense if the image set in FROM section of Dockerfile was updated with the same version. Also it will force image rebuilding.'

     booleanParam name: 'BA_RUN_TESTS',
        defaultValue: true,
        description: 'Run main tests. The param must be removed after the job stabilization.'

     choice name: 'BA_DEPLOY_ENV',
        choices: ['staging'],
        description: 'An environment to deploy if BA_DEPLOY is true.'
  }

   stages {
    stage('Prepare') {
      steps {
        script {
          Map chart = [:]
          setBuildDescription paramsPrefix: 'BA_'
        }
      }
    }

     stage('Lint') {
      steps {
        script {
          lintDockerfile()
        }
      }
    }

     stage('Build') {
      steps {
        script {
          image = buildDockerImage env.APP_NAME,
              buildArgs: [
                  'GIT_COMMIT'      : env.GIT_COMMIT,
              ],
              doNotPull: !params.BA_REPULL_BASE_IMG
        }
      }
    }

     stage('Build Chart') {
      steps {
        script {
          chart = buildChart env.APP_NAME,
              environment: params.BA_DEPLOY_ENV
        }
      }
    }

     stage('Push') {
      steps {
        script {
          if (params.BA_PUSH_IMAGES) {
            pushDockerImage image
          }
        }
      }
    }

     stage('Deploy') {
      steps {
        script {
          if (params.BA_DEPLOY) {
            stage('Chart') {
              deployChart env.APP_NAME,
                  noTiller: true, // (!) NB
                  chartPath: chart.path,
                  environment: params.BA_DEPLOY_ENV,
                  namespace: env.NAMESPACE
            }
          }

         }
      }
    }
  }
}
