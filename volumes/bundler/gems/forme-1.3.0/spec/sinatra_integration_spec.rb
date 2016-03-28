require File.join(File.dirname(File.expand_path(__FILE__)), 'spec_helper.rb')
require File.join(File.dirname(File.expand_path(__FILE__)), 'sequel_helper.rb')
require File.join(File.dirname(File.expand_path(__FILE__)), 'erb_helper.rb')

require 'rubygems'
begin
require 'sinatra/base'
require(ENV['ERUBIS'] ? 'erubis' : 'erb')
require 'rack/csrf'
rescue LoadError
  warn "unable to load sinatra or rack/csrf, skipping sinatra spec"
else
require 'forme/sinatra'
class FormeSinatraTest < Sinatra::Base
  helpers(Forme::Sinatra::ERB)
  disable :show_exceptions
  enable :raise_errors
  enable :sessions
  use Rack::Csrf

  def self.get(path, &block)
    super("/#{path}", &block)
  end

  instance_exec(self, &ERB_BLOCK)
end

describe "Forme Sinatra ERB integration" do
  def sin_get(path)
    s = ''
    FormeSinatraTest.new.call(@rack.merge('PATH_INFO'=>path))[2].each{|str| s << str}
    s.gsub(/\s+/, ' ').strip
  end

  it_should_behave_like "erb integration"
end
end
