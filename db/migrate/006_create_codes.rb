Sequel.migration do
  up do
    create_table :codes do
      primary_key :id
      Fixnum :company_id
      Fixnum :user_id
      Fixnum :num_used, :default => 0
      String :code
      String :status, :default => 'active'
      DateTime :created_at
      DateTime :updated_at
      index [:company_id, :code], :unique => true 
      
    end
  end

  down do
    drop_table :codes
  end
end
