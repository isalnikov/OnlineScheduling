<%-- 
    Document   : time
    Created on : May 7, 2015, 10:40:21 AM
    Author     : Igor Salnikov  <igor.salnikov@stoloto.ru>
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Server time</title>
        <script src="/media/lib/js/sockjs-0.3.4.js"></script>
        <script src="/media/lib/js/stomp.js"></script>
        <script type="text/javascript">
            var stompClient = null;

    function connect() {
                console.log("Connect");
                
                var socket = new SockJS('/time');
                
                 stompClient = Stomp.over(socket);
                
                    stompClient.connect({}, function(frame) {
                        
                    console.log('Connected: ' + frame);
                    
                    stompClient.subscribe('/topic/time', function(message) {
                        
                    document.getElementById('time').innerHTML = message.body;
                    
                    });
                });
            }

            function disconnect() {
                stompClient.disconnect();
                console.log("Disconnected");
            }


    
            window.onload = connect;
           
        </script>
    </head>
    <body>
        
        <noscript><h2 style="color: #ff0000">Seems your browser doesn't support Javascript! Websocket relies on Javascript being enabled. Please enable
            Javascript and reload this page!</h2></noscript>
        time : <p id="time"></p>
    </body>
</html>
