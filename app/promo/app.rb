# This is the main router file
# You can also create your own controllers in app/controllers/

module Honeybadger

  class PromoApp < Padrino::Application

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
      @title = "Promo Codes"
    end

    ### put your routes here ###
    get '/offer/:code' do
      @code = Code[params[:code]]
      render "code", :layout => false
    end

    # catch all error
    error Sinatra::NotFound do
      content_type 'text/plain'
      [404, 'Not Found']
    end


  end

end
