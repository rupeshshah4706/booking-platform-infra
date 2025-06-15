#!/bin/bash
KAFKA_BIN="/opt/bitnami/kafka/bin"
BROKER="kafka:9092"

$KAFKA_BIN/kafka-topics.sh --create --topic bookings --bootstrap-server $BROKER --partitions 3 --replication-factor 1
$KAFKA_BIN/kafka-consumer-groups.sh --bootstrap-server $BROKER --create --group booking-processor-group --topic bookings