require "redis"
require "faraday"

$redis = Redis.new

class FetchGemWorker
  include Sidekiq::Worker

  def perform(gem_name)
    response = connection.get("/api/v1/gems/#{gem_name}.json")
    downloads = JSON.parse(response.body)["downloads"]
    $redis.set(gem_name, downloads)
  end

  private
  def connection
    @connection ||= begin
      conn = ::Faraday.new(url: "https://rubygems.org") do |faraday|
        faraday.adapter :httpclient
      end
    end
  end
end
