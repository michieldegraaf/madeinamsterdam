require 'sinatra'
require 'sinatra/static_assets'
require 'compass'
require 'pony'

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

  require 'pony'

  @mailconfig = {
    :to => 'info@madeinamserd.am',
    :from => 'no-reply@madeinamsterd.am',
    :subject => "[Made in Amsterdam] New application",
    :body => "Company name: #{params[:ApplicationForm_CompanyName]} \nCompany website: #{params[:ApplicationForm_CompanyWebsite]} \n \nName: #{params[:ApplicationForm_Name]} \nEmail: #{params[:ApplicationForm_Email]}",
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

  # if company_name.nil? || company_website.nil? || name.nil? || email.nil? || filename.nil?
  # @errorMessage   = "Error"
  #end

  haml :about
end