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

SkateSpot.prototype.showMarker = function(){
    if ((this.marker === undefined) || (this.marker === null))
    {
        this.marker = Map.Marker(Map.Coord(this.center), this.icon());
        this.map.addMarker(this.marker);
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
            //will need to throttle, and disable until success or failure
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

    if (zoom <= 18) this.showMarker();
    else this.hideMarker();

    if (zoom >= 16) this.showBounds();
    else this.hideBounds();

    if (zoom >= 19) this.showObstacles();
    else this.hideObstacles();
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

    this.event = this.map.addEvent(Map.EVENT.TYPE.ZOOM, this.display.bind(this));

    this.display();
}

$(window).ready(function(){
    var map = new Map();
    var skateSpots = []

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
                for (var loop = 0, count = geo.features.length; loop < count; loop++)
                {
                    skateSpots.push(new SkateSpot(geo.features[loop], map));
                }
            }
        }
    });

    // map.addEvent(Map.EVENT.TYPE.CLICK, function(map, mouse){
    //     console.log("[" + mouse.latLng.lng() + ", " + mouse.latLng.lat() + "]");
    // });
});