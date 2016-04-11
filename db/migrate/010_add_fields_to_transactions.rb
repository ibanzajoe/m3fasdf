Sequel.migration do
  up do
    add_column :transactions, :type, String
    from(:transactions).update(:type=>'activation')
    add_column :transactions, :label, String
  end

  down do
  end
end
