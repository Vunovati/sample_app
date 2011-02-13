# == Schema Information
# Schema version: 20110131163109
#
# Table name: users
#
#  id         :integer         not null, primary key
#  name       :string(255)
#  email      :string(255)
#  created_at :datetime
#  updated_at :datetime
#

require 'digest'
class User < ActiveRecord::Base
 attr_accessor :password 
 attr_accessible :name, :email, :password, :password_confirmation

 email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
 
 validates :name, :presence => true,
                  :length => { :maximum => 50 }
 validates :email, :presence => true,
                  :format    => { :with => email_regex },
                  :uniqueness => { :case_sensitive => false }

 # Automatically create the virtual attribute 'password_confirmation'.
 validates :password, :presence => true,
                      :confirmation => true,
                      :length => { :within => 6..40 }
 
 before_save :encrypt_password # Send callback called encrypt_password by passing the simbol of that name to the before_save method. With before_save in place Active Record will automatically call the corresponding method before saving the record.

 
 # Return true if the user's password matches the submitted password
 def has_password?(submitted_password)
   # compare encrypted_password with the encrypted version of
   # the submitted password.
	encrypted_password == encrypt(submitted_password)
 end

 def self.authenticate(email, submitted_password)
   user = find_by_email(email)
   return nil if user.nil?
   return user if user.has_password?(submitted_password)
 end
  
 # nadji usera po id-u, a onda provjeri da je salt spremljena u cookieju ispravna za tog usera
 def self.authenticate_with_salt(id, cookie_salt)
    user = find_by_id(id)
    (user && user.salt == cookie_salt) ? user : nil # ternarni operator za if then else, idiomatski ispravno
 end

 
 private
  
  def encrypt_password
    self.salt = make_salt if new_record? # returns true if theobject has not yet been saved to the database
    self.encrypted_password = encrypt(password)
  end

  def encrypt(string)
    secure_hash("#{salt}--#{string}")
  end

  def make_salt
    secure_hash("#{Time.now.utc}--#{password}")
  end

  def secure_hash(string)
    Digest::SHA2.hexdigest(string)
  end

end
