class NilClass
  def to_s
    ""
  end

  def [](val)
    nil
  end
end