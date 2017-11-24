defmodule EventStore.Couchdb.Packet do

  @id "_id"

  def valid_structure?(structure) do
    structure
    |> unpack()
    |> fn {status, map} ->
       status == :ok and map |> Map.has_key?(@id)
     end.()
  end

  def pack(map) when is_map(map) do
    {
      map
      |> Enum.map(fn {key, value} ->
        {Atom.to_string(key), value}
      end)
    }
  end

  def unpack!(arr) when is_list(arr) do
    arr |> Enum.map(fn doc -> unpack!(doc) end)
  end

  def unpack!({arr}) when is_list(arr) do
    arr
    |> Enum.map(fn doc -> unpack!(doc) end)
    |> Map.new
  end

  def unpack!({key, value}) when is_bitstring(value), do: {key, value}
  def unpack!({key, value}), do: {key, unpack!(value)}

  def unpack({arr}) when is_list(arr) do
      {:ok, arr |> Map.new()}
  end
  def unpack(_structure), do: {:error, %{}}

end
