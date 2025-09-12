package com.example.producer;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class MessageProductController {

  private final KafkaMessageProducer producer;

  private static final Logger log = LoggerFactory.getLogger(MessageProductController.class);

  public MessageProductController(KafkaMessageProducer producer) {
    this.producer = producer;
  }

  @GetMapping("send")
  public void sendMessage() {
    producer.sendMessage("helloTopic", "Hello from Spring Boot!");
    log.info("Message sent to Kafka");
  }
}
