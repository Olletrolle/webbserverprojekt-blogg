require 'SQlite3'
require 'sinatra'
require 'slim'
require 'bcrypt'

enable :sessions

get('/') do
    slim(:index)
end

get('/login') do
    slim(:login)
end

post('/login') do
  redirect('/browse')
end
