# This is the main router file
# You can also create your own controllers in app/controllers/

module Honeybadger

  class SiteApp < Padrino::Application

    register Padrino::Mailer
    register Padrino::Helpers
    register WillPaginate::Sinatra

    enable :sessions
    enable :reload
    disable :dump_errors
    layout :site



    ### this runs before all routes ###
    before do
      @title = setting('site_title') || "Markett"
      @page = (params[:page] || 1).to_i
      @per_page = params[:per_page] || 5
    end        

    ### put your routes here ###
    get '/' do
      render "index"
    end

    get '/about' do
      render "about"
    end

    get '/affiliate' do
      render "affiliate"
    end

    get '/affiliate/register' do
      if !session[:user].nil?
        redirect "/admin"
      end
      render "affiliate_register"
    end

    post "/affiliate/register" do

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
        render "affiliate_register"
      else
        
        user = User.register_with_email(data, 'affiliate')
        if user.errors.empty?
          session[:user] = user
          redirect("/admin")
        else
          flash.now[:notice] = user.errors[:validation][0]
          render "affiliate_register"
        end

      end

    end


    get '/companies' do
      render "companies"
    end

    get '/company/register' do
      if !session[:user].nil?
        redirect "/admin"
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
        
        user = User.register_with_email(data, 'company')
        if user.errors.empty?
          session[:user] = user
          redirect("/admin")
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
      auth    = request.env["omniauth.auth"]
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
          session[:user] = user
          flash[:success] = "You are now logged in"
          redirect("/admin")
        else
          flash.now[:notice] = user.errors[:validation][0]
          render "login"
        end        
      end

    end

    get "/user/logout" do
      session.delete(:user)
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

    error Sinatra::NotFound do
      content_type 'text/plain'
      [404, 'Not Found']
    end




    
  end

end
