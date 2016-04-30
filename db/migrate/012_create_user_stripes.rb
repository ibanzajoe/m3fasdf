Sequel.migration do
  up do
    create_table :user_stripes do
      primary_key :id
      
    end
  end

  down do
    drop_table :user_stripes
  end
end
