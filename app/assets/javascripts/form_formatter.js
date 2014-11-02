FormFormatter = {
    Edit: function(form){
        var style = 0;

        $(form).children("#style-type").children("input[type='checkbox']:checked").each(function(){
            style |= $(this).val();
        });

        $(form).children("#style").val(style);

        if ((boundsEditor.active) && (boundsEditor.coords.length > 2))
        {
            var coords = boundsEditor.coords.map(function(coord){
                return "[" + [coord.lng(), coord.lat()].toString() + "]";
            });

            coords.push(coords[0]);

            $(form).children("#geometry").val("[" + coords.toString() + "]");
            boundsEditor.disable();
        }

        var a = ($(form).children("#name").val() + "," + $(form).children("#alternative_names").val()).split(",").map(function(name){
            return "<input name=\"alt_names[]\" type=\"hidden\" value=\"" + name + "\">";
        });

        $(form).children("#alt-names").html(a.join("\n"));

        return true;
    },
    Delete: function(form){
        $("#view").html("");
        return true;
    }
};
