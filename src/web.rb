require 'sinatra'

api_token = ENV['HIPCHAT_TOKEN']
client = HipChat::Client.new(api_token)
room_id = ENV['HIPCHAT_ROOM_ID']
username = 'Logentries'

http_user = ENV['WEBHOOK_USER']
http_password = ENV['WEBHOOK_PASSWORD']

use Rack::Auth::Basic do |username, password|
  username == http_user && password == http_password
end


get '/' do
  puts "Hello World!"
  client[room_id].send(username, 'Hello!')
  "Hello World!"
end

post '/alert' do
  puts params
  payload = JSON.parse(params[:payload])
  puts payload
  message = "%s: %s" % [payload['alert']['name'], payload['event']['m']]
  puts message
  client[room_id].send(username, message, color: 'red', notify: 1)
end
