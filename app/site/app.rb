# This is the main router file
# You can also create your own controllers in app/controllers/

module Honeybadger

  class SiteApp < Padrino::Application

    register Padrino::Mailer
    register Padrino::Helpers
    register WillPaginate::Sinatra
  
    # enable :sessions
    require 'rack/session/dalli'
    use Rack::Session::Dalli, {:cache => Dalli::Client.new('memcache:11211')}    
    enable :reload
    disable :dump_errors
    layout :site

    ### this runs before all routes ###
    before do      

      # always redirect to www.markett.com
      if ["markett.com","markett.io","www.markett.io"].include? env["HTTP_HOST"]
        redirect "https://www.markett.com" + env["REQUEST_URI"]
      end

      # Login Bug
      if !session[:user_id].nil?
        session[:user] = User[session[:user_id]]
      end

      @title = setting('site_title') || "Markett"
      @page = (params[:page] || 1).to_i
      @per_page = params[:per_page] || 25              

      if env["REQUEST_URI"].include? "logout"
        session.destroy
        redirect "/"
      end

      if !env["REQUEST_URI"].include? "logout"
        case session[:user][:role] when "marketer", "company", "admin" then 
          redirect "/dashboard"
        end
      end

    end

    ### put your routes here ###
    get '/' do
      render "index"
    end

    get '/about' do
      render "about"
    end

    get '/beta/pending' do
      render "beta_pending"
    end

    post '/beta/pending' do

      if params[:beta_request].blank?
        redirect "/beta/pending", :notice => "Message can't be empty"
      end

      user = User[session[:user][:id]]
      user.beta_request = params[:beta_request]
      user.beta_how_hear = params[:beta_how_hear]
      user.beta_how_hear_custom = params[:beta_how_hear_custom]
      user.save_changes

      email({
        :from => session[:user][:email], 
        :to => 'support@markett.com', 
        :subject => "Beta Program Priority Request", 
        :body=> "#{params[:beta_request]}",
        :bcc => setting('bcc')
      })

      redirect "/beta/pending", :success => "Thank you, we will try to get you in as soon as possible! Stay tuned for our welcome email."
    end

    get '/marketer' do
      render "marketer"
    end

    get '/marketer/register' do
      if !session[:user].nil?
        redirect "/dashboard"
      end
      render "marketer_register"
    end

    post "/marketer/register" do

      data = params[:user]

      rules = {
          :first_name => {:type => 'string', :required => true},
          :last_name => {:type => 'string', :required => true},
          :email => {:type => 'email', :required => true},
          :password => {:type => 'string', :required => true},
      }
      validator = Validator.new(data, rules)
      if !validator.valid?
        flash.now[:notice] = validator.errors[0][:error]
        render "marketer_register"
      else

        # signed up via referral
        if !session[:referral_user_id].nil?
          data[:referral_user_id] = session[:referral_user_id]
          data[:invite_id] = session[:invite_id]
        end

        user = User.register_with_email(data, 'pending_marketer')
        if user.errors.empty?
          session[:user_id] = user[:id]
          redirect("/dashboard/promote")
        else
          flash.now[:notice] = user.errors[:validation][0]
          render "marketer_register"
        end

      end

    end

    get '/companies' do
      render "companies"
    end

    get '/company/register' do
      if !session[:user].nil?
        redirect "/dashboard"
      end
      render "company_register"
    end

    post "/company/register" do

      data = params[:user]

      rules = {
          :first_name => {:type => 'string', :required => true},
          :last_name => {:type => 'string', :required => true},
          :email => {:type => 'email', :required => true},
          :password => {:type => 'string', :required => true},
      }
      validator = Validator.new(data, rules)
      if !validator.valid?
        flash.now[:notice] = validator.errors[0][:error]
        render "company_register"
      else

        user = User.register_with_email(data, 'pending_company')
        if user.errors.empty?
          session[:user] = user
          redirect("/dashboard")
        else
          flash.now[:notice] = user.errors[:validation][0]
          render "company_register"
        end

      end

    end

    ### authentication routes ###
    #abort
    # auth_keys = setting('auth')

    # use OmniAuth::Builder do

    #   # /auth/twitter
    #   provider :twitter,  auth_keys[:twitter][:key], auth_keys[:twitter][:secret]

    #   # /auth/instagram
    #   provider :instagram,  auth_keys[:instagram][:key], auth_keys[:instagram][:secret]

    # end

    get '/auth/:name/callback' do
      auth = request.env["omniauth.auth"]
      user = User.login_with_omniauth(auth)

      if user
        session[:user] = user

        if user.email.blank?
          redirect("/user/account", :notice => 'Please fill in required informations')
        end

        redirect("/")
      else
        output(user.values)
      end
    end

    get "/user/account" do
      @user = session[:user]

      render "account"
    end

    post "/user/account" do

      rules = {
          :email => {:type => 'email', :required => true},
          :first_name => {:type => 'string', :required => true},
          :last_name => {:type => 'string', :required => true},
      }
      validator = Validator.new(params, rules)

      @user = session[:user]
      @user.email = params[:email]
      @user.first_name = params[:first_name]
      @user.last_name = params[:last_name]

      if !validator.valid?
        flash.now[:notice] = validator.errors[0][:error]
        render "account"
      else
        @user.save_changes
        redirect("/user/account", :success => 'Account information updated!')
      end

    end

    get "/user/login" do
      render "login"
    end

    post "/user/login" do

      rules = {
          :email => {:type => 'email', :required => true},
          :password => {:type => 'string', :required => true},
      }
      validator = Validator.new(params, rules)
      if !validator.valid?
        flash.now[:notice] = validator.errors[0][:error]
        render "login"
      else
        user = User.login(params)
        if user.errors.empty?
          session[:user_id] = user[:id]
          flash[:success] = "You are now logged in"
          redirect("/dashboard")
        else
          flash.now[:notice] = user.errors[:validation][0]
          render "login"
        end
      end

    end

    get "/user/logout" do
      session.destroy
      redirect("/")
    end

    get "/user/register" do
      render "register"
    end

    post "/user/register" do

      rules = {
          :first_name => {:type => 'string', :required => true},
          :last_name => {:type => 'string', :required => true},
          :email => {:type => 'email', :required => true},
          :password => {:type => 'string', :required => true},
      }
      validator = Validator.new(params, rules)
      if !validator.valid?
        flash.now[:notice] = validator.errors[0][:error]
        render "register"
      else

        user = User.register_with_email(params)
        if user.errors.empty?
          session[:user] = user
          redirect("/user/account")
        else
          flash.now[:notice] = user.errors[:validation][0]
          render "register"
        end

      end

    end

    get "/user/forgot_pass" do
      render "forgot_pass"
    end

    post "/user/forgot_pass" do

      rules = {
          :email => {:type => 'email', :required => true},
      }
      validator = Validator.new(params, rules)
      if !validator.valid?
        redirect("/user/forgot_pass", :notice => validator.errors[0][:error])
      else

        user = User.where(:email => params[:email]).first

        if !user.nil?

          # create message
          hash = Util::encrypt(params[:email])

          # send email
          body = "To reset your password, click here https://www.markett.com/user/reset_pass/#{hash}"
          email(
            :to => params[:email], 
            :from => 'support@markett.com', 
            :subject => 'Forgot email from markett.com', 
            :body => body, 
            :bcc => setting('bcc')
          )

          redirect("/user/forgot_pass", :success => "Password reset instructions sent to your email")
        else
          redirect("/user/forgot_pass", :notice => "Could not locate that email, please try again")
        end

      end

    end


    get "/user/reset_pass/:hash" do
      render "reset_pass"
    end

    post "/user/reset_pass" do

      rules = {
          :password => {:type => 'string', :required => true},
      }
      validator = Validator.new(params, rules)
      if !validator.valid?
        redirect("/user/reset_pass", :notice => validator.errors[0][:error])
      else

        email = Util::decrypt(params[:hash])
        user = User.where(:email => email).first

        if !user.nil?

          user.password = params[:password]
          user.password_confirmation = params[:password]
          if user.save
            # create message
            redirect("/user/login", :success => "Password has reset, please login with your new password")
          end
        else
          redirect("/user/reset_pass/#{params[:hash]}", :notice => "There was a problem resetting your password, please try again")
        end

      end

    end

    get "/invitation/:hash" do
      invite_id = Util::decrypt(params[:hash])
      invite = Invite[invite_id]
      session[:invite_id] = invite[:id]
      session[:referral_user_id] = invite[:user_id]
      redirect "/marketer/register"
      #render "invitation"
    end

    get '/promo_code/(:id)' do
      @code = Code[params[:id]]
      render "promo_code", :layout => false
    end

    get :posts do
      @title = "Honeybadger CMS"
      @posts = Post.order(:id).paginate(@page, @per_page).reverse
      render "posts"
    end

    ### view page ###
    get :post, :with => [:title, :id] do
      @post = Post[params[:id]]
      render "post"
    end

    get :about do
      render "about"
    end

    # api actions
    post '/api/codes/create' do
      "hello"
    end
    
    # catch all error 
    error Sinatra::NotFound do
      content_type 'text/plain'
      [404, 'Not Found']
    end


  end

end
