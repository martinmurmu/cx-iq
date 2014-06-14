class PaperDownload < ActiveRecord::Base
  validates_presence_of :email, :paper_link, :first_name, :last_name, :company
  validates_format_of :email, :with => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i
  
  def full_name
    "#{self.first_name} #{self.last_name}"
  end
end
