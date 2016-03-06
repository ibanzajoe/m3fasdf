Sequel.migration do
  up do
    create_table :withdrawls do
      primary_key :id
      Fixnum :user_id
      BigDecimal :amount, :size => [12, 2]
      String :status, :default => 'requested'
      DateTime :paid_at
      DateTime :created_at
      DateTime :updated_at
    end
  end

  down do
    drop_table :withdrawls
  end
end
