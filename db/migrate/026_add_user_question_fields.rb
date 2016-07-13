Sequel.migration do
  up do
    add_column :users, :q_full_time, String
    add_column :users, :q_started_how_soon, String
    add_column :users, :q_level_of_education, String
    add_column :users, :q_sales_marketing_experience, String
    add_column :users, :q_school, String
    add_column :users, :q_grad_year, String
    add_column :users, :q_pandas, String
  end

  down do
    drop_column :users, :q_full_time
    drop_column :users, :q_started_how_soon
    drop_column :users, :q_level_of_education
    drop_column :users, :q_sales_marketing_experience
    drop_column :users, :q_pandas
    drop_column :users, :q_school
    drop_column :users, :q_grad_year
  end
end
