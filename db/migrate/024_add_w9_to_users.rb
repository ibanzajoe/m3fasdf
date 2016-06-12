Sequel.migration do
  up do
  	add_column :users, :w9_url, String
  end

  down do
  	drop_column :users, :w9_url
  end
end
