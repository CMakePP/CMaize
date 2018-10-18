def buildModuleMatrix = [
		   "CMake 3.12.2":("cmake gcc/7.1.0")
]

node{
    def nwxJenkins
    stage("Set-Up Workspace"){
        deleteDir()
        checkout scm
    }

    stage('Import Jenkins Commands'){
        sh """
           da_url=https://raw.githubusercontent.com/NWChemEx-Project/
           da_url+=DeveloperTools/master/ci/Jenkins/nwxJenkins.groovy
           wget \${da_url}
           """
           nwxJenkins=load("nwxJenkins.groovy")
    }

    def buildTypeList=buildModuleMatrix.keySet() as String[]
    for (int i=0; i<buildTypeList.size(); i++){
        def buildType = "${buildTypeList[i]}"

        stage("${buildType}: Export Module List"){
            def buildModules = "${buildModuleMatrix[buildType]}"
            nwxJenkins.exportModules(buildModules)
        }

        stage("${buildType}: Build Repo"){
            nwxJenkins.compileRepo("CMakePackagingProject")
        }

        stage("${buildType}: Test Repo"){
            nwxJenkins.testRepo()
        }
    }
}
