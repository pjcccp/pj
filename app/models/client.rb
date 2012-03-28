class Client < ActiveRecord::Base
  has_many :invoices, :dependent => :destroy
  has_many :items
  has_many :shipments

  validates :name, :presence => true
  validates :email, :format => { :with => /^(.+@.+\..+)?$/, :message => "is not a valid email address." }
end
