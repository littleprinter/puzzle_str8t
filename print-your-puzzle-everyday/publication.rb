# encoding: UTF-8
require 'json'
require 'sinatra'
require 'nokogiri'
require 'open-uri'


configure do
  # Define greetings for different times of the day in different languages.
  set :greetings, {
    'english'     => ['Good morning', 'Hello', 'Good evening'], 
    'french'      => ['Bonjour', 'Bonjour', 'Bonsoir'], 
    'german'      => ['Guten morgen', 'Hallo', 'Guten abend'], 
    'spanish'     => ['Buenos días', 'Hola', 'Buenas noches'], 
    'portuguese'  => ['Bom dia', 'Olá', 'Boa noite'], 
    'italian'     => ['Buongiorno', 'Ciao', 'Buonasera'], 
    'swedish'     => ['God morgon', 'Hallå', 'God kväll']
  }
end


get '/' do
@time = Time.new
url = 'http://www.str8ts.com/Print_Daily_Str8ts_DE.asp?d=0&a=7819'
data = Nokogiri::HTML(open(url), nil, Encoding::UTF_8.to_s)
@rows = data.css("td[valign=top] table tr") 

erb :muster
end


# == POST parameters:
# :config
#   params[:config] contains a JSON array of responses to the options defined
#   by the fields object in meta.json. In this case, something like:
#   params[:config] = ["name":"SomeName", "lang":"SomeLanguage"]
#
# == Returns:
# A JSON response object.
# If the parameters passed in are valid: {"valid":true}
# If the parameters passed in are not valid: {"valid":false,"errors":["No name was provided"], ["The language you chose does not exist"]}
#
post '/validate_config/' do
  if params[:config].nil?
    return 400, 'There is no config to validate.'
  end

  # Preparing what will be returned:
  response = {
    :errors => [],
    :valid => true
  }

  # Extract the config from the POST data and parse its JSON contents.
  # user_settings will be something like: {"name":"Alice", "lang":"english"}.
  user_settings = JSON.parse(params[:config])

  # If the user did not choose a language:
  if user_settings['lang'].nil? || user_settings['lang'] == ''
    response[:valid] = false
    response[:errors] << 'Please choose a language from the menu.'
  end
  
  # If the user did not fill in the name option:
  if user_settings['name'].nil? || user_settings['name'] == ''
    response[:valid] = false
    response[:errors] << 'Please enter your name into the name box.'
  end
  
  unless settings.greetings.include?(user_settings['lang'].downcase)
    # Given that the select field is populated from a list of languages
    # we defined this should never happen. Just in case.
    response[:valid] = false
    response[:errors] << "We couldn't find the language you selected (#{user_settings['lang']}). Please choose another."
  end
  
  content_type :json
  response.to_json
end


get '/sample/' do
@time = Time.new
url = 'http://www.str8ts.com/Print_Daily_Str8ts_DE.asp?d=0&a=7819'
data = Nokogiri::HTML(open(url), nil, Encoding::UTF_8.to_s)
@rows = data.css("td[valign=top] table tr") 

erb :muster
end

# Prepares and returns an edition of the publication.
#

# 
get '/edition/' do
@time = Time.new
url = 'http://www.str8ts.com/Print_Daily_Str8ts_DE.asp?d=0&a=7819'
data = Nokogiri::HTML(open(url), nil, Encoding::UTF_8.to_s)
@rows = data.css("td[valign=top] table tr") 
  # Set the ETag to match the content.
  etag Digest::MD5.hexdigest(Time.now.utc.strftime('%d%m%Y'))

erb :muster
end

