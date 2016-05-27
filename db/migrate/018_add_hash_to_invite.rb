Sequel.migration do
  up do
    add_column :invites, :hash, String, :index => true
  end

  down do
    drop_column :invites, :hash
  end
end
