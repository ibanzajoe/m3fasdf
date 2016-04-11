Sequel.migration do
  up do
    add_column :transactions, :type, String
    from(:transactions).update(:type=>'activation')
    add_column :transactions, :label, String
    add_column :transactions, :parent_user_id, Fixnum
  end

  down do
  end
end
