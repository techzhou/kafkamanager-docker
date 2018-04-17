FROM openjdk:8-jdk-slim

ENV ZK_HOSTS=localhost:2181 \
    KM_VERSION=1.3.3.17 \
    KM_CONFIGFILE="conf/application.conf"

ADD start-kafka-manager.sh /kafka-manager-${KM_VERSION}/start-kafka-manager.sh

RUN \
    apt-get update && apt-get install -y wget unzip && \
    mkdir -p /tmp && \
    cd /tmp && \
    wget https://dl.bintray.com/sbt/debian/sbt-0.13.9.deb && \
    dpkg -i sbt-0.13.9.deb && \
    apt-get update && apt-get install -y sbt && rm -rf /var/lib/apt/lists/* && \ 
    wget https://github.com/yahoo/kafka-manager/archive/${KM_VERSION}.zip && \
    unzip ${KM_VERSION}.zip && cd kafka-manager-${KM_VERSION} && \
    echo 'scalacOptions ++= Seq("-Xmax-classfile-name", "200")' >> build.sbt && \
    sbt clean dist && \
    unzip  -d / ./target/universal/kafka-manager-${KM_VERSION}.zip && \
    rm -fr /tmp/* /root/.sbt /root/.ivy2 && \
    chmod +x /kafka-manager-${KM_VERSION}/start-kafka-manager.sh && \

WORKDIR /kafka-manager-${KM_VERSION}

EXPOSE 8083
ENTRYPOINT ["./start-kafka-manager.sh"]
