class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  ROLES = %w[student instructor admin]

  def admin?
    role == 'admin'
  end
       
  def instructor?
     role == 'instructor'
  end
       
  def student?
    role == 'student'
  end
end
