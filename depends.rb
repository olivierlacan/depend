require "bundler"
Bundler.require(:default)

require "json"
require 'sinatra/reloader' if development?

get "/gem/:name" do
  results = rubygems_get(gem_name: params[:name], endpoint: "reverse_dependencies?only=runtime")

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
  response = connection.get(path)
  JSON.parse(response.body)
end

def connection
  @connection ||= begin
    conn = Faraday.new(url: "http://rubygems.org") do |faraday|
      faraday.adapter :httpclient
    end
  end
end
