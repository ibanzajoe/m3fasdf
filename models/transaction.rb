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
end
