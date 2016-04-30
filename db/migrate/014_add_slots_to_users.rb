Sequel.migration do
  up do
    add_column :users, :open_slots, Fixnum
  end

  down do
    drop_column :users, :open_slots, Fixnum
  end
end
