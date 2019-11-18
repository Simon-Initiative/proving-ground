defprotocol ContentHash do
  @doc "Calculates the hash of a portion of the content model"
  def hash(data)
end

defprotocol ContentSerialize do
  @doc "Serializes a portion of the content model"
  def iodata(data)
end
