Sequel.migration do
  up do
  	add_column :users, :w9_status, String
  end

  down do
  	add_column :users, :w9_status
  end
end
