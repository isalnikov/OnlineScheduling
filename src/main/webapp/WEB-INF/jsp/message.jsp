<%-- 
    Document   : message
    Created on : May 7, 2015, 10:16:39 AM
    Author     : Igor Salnikov  <isalnikov1@gmail.com>
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <title>Hello WebSocket</title>
        <script src="/media/lib/js/sockjs-0.3.4.js"></script>
        <script src="/media/lib/js/stomp.js"></script>
        <script type="text/javascript">
            var stompClient = null;

            function setConnected(connected) {
                document.getElementById('connect').disabled = connected;
                document.getElementById('disconnect').disabled = !connected;
                document.getElementById('conversationDiv').style.visibility = connected ? 'visible' : 'hidden';
                document.getElementById('response').innerHTML = '';
            }

            function connect() {
                console.log("Connect");
                var socket = new SockJS('/hello');
                stompClient = Stomp.over(socket);
                stompClient.connect({}, function(frame) {
                    setConnected(true);
                    console.log('Connected: ' + frame);
                    stompClient.subscribe('/topic/greetings', function(greeting) {
                        console.log(greeting.body);
                         var response = document.getElementById('response');
                         response.innerHTML = greeting.body;
                       // showGreeting(JSON.parse(greeting.body).content);
                    });
                });
            }

            function disconnect() {
                stompClient.disconnect();
                setConnected(false);
                console.log("Disconnected");
               
            }

            function sendName() {
                var name = document.getElementById('name').value;
                stompClient.send("/app/hello", {}, JSON.stringify({'name': name}));
            }

            function showGreeting(message) {
                var response = document.getElementById('response');
                var p = document.createElement('p');
                p.style.wordWrap = 'break-word';
                p.appendChild(document.createTextNode(message));
                response.appendChild(p);
            }
            
         window.onload=connect;
         
        </script>
    </head>
    <body>
        <noscript><h2 style="color: #ff0000">Seems your browser doesn't support Javascript! Websocket relies on Javascript being enabled. Please enable
            Javascript and reload this page!</h2></noscript>
        <div>
            <div>
                <button id="connect" onclick="connect();">Connect</button>
                <button id="disconnect" disabled="disabled" onclick="disconnect();">Disconnect</button>
            </div>
            <div id="conversationDiv">
                <label>What is your name?</label><input type="text" id="name" />
                <button id="sendName" onclick="sendName();">Send</button>
                <p id="response"></p>
            </div>
        </div>
    </body>
</html>