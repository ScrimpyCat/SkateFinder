//Map
//Namespace
Map.namespace = {};
//Map::Marker
Map.namespace.Marker = function(coord, icon){
    this.marker = new google.maps.Marker({
        position: coord,
        icon: icon
    });
};

Map.namespace.Marker.prototype.setMap = function(map){
    this.marker.setMap(map);
};

Map.namespace.Marker.prototype.addEvent = function(type, event){
    return google.maps.event.addListener(this.marker, type, event);
};

Map.namespace.Marker.prototype.removeEvent = function(event){
    google.maps.event.removeListener(event);
};

//Map Constant variables
Map.EVENT = {
    SETUP: {
        bounds_changed: function(context){
            context.event(context.map);
        },
        center_changed: function(context){
            context.event(context.map);
        },
        click: function(context, mouse){
            context.event(context.map, mouse);
        },
        dblclick: function(context){
            context.event(context.map);
        },
        drag: function(context){
            context.event(context.map);
        },
        dragend: function(context){
            context.event(context.map);
        },
        dragstart: function(context){
            context.event(context.map);
        },
        heading_changed: function(context){
            context.event(context.map);
        },
        idle: function(context){
            context.event(context.map);
        },
        maptypeid_changed: function(context){
            context.event(context.map);
        },
        mousemove: function(context){
            context.event(context.map);
        },
        mouseout: function(context){
            context.event(context.map);
        },
        mouseover: function(context){
            context.event(context.map);
        },
        projection_changed: function(context){
            context.event(context.map);
        },
        resize: function(context){
            context.event(context.map);
        },
        rightclick: function(context){
            context.event(context.map);
        },
        tilesloaded: function(context){
            context.event(context.map);
        },
        tilt_changed: function(context){
            context.event(context.map);
        },
        zoom_changed: function(context){
            context.event(context.map, context.map.zoom);
        }
    },
    TYPE: {
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
};

Map.Coord = function(lng, lat){
    if (Array.isArray(lng)) return new google.maps.LatLng(lng[1], lng[0]);
    else return new google.maps.LatLng(lat, lng);
};

Map.Bounds = function(sw, ne){
    return new google.maps.LatLngBounds(sw, ne);
};

Map.Marker = function(coord, icon){
    return new Map.namespace.Marker(coord, icon);
};

Map.Polygon = function(coords, fillColour, strokeColour, strokeWidth){
    fillColour = fillColour || Colour.Clear();
    strokeColour = strokeColour || Colour.Clear();
    strokeWidth = strokeWidth == undefined ? 1 : strokeWidth;

    return new google.maps.Polygon({
        paths: coords,
        fillColor: fillColour.hex,
        fillOpacity: fillColour.a,
        strokeColor: strokeColour.hex,
        strokeOpacity: strokeColour.a,
        strokeWidth: strokeWidth
    });
};

Map.Create = function(zoom, center){
    return new google.maps.Map(document.getElementById("map"), {
        zoom: zoom,
        center: center
    });
};

//Map instance methods
Map.prototype.addEvent = function(type, event){
    return google.maps.event.addListener(this.map, type, event);
};

Map.prototype.removeEvent = function(event){
    google.maps.event.removeListener(event);
};

Map.prototype.addMarker = function(marker){
    this.markers.push(marker);
    marker.setMap(this.map);
};

Map.prototype.removeMarker = function(marker){
    this.markers = this.markers.filter(Compare.Equal, [marker]);
    marker.setMap(null);
};

Map.prototype.addPolygon = function(polygon){
    polygon.setMap(this.map);
};

Map.prototype.removePolygon = function(polygon){
    polygon.setMap(null);
};

Map.prototype.panBy = function(x, y){
    this.map.panBy(x, y);
};

Map.prototype.panTo = function(coord){
    this.map.panTo(coord);
};

Map.prototype.panToBounds = function(bounds){
    this.map.panToBounds(bounds);
};

//Map properties
Object.defineProperty(Map.prototype, "bounds", {
    get: function(){
        return this.map.getBounds();
    },
    set: function(bounds){
        this.map.fitBounds(bounds);
    }
});

Object.defineProperty(Map.prototype, "center", {
    get: function(){
        return this.map.getCenter();
    },
    set: function(center){
        this.map.setCenter(center);
    }
});

Object.defineProperty(Map.prototype, "div", {
    get: function(){
        return this.map.getDiv();
    }
});

Object.defineProperty(Map.prototype, "heading", {
    get: function(){
        return this.map.getHeading();
    },
    set: function(heading){
        this.map.setHeading(heading);
    }
});

Object.defineProperty(Map.prototype, "mapTypeId", {
    get: function(){
        return this.map.getMapTypeId();
    },
    set: function(mapTypeId){
        this.map.setMapTypeId(mapTypeId);
    }
});

Object.defineProperty(Map.prototype, "projection", {
    get: function(){
        return this.map.getProjection();
    }
});

Object.defineProperty(Map.prototype, "options", {
    set: function(options){
        this.map.setOptions(options);
    }
});

Object.defineProperty(Map.prototype, "streetView", {
    get: function(){
        return this.map.getStreetView();
    },
    set: function(streetView){
        this.map.setStreetView(streetView);
    }
});

Object.defineProperty(Map.prototype, "tilt", {
    get: function(){
        return this.map.getTilt();
    },
    set: function(tilt){
        this.map.setTilt(tilt);
    }
});

Object.defineProperty(Map.prototype, "zoom", {
    get: function(){
        return this.map.getZoom();
    },
    set: function(zoom){
        this.map.setZoom(zoom);
    }
});

Object.defineProperty(Map.prototype, "controls", {
    get: function(){
        return this.map.controls;
    }
});

Object.defineProperty(Map.prototype, "data", {
    get: function(){
        return this.map.data;
    }
});

Object.defineProperty(Map.prototype, "mapTypes", {
    get: function(){
        return this.map.mapTypes;
    }
});

Object.defineProperty(Map.prototype, "overlayMapTypes", {
    get: function(){
        return overlayMapTypes;
    }
});

function Map()
{
    this.markers = [];
    this.map = Map.Create(14, Map.Coord(144.9631, -37.8136));
}
