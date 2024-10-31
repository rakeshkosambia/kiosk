<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="refresh" content="5">
	<title>Serial Port Read Demo</title>
</head>
<body>
  <h1>Serial Port Read Demo</h1>
	<p>Data received from the serial port:</p>
	<pre>${data}</pre>
	<form method="post" action="${pageContext.request.contextPath}/serial-read">
		<input type="submit" name="action" value="start">
		<input type="submit" name="action" value="stop">
	</form>
</body>
</html>
