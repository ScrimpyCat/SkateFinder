function Callback(context, event)
{
    this.callback = function(){
        return this.event(this.context);
    }.bind(this);

    this.event = event;
    this.context = context;
}



Map.event = {}
Map.event.setup = {
    bounds_changed: null,
    center_changed: null,
    click: null,
    dblclick: null,
    drag: null,
    dragend: null,
    dragstart: null,
    heading_changed: null,
    idle: null,
    maptypeid_changed: null,
    mousemove: null,
    mouseout: null,
    mouseover: null,
    projection_changed: null,
    resize: null,
    rightclick: null,
    tilesloaded: null,
    tilt_changed: null,
    zoom_changed: function(context){
        context.event(context.map, context.map.zoom);
    }
}

Map.event.type = {
    BOUNDS: "bounds_changed",
    CENTER: "center_changed",
    CLICK: "click",
    DOUBLE_CLICK: "dblclick",
    DRAG: "drag",
    DRAG_STOP: "dragend",
    DRAG_START: "dragstart",
    DIRECTION_CHANGE: "heading_changed",
    IDLE: "idle",
    MAP_TYPE_ID_CHANGE: "maptypeid_changed",
    MOUSE_MOVE: "mousemove",
    MOVE_EXIT: "mouseout",
    MOVE_ENTER: "mouseover",
    PROJECTION_CHANGE: "projection_changed",
    RESIZE: "resize",
    RIGHT_CLICK: "rightclick",
    TILE_LOAD: "tilesloaded",
    TILT_CHANGE: "tilt_changed",
    ZOOM: "zoom_changed"
}

Map.Coord = function(lng, lat){
    return new google.maps.LatLng(lat, lng);
}

Map.Create = function(zoom, center){
    return new google.maps.Map(document.getElementById("map"), {
        zoom: zoom,
        center: center
    });
}

Map.prototype.Event = function(type, event){
    google.maps.event.addListener(this.map, type, new Callback({
        map: this,
        event: event
    }, Map.event.setup[type]).callback);
}

Object.defineProperty(Map.prototype, "zoom", {
    get: function(){
        return this.map.zoom;
    },
    set: function(zoom){
        this.map.zoom = zoom;
    }
})

function Map()
{
    this.map = Map.Create(14, Map.Coord(144.9631, -37.8136));

    this.Event(Map.event.type.ZOOM, function(map, zoom){
        console.log("zoom: " + zoom);
        if (zoom >= 16)
        {
            
        }
    });
    // google.maps.event.addListener(map, "zoom_changed", function(){
    //     console.log("zoom: " + map.zoom);
    //     if (zoom >= 16)
    //     {

    //     }
    // });
}



$(window).ready(function(){
    map = new Map();
    // var map = new google.maps.Map(document.getElementById("map"), {
    //     zoom: 14,
    //     center: new google.maps.LatLng(-37.8136, 144.9631)
    // });

    // $.ajax({
    //     url: '/api/v1/skategeo',
    //     data: {
    //         longitude: 0,
    //         latitude: 0,
    //         area: 0
    //     },
    //     success: function(data){
    //         if (data.status == "success")
    //         {
    //             var geo = data.data;
    //             for (var loop = 0, count = geo.features.length; loop < count; loop++)
    //             {
    //                 var marker = new google.maps.Marker({
    //                     position: new google.maps.LatLng(geo.features[loop].geometry.coordinates[1], geo.features[loop].geometry.coordinates[0]),
    //                     map: map
    //                 });
    //             }
    //         }
    //     }
    // });

    // google.maps.event.addListener(map, "zoom_changed", function(){
    //     console.log("zoom: " + map.zoom);
    //     if (zoom >= 16)
    //     {

    //     }
    // });
});