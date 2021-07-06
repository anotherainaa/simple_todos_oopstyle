require_relative 'todo'
require_relative 'list'
require_relative 'list_repo'

require 'yaml'
require 'sinatra'
require 'sinatra/reloader'
require 'tilt/erubis'
require "sinatra/content_for"

configure do
  enable :sessions
  set :session_secret, 'secret'
end

before do
  @lists_data = ListRepo.new
end

get '/' do
  redirect '/lists'
end

get '/lists' do
  @all_lists = @lists_data.all
  erb :lists
end

get '/lists/new' do
  erb :new_list
end

post '/lists' do
  id = @lists_data.all.last.nil? ? 1 : @lists_data.all.last.id + 1
  list_title = params[:list_title].strip

  if !(1..100).cover? list_title.size
    session[:error] = "List title must be between 1 and 100 characters."
    erb :new_list
  elsif !@lists_data.unique_title?(list_title)
    session[:error] = "List title must be unique."
    erb :new_list
  else
    list = List.new(id, list_title)
    @lists_data.add(list)
    @lists_data.save_lists
    session[:success] = "The list has been created."
    redirect '/'
  end
end

get '/lists/:id' do
  id = params[:id].to_i
  @list = @lists_data.item_at(id)
  erb :list
end

get "/lists/:id/edit" do
  id = params[:id].to_i
  @list = @lists_data.item_at(id)
  erb :edit_list
end

post '/lists/:id' do
  id = params[:id].to_i
  @list = @lists_data.item_at(id)
  list_title = params[:list_name].strip

  @list.title = list_title
  @lists_data.save_lists

  session[:success] = "The list has been updated."
  redirect "/lists/#{id}"
end

post '/lists/:id/destroy' do
  id = params[:id].to_i

  @lists_data.remove_at(id)
  @lists_data.save_lists

  session[:success] = "The list has been deleted."
  redirect "/lists"
end

post '/lists/:id/todos' do
  id = params[:id].to_i
  @list = @lists_data.item_at(id)
  todo_id = @list.last.nil? ? 1 : @list.last.id + 1
  todo_title = params[:todo]
  todo = Todo.new(todo_id, todo_title)

  @list.add(todo)
  @lists_data.save_lists
  session[:success] = "The todo has been added."
  redirect "/lists/#{id}"
end

post '/lists/:list_id/todos/complete_all' do
  list_id = params[:list_id].to_i
  @list = @lists_data.item_at(list_id)

  @list.done!
  @lists_data.save_lists

  session[:success] = "All todos have been updated."
  redirect "/lists/#{list_id}"
end

post '/lists/:list_id/todos/:id' do
  list_id = params[:list_id].to_i
  @list = @lists_data.item_at(list_id)
  id = @params[:id].to_i

  if params[:completed] == "true"
    @list.mark_done_at(id)
  elsif params[:completed] == "false"
    @list.mark_undone_at(id)
  end

  @lists_data.save_lists
  session[:success] = "Todo has been updated."
  redirect "/lists/#{list_id}"
end

post '/lists/:list_id/todos/:id/destroy' do
  list_id = params[:list_id].to_i
  @list = @lists_data.item_at(list_id)
  id = @params[:id].to_i

  @list.remove_at(id)
  @lists_data.save_lists

  redirect "/lists/#{list_id}"
end


