FROM wurstmeister/kafka:0.10.0.0

MAINTAINER CloudTrackInc

RUN java -version

ADD . /tmp/build
RUN cd /tmp/build && \
    ./gradlew -Dorg.gradle.native=false build && \
    cp build/libs/kubernetes-expander-1.0-SNAPSHOT.jar $KAFKA_HOME/libs/

ADD kafka-autoextend-partitions.sh /usr/bin/kafka-autoextend-partitions.sh
ADD kafka-kubernetes-start.sh /usr/bin/kafka-kubernetes-start.sh
RUN SED -i "listeners=PLAINTEXT://KAFKA_ADVERTISED_HOST_NAME:9092"  $KAFKA_HOME/config/server.properties
CMD ["kafka-kubernetes-start.sh"]