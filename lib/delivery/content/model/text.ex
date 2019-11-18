defmodule Delivery.Content.Text do
  defstruct text: "", marks: [], object: "text"
end


defimpl ContentSerialize, for: Text do
  def iodata(text) do
    [text.text] ++ text.marks
  end
end
