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

get('/edit') do
  slim(:edit)
end

post('/login') do

  db = SQLite3::Database.new('./db/databas.db')
  db.results_as_hash = true
  
  list = db.execute("SELECT password FROM users WHERE nickname = '#{params["nickname"]}'")
  
  password = list[0][0]
  
  if BCrypt::Password.new(password) == params["password"]
    session[:id] = db.execute("SELECT id FROM users WHERE nickname = '#{params["nickname"]}'").first["id"]
    session[:username] = db.execute("SELECT nickname FROM users WHERE nickname = '#{params["nickname"]}'").first["nickname"]
    session[:profile] = true
    id = session[:id]
    redirect("/profile/#{id}")
  else
    redirect('/nix')
  end
end

get("/profile/:id") do
  db = SQLite3::Database.new('./db/databas.db')
  db.results_as_hash = true

  if session[:profile] == true
    session[:users] = db.execute("SELECT realName FROM users WHERE id = #{session[:id]}")
    slim(:profile, locals: {
      user: session[:users]
    })
  else
    redirect("/nix")
  end

end

post('/create') do
  db = SQLite3::Database.new('./db/databas.db')
  db.results_as_hash = true

  hash_password = BCrypt::Password.create( params["password"])

  db.execute("INSERT INTO users(nickname, realName, password) VALUES(?, ?, ?)", params["nickname"], params["realName"], hash_password)
  redircedt("/")
end

get("/uploadPost/:id") do
  slim(:upload)
end

post("/uploadPost/:id") do
  db = SQLite3::Database.new('./db/databas.db')
  db.results_as_hash = true

  post_id = session[:id]

  db.execute("INSERT INTO posts(title, text, post_id) VALUES(?, ?, ?)", params["title"], params["text"], post_id)
  redircedt("/profile/:id")
end

# post('/edit') do
#   db = SQLite3::Database.new('./db/databas.db')
#   db.results_as_hash = true

#   db.execute("UPDATE users SET nickname ='?', realName = '?', WHERE id = :id}", params["nickname"], params["realName"])
#   redirect("/profile/:id")
# end