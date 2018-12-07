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
    <link rel='stylesheet' href='webjars/font-awesome/5.4.1/css/all.css'>
    <link rel="stylesheet" href="webjars/bootstrap/3.3.7/css/bootstrap.min.css">

    <script src="webjars/jquery/3.3.1-1/jquery.min.js"></script>
    <script src="webjars/bootstrap/3.3.7/js/bootstrap.min.js"></script>

    <style>
        @media only screen and (min-width: 992px) {
            html, body {
                height: 100%;
            }
            #map {
                height: 94.5%;
            }
            #submit{
                width: 80px;
                text-align: center;
                font-weight: bold;
            }

            #floating-panel {
                position: absolute;
                width: 300px;
                top: 56px;
                left: 9px;
                z-index: 5;
                background-color: #fff;
                padding: 5px;
                border: 1px solid #999;
                text-align: center;
                font-family: 'Roboto','sans-serif';
                line-height: 20px;
                padding-left: 5px;
                display: none;
            }
            .navbar .container-fluid>.navbar-header {
                float: left;
                margin-right: 10px;
            }
            .navbar .navbar-nav {
                float: left;
            }
            .nav>li > a{
                float: left;
            }
            #find{
                font-size: 16px;
                margin-top: 7px;
            }

        }
        @media only screen and (max-width: 991px) and (min-width: 769px) {
            #map {
                height: 94.5%;
            }
            #find{
                margin-top: 7px;
                font-size:16px;
            }
        }

        @media only screen and (max-width: 768px) {
            /* For mobile phones: */
            #find{
                font-size:16px;
            }
            #map {
                height: 94.5%;
            }
        }
        @media only screen and (max-width: 600px) {
            #find{
                font-size:13px;
            }
            #map {
                height: 95%;
            }
            .navbar-brand{
                font-size: 15px;
            }
        }

    </style>
</head>
<body>
<nav class="navbar navbar-inverse">
    <div class="container-fluid">
        <div class="navbar-header">
            <a class="navbar-brand" style="color: white;"><strong>Traffic Congestion Detection</strong></a>
        </div>
        <ul class="nav navbar-nav">
            <button id="find" class="btn btn-md btn-default"
                    style="" onclick="findDirection()"><strong>Find Path</strong></button>
        </ul>
    </div>
</nav>

<div id="floating-panel">
    <h5 style="text-align: center;"><strong>DIRECTIONS</strong></h5>
    <input id="start" style="width:95%;margin-bottom: 5px;" type="text" placeholder="Enter the starting point..."><br>
    <input id="end" style="width:95%; margin-bottom: 5px;" type="text" placeholder="Enter the destination..."><br>
    <button id="submit" class="btn btn-xs btn-default" style="font-size: 14px;">Find <i class='fas fa-directions'></i></button>
</div>
<div id="map"></div>

