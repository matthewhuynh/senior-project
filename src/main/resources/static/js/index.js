function initMap() {
    var directionsService = new google.maps.DirectionsService;
    var directionsDisplay = new google.maps.DirectionsRenderer;

    var map = new google.maps.Map(document.getElementById('map'), {
        zoom: 13,
        maxZoom: 19,
        center: {lat: 10.756456968028788, lng: 106.6851868278552},
        mapTypeId:'satellite'
    });

    var heatmap = new google.maps.visualization.HeatmapLayer({
        data: getPointsHeatMap(),
        //dissipating: false,
        opacity: 0.7,
        radius: 15,
        map:map
    });

    directionsDisplay.setMap(map);
    //heatmap.setMap(map);

    //autocomplete address
    var start = document.getElementById('start');
    var end = document.getElementById('end');
    autoComplete(start,map);
    autoComplete(end,map);

    map.addListener('zoom_changed', function (){
        console.log(map.getZoom());

        getRadiusHeatmap(heatmap,map);
    });
    document.getElementById('submit').addEventListener('click', function() {
        calculateAndDisplayRoute(directionsService, map);
    });
}

function calculateAndDisplayRoute(directionsService, map) {
    var markerArray = [];
    var stepDisplay = new google.maps.InfoWindow;

    // First, remove any existing markers from the map.
    for (var i = 0; i < markerArray.length; i++) {
        markerArray[i].setMap(null);
    }

    directionsService.route({
        origin: document.getElementById('start').value,
        destination: document.getElementById('end').value,
        travelMode: 'DRIVING',
        provideRouteAlternatives: true
    }, function(response, status) {
        if (status === 'OK') {
            for (var i = 0; i< response.routes.length ; i++) {
                var paths = new google.maps.Polyline({
                    path: response.routes[i].overview_path,
                    strokeWeight: 0,
                    map: map
                });
                var points = new google.maps.LatLng(10.756364740182647, 106.68512614287624);
                if(!google.maps.geometry.poly.isLocationOnEdge(points, paths, 10e-5)){
                    new google.maps.DirectionsRenderer({
                        map: map,
                        directions: response,
                        routeIndex: i,
                        polylineOptions: {
                            strokeColor: getRandomColor(),
                            strokeOpacity: 0.6,
                            strokeWeight: 8
                        }
                    });
                }
            }
            var marker = new google.maps.Marker({
                position: new google.maps.LatLng(10.756456968028788, 106.6851868278552),
                draggable: true,
                map: map
            });
            attachInstructionText(stepDisplay, marker,map);

            console.log(JSON.stringify(markerArray, null, 4));
        }
        else {
            window.alert('Directions request failed due to ' + status);
        }
    });
}

function getRadiusHeatmap(heatmap, map){
    var zooms = [17,18,19];
    var radius = [20,45.5,99.5];
    for (var i = 0; i < zooms.length; i++){
        if(map.getZoom() == zooms[i]){
            heatmap.setOptions({
                radius: radius[i],
                map: map
            });
        }
    }
}

// function sendData(data){
//     $.ajax({
//         type: "POST",
//         url: "/handleRoutes",
//         data: data,
//         dataType: "application/json",
//         success: function(msg){
//             alert(msg);
//         }
//     });
//
// }
function attachInstructionText(stepDisplay, marker, map) {
    google.maps.event.addListener(marker, 'click', function() {
        stepDisplay.setContent(marker.getPosition().toString());
        stepDisplay.open(map, marker);
    });
}

function getPointsHeatMap() {
    return [
        new google.maps.LatLng(10.756456968028788, 106.6851868278552),
        new google.maps.LatLng(10.801319,106.662233),
        new google.maps.LatLng(10.779126,106.702120),
        new google.maps.LatLng(10.820933,106.693903)
    ];
}
function autoComplete(address,map){
    var autocomplete = new google.maps.places.Autocomplete(address,{types: ['geocode']});
    autocomplete.bindTo('bounds', map);
    autocomplete.setFields(
        ['address_components', 'geometry', 'icon', 'name']);
}
function getRandomColor() {
    var letters = '0123456789ABCDEF';
    var color = '#';
    for (var i = 0; i < 6; i++) {
        color += letters[Math.floor(Math.random() * 16)];
    }
    return color;
}