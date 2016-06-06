class Company < Sequel::Model
  plugin :timestamps
  one_to_many :codes

  def before_save

    if !self[:logo_url].blank? && self[:logo_url].class == Hash
      tempfile = self[:logo_url][:tempfile]
      path = "/uploads/logo_" + Time.now.to_i.to_s + "_" + self[:logo_url][:filename]
      local_dest = Dir.pwd + "/public/" + path
      FileUtils.mv(tempfile.path, local_dest)
      self[:logo_url] = path
    end

    # if !self[:playbook_url].blank? && self[:playbook_url].class == Hash
    #   tempfile = self[:playbook_url][:tempfile]
    #   path = "/uploads/playbook_" + Time.now.to_i.to_s + "_" + self[:playbook_url][:filename]
    #   local_dest = Dir.pwd + "/public/" + path
    #   FileUtils.mv(tempfile.path, local_dest)
    #   self[:playbook_url] = path
    # end

    if !self[:reference_guide_url].blank? && self[:reference_guide_url].class == Hash
      tempfile = self[:reference_guide_url][:tempfile]
      path = "/uploads/refguide_" + Time.now.to_i.to_s + "_" + self[:reference_guide_url][:filename]
      local_dest = Dir.pwd + "/public/" + path
      FileUtils.mv(tempfile.path, local_dest)
      self[:reference_guide_url] = path      
    end

    super
  end

end
