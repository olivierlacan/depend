require "net/https"
require "uri"
require "json"
require "sinatra"

get "/gem/:name" do
  results = rubygems_get(gem_name: "rack", endpoint: "reverse_dependencies")

  weighted_results = {}

  results.each do |name|
    begin
      weighted_results[name] = rubygems_get(gem_name: name)["downloads"]
    rescue => e
      puts "#{name} #{e.message}"
    end
  end

  weighted_results.sort {|(k1, v1), (k2, v2)| v2 <=> v1 }.first(50).each_with_index do |(k, v), i|
    puts "#{i}) #{k}: #{v}"
  end
end

private

def rubygems_get(gem_name: "", endpoint: "")
  path = File.join("/api/v1/gems/", gem_name, endpoint).chomp("/") + ".json"
  uri = URI.parse("https://www.rubygems.org" + path)

  http = Net::HTTP.new(uri.host, uri.port)
  http.use_ssl = true
  http.verify_mode = OpenSSL::SSL::VERIFY_NONE

  response = http.get(uri.request_uri)
  JSON.parse(response.body)
end
