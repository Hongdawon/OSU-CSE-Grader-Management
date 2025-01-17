class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  ROLES = %w[student instructor admin]

  validates :email, format: { with: /\A[a-zA-Z]+\.\d+@osu\.edu\z/i, message: "must be a valid email address in the format name.number@osu.edu" }


  before_create :set_default_approval

  def set_default_approval
    if role.in?(["Instructor", "Admin"]) && self.email != "admin@osu.edu"
      self.approved = false
    else
      self.approved = true
    end
  end

  def admin?
    role == 'Admin'
  end
       
  def instructor?
     role == 'Instructor'
  end
       
  def student?
    role == 'Student'
  end

  def approved?
    self.approved
  end

  def approve
    self.approved = true;
    save
  end
end
