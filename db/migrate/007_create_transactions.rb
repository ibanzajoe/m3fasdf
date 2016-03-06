Sequel.migration do
  up do
    create_table :transactions do
      primary_key :id
      Fixnum :company_id
      Fixnum :code_id
      Fixnum :user_id
      Fixnum :num_used, :default => 0
      String :commission_type, :default => 'dollar'
      Fixnum :commission_amount, :default => 0
      BigDecimal :amount, :size => [10, 2]
      DateTime :created_at
      DateTime :updated_at
    end
  end

  down do
    drop_table :transactions
  end
end
