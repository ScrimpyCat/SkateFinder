SkateObstacle.COLOUR = {
    //mostly vert related stuff (redish)
    "quarter_pipe": new Colour(1, 0.5, 0),
    "half-pipe": new Colour(1, 0, 0.5),
    "bowl": new Colour(1, 0.5, 0.5),
    "deck": new Colour(1, 0.2, 0.8),
    "spine": new Colour(1, 0.8, 0.2),
    "vert_wall": new Colour(1, 0.2, 0.2),
    "roll-in": new Colour(1, 0.5, 0.2),
    "pool": new Colour(1, 0.7, 0.5),
    "kidney_bowl": new Colour(1, 0.5, 0.7),
    "egg_bowl": new Colour(1, 0.8, 0.45),
    "cradle": new Colour(1, 0.3, 0.4),

    //mostly flip or grab or technical trick related stuff (greenish)
    "bank": new Colour(0, 1, 0),
    "hip": new Colour(0.5, 1, 0),
    "funbox": new Colour(0, 1, 0.5),
    "pyramid": new Colour(0, 1, 0.25),
    "wall-box": new Colour(0.4, 1, 0.2),
    "kicker": new Colour(0.2, 1, 0.6),
    "step-up": new Colour(0.8, 1, 0.2),
    "foam_pit": new Colour(0.6, 1, 0.3),
    "stairs": new Colour(0.5, 1, 0.5),
    "flat": new Colour(0.2, 1, 0.8),

    //mostly grindable reated stuff (blueish)
    "flat_rail": new Colour(0, 0, 1),
    "sloped_rail": new Colour(0, 0.5, 1),
    "kinked_rail": new Colour(0, 0.75, 1),
    "hand_rail": new Colour(0, 0.25, 1),
    "hubba": new Colour(0.75, 0, 1),
    "ledge": new Colour(0.5, 0, 1),

    //misc
    "jersey_barrier": new Colour(0, 0.5, 0.5)
};

SkateObstacle.prototype.showBounds = function(){
    if (((this.polygon === undefined) || (this.polygon === null)) && (this.bounds !== null))
    {
        var coords = this.bounds.map(function(point){
            return Map.Coord(point);
        });
        var colour = SkateObstacle.COLOUR[this.name];

        this.polygon = Map.Polygon(coords, colour.opacity(0.4), colour.opacity(0.2));
        this.map.addPolygon(this.polygon);
    }
};

SkateObstacle.prototype.hideBounds = function(){
    if ((this.polygon !== undefined) && (this.polygon !== null))
    {
        this.map.removePolygon(this.polygon);
        this.polygon = null;
    }
};

SkateObstacle.prototype.destroy = function(){
    this.hideBounds();

    this.map = null;
};

function SkateObstacle(name, bounds, map)
{
    this.map = map;
    this.name = name;
    this.bounds = bounds;
}


SkateSpot.STYLE = {
    UNKNOWN: 0,
    STREET: 1 << 0,
    VERT: 1 << 1
};

SkateSpot.prototype.icon = function(){
    var icon = "/assets/map/icons/44x44/"
    + (this.info.park? "park" : "spot")
    + (this.info.style & SkateSpot.STYLE.STREET? "-street" : "")
    + (this.info.style & SkateSpot.STYLE.VERT? "-vert" : "")
    + ".png";

    return icon;
};

SkateSpot.prototype.edit = function(){
    $.ajax({
        url: "/" + this.info.object_id + "/edit/",
        success: function(data){
            $("#view").html(data);
        }
    });
};

SkateSpot.prototype.showMarker = function(){
    if ((this.marker === undefined) || (this.marker === null))
    {
        this.marker = Map.Marker(Map.Coord(this.center), this.icon());
        this.map.addMarker(this.marker);
        this.marker.addEvent(Map.EVENT.CLICK, this.edit.bind(this));
    }
};

SkateSpot.prototype.hideMarker = function(){
    if ((this.marker !== undefined) && (this.marker !== null))
    {
        this.map.removeMarker(this.marker);
        this.marker = null;
    }
};

