# module V1
    class SkateGeoController < ApplicationController
        respond_to :json

        #GET ?longitude=float&latitude=float&area=float
        def index
            puts params
            if params.has_key?(:longitude) and params.has_key?(:latitude) and params.has_key?(:area)
                puts "correct"

                spots = {
                    :type => "FeatureCollection"
                }

                render 'index.json'
            else
                puts "incorrect"
                render :json => { :status => :unprocessable_entity }
            end
        end

        def new
        end

        def create
        end

        def show
        end

        def edit
        end

        def update
        end

        def destroy
        end
    end
# end
