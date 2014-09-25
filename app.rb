require "sinatra"
if development?
  require "sinatra/reloader"
end

require "active_record"

ActiveRecord::Base.establish_connection(
  adapter: "postgresql",
  database: "photo_gallery"
)

class Gallery < ActiveRecord::Base
end

class Image < ActiveRecord::Base
end

get "/" do
  @galleries = Gallery.all 
  erb :home
end

get "/galleries/new" do
  erb :new_gallery
end

post "/galleries" do
  new_gallery_name = params[:gallery][:name]
  Gallery.create(name: new_gallery_name)

  redirect to("/")
end

get "/galleries/:id/edit" do
  @gallery = Gallery.find(params[:id])
  erb :edit_gallery
end

patch "/galleries/:id" do
  id = params[:id]
  gallery = Gallery.find(params[:id])
  gallery.update(params[:gallery])
  redirect to("/galleries/#{id}")
end

delete "/galleries/:id" do
  id = params[:id]
  gallery = Gallery.find(params[:id])
  gallery.destroy
  redirect to("/")
end

get "/galleries/:id" do
  id = params[:id]
  @gallery = Gallery.find(id)
  @images = Image.where(gallery_id: id)

 erb :gallery
end
