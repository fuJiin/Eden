class Page
  # Map object to MongoDB
  include MongoMapper::Document

  # Define Schema - 
  key :content, String
  key :name, String

  # Relationships
  many :pictures
  
  # Validations
  validates_uniqueness_of :name
  validates_presence_of :name
  
  # Callbacks
  before_save :remove_whitespaces_from_names
  
  protected
  def remove_whitespaces_from_names
    self.name = self.name.gsub(/ /,"_")
  end
end
