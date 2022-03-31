# OmniAuth Railscasts notes

### Gemfile
	gem 'omniauth-identity'
	gem 'bcrypt-ruby', '~> 3.0.0'
	
### config/initialiazers/omniauth.rb

	Rails.application.config.middleware.use OmniAuth::Builder do
	  #provider :twitter, 'CONSUMER_KEY', 'CONSUMER_SECRET'
	  provider :identity
	#  provider :identity, on_failed_registration: lambda { |env| IdentitiesController.action(:new).call(env) }
	end

	> rails g model identity name:string password_digest:string

	class Identity < OmniAuth::Identity::Models::ActiveRecord
	  validates_presence_of :password, on: :create
	  validates_presence_of :name
	
### new.html.haml
	%h1 Sign In
	#= link_to "Create an Account", "/auth/identity/register"
	= link_to "Create an Account", new_identity_path
	
	= form_tag "/auth/identity/callback" do
	  .field
	    = label_tag :auth_key, "Name"
	    = text_field_tag :auth_key
	  .field
	    = label_tag :password
	    = password_field_tag :password
	  .actions
	    = submit_tag "Login"
	
### > rails g controller identities
  
	class IdentitiesController <
	  def new
	    @identity = env['omniauth.identity']
	
### identities/new.html.haml
	%h1 New Account
	= form_tag "/auth/identity/register" do
	  if @identity && @identity.errors.any?
	    .error_messages
	      %h2 
	        = pluralize(@identity.errors.count, "error")
	        prevented this account from being saved!
	      %ul
	        - @identity.errors.full_messages.each do |msg|  
	          %li = msg
	  .field
	    = label_tag :name
	    = text_field_tag :name, @identity.try(:name)
	  .field
	    = label_tag :password
	    = password_field_tag :password
	    

### > rails g controller sessions

	class SessionsController <
	
	def create
	  raise request.env["omniauth.auth"].to_yaml
	end
	
	def create
	  auth = request.env["omniauth.auth"]
	  user = User.find_by_provider_and_uid(auth["provider"], auth["uid"]) || User.create_with_omniauth(auth)
	  session[:userid] = user.id
	  redirect_to root_url, :notice => "Signed in!"
	end
	
	def destroy
	  session[:userid] = nil
	  redirect_to root_url, :notice => "Signed out!"
	end
	
### > rails g model user provider:string uid:string name:string

### > rake db:migrate

	Class User
	  def self.create_with_omniauth(auth)
	    create! do |user|
	      user.provider = auth["provider"]
	      user.uid = auth["uid"]
	      user.name = auth["info"]["name"]
	    end
	  end
	end
	
	
	Class ApplicationController <
	
	  helper_method :current_user
	  
	  private
	  
	  def current_user
	    @current_user ||= User.find(session[:user_id]) if session[:user_id]
	  end
	
### config/routes.rb  
	  # Omniauth routes
	  root to: "session#new"
	  match "/auth/:provider/callback" => "sessions#create"
	  match "/auth/failure", to: "sessions#failure"
	  match "/logout" => "sessions#destroy", :as => :logout
	  resource :identities
	  
 
### layout/application.html.haml  
	  %body
	    .datepicker
	    #user_auth
	      if current_user
	        Welcome #{current_user.name}
	         = link_to "sign out", sign_out_path
	      else
	        = link_to "Log in", "/auth/identity
	    = yield  
	  
  
  
