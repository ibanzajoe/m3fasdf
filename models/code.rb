class Code < Sequel::Model
    plugin :timestamps
    many_to_one :company
    many_to_one :user

    def before_save
        super
    end

    def self.add(company_id, code, total_used = 0)

        added = 0

        # if new code, create it
        record = Code.where(:company_id => company_id, :code => code).first
        if record.nil?
          Code.create(:company_id => company_id, :code => code)
          added += 1

        # if code already exists
        else

          # if no new activations, consider it a dupe
          if total_used == record[:num_used]
            used = 0

          # add to transactions only if new used is higher than previous used
          elsif total_used > record[:num_used]
              used = total_used - record[:num_used]


            # if code attached to user, update number of times used
            if !record[:user_id].nil?
              record[:num_used] += used
              record.save_changes

              company = Company[record[:company_id]]
              amount = 0
              if company[:commission_type] == 'dollar'
                amount = company[:commission_amount] * used
              end

              Transaction.creditActivation(:user_id => record[:user_id], :company_id => company[:id], :code_id => record[:id], :num_used => used, :commission_type => company[:commission_type], :commission_amount => company[:commission_amount], :amount => amount)
            end

          end

        end

        return added

    end

end
