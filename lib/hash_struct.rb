class HashStruct < BasicObject
  def initialize(hash)
    @hash = hash
  end

  def method_missing(key, *)
    try(key) { super }
  end

  def try(key)
    val = @hash.fetch(key.to_s) { yield if block_given? }
    ::Hash === val ? ::HashStruct.new(val) : val
  end

  def to_s
    @hash.to_s
  end

  def inspect
    @hash.inspect
  end
end
