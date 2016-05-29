Padrino.configure_apps do
    enable :sessions
    set :session_secret, '52cb066050f4e1bef0802bef111939d64969136a6774f7d34f26f682cf4e10e9'
    set :protection, :except => :path_traversal
    #set :protect_from_csrf, true
    #set :protect_from_csrf, except: %r{/__better_errors/\w+/\w+\z} if Padrino.env == :development
    
    ### app specific settings, you can access them like this: settings.auth[:twitter][:key] ###
    # single sign on credentials
    set :auth, {
        :twitter => {:key => '', :secret => ''},
        :instagram => {:key => 'caa3d31debb44b11b9d5d6f171358899', :secret => 'ab4913bc59364bd8bf60f7172dfd0243'}
    }

    set :sendgrid, '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'
    set :plaid_pubkey, '5f0d575b97d6156fb7c889cc05b777'

end


# PayPal::SDK.configure(
#   :mode => "sandbox", # "sandbox" or "live"
#   :client_id => "AbuiPdnpCPRZ6iQ6iZjY69kdBb-AYSMASGB1VBmFUhIQmNI7VJeiKJsWyYm9G5OF2-zNwdf0RaxEOxCQ",
#   :client_secret => "EGFWv2tsrJF3hsvrDbD7hoGMmjt4kT9QVgcnWVzc1vLZur8EUDxbDkExMwgMZjS6X6lHpz27J7VAgYzm",
#   :ssl_options => { } )


# Mounts the core application for this project
Padrino.mount('Honeybadger::ApiApp', :app_file => Padrino.root('app/api/app.rb')).to('/api')
Padrino.mount('Honeybadger::AdminApp', :app_file => Padrino.root('app/admin/app.rb')).to('/admin')
Padrino.mount('Honeybadger::SiteApp', :app_file => Padrino.root('app/site/app.rb')).to('/')
