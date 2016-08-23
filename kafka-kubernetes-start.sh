#!/usr/bin/env bash

if ! [[  $KAFKA_ADVERTISED_HOST_NAME =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$ ]]; then
	echo "KAFKA_ADVERTISED_HOST_NAME NOT DEFINED OR INVALID '$KAFKA_ADVERTISED_HOST_NAME' !!!"
	exit 1
fi

if [[ -z "$KAFKA_BROKER_ID" ]]; then
	if [[ -z "$KUBERNETS_UID" ]]; then
		export KUBERNETS_UID=$HOSTNAME
	fi
    echo "Generate Kafka Broker ID: for $KUBERNETS_UID"
	ID=`$KAFKA_HOME/bin/kafka-run-class.sh kafka.admin.AutoExpandCommand --zookeeper=$KAFKA_ZOOKEEPER_CONNECT -broker=$KUBERNETS_UID -mode=generate`
	echo "Use broker ID: $ID"
	export KAFKA_BROKER_ID=$ID
fi

if [[ -n "$ENABLE_AUTO_EXTEND" ]]; then
	echo "Enable auto exand"
	/usr/bin/kafka-autoextend-partitions.sh &
	/usr/bin/start-kafka.sh config.properties
else
	/usr/bin/start-kafka.sh config.properties
fi