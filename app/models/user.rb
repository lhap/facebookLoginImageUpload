class User < ActiveRecord::Base
  attr_accessible :name, :oauth_expires_at, :oauth_token, :provider, :uid, :image

  has_attached_file :image, :styles => { :medium => "300x300>", 
                                         :thumb => "100x100>" }, 
                                         :default_url => "/images/:style/missing.png"

validates_attachment_size :image, :less_than => 3.megabytes
validates_attachment_content_type :image, :content_type => ['image/jpeg', 'image/png']

  def self.from_omniauth(auth)
    where(auth.slice(:provider, :uid)).first_or_initialize.tap do |user|
      user.provider = auth.provider
      user.uid = auth.uid
      user.name = auth.info.name
      user.oauth_token = auth.credentials.token
      user.oauth_expires_at = Time.at(auth.credentials.expires_at)
      user.save!
    end
  end  
end
