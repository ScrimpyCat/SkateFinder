class SkateMapController < ApplicationController
    def index 
    end

    def edit
        @spot = SkateSpot.where(:id => params[:id]).first
        render :partial => 'edit'
    end
end
