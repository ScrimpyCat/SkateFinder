# module V1
    class SkateGeoController < ApplicationController
        protect_from_forgery :with => :null_session
        respond_to :json

        #GET ?longitude=float&latitude=float&area=float
        #curl -i -H "Accept: application/json" -G -d "longitude=0&latitude=0&area=0" http://0.0.0.0:3000/skategeo
        def index
            if params.has_key?(:longitude) and params.has_key?(:latitude) and params.has_key?(:area)
                @spots = SkateSpot.all

                render 'index.json'
            else
                render :json => { :status => :unprocessable_entity }
            end
        end

        def parse_boolean(attribute, params)
            info = {}
            if params.has_key?(attribute)
                if params[attribute].kind_of? String
                    info[attribute] = params[attribute].to_bool
                    raise ArgumentError, 'Argument cannot be parsed as boolean' unless info[attribute]
                else
                    info[attribute] = nil
                end
            end

            info
        end

        def parse_input(params)
            info = {}

            if params.has_key?(:alt_names)
                if params[:alt_names].kind_of? Array
                    info[:alt_names] = params[:alt_names]
                elsif params[:alt_names] == nil
                    info[:alt_names] = []
                else
                    info[:alt_names] = [params[:alt_names]]
                end
            end

            info[:name] = params[:name]
            info.merge!(parse_boolean(:park, params))
            info[:style] = (params[:style] == nil ? nil : params[:style].to_i) if params.has_key?(:style)
            info.merge!(parse_boolean(:undercover, params))
            info[:cost] = (params[:cost] == nil ? nil : params[:cost].to_f) if params.has_key?(:cost)
            info[:currency] = params[:currency] if params.has_key?(:currency)
            info.merge!(parse_boolean(:lights, params))
            info.merge!(parse_boolean(:private_property, params))

            info

            rescue ArgumentError
                nil
        end

        #curl -i -H "Accept: application/json" -X POST -d "geometry=[0,0],[0,1],[1,0],[0,0]" http://0.0.0.0:3000/skategeo/
        def create
            spot = SkateSpot.new({
                :longitude => 0.5, #remove later
                :latitude => 0.5, #remove later
                :geometry => params[:geometry],
                :park => params[:park],
                :style => params[:style],
                :undercover => params[:undercover],
                :cost => params[:cost],
                :currency => params[:currency],
                :lights => params[:lights],
                :private_property => params[:private_property]
            })
            spot.save
            render :json => { :status => :unprocessable_entity }
        end

        #GET /:id ?detailed, geo, name, alt_name, park, style, undercover, cost, lights, private_property, obstacles
        #curl -i -H "Accept: application/json" -G -d "geo=false&name=true&alt_names=true" http://0.0.0.0:3000/skategeo/1/
        def show
            if @spot = SkateSpot.where(:id => params[:id]).first
                @detailed = params[:detailed] == 'true' ? true : false

                if params[:geo] == 'false'
                    @use = {
                        :name => params[:name] == 'true',
                        :alt_names => params[:alt_names] == 'true',
                        :park => params[:park] == 'true',
                        :style => params[:style] == 'true',
                        :undercover => params[:undercover] == 'true',
                        :cost => params[:cost] == 'true',
                        :lights => params[:lights] == 'true',
                        :private_property => params[:private_property] == 'true',
                        :obstacles => params[:obstacles] == 'true'
                    }
                    render 'data.json' #JSON
                else
                    render 'show.json' #GeoJSON
                end
            else
                render :json => { :status => :unprocessable_entity }
            end
        end

        #curl -i -H "Accept: application/json" -X PUT -d "name=testing" http://0.0.0.0:3000/skategeo/1/
        def update
            if spot = SkateSpot.where(:id => params[:id]).first
                # if params.has_key?(:alt_names)
                #     if params[:alt_names].kind_of? Array
                #         spot.update(:alt_names => params[:alt_names].map { |n| SpotName.create(:name => n, :spot => spot) })
                #     elsif params[:alt_names] == nil
                #         spot.update(:alt_names => [])
                #     else
                #         spot.update(:alt_names => [SpotName.create(:name => params[:alt_names], :spot => spot)])
                #     end
                # end

                # info = {}
                # if params[:name]
                #     info[:name] = SpotName.where(:name => params[:name]).first || SpotName.create(:name => params[:name], :spot => spot)
                # end
                # info[:park] = params[:park].to_bool if params.has_key?(:park)
                # info[:style] = params[:style].to_i if params.has_key?(:style)
                # info[:undercover] = params[:undercover].to_bool if params.has_key?(:undercover)
                # info[:cost] = params[:cost].to_f if params.has_key?(:cost)
                # info[:currency] = params[:currency] if params.has_key?(:currency)
                # info[:lights] = params[:lights].to_bool if params.has_key?(:lights)
                # info[:private_property] = params[:private_property].to_bool if params.has_key?(:private_property)
                parse_input()

                render :json => { :status => (spot.update(info) == true ? :success : :unprocessable_entity) }
            else
                render :json => { :status => :unprocessable_entity }
            end
        end

        #curl -i -H "Accept: application/json" -X DELETE http://0.0.0.0:3000/skategeo/1/
        def destroy
            render :json => { :status => (SkateSpot.where(:id => params[:id]).destroy_all.count > 0 ? :success : :unprocessable_entity) }
        end
    end
# end
