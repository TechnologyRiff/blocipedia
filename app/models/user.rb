class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
after_initialize :init

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable

def admin?
  role == 'admin'
end

def premium?
  role == 'premium'
end

def standard?
  role == 'standard'
end

def init
  self.role ||= 'standard' if self.has_attribute? :role
end

end