SkateSpot.prototype.showBounds = function(){
    if ((this.polygon === undefined) || (this.polygon === null))
    {
        if (this.bounds !== null)
        {
            var coords = this.bounds.map(function(point){
                return Map.Coord(point);
            });
            this.polygon = Map.Polygon(coords, new Colour(1,0,0,0.15), new Colour(1,0,0,0.3));
            this.map.addPolygon(this.polygon);
        }

        else
        {
            $.ajax({
                url: "/api/v1/skategeo/" + this.info.object_id,
                data: {
                    geo: true
                },
                success: function(data){
                    if (data.status == "success")
                    {
                        this.obstacles = []
                        var geo = data.data.features;
                        for (var loop = 0, count = geo.length; loop < count; loop++)
                        {
                            if (geo[loop].id == "spot_bounds")
                            {
                                this.bounds = geo[loop].geometry.coordinates[0];
                                this.bounds.pop();
                            }

                            else if (geo[loop].id.substr(0, 8) == "obstacle")
                            {
                                var bounds = null;
                                if (geo[loop].geometry != null)
                                {
                                    bounds = geo[loop].geometry.coordinates[0];
                                    bounds.pop();
                                }

                                this.obstacles.push(new SkateObstacle(geo[loop].id.slice(9), bounds, this.map));
                            }
                        }

                        this.display();
                    }
                }.bind(this)
            });
        }
    }
};

SkateSpot.prototype.hideBounds = function(){
    if ((this.polygon !== undefined) && (this.polygon !== null))
    {
        this.map.removePolygon(this.polygon);
        this.polygon = null;
    }
};

SkateSpot.prototype.showObstacles = function(){
    this.obstacles.each(SkateObstacle.prototype.showBounds);
};

SkateSpot.prototype.hideObstacles = function(){
    this.obstacles.each(SkateObstacle.prototype.hideBounds);
};

SkateSpot.prototype.display = function(){
    var zoom = this.map.zoom;

    if ((zoom <= 18) && (this.displaySettings.marker)) this.showMarker();
    else this.hideMarker();

    if ((zoom >= 16) && (this.displaySettings.bounds)) this.showBounds();
    else this.hideBounds();

    if ((zoom >= 19) && (this.displaySettings.obstacles)) this.showObstacles();
    else this.hideObstacles();
};

SkateSpot.prototype.update = function(data){
    if ((!_.isEqual(this.center, data.geometry.coordinates)) ||
        (this.info.park != data.properties.park) || 
        (this.info.style != data.properties.style)) this.hideMarker();

    this.center = data.geometry.coordinates;
    this.info = data.properties;

    if (this.bounds != null)
    {
        $.ajax({
            url: "/api/v1/skategeo/" + this.info.object_id,
            data: {
                geo: true
            },
            success: function(data){
                if (data.status == "success")
                {
                    var obstacles = this.obstacles, updatedObstacles = [];
                    var geo = data.data.features;
                    for (var loop = 0, count = geo.length; loop < count; loop++)
                    {
                        var bounds = null;
                        if (geo[loop].geometry != null)
                        {
                            bounds = geo[loop].geometry.coordinates[0];
                            bounds.pop();
                        }

                        if (geo[loop].id == "spot_bounds")
                        {
                            if (!_.isEqual(this.bounds, bounds)) this.hideBounds();
                            this.bounds = bounds;
                        }

                        else if (geo[loop].id.substr(0, 8) == "obstacle")
                        {
                            var updated = false;
                            for (var loop2 = 0, count2 = obstacles.length; loop2 < count2; loop2++)
                            {
                                if (bounds != null)
                                {
                                    if (_.isEqual(obstacles[loop2].bounds, bounds))
                                    {
                                        updated = true;
                                        updatedObstacles.push(obstacles[loop2]);
                                        obstacles.splice(loop2, 1);
                                        break;
                                    }
                                }
                            }

                            if (!updated) updatedObstacles.push(new SkateObstacle(geo[loop].id.slice(9), bounds, this.map));
                        }
                    }

                    this.obstacles = updatedObstacles;

                    obstacles.each(SkateObstacle.prototype.destroy);
                }

                this.display();
            }.bind(this)
        });
    }

    this.display();
};

SkateSpot.prototype.destroy = function(map){
    this.map.removeEvent(this.event);

    this.hideMarker();
    this.hideBounds();
    this.hideObstacles();

    this.map = null;
};

function SkateSpot(data, map)
{
    this.map = map;
    this.center = data.geometry.coordinates;
    this.bounds = null;
    this.info = data.properties;
    this.obstacles = []

    this.displaySettings = {
        marker: true,
        bounds: true,
        obstacles: true
    };

    this.event = this.map.addEvent(Map.EVENT.ZOOM, this.display.bind(this));

    this.display();
}


BoundsEditor.prototype.disable = function(){
    if (this.event != null)
    {
        this.map.removeEvent(this.event);
        this.event = null;

        if (this.bounds != null)
        {
            this.map.removePolygon(this.bounds);
            this.bounds = null;
        }

        Unfocus.event = this.map.addEvent(Map.EVENT.CLICK, Unfocus);

        boundsEditor.disableHook();
    }
};

BoundsEditor.prototype.enable = function(){
    boundsEditor.enableHook();

    if ((this.event === undefined) || (this.event === null))
    {
        this.coords = [];
        this.bounds = null;
        this.event = this.map.addEvent(Map.EVENT.CLICK, BoundsEditor.prototype.addPoint.bind(this));

        this.map.removeEvent(Unfocus.event);
        Unfocus.event = null;
    }
};

