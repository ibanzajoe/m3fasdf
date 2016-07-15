Sequel.migration do
  up do
    add_column :companies, :company_name, String
    add_column :companies, :q_company_ambassador, String
    add_column :companies, :q_company_promocards, String
  end

  down do
    drop_column :companies, :company_name
    drop_column :companies, :q_company_ambassador
    drop_column :companies, :q_company_promocards
  end
end
