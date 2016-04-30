Sequel.migration do
  up do
    self[:users].where(:role => 'affiliate').update(:role => 'marketer')
    self[:users].where(:role => 'pending_affiliate').update(:role => 'pending_marketer')
  end

  down do
  end
end
