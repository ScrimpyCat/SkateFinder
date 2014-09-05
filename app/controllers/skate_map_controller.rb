class SkateMapController < ApplicationController
    def index
        @spots = [
            { :latitude => -37.8204706, :longitude => 144.9730166 }
        ]
        @markers = Gmaps4rails.build_markers(@spots) { |spot, marker|
            marker.lat spot[:latitude]
            marker.lng spot[:longitude]

        }

        puts @markers
    end
end
