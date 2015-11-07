class HashStruct < BasicObject
  def initialize(hash)
    @hash = hash
  end

  def method_missing(key, *)
    val = @hash.fetch(key.to_s) { super }
    ::Hash === val ? ::HashStruct.new(val) : val
  end

  def to_s
    @hash.to_s
  end

  def inspect
    @hash.inspect
  end
end
