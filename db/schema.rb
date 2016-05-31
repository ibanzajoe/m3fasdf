Sequel.migration do
  change do
    create_table(:codes, :ignore_index_errors=>true) do
      primary_key :id
      Integer :company_id
      Integer :user_id
      Integer :num_used, :default=>0
      String :code, :text=>true
      String :status, :default=>"active", :text=>true
      DateTime :created_at
      DateTime :updated_at
      
      index [:company_id, :code], :unique=>true
    end
    
    create_table(:companies) do
      primary_key :id
      Integer :user_id
      String :company, :size=>256
      String :title, :text=>true
      String :description, :text=>true
      String :industry, :text=>true
      String :logo_url, :text=>true
      String :promo_text, :text=>true
      String :commission_type, :default=>"dollar", :text=>true
      Integer :commission_amount
      Integer :markett_amount
      String :status, :default=>"active", :text=>true
      DateTime :created_at
      DateTime :updated_at
    end
    
    create_table(:hits) do
      primary_key :id
      Integer :user_id
      String :ip, :text=>true
      DateTime :created_at
    end
    
    create_table(:invites, :ignore_index_errors=>true) do
      primary_key :id
      Integer :user_id
      String :email, :text=>true
      String :status, :text=>true
      DateTime :accepted_at
      DateTime :created_at
      DateTime :updated_at
      String :hash, :text=>true
      
      index [:user_id, :email], :name=>:invites_user_id_email_key, :unique=>true
    end
    
    create_table(:posts) do
      primary_key :id
      Integer :user_id
      String :title, :size=>256
      String :teaser, :text=>true
      String :content, :text=>true
      DateTime :created_at
      DateTime :updated_at
    end
    
    create_table(:schema_info) do
      Integer :version, :default=>0, :null=>false
    end
    
    create_table(:settings) do
      primary_key :id
      String :name, :text=>true
      String :value, :text=>true
      DateTime :created_at
      DateTime :updated_at
    end
    
    create_table(:transactions) do
      primary_key :id
      Integer :company_id
      Integer :code_id
      Integer :user_id
      Integer :withdrawal_id
      Integer :num_used, :default=>0
      String :commission_type, :default=>"dollar", :text=>true
      Integer :commission_amount, :default=>0
      BigDecimal :amount, :size=>[10, 2]
      DateTime :created_at
      DateTime :updated_at
      String :type, :text=>true
      String :label, :text=>true
      Integer :parent_user_id
    end
    
    create_table(:user_stripes) do
      primary_key :id
    end
    
    create_table(:users, :ignore_index_errors=>true) do
      primary_key :id
      String :first_name, :size=>64
      String :last_name, :size=>64
      String :address, :size=>128
      String :address2, :size=>32
      String :city, :size=>64
      String :state, :size=>32
      String :zip, :size=>16
      String :country, :size=>2
      String :username, :text=>true
      String :password_digest, :text=>true
      String :email, :text=>true
      String :role, :text=>true
      String :uid, :text=>true
      String :provider, :text=>true
      String :refid, :text=>true
      String :avatar_url, :text=>true
      Integer :referral_user_id
      String :is_student, :text=>true
      String :school_name, :text=>true
      String :school_enrollment, :text=>true
      String :school_major, :text=>true
      String :school_gpa, :text=>true
      String :school_fraternity, :text=>true
      String :school_sports, :text=>true
      String :work_company, :text=>true
      String :work_date, :text=>true
      String :work_industry, :text=>true
      String :gender, :text=>true
      String :ethnicity, :text=>true
      String :language, :text=>true
      String :military, :text=>true
      String :car, :text=>true
      String :fun_fact, :text=>true
      String :stripe_bank_account_token, :text=>true
      String :stripe_customer_id, :text=>true
      DateTime :created_at
      DateTime :updated_at
      String :beta_request, :text=>true
      Integer :open_slots
      String :phone, :text=>true
      String :access_token, :text=>true
      String :paypal_email, :text=>true
      
      index [:provider, :refid], :name=>:users_provider_refid_key, :unique=>true
    end
    
    create_table(:withdrawals) do
      primary_key :id
      Integer :user_id
      BigDecimal :amount, :size=>[12, 2]
      String :status, :default=>"requested", :text=>true
      DateTime :paid_at
      DateTime :created_at
      DateTime :updated_at
    end
  end
end
