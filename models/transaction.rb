class Transaction < Sequel::Model
    plugin :timestamps
    many_to_one :code
    many_to_one :company
    many_to_one :user

    def after_destroy
        used = self[:num_used]
        self.code[:num_used] = self.code[:num_used] - used
        self.code.save
    end

    def self.credit(user_id, amount, type, label)
        data = {
          :user_id => user_id,
          :amount => amount,
          :type => type,
          :label => label
        }
        id = self.create(data)
        return id
    end

    def self.creditReferralBonus(user_id)
        return self.create(:user_id => user_id, :amount => 5, :type => "referral", :label => "New user referral bonus")
    end

end
