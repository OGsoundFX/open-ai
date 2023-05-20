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
