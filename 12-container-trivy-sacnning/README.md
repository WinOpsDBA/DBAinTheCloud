# 12-container-trivy-sacnning

## Sample pipeline with container security scanning

Sample pipeline is containing following steps.

1. Build container
2. Scan container with Trivy
3. Publish results to Azure DevOps
4. Scan container with Trivy and fail pipeline if there are any critical vulnerabilities.
5. Publish container to Docker Hub


Scanning is done with a use of docker image provided by AquaSec.

Detailed description is available in my blog [post](https://www.winopsdba.com/blog/azure-cloud-container-build-scan-publish.html)