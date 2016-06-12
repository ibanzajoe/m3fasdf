Padrino.configure_apps do
    enable :sessions
    set :session_secret, '52cb066050f4e1bef0802bef111939d64969136a6774f7d34f26f682cf4e10e9'
    set :protection, :except => :path_traversal
    #set :protect_from_csrf, true
    # set :protect_from_csrf, except: %r{/__better_errors/\w+/\w+\z} if Padrino.env == :development
    
    ### app specific settings, you can access them like this: settings.auth[:twitter][:key] ###
    # single sign on credentials
    set :auth, {
        :twitter => {:key => '', :secret => ''},
        :instagram => {:key => '', :secret => ''}
    }

    set :delivery_method, :smtp => {
      :address              => "email-smtp.us-east-1.amazonaws.com",
      :port                 => 587,
      :user_name            => 'AKIAI7C6YMLDA3ODC7AQ',
      :password             => 'AgHy0zRhy+MLjMHpSbSevUx91QmQl05zl3celMSk/DOl',
      :authentication       => 'plain',      
      :enable_starttls_auto => true,    
    }

    set :bcc, ['jae@markett.com', 'erin@markett.com', 'franky@markett.com', 'ronny@markett.com']

end

# Mounts the core application for this project
Padrino.mount('Honeybadger::ApiApp', :app_file => Padrino.root('app/api/app.rb')).to('/api')
Padrino.mount('Honeybadger::PromoApp', :app_file => Padrino.root('app/promo/app.rb')).to('/promo')
Padrino.mount('Honeybadger::DashboardApp', :app_file => Padrino.root('app/dashboard/app.rb')).to('/dashboard')
Padrino.mount('Honeybadger::SiteApp', :app_file => Padrino.root('app/site/app.rb')).to('/')
