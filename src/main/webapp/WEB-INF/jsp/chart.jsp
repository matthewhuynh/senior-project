<!doctype html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport"
          content="width=device-width, user-scalable=no, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    <title>Matthew</title>

    <%--<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">--%>
    <%--<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>--%>
    <%--<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>--%>
    <%--<link rel='stylesheet' href='https://use.fontawesome.com/releases/v5.4.2/css/all.css'--%>
          <%--integrity='sha384-/rXc/GQVaYpyDdyxK+ecHPVYJSN9bmVFBvjA/9eOB+pb3F2w2N6fc5qB9Ew5yIns' crossorigin='anonymous'>--%>
    <link rel="stylesheet" href="css/main.css">
    <link rel="stylesheet" href="webjars/bootstrap/3.3.7/css/bootstrap.min.css">

    <script src="webjars/jquery/3.3.1-1/jquery.min.js"></script>
    <script src="webjars/bootstrap/3.3.7/js/bootstrap.min.js"></script>
    <script src="https://canvasjs.com/assets/script/canvasjs.min.js"></script>

</head>
<body>
<nav class="navbar navbar-inverse navbar-fixed-top">
    <div class="container-fluid">
        <div class="navbar-header">
            <a class="navbar-brand" style="color: white;"><strong>Traffic Congestion Detection</strong></a>
        </div>
        <ul class="nav navbar-nav">
            <li ><a href="/" style="font-weight: 600;font-size: 15px;">Map</a></li>
            <li class="active"><a href="#" style="font-weight: 600; font-size: 15px;">Chart</a></li>
        </ul>
    </div>
</nav>
<div id="chartContainer" style="height: 370px; width: 100%;"></div>

<script type="text/javascript">
    window.onload = function() {

        var dataPoints = [];
        var chart = new CanvasJS.Chart("chartContainer", {
            theme: "light2", // "light1", "dark1", "dark2"
            title: {
                text: "Room Temperature"
            },
            axisX: {
                title: "Time Elapsed (in seconds)",
                suffix: " s"
            },
            axisY: {
                title: "Temperature (in °C)",
                includeZero: false,
                valueFormatString: "#,##0.0",
                suffix: " °C"
            },
            data: [{
                type: "line",
                xValueFormatString: "After #,##0 s",
                yValueFormatString: "#,##0.0 °C",
                dataPoints: dataPoints
            }]
        });

        var yValue;
        var xValue;
        var updateInterval = 2000;

        <c:forEach items="${dataPointsList}" var="dataPoints" varStatus="loop">
        <c:forEach items="${dataPoints}" var="dataPoint">
        yValue = parseFloat("${dataPoint.y}");
        xValue = parseInt("${dataPoint.x}");
        dataPoints.push({
            x : xValue,
            y : yValue,
        });
        </c:forEach>
        </c:forEach>

        chart.render();

        setInterval(function () { updateChart() }, updateInterval);

        function updateChart(count) {
            count = count || 1;
            for (var i = 0; i < count; i++) {
                xValue += 2;
                yValue = Math.max(yValue + (0.2 + Math.random() * (-0.2 - 0.2)), 0);
                dataPoints.push({ x: xValue, y: yValue });
            }
            chart.render();
        }

    }
</script>
</body>
</html>
