require "bundler"
Bundler.require(:default)

require "json"
require 'sinatra/reloader' if development?
require_relative "fetch_gem_worker"

get "/" do
  erb :index
end

get "/search" do
  if !params[:gem].empty?
    redirect "/gem/#{params[:gem]}"
  else
    redirect "/"
  end
end

get "/gem/:name" do
  results = rubygems_get(gem_name: params[:name], endpoint: "reverse_dependencies?only=runtime")

  download_counts = {}
  @gems = []

  results.each { |name| FetchGemWorker.perform_async(name) }
  results.map { |name| download_counts[name] = $redis.get(name) }

  sorted_by_download_count = download_counts.sort do |(name1, count1), (name2, count2)|
    count2 <=> count1
  end

  sorted_by_download_count.first(50).each do |(name, count)|
    @gems << { name: name, downloads: count }
  end

  erb :gem
end

private

def rubygems_get(gem_name: "", endpoint: "")
  path = File.join("/api/v1/gems/", gem_name, endpoint).chomp("/") + ".json"
  response = connection.get(path)
  JSON.parse(response.body)
end

def connection
  @connection ||= begin
    conn = Faraday.new(url: "https://rubygems.org") do |faraday|
      faraday.adapter :httpclient
    end
  end
end
