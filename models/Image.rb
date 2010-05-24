class Picture
  include MongoMapper::Document
  plugin Joint
  
  attachment :image
  
  def show
    return GRID.get(self.image).read
  end
end
