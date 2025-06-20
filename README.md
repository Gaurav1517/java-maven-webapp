# 🚀 Java Maven WebApp CI/CD Pipeline with Jenkins, Docker & Trivy

## 📘 Project Description

This project demonstrates a **complete CI/CD pipeline** for a Java Maven web application using **Jenkins**, **Docker**, and **Trivy**. The pipeline automates the process of building, testing, containerizing, scanning, and deploying the application using modern DevOps practices.

Key components:

* **CI (Continuous Integration)**: Automates Git checkout, unit testing, Maven build, and integration testing.
* **CD (Continuous Deployment)**: Builds a Docker image, scans it for vulnerabilities with Trivy, pushes it to Docker Hub, and deploys the container.
* **Security**: Integrates vulnerability scanning to ensure images are production-ready.
* **Infrastructure**: Runs on Jenkins installed on a CentOS/RHEL server with configured JDK, Maven, and Docker tools.

This setup provides a scalable, repeatable, and secure workflow for Java-based web applications.

---

## 🔧 Project Tech Stack

- Java 17 (OpenJDK)
- Apache Maven 3.9.9
- Jenkins (on RHEL/CentOS)
- Docker Engine
- Trivy (Aqua Security)
- GitHub (source code)
- Docker Hub (image registry)

<a href="https://www.kernel.org">
  <img src="https://www.svgrepo.com/show/354004/linux-tux.svg" alt="Linux" width="80">
</a> 
<a href="https://www.java.com/">
  <img src="https://www.vectorlogo.zone/logos/java/java-ar21.svg" alt="Java" width="80">
</a>
<a href="https://maven.apache.org">
  <img src="https://www.svgrepo.com/show/354051/maven.svg" alt="Maven" width="80">
</a>
<a href="https://code.visualstudio.com/">
  <img src="https://www.svgrepo.com/show/452129/vs-code.svg" alt="Visual Studio Code" width="80">
</a>
<a href="https://git-scm.com/">
  <img src="https://www.svgrepo.com/show/452210/git.svg" alt="Git" width="80">
</a>
<a href="https://github.com">
  <img src="https://www.svgrepo.com/show/475654/github-color.svg" alt="GitHub" width="80">
</a>
<a href="https://www.docker.com">
  <img src="https://www.svgrepo.com/show/303231/docker-logo.svg" alt="Docker" width="80">
</a>
<a href="https:hub.docker.com">
  <img src="https://roost.ai/hubfs/logos/integrations/logo-dockerhub.png" alt="DockerHub" width="80">
</a>
<a href="https://www.jenkins.io">
  <img src="https://get.jenkins.io/art/jenkins-logo/logo.svg" alt="Jenkins" width="80">
</a>
<a href="https://github.com/tonistiigi/trivy">
  <img src="https://trivy.dev/v0.46/imgs/logo.png" alt="Trivy" width="80">
</a>

---

## ⚙️ Jenkins Server Setup (RHEL/CentOS)

### 📦 1. Install Jenkins
> Ref: https://www.jenkins.io/doc/book/installing/linux/#red-hat-centos

```bash
sudo yum install -y fontconfig java-21-openjdk wget
java --version

sudo wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo
sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key
sudo yum upgrade
sudo yum install -y jenkins

sudo systemctl daemon-reload
sudo systemctl enable jenkins
sudo systemctl start jenkins
sudo systemctl status jenkins
````

### 🌐 2. Allow Jenkins Port in Firewall

```bash
sudo firewall-cmd --permanent --add-port=8080/tcp
sudo firewall-cmd --reload
sudo firewall-cmd --list-all
```

### 🔐 3. Retrieve Initial Admin Password

```bash
sudo cat /var/lib/jenkins/secrets/initialAdminPassword
```

Then open Jenkins in a browser:
📍 `http://<Server-IP>:8080`

---

## 🐳 Docker Installation (on Jenkins server)

