RailsAdmin.config do |config|
    config.authenticate_with do
        authenticate_admin! if Admin.count != 0
    end



    config.actions do
        dashboard                     # mandatory
        index                         # mandatory
        new
        export
        bulk_delete
        show
        edit
        delete
        show_in_app

        ## With an audit adapter, you can add:
        # history_index
        # history_show
    end
end
