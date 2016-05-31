Sequel.migration do
  up do
  	add_column :withdrawals, :type, String, :index => true
  	add_column :withdrawals, :reference, String, :index => true
  end

  down do
  	drop_column :withdrawals, :type
  	drop_column :withdrawals, :reference
  end
end