> Ref: [https://docs.docker.com/engine/install/rhel/](https://docs.docker.com/engine/install/rhel/)

```bash
sudo dnf -y install dnf-plugins-core
sudo dnf config-manager --add-repo https://download.docker.com/linux/rhel/docker-ce.repo
sudo dnf install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

sudo systemctl enable --now docker
sudo docker run hello-world
```

---

## 🔍 Install Trivy for Image Scanning

> Ref: [https://trivy.dev/v0.18.3/installation/](https://trivy.dev/v0.18.3/installation/)

```bash
cat <<EOF | sudo tee /etc/yum.repos.d/trivy.repo > /dev/null
[trivy]
name=Trivy repository
baseurl=https://aquasecurity.github.io/trivy-repo/rpm/releases/\$releasever/\$basearch/
gpgcheck=0
enabled=1
EOF

sudo yum -y update
sudo yum -y install trivy
trivy --version
```

---
## 🔌 Required Jenkins Plugins

### 🔧 General

* **Maven Integration**
* **SSH Agent**
* **Pipeline: Stage View Plugin**

### 🧱 Maven Specific

* **Config File Provider**
* **Pipeline Maven Integration**
* **Pipeline Maven Plugin API**
* **Maven Integration Plugin**

### 🐳 Docker Specific

* **Docker Pipeline**
* **Docker Commons**
* **Docker API**

---

## 🛠️ Jenkins: Tool Configuration **JDK**, **Maven**, and **Docker**

Navigate to:
🔗 `http://<<Machine-IP>>:8080/manage/configureTools/`

---

## ✅ **1. Configure JDK in Jenkins**

1. Go to:
   `http://<<Machine-IP>>:8080/manage/configureTools/`

2. Scroll to **"JDK installations"**
   Click **"Add JDK"**

3. Configure:

   * **Name**: `jdk-17`
   * ✅ **Check**: `Install automatically`
   * **Installer**: Select `Install from adoptium.net`
   * **Version**: `jdk-17.0.14+7`

4. Click **Save** at the bottom.

---

## ✅ **2. Configure Maven in Jenkins**

1. Still on:
   `http://<<Machine-IP>>:8080/manage/configureTools/`

2. Scroll to **"Maven installations"**
   Click **"Add Maven"**

3. Configure:

   * **Name**: `maven`
   * ✅ **Check**: `Install automatically`
   * **Installer**: Select `Install from Apache`
   * **Version**: `3.9.9`

4. Click **Save**

---

## ✅ **3. Configure Docker in Jenkins**

1. On the same page:
   `http://<<Machine-IP>>:8080/manage/configureTools/`

2. Scroll to **"Docker installations"**
   Click **"Add Docker"**

3. Configure:

   * **Name**: `docker`
   * ✅ **Check**: `Install automatically`
   * **Installer**: Select `Download from docker.com`
   * **Docker version**: `latest`

4. Click **Save**

---

## 📝 Notes

* The names `jdk-17`, `maven`, and `docker` **must exactly match** what's used in your `Jenkinsfile`:

  ```groovy
  tools {
      jdk 'jdk-17'
      maven 'maven'
      dockerTool 'docker'
  }
  ```

---


## 📦 Dockerfile Used

```Dockerfile
FROM openjdk:17-jdk-slim
ENV APP_NAME java-maven-0.0.1-SNAPSHOT.war
WORKDIR /app
COPY target/${APP_NAME} /app/${APP_NAME}
EXPOSE 8080
ENTRYPOINT ["java", "-jar", "java-maven-0.0.1-SNAPSHOT.war"]
```

---

## 🚀 CI/CD Pipeline Flow (Jenkinsfile)

### ✅ CI Steps

1. Clean workspace
2. Git clone the Java Maven project
3. Run unit and integration tests
4. Build WAR file using Maven
5. Build Docker image
6. Scan image with **Trivy**
7. Push image to Docker Hub

### ✅ CD Steps

1. Remove previous containers
2. Run the new Docker container
3. Expose on host port `8081 -> container port 8080`

---

## 🔒 Docker Hub Credentials in Jenkins

1. Go to `Jenkins → Manage Jenkins → Credentials → Global`
2. Add **Username + Password** (Docker Hub)
3. ID must match in `Jenkinsfile`, e.g.:

   ```groovy
   credentialsId: 'docker-hub-creds'
   ```

---

## 🧪 Run the Pipeline

Once setup is complete, either:

* Click **"Build Now"** on the pipeline job
* Or push a commit to the GitHub repo (if polling is enabled)

---

## 📄 Output Artifacts

* Docker Image: `gchauhan1517/java-maven-webapp:latest`
![](/snap/docker-hub.png)
* Trivy Report: `image-report.html`
![](/snap/trivyImage-report.png)
* Container: `docker ps`
![](/snap/container.png)
* Pipeline Stages:
![](/snap/BlueOcean-pipeline.png)
![](/snap/pipeline.png)
* Deployed App: `http://<Jenkins-IP>:8081`
![](/snap/app-snap.png)

---

