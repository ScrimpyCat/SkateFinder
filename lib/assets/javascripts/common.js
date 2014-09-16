//Convenient comparisons
Compare = {
    Equal: function(o){
        return o == this;
    },
    StrictEqual: function(o){
        return o === this;
    },
    NotEqual: function(o){
        return o != this;
    },
    StrictNotEqual: function(o){
        return o !== this;
    },
    GreaterThan: function(o){
        return o > this;
    },
    GreaterThanOrEqual: function(o){
        return o >= this;
    },
    LessThan: function(o){
        return o < this;
    },
    LessThanOrEqual: function(o){
        return o <= this;
    }
}

//Colour
Colour.Clear = function(){
    return new Colour(0, 0, 0, 0);
};

Object.defineProperty(Colour.prototype, "hex", {
    get: function(){
        return "#" + [this.r, this.g, this.b].map(function(c){
            var h = Math.round(255 * c).toString(16);
            return h.length == 1 ? "0" + h : h;
        }).join("");
    }
});

Colour.prototype.opacity = function(a){
    return new Colour(this.r, this.g, this.b, a);
}

function Colour(r, g, b, a)
{
    this.r = r == undefined ? 0 : r;
    this.g = g == undefined ? 0 : g;
    this.b = b == undefined ? 0 : b;
    this.a = a == undefined ? 1 : a;
}

//Array
Array.prototype.each = function(callback, args){
    var array = this;
    for (var loop = 0, count = array.length; loop < count; loop++)
    {
        callback.apply(array[loop], args);
    }
};