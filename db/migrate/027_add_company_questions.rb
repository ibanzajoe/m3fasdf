Sequel.migration do
  up do
    add_column :users, :company_name, String
    add_column :users, :q_company_ambassador, String
    add_column :users, :q_company_promocards, String
  end

  down do
    drop_column :users, :company_name
    drop_column :users, :q_company_ambassador
    drop_column :users, :q_company_promocards
  end
end
