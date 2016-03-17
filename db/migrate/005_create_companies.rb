Sequel.migration do
  up do
    create_table :companies do
      primary_key :id
      Fixnum :user_id
      String :company, :size => 256
      String :title
      String :description
      String :industry
      String :logo_url
      String :promo_text
      String :commission_type, :default => 'dollar' # 'dollar', 'pct'
      Fixnum :commission_amount
      Fixnum :markett_amount

      String :status, :default => 'active'
      DateTime :created_at
      DateTime :updated_at      
    end
  end

  down do
    drop_table :companies
  end
end
