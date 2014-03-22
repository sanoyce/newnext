class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
         
  has_many :tasks, inverse_of: :master 
  has_and_belongs_to_many :tasks 
         
  validates_presence_of :name
  validates_uniqueness_of :name, :email, :case_sensitive => false
end
