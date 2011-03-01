<html>
<meta charset="utf-8" />
<head>
<title>WebSocket Test</title>
<style type="text/css">
.info {
	color: #01529B;
	background-color: #BDE5F8;
}
.error {
	color: #D8000C;
	background-color: #FFBABA;
}
.warning {
	color: #9F6000;
	background-color: #FEEFB3;
}
.button{
    font: 11px verdana, arial, helvetica, sans-serif;
    border: 1px solid #ccc;
    color: #666;
    font-weight: bold;
    font-size: 10px;
    margin-top: 5px;
    overflow: hidden;
}

</style>
</head>
<body onload="init">
<h3>Hello HTML5 Web Socket</h3>
<input type="button" value="stop" name="stopBtn" class="button" onclick="javascript:stop();"/>
<div id="output">
</div>

<span class="warning">Behold websockets</span>


</body>
<script language="javascript" type="text/javascript">

  var wsUri = "ws://localhost:"+<%=request.getLocalPort()%>+"/html5-webapp/hello-html5";
  var output;

  function init()
  {
    output = document.getElementById("output");
    writeToScreen(" Not Connected to server",'warning');
    testWebSocket();
  }
  function stop()
  {
	  websocket.send('disconnect');
  }
  function testWebSocket()
  {
    websocket = new WebSocket(wsUri);
    websocket.onopen = function(evt) { onOpen(evt) };
    websocket.onclose = function(evt) { onClose(evt) };
    websocket.onmessage = function(evt) { onMessage(evt) };
    websocket.onerror = function(evt) { onError(evt) };
  }

  function onOpen(evt)
  {
    writeToScreen("Connected to server");
    doSend("Hello are you there WebSocket Server");
  }

  function onClose(evt)
  {
    writeToScreen("...Kaboom...Im gone",'warning');
  }

  function onMessage(evt)
  {
	var evalStocks = eval('(' + evt.data + ')');
	var aTable="<table><tr><th>Ticker</th><th>Price</th></tr>";
	for(i=0;i<evalStocks.stocks.length;i++){
		aTable=aTable+"<tr>";
		aTable=aTable+"<td>";
		aTable=aTable+evalStocks.stocks[i].ticker;
		aTable=aTable+"</td>";
		aTable=aTable+"<td>";
		aTable=aTable+evalStocks.stocks[i].price;
		aTable=aTable+"</td>";		
		aTable=aTable+"</tr>";
	}
	aTable=aTable+"</table>";
    writeToScreen(aTable,'info');
  }

  function onError(evt)
  {
	  writeToScreen(evt.data,'error');
  }

  function doSend(message)
  {
    writeToScreen("SENT: " + message); 
    websocket.send(message);
  }

  function writeToScreen(message,rule)
  {
    output.innerHTML=message;
    output.className=rule;
  }
  if(window.addEventListener){
	  window.addEventListener("load", init, false);
  }else{
	  window.attachEvent("onload", init);
  }
  

</script>
</html>
