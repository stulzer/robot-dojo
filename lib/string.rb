class String
  def is_valid_integer?
    true if Integer(self) rescue false
  end
end
