
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


def print_r(inHash, *indent)
    @indent = indent.join
    if (inHash.class.to_s == "Hash") then
        print "Hash\n#{@indent}(\n"
        inHash.each { |key, value|
            if (value.class.to_s =~ /Hash/) || (value.class.to_s =~ /Array/) then
                print "#{@indent}    [#{key}] => "
                self.print_r(value, "#{@indent}        ")
            else
                puts "#{@indent}    [#{key}] => #{value}"
            end
        }
        puts "#{@indent})\n"
    elsif (inHash.class.to_s == "Array") then
        print "Array\n#{@indent}(\n"
        inHash.each_with_index { |value,index|
            if (value.class.to_s == "Hash") || (value.class.to_s == "Array") then
                print "#{@indent}    [#{index}] => "
                self.print_r(value, "#{@indent}        ")
            else
                puts "#{@indent}    [#{index}] => #{value}"
            end
        }
        puts "#{@indent})\n"
    end
    #   Pop last indent off
    puts 8.times {@indent.chop!}
end