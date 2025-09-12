package com.example.consumer;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.kafka.annotation.KafkaListener;
import org.springframework.stereotype.Service;

@Service
public class KafkaMessageListener {

  private static final Logger log = LoggerFactory.getLogger(KafkaMessageListener.class);

  @KafkaListener(topics = "helloTopic", groupId = "my-group")
  public void listen(String message) {
    log.info("Got message from Kafka: {}", message);
  }
}
