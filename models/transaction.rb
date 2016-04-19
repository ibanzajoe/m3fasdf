class Transaction < Sequel::Model
    plugin :timestamps
    many_to_one :code
    many_to_one :company
    many_to_one :user

    def after_destroy
        if !self.code.nil?
            used = self[:num_used]
            self.code[:num_used] = self.code[:num_used] - used
            self.code.save
        end
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

    def self.creditActivation(data)
        data[:type] = 'activation'
        data[:label] = "Activation Commission"
        transaction = self.create(data)

        # credit referral        
        self.creditActivationParent(transaction)
    end

    def self.creditActivationParent(transaction)

        # user that made the activation
        user = User[transaction[:user_id]]

        # if user has parent
        if !user[:referral_user_id].nil?

            # credit the parent user            
            parent_user = User[user[:referral_user_id]]
            amount = 0.1 * transaction[:amount]
            type = "team"
            label = "Team commission from #{user[:email]}"

            data = {
              :user_id => parent_user[:id],
              :parent_user_id => user[:id],
              :amount => amount,
              :type => type,
              :label => label,
            }
            self.create(data)
            
        end
    end


end
