Sequel.migration do
  up do
    rename_table :withdrawls, :withdrawals
    alter_table(:transactions) do
      rename_column :withdrawl_id, :withdrawal_id
    end
  end

  down do
    rename_table :withdrawals, :withdrawls
    alter_table(:transactions) do
      rename_column :withdrawal_id, :withdrawl_id
    end
  end
end
