#!/bin/bash
systemctl start nginx.service
systemctl enable nginx.service
cat <<\EOF > /var/www/html/index.html
<!DOCTYPE html>
<html>
<head>
<title>Welcome to Jiangren Devops!</title>
<style>
    body {
        width: 35em;
        margin: 0 auto;
        font-family: Tahoma, Verdana, Arial, sans-serif;
    }
</style>
</head>
<body>
<h1>Welcome to Jiangren Devops!</h1>
<p>Hello from $(hostname -f)</p>
</body>
</html>
EOF