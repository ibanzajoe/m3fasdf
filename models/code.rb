class Code < Sequel::Model
    plugin :timestamps
    many_to_one :company
    many_to_one :user
end
