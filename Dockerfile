FROM hypriot/rpi-java
WORKDIR /root
RUN cd ~
RUN sudo apt-key list  | grep "expired: " | sed -ne 's|pub .*/\([^ ]*\) .*|\1|gp' | xargs -n1 sudo apt-key adv --keyserver keys.gnupg.net --recv-keys
RUN sudo apt-get update
RUN apt-get install git
RUN apt-get install wget
RUN git --version
RUN wget -q -O – https://jenkins-ci.org/debian/jenkins-ci.org.key | sudo apt-key add –
RUN sudo sh -c 'echo deb http://pkg.jenkins-ci.org/debian binary/ > /etc/apt/sources.list.d/jenkins.list'
RUN sudo apt-get update
RUN apt-get install jenkins
RUN sudo /etc/init.d/jenkins start

RUN apt-get install curl
RUN cd /var/lib/jenkins
RUN wget https://gist.githubusercontent.com/micw/e80d739c6099078ce0f3/raw/33a21226b9938382c1a6aa68bc71105a774b374b/install_jenkins_plugin.sh
RUN sh install_jenkins_plugin.sh Git Mailer Credentials SSHCredentials Pipeline:Groovy

RUN curl -sL https://deb.nodesource.com/setup_8.x | sudo -E bash -
RUN sudo apt-get install -y nodejs zip unzip
RUN node -v

RUN sudo /etc/init.d/jenkins stop

EXPOSE 8080
EXPOSE 50000

ENV JENKINS_HOME /root/.jenkins

CMD java -jar /usr/share/jenkins/jenkins.war