<script>
    function findDirection(){
        var findPanel = document.getElementById("floating-panel");
        if(findPanel.style.display === "none"){
            findPanel.style.display = "block";
        }
        else{
            findPanel.style.display = "none";
        }
    }
    function initMap() {
        document.getElementById("find").click();
        var directionsService = new google.maps.DirectionsService;
        var directionsDisplay = new google.maps.DirectionsRenderer;

        var map = new google.maps.Map(document.getElementById('map'), {
            zoom: 13,
            maxZoom: 19,
            center: {lat: 10.756456968028788, lng: 106.6851868278552},
            mapTypeId: 'roadmap',
            mapTypeControl: false
        });

        var heatmap = new google.maps.visualization.HeatmapLayer({
            data: getPointsHeatMap(),
            radius: 15,
            maxIntensity: 30,
            map: map,
            opacity: 0.9999999
        });

        var circlePoints = getCirclePoint();

        var circle1 = new google.maps.Circle({
            strokeColor:'#FA8072',
            strokeOpacity: 0,
            strokeWeight: 0,
            fillOpacity: 0,
            map: map,
            center: circlePoints[0],
            radius: 180
        });
        var circle2 = new google.maps.Circle({
            strokeColor:'#FA8072',
            strokeOpacity: 0,
            strokeWeight: 0,
            fillOpacity: 0,
            map: map,
            center: circlePoints[1],
            radius: 180
        });
        var circle3 = new google.maps.Circle({
            strokeColor:'#FA8072',
            strokeOpacity: 0,
            strokeWeight: 0,
            fillOpacity: 0,
            map: map,
            center: circlePoints[2],
            radius: 180
        });
        var circle4 = new google.maps.Circle({
            strokeColor:'#FA8072',
            strokeOpacity: 0,
            strokeWeight: 0,
            fillOpacity: 0,
            map: map,
            center: circlePoints[3],
            radius: 180
        });

        directionsDisplay.setMap(map);

        var routesPass = new google.maps.DirectionsRenderer();
        var routesNotPass = new google.maps.DirectionsRenderer();
        var routes = new google.maps.DirectionsRenderer();
        var paths = new google.maps.Polyline();

        //autocomplete address
        var start = document.getElementById('start');
        var end = document.getElementById('end');
        autoComplete(start, map);
        autoComplete(end, map);

        map.addListener('zoom_changed', function () {
            console.log(map.getZoom());
            getRadiusHeatmap(heatmap, circle1, circle2, circle3, circle4, map);
        });
        var stepDisplay = new google.maps.InfoWindow();
        circle1.addListener('click', function() {
            showInfo(circle1, stepDisplay, map);
        });
        circle2.addListener('click', function() {
            showInfo(circle2, stepDisplay, map);
        });
        circle3.addListener('click', function() {
            showInfo(circle3, stepDisplay, map);
        });
        circle4.addListener('click', function() {
            showInfo(circle4, stepDisplay, map);
        });

        document.getElementById('submit').addEventListener('click', function () {
            calculateAndDisplayRoute(directionsService, map, routesPass, routesNotPass, routes, paths);
        });

        var refreshHeatMap = setInterval( function()
        {
            var points = [];
            $.ajax({
                type: "POST",
                url: "/getDensity",
                success: function(data){
                    for (var key in data){
                        var latlng = key.split(",");
                        points.push({location: new google.maps.LatLng(Number(latlng[0]), Number(latlng[1])), weight: data[key]});
                    }
                    heatmap.setOptions({
                        data: points,
                        map: map
                    });
                },
                error: function () {
                    heatmap.setMap(null);
                }
            });
            console.log(points);
        }, 5000);
    }


    function calculateAndDisplayRoute(directionsService, map, routesPass, routesNotPass, routes, paths) {
        routesPass.setMap(null);
        routesNotPass.setMap(null);
        routes.setMap(null);
        directionsService.route({
            origin: document.getElementById('start').value,
            destination: document.getElementById('end').value,
            travelMode: 'DRIVING',
            provideRouteAlternatives: true
        }, function(response, status) {
            if (status === 'OK') {
                var pointJams = getPointJams();
                var pointJamsNow = [];
                var pointNotJams = [];
                for (var i = 0; i< response.routes.length; i++) {
                    paths.setOptions({
                        strokeWeight: 0,
                        path: response.routes[i].overview_path
                    });

                    for(var j = 0; j < pointJams.length; j++) {
                        if(google.maps.geometry.poly.isLocationOnEdge(pointJams[j], paths, 10e-5)){
                            if(pointJamsNow[pointJamsNow.length -1] !== i){
                                pointJamsNow.push(i);
                            }
                        }
                        else{
                            if(pointNotJams[pointNotJams.length -1] !== i){
                                pointNotJams.push(i);
                            }
                        }
                    }
                }
                pointNotJams = diffArray(pointJamsNow, pointNotJams);
                if(pointJamsNow.length >= 2 && pointNotJams.length >= 0){
                    routesNotPass.setOptions({
                        directions: response,
                        routeIndex: pointJamsNow[0],
                        polylineOptions: {
                            strokeColor: '#DD4B3E',
                            strokeOpacity: 0.5,
                            strokeWeight: 4
                        },
                        map: map
                    });
                    routes.setOptions({
                        directions: response,
                        routeIndex: pointJamsNow[1],
                        polylineOptions: {
                            strokeColor: '#DD4B3E',
                            strokeOpacity: 0.5,
                            strokeWeight: 4
                        },
                        map: map
                    });
                    if(pointNotJams.length > 0){
                        routesPass.setOptions({
                            directions: response,
                            routeIndex: pointNotJams[0],
                            polylineOptions: {
                                strokeColor: '#4A89F3',
                                strokeOpacity: 0.9,
                                strokeWeight: 6
                            },
                            map: map
                        });
                    }
                }
                else if(pointNotJams.length >= 2 && pointJamsNow >= 0){
                    routesPass.setOptions({
                        directions: response,
                        routeIndex: pointNotJams[0],
                        polylineOptions: {
                            strokeColor: '#4A89F3',
                            strokeOpacity: 0.9,
                            strokeWeight: 6
                        },
                        map: map
                    });
                    routes.setOptions({
                        directions: response,
                        routeIndex: pointNotJams[1],
                        polylineOptions: {
                            strokeColor: '#4A89F3',
                            strokeOpacity: 0.9,
                            strokeWeight: 6
                        },
                        map: map
                    });
                    if(pointJamsNow > 0){
                        routesNotPass.setOptions({
                            directions: response,
                            routeIndex: pointJamsNow[0],
                            polylineOptions: {
                                strokeColor: '#DD4B3E',
                                strokeOpacity: 0.5,
                                strokeWeight: 4
                            },
                            map: map
                        });
                    }
                }
                else{
                    if(pointNotJams.length === 1){
                        routesPass.setOptions({
                            directions: response,
                            routeIndex: pointNotJams[0],
                            polylineOptions: {
                                strokeColor: '#4A89F3',
                                strokeOpacity: 0.9,
                                strokeWeight: 7
                            },
                            map: map
                        });
                    }
                    if(pointJamsNow.length === 1){
                        routesNotPass.setOptions({
                            directions: response,
                            routeIndex: pointJamsNow[0],
                            polylineOptions: {
                                strokeColor: '#DD4B3E',
                                strokeOpacity: 0.5,
                                strokeWeight: 5
                            },
                            map: map
                        });
                    }
                    console.log('not = 1, pass = 1');
                }
            }
            else if(document.getElementById('start').value.trim() === "" |
                document.getElementById('end').value.trim() === ""){
                alert('The Address is empty!')
            }
            else if(status === 'NOT_FOUND'){
                alert('The Address is invalid!')
            }
        });
    }

    function getRadiusHeatmap(heatmap, circle1, circle2, circle3, circle4, map){
        var zooms = [11,12,13,14,15,16,17,18,19];
        var radiusHeatmap = [5,10,15,15,15,15,20,45.5,70];
        var radiusCircle = [350,250,180,100,60,27,17,16,15];
        for (var i = 0; i < zooms.length; i++){
            if(map.getZoom() == zooms[i]){
                heatmap.setOptions({
                    radius: radiusHeatmap[i]
                });
                circle1.setOptions({
                    radius: radiusCircle[i]
                });
                circle2.setOptions({
                    radius: radiusCircle[i]
                });
                circle3.setOptions({
                    radius: radiusCircle[i]
                });
                circle4.setOptions({
                    radius: radiusCircle[i]
                });
            }
        }
    }

    function getPointJams(){
        return [
            new google.maps.LatLng(10.779065114294985, 106.70207401581297),//ly tu trong 2 ba trung
            new google.maps.LatLng(10.82084026010509, 106.69395195148627),//phan van tri
            new google.maps.LatLng(10.756480354521894, 106.68511105529706),//tran hung dao
            new google.maps.LatLng(10.756429958448201, 106.68526025332699),//tran hung dao
            new google.maps.LatLng(10.800814959119283, 106.66173560388575)//tran quoc hoang
        ];
    }

    function getPointsHeatMap() {
        var points = new google.maps.MVCArray();
        $.ajax({
            type: "POST",
            url: "/getDensity",
            success: function(data){
                for (var key in data){
                    var latlng = key.split(",");
                    points.push({location: new google.maps.LatLng(Number(latlng[0]), Number(latlng[1])), weight: data[key]});
                    points.push(new google.maps.LatLng(Number(latlng[0]), Number(latlng[1])));
                }
            },
            error: function () {
                heatmap.setMap(null);
            }
        });
        return points;
        // return [
        //     {location: new google.maps.LatLng(10.756467508352271, 106.68520560331831), weight: getRandomInt(5)},//tran hung dao
        //     {location: new google.maps.LatLng(10.800978639350589, 106.66188916035185), weight: getRandomInt(5)},//tran quoc hoang
        //     {location: new google.maps.LatLng(10.77910990730577, 106.70211961336622), weight: getRandomInt(5)},//ly tu trong - 2 ba trung
        //     {location: new google.maps.LatLng(10.820837625437557, 106.6939700565506), weight: getRandomInt(5)}//phan van tri - pham van dong
        // ];
    }
    function getCirclePoint(){
        return [
            new google.maps.LatLng(10.756467508352271, 106.68520560331831),//tran hung dao
            new google.maps.LatLng(10.800978639350589, 106.66188916035185),//tran quoc hoang
            new google.maps.LatLng(10.77910990730577, 106.70211961336622),//ly tu trong - 2 ba trung
            new google.maps.LatLng(10.820837625437557, 106.6939700565506)//phan van tri - pham van dong
        ];
    }

    function showInfo(circle, stepDisplay, map){
        var latlng = circle.getCenter().lat()+","+circle.getCenter().lng();
        $.ajax({
            type: "GET",
            url: "/getInfo?latlng=" + latlng,
            success: function(data){
                attachInstructionText(stepDisplay,circle, data, map);
            }
        });
    }

    function autoComplete(address,map){
        var autocomplete = new google.maps.places.Autocomplete(address,{types: ['geocode']});
        autocomplete.bindTo('bounds', map);
        autocomplete.setFields(
            ['address_components', 'geometry', 'icon', 'name']);
    }

    function attachInstructionText(stepDisplay, circle, content, map) {
            stepDisplay.setOptions({
                position: circle.getCenter(),
                content: content,
                map: map
            });
    }
    function diffArray(arr1, arr2) {
        var newArr = [];
        arr1.forEach(function(val){
            if(arr2.indexOf(val) < 0) newArr.push(val);
        });
        arr2.forEach(function(val){
            if(arr1.indexOf(val) < 0) newArr.push(val);
        });
        return newArr;
    }
</script>
<script async defer
        src="https://maps.googleapis.com/maps/api/js?key=AIzaSyCCfMPjAoZW5oKYqW20pavZ6ymZ5vQvbog&libraries=places,visualization,geometry&callback=initMap">
</script>
</body>
</html>

<%--var marker = new google.maps.Marker({--%>
<%--     position: pointJams[j],--%>
<%--     draggable: true,--%>
<%--     map: map--%>
<%-- });--%>
<%-- var stepDisplay = new google.maps.InfoWindow();--%>
<%-- attachInstructionText(stepDisplay, marker, map);--%>