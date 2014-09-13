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
                value = params[attribute]
                if value.kind_of? String
                    info[attribute] = value.to_bool
                    raise ArgumentError, 'Argument cannot be parsed as boolean' if info[attribute] == nil
                elsif value.kind_of? TrueClass or value.kind_of? FalseClass
                    info[attribute] = value
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
                elsif params[:alt_names].kind_of? String
                    info[:alt_names] = [params[:alt_names]]
                else
                    raise ArgumentError
                end
            end

            if params.has_key?(:name)
                raise ArgumentError if !params[:name].kind_of? String and params[:name] != nil
                info[:name] = params[:name]
            end


            info[:geometry] = params[:geometry] if params.has_key?(:geometry)            
            info.merge!(parse_boolean(:park, params))
            info[:style] = params[:style] if params.has_key?(:style)
            info.merge!(parse_boolean(:undercover, params))
            info[:cost] = params[:cost] if params.has_key?(:cost)
            info[:currency] = params[:currency] if params.has_key?(:currency)
            info.merge!(parse_boolean(:lights, params))
            info.merge!(parse_boolean(:private_property, params))

            if params.has_key?(:obstacles)
                if params[:obstacles].kind_of? Array
                    info[:obstacles] = params[:obstacles]
                elsif params[:obstacles] == nil
                    info[:obstacles] = []
                else
                    info[:obstacles] = [params[:obstacles]]
                end
            end

            info

            rescue ArgumentError
                nil
        end

        #curl -i -H "Accept: application/json" -X POST -d "geometry=[[0,0],[1,0],[0,1],[0,0]]" http://0.0.0.0:3000/skategeo/
        def create
            if info = parse_input(params)
                name = info.delete(:name)
                alt_names = info.delete(:alt_names)
                obstacles = info.delete(:obstacles)

                if spot = SkateSpot.new(info)
                    spot.alt_names = alt_names.map! { |n| SpotName.find_or_create_by(:name => n, :spot => spot) } if alt_names
                    spot.name = SpotName.find_or_create_by(:name => name, :spot => spot) if name
                    spot.obstacles = obstacles.map! { |o| Obstacle.create(:type => ObstacleType.where(:name => o['type']).first, :geometry => o['geometry'], :spot => spot) } if obstacles

                    return render :json => { :status => (spot.save == true ? :success : :unprocessable_entity) }
                end
            end

            render :json => { :status => :unprocessable_entity }

            rescue ActiveRecord::RecordNotSaved
                render :json => { :status => :unprocessable_entity }
        end

        #GET /:id ?detailed, geo, name, alt_names, park, style, undercover, cost, lights, private_property, obstacles
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
            if spot = SkateSpot.where(:id => params[:id]).first and info = parse_input(params)
                if info.has_key?(:alt_names)
                    info[:alt_names].map! { |n| SpotName.find_or_create_by(:name => n, :spot => spot) }
                end

                if info[:name]
                    info[:name] = SpotName.find_or_create_by(:name => info[:name], :spot => spot) 
                end

                if info.has_key?(:obstacles)
                    info[:obstacles].map! { |o|
                        Obstacle.find_or_create_by(:type => ObstacleType.where(:name => o['type']).first, :geometry => o['geometry'], :spot => spot)
                    }
                end

                render :json => { :status => (spot.update(info) == true ? :success : :unprocessable_entity) }
            else
                render :json => { :status => :unprocessable_entity }
            end

            rescue ActiveRecord::RecordNotSaved
                render :json => { :status => :unprocessable_entity }
        end

        #curl -i -H "Accept: application/json" -X DELETE http://0.0.0.0:3000/skategeo/1/
        def destroy
            render :json => { :status => (SkateSpot.where(:id => params[:id]).destroy_all.count > 0 ? :success : :unprocessable_entity) }
        end
    end
# end
