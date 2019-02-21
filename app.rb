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

get('/create') do
  slim(:create)
end

# post('/login') do

#   db = SQLite3::Database.new('./public/inlogg.db')
#   db.results_as_hash = true
  
#   list = db.execute("SELECT password FROM users WHERE nickname = '#{params["nickname"]}'")
  
#   password = list[0][0]
  
#   hash_password = BCrypt::Password.create(password)

#   if BCrypt::Password.new(hash_password) == params["password"]
#       session[:id] = db.execute("SELECT id FROM users WHERE nickname = '#{params["nickname"]}'").first["id"]
#       session[:username] = db.execute("SELECT nickname FROM users WHERE nickname = '#{params["nickname"]}'").first["nickname"]
#       redirect('/myside/#{id}')
#   else
#       redirect('/')
#   end
# end

post('/create') do
  db = SQLite3::Database.new('./db/databas.db')
  db.results_as_hash = true

  db.execute("INSERT INTO users(nickname, email, password) VALUES(?, ?, ?)", params["nickname"], params["email"], params["password"])
end
