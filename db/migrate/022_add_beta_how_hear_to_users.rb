Sequel.migration do
  up do
    add_column :users, :beta_how_hear, String
    add_column :users, :beta_how_hear_custom, String
  end

  down do
    drop_column :users, :beta_how_hear
    drop_column :users, :beta_how_hear_custom
  end
end
