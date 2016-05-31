Sequel.migration do
  up do
  	add_column :users, :paypal_email, String, :index => true
  end

  down do
  	drop_column :users, :paypal_email
  end
end
