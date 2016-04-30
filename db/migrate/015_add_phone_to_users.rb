Sequel.migration do
  up do
    add_column :users, :phone, String
  end

  down do
    drop_column :users, :phone
  end
end
