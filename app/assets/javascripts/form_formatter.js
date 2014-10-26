FormFormatter = {
    Edit: function(form){
        var style = 0;

        $(form).children("#style-type").children("input[type='checkbox']:checked").each(function(){
            style |= $(this).val();
        });

        $(form).children("#style").val(style);

        return true;
    }
}
