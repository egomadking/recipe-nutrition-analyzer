class Fetcher
  # "https://api.edamam.com/api/nutrition-details?app_id=${YOUR_APP_ID}&app_key=${YOUR_APP_KEY}"

  attr_accessor :url, :response, :req_body

  def initialize
    @KEY = ENV["API_KEY"]
    @ID = ENV["APP_ID"]
    @url = "https://api.edamam.com/api/nutrition-details?app_id=#{@ID}&app_key=#{@KEY}"
  end

  def self.init_and_send(req_body)
    fetcher = self.new
    fetcher.req_body = req_body
    fetcher.request
  end
  
  def request
    uri = URI(@url)

    https = Net::HTTP.new(uri.host, uri.port)
    https.use_ssl = true

    request = Net::HTTP::Post.new(uri)
    request["Content-Type"] = "application/json"
    request.body = @req_body.to_json

    response = https.request(request)
  end

end 
