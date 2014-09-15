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

//Callback (provides a specified context)
function Callback(context, event)
{
    if (event == undefined)
    {
        event = context;
        context = undefined;
    }

    this.callback = function(){
        return this.event(this.context);
    }.bind(this);

    this.event = event;
    this.context = context;
}