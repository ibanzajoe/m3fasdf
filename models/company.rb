class Company < Sequel::Model
  plugin :timestamps

  def before_save

    if !self[:logo_url].blank? && self[:logo_url].class == Hash
      tempfile = self[:logo_url][:tempfile]
      path = "/uploads/" + self[:logo_url][:filename]
      local_dest = Dir.pwd + "/public/" + path
      FileUtils.mv(tempfile.path, local_dest)
      self[:logo_url] = path
    end

    super
  end

end
