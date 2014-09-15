

SkateSpot.prototype.showMarker = function(){
    if ((this.marker == undefined) || (this.marker == null))
    {
        this.marker = Map.Marker(Map.Coord(this.center));
        this.map.addMarker(this.marker);
    }
};

SkateSpot.prototype.hideMarker = function(){
    if ((this.marker != undefined) || (this.marker != null))
    {
        this.map.removeMarker(this.marker);
        this.marker = null;
    }
}

SkateSpot.prototype.display = function(){
    console.log(this);
    // var zoom = this.map.zoom;
    // if (zoom < 16) //0 - 15 marker
    // {
    //     this.showMarker();
    // }

    // else if (zoom < 20) //16 - 19 marker + bounds
    // {

    // }

    // else //20+ bounds + obstacles
    // {
    //     this.hideMarker();
    // }
};

SkateSpot.prototype.destroy = function(map){

};

function SkateSpot(data, map)
{
    this.map = map;
    this.id = data.id;
    this.center = data.geometry.coordinates;
    this.bounds = null;
    this.info = data.properties;

    this.map.addEvent(Map.EVENT.TYPE.ZOOM, this.display.bind(this));

    // this.display();
}

$(window).ready(function(){
    var map = new Map();
    var skateSpots = []

    $.ajax({
        url: '/api/v1/skategeo',
        data: {
            longitude: 0,
            latitude: 0,
            area: 0
        },
        success: function(data){
            if (data.status == "success")
            {
                var geo = data.data;
                for (var loop = 0, count = geo.features.length; loop < count; loop++)
                {
                    skateSpots.push(new SkateSpot(geo.features[loop], map));
                    // var marker = Map.Marker(Map.Coord(geo.features[loop].geometry.coordinates));
                    // map.addMarker(marker);
                }
            }
        }
    });

    map.addEvent(Map.EVENT.TYPE.ZOOM, function(map, zoom){
        console.log(zoom);
        // if (zoom >= 16) //draw bounds
        // {
            // console.log(map);
            // for 
            // console.log(map.markers);
            // map.removeMarker(map.markers[0]);

        // }

        //draw obstacles

        //draw  marker
    });
});