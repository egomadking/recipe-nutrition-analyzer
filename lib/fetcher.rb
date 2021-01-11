class Fetcher
  # "https://api.edamam.com/api/nutrition-details?app_id=${YOUR_APP_ID}&app_key=${YOUR_APP_KEY}"

  attr_accessor :url, :response, :req_body, :controller
  # attr_reader :APP_KEY, :APP_KEY

  def initialize
    @KEY = ENV["API_KEY"]
    @ID = ENV["APP_ID"]
    @url = "https://api.edamam.com/api/nutrition-details?app_id=#{@ID}&app_key=#{@KEY}"
  end

  def self.init_and_send(controller)
    fetcher = self.new
    fetcher.controller = controller
    fetcher.req_body = controller.req_body
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
    @controller.response(response)
  end

end 
