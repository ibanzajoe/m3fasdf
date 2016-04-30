Sequel.migration do
  up do
    add_column :users, :beta_request, String
  end

  down do
    drop_column :users, :beta_request, String
  end
end
