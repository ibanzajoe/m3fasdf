def config(name, value = nil)

  # return config value
  if value.nil?

    # do lookup
    row = Setting.where(:name => name).first[:value]

    # if not found, get settings from config/apps.rb
    if row.nil?
      row = settings.send(name).dup rescue nil
    end

    if row[0] == '{'
      row = eval(row)
    end

  elsif

    if value == ""
      Setting.where(:name => name).destroy
    end

  else
    row = Setting.where(:name => name)

    if value.class == Hash
      value = value.to_s
    end

    if row.count == 0
      Setting.new(:name => name, :value => value).save
    else
      row.update(:name => name, :value => value)
    end
  end

  return row
end

def number_to_currency(number, options = {})
  options.symbolize_keys!

  defaults  = I18n.translate(:'number.format', :locale => options[:locale], :raise => true) rescue {}
  currency  = I18n.translate(:'number.currency.format', :locale => options[:locale], :raise => true) rescue {}
  defaults  = defaults.merge(currency)

  precision = options[:precision] || defaults[:precision]
  unit      = options[:unit]      || defaults[:unit]
  separator = options[:separator] || defaults[:separator]
  delimiter = options[:delimiter] || defaults[:delimiter]
  format    = options[:format]    || defaults[:format]
  separator = '' if precision == 0

  begin
    format.gsub(/%n/, number_with_precision(number,
      :precision => precision,
      :delimiter => delimiter,
      :separator => separator)
    ).gsub(/%u/, unit)
  rescue
    number
  end
end
