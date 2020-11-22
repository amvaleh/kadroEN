class LocationSerializer < ActiveModel::Serializer
  attributes :id, :living_address, :living_long, :living_lat, :working_long, :working_lat, :living_input, :working_input,
             :area_name, :city_name, :city_id
end