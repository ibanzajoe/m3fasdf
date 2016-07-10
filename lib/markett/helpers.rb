module Markett

  module Helpers  

    # mailjet, usage:
    # 
    # make sure either :template or :text and :html are passed. if none of them are passed, it defaults
    # to :template with the default template id from config/apps.rb
    # 
    # - template way
    # mailjet({
    #   :from => 'support@markett.com', #(optional, defaults in config/apps.rb)
    #   :to => 'some@body.com',
    #   :bcc => ['test@test.com'], #(optional)
    #   :subject => 'test message',
    #   :template => {:id => 123, :name => 'jae lee', :message => 'this is a test message'}, #(optional if text or html is set)
    # })
    # 
    # - standard way
    # mailjet({
    #   :from => 'support@markett.com', #(optional, defaults in config/apps.rb)
    #   :to => 'some@body.com',
    #   :bcc => ['test@test.com'], #(optional)
    #   :subject => 'test message',
    #   :text => "this is a text message", 
    #   :html => "this is an html message",
    # })
    def mailjet(opts)

      # configure keys
      Mailjet.configure do |config|
        config.api_key = setting('mailjet')[:api_key]
        config.secret_key = setting('mailjet')[:secret_key]
      end

      # set recipients
      to = opts[:to]

      # copy markett employees
      bcc = []
      if Padrino.env == "production"
        setting('bcc').each do |email|
          bcc << email
        end
      end

      # set data to pass to mailjet
      data = {
        :from_email => opts[:from] || setting('mailjet')[:from],
        :from_name => opts[:from] || setting('mailjet')[:from],
        :subject => opts[:subject],
        :"Mj-TemplateID" => opts[:template][:id] || setting('mailjet')[:template_id],
        :"Mj-TemplateLanguage" => "true",
        :to => to,
        :bcc => bcc.join(","),
      }

      # choose either direct or template
      if !opts[:template].nil?
        data[:vars] = opts[:template]
      end

      if !opts[:text].nil?
        data[:text_part] = opts[:text]
      end

      if !opts[:html].nil?
        data[:html_part] = opts[:html]
      end

      # send mail
      res = Mailjet::Send.create(data)

      return res
      
    end

    def output(content)
      content
    end

  end

end