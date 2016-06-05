Sequel.migration do
  up do
  	add_column :companies, :playbook_url, String
  	add_column :companies, :reference_guide_url, String
  	add_column :companies, :promo_cards_url, String
  end

  down do
  	drop_column :companies, :playbook_url
  	drop_column :companies, :reference_guide_url
  	drop_column :companies, :promo_cards_url
  end
end
