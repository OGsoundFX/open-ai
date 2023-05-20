class PagesController < ApplicationController
  require "openai"

  def home
    if params[:query].present?
      client = OpenAI::Client.new(api_key: ENV["OPEN_AI_KEY"])

      response = client.completions(
        engine: "text-davinci-003",
        prompt: params[:query],
        temperature: 0.7,
        max_tokens: 250,
        n: 1,
        stop: nil
      )

      @response = response.choices[0].text
    else
      @response = ""
    end

    if params[:image]
      require "net/http"
      require "json"

      api_key = ENV["OPEN_AI_KEY"]
      url = URI.parse("https://api.openai.com/v1/images/generations")

      http = Net::HTTP.new(url.host, url.port)
      http.use_ssl = true

      request = Net::HTTP::Post.new(url.path)
      request["Content-Type"] = "application/json"
      request["Authorization"] = "Bearer #{api_key}"
      request.body = {
        prompt: params[:image],
        n: 4,
        size: "256x256"
      }.to_json

      response = http.request(request)

      if response.code == "200"
        image_data = JSON.parse(response.body)
        @images = image_data["data"]
      else
        @images = []
      end
    else
      @images = []
    end
  end
  
  def ask
    client = OpenAI::Client.new(api_key: ENV["OPEN_AI_KEY"])

    response = client.completions(
      engine: "text-davinci-003",
      prompt: params[:query],
      temperature: 0.7,
      max_tokens: 250,
      n: 1,
      stop: nil
    )

    @response = response.choices[0].text
  end
end
