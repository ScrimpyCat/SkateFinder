// var RetrieveSpots = _.throttle(function(){
//     $.ajax({
//         url: '/'
//     });
// });

$(window).ready(function(){
    handler = Gmaps.build('Google');
    handler.buildMap({
        provider: {},
        internal: {id: 'map'}
    }, function(){
        handler.map.centerOn({ "lat": -37.8136, "lng": 144.9631 });
        $.ajax({
            url: '/'
        });
        // markers = handler.addMarkers([
        //     {
        //         "lat": -37.8204706,
        //         "lng": 144.9730166
        //     }
        // ]);
        // handler.bounds.extendWith(markers);
        handler.fitMapToBounds();
    });
});