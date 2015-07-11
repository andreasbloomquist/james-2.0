class Admin < ActiveRecord::Base
  has_secure_password

	def self.confirm(params)
    @admin = Admin.find_by({email: params[:email]})
    @admin.try(:authenticate, params[:password])
  end  
end
