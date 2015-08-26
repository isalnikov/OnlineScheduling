/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package ru.web.portal.onlinescheduling;

import java.time.LocalDateTime;
import java.util.Queue;
import java.util.concurrent.ConcurrentLinkedQueue;
import java.util.concurrent.ExecutionException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.messaging.core.MessageSendingOperations;
import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.handler.annotation.SendTo;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.context.request.async.DeferredResult;

/**
 *
 * @author Igor Salnikov <isalnikov1@gmail.com>
 */
@Controller
public class WsController {

    @RequestMapping("/")
    @ResponseBody
    public String index() {
        return String.format(" random : %s", Math.random());
    }

    /**
     * send news
     */
    private final Queue<DeferredResult<String>> responseBodyQueue = new ConcurrentLinkedQueue<>();

    @RequestMapping("/index")
    @ResponseBody
    public DeferredResult<String> hello() throws InterruptedException, ExecutionException {
        DeferredResult<String> deferredResult = new DeferredResult<>();
        responseBodyQueue.add(deferredResult);
        return deferredResult;
    }

    @Scheduled(fixedDelay = 1000)
    public void processQueues() throws InterruptedException, ExecutionException {
        for (DeferredResult<String> deferredResult : responseBodyQueue) {
            deferredResult.setResult(String.format(" random : %s", Math.random()));
            responseBodyQueue.remove(deferredResult);
        }
    }

    @MessageMapping("/hello")
    @SendTo("/topic/greetings")
    public String greeting(String message) throws Exception {
        // Thread.sleep(3000); 
        return "Hello, " + message + "!";
    }

    @Autowired
    public MessageSendingOperations<String> messagingTemplate;

    @Scheduled(fixedDelay = 1000)
    public void currentTime() {

        this.messagingTemplate.convertAndSend("/topic/time", LocalDateTime.now().toString());
    }
}
