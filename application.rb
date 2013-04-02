require 'sinatra'
require 'sinatra/static_assets'
require 'compass'
require 'pony'

# set :show_exceptions, true

configure do
  set :views, "#{File.dirname(__FILE__)}/views"
  Compass.add_project_configuration(File.join(Sinatra::Application.root, 'config', 'compass.config'))
end

get '/stylesheet/:name.css' do
  content_type 'text/css', :charset => 'utf-8'
  sass(:"stylesheet/#{params[:name]}", Compass.sass_engine_options )
end

get '/' do
  haml :index
end

get '/about.html' do
  haml :about
end

post '/about.html' do
  if params[:company_name].nil? || params[:company_website].nil? || params[:name].nil? || params[:email].nil? || params[:logo].nil?
    @errorMessage   = "Please fil in all fields."
  else
    @mailconfig = {
      :to => 'info@madeinamsterd.am',
      :from => 'no-reply@madeinamsterd.am',
      :subject => '[Made in Amsterdam] New application',
      :body => "Company name: #{params[:company_name]} \nCompany website: #{params[:company_website]} \n \nName: #{params[:name]} \nEmail: #{params[:email]}",
      :via => :smtp,
      :via_options => {
        :port =>           '587',
        :address =>        'smtp.mandrillapp.com',
        :user_name =>      ENV["MANDRILL_USERNAME"],
        :password =>       ENV["MANDRILL_APIKEY"],
        :domain =>         'heroku.com',
        :authentication => :plain
      }
    }
    if params[:logo] &&
        (tmpfile = params[:logo][:tempfile]) &&
        (name = params[:logo][:filename])
      @mailconfig[:attachments] = { name => tmpfile.read() }
    end
    Pony.mail(@mailconfig)
  end
  haml :about
end