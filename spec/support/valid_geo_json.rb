def validate_geo_json(geojson)
    uri = URI('http://geojsonlint.com/validate')
    request = Net::HTTP::Post.new(uri.path, { 'Content-Type' => 'application/json' })
    request.body = geojson
    Net::HTTP.start(uri.hostname, uri.port) { |http| JSON.parse(http.request(request).body) }
end

RSpec.shared_examples 'GeoJSON' do
    it 'should be valid' do
        render
        expect(validate_geo_json(rendered)).to eql({ 'status' => 'ok' })
    end
end
