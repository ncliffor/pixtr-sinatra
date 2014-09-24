require "sinatra"
if development?
  require "sinatra/reloader"
end

require "pg"

database = PG.connect({ dbname: "photo_gallery"})

GALLERIES = {
  "cats" => ["colonel_meow.jpg", "grumpy_cat.png"],
  "dogs" => ["shibe.png"]
}

get "/" do
  galleries = database.exec_params("SELECT name FROM galleries")
  @gallery_names = galleries.map {|gallery| gallery["name"]}
  @galleries = GALLERIES
  erb :home
end

get "/galleries/:name" do
 @name = params[:name]
 @images = GALLERIES[@name]
 erb :gallery
end