Object.defineProperty(BoundsEditor.prototype, "active", {
    get: function(){
        return this.event != undefined && this.event != null;
    }
});

BoundsEditor.prototype.addPoint = function(mouse){
    this.coords.push(mouse.latLng);

    var colour = new Colour(1, 0, 1);

    if (this.bounds != null) this.map.removePolygon(this.bounds);

    this.bounds = Map.Polygon(this.coords, colour.opacity(0.4), colour.opacity(0.2));
    this.map.addPolygon(this.bounds);

    google.maps.event.addListener(this.bounds, Map.EVENT.CLICK, BoundsEditor.prototype.addPoint.bind(this));
};

BoundsEditor.Edit = function(id){
    boundsEditor.disable();
    if ((boundsEditor.coords != undefined) && (boundsEditor.coords != null) && (boundsEditor.coords.length == 0))
    {
        boundsEditor.coords = null;
        return;
    }

    var spot = null;
    for (var loop = 0, count = skateSpots.length; loop < count; loop++)
    {
        if (skateSpots[loop].info.object_id == id)
        {
            spot = skateSpots[loop];
            break;
        }
    }

    boundsEditor.enableHook = function(){
        spot.displaySettings.bounds = false;
    };
    boundsEditor.disableHook = function(){
        spot.displaySettings.bounds = true;
    };

    boundsEditor.enable();
};

function BoundsEditor(map)
{
    this.map = map;
}


Unfocus.event = null;

function Unfocus()
{
    $("#view").html("");
}


$(window).ready(function(){
    var map = new Map();
    skateSpots = [];
    boundsEditor = new BoundsEditor(map);

    Unfocus.event = map.addEvent(Map.EVENT.CLICK, Unfocus);

    setInterval(function(){
        $.ajax({
            url: "/api/v1/skategeo",
            data: {
                longitude: 0,
                latitude: 0,
                area: 0
            },
            success: function(data){
                if (data.status == "success")
                {
                    var geo = data.data;
                    var updatedSkateSpots = [];
                    for (var loop2 = 0, count2 = skateSpots.length; loop2 < count2; loop2++)
                    {
                        var updated = false;
                        for (var loop = 0, count = geo.features.length; loop < count; loop++)
                        {
                            if (geo.features[loop].properties.object_id == skateSpots[loop2].info.object_id)
                            {
                                skateSpots[loop2].update(geo.features[loop]);
                                updatedSkateSpots.push(skateSpots[loop2]);
                                geo.features.splice(loop, 1);
                                updated = true;
                                break;
                            }
                        }

                        if (updated == false) skateSpots[loop2].destroy();
                    }

                    skateSpots = updatedSkateSpots;

                    for (var loop = 0, count = geo.features.length; loop < count; loop++)
                    {
                        skateSpots.push(new SkateSpot(geo.features[loop], map));
                    }
                }
            }
        });
    }, 2000);


    var toggle = document.createElement("div");
    $(toggle).css("padding-top", "5px");
    $(toggle).css("padding-left", "5px");
    $(toggle).html("<div class='gmaps-button'><strong>Obstacles</strong></div>");

    google.maps.event.addDomListener(toggle, Map.EVENT.CLICK, function(){
        skateSpots.forEach(function(spot){
            spot.displaySettings.obstacles = !spot.displaySettings.obstacles;
        });
    });

    toggle.index = 1;
    map.map.controls[google.maps.ControlPosition.TOP_RIGHT].push(toggle);


    toggle = document.createElement("div");
    $(toggle).css("padding-top", "5px");
    $(toggle).css("padding-left", "5px");
    $(toggle).html("<div class='gmaps-button'><strong>Bounds</strong></div>");

    google.maps.event.addDomListener(toggle, Map.EVENT.CLICK, function(){
        skateSpots.forEach(function(spot){
            spot.displaySettings.bounds = !spot.displaySettings.bounds;
        });
    });

    toggle.index = 1;
    map.map.controls[google.maps.ControlPosition.TOP_RIGHT].push(toggle);


    toggle = document.createElement("div");
    $(toggle).css("padding-top", "5px");
    $(toggle).css("padding-left", "5px");
    $(toggle).html("<div class='gmaps-button'><strong>Marker</strong></div>");

    google.maps.event.addDomListener(toggle, Map.EVENT.CLICK, function(){
        skateSpots.forEach(function(spot){
            spot.displaySettings.marker = !spot.displaySettings.marker;
        });
    });

    toggle.index = 1;
    map.map.controls[google.maps.ControlPosition.TOP_RIGHT].push(toggle);
});
