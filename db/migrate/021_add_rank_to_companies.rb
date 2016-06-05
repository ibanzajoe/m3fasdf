Sequel.migration do
  up do
  	add_column :companies, :rank, Fixnum, :index => true, :default => 0
  end

  down do
  	drop_column :companies, :rank
  end
end
