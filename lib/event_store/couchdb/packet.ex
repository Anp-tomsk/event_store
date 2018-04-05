defmodule EventStore.Couchdb.Packet do

  @id "_id"

  def valid_structure?(structure) do
    structure
    |> unpack()
    |> fn {status, map} ->
       status == :ok and map |> Map.has_key?(@id)
     end.()
  end

  def to_couch(%{:__struct__ => _struct} = struct),
    do: struct
      |> Map.from_struct()
      |> pack()

  def to_couch(map) when is_map(map),
    do: map
      |> Map.put(@id, UUID.uuid1())
      |> pack()

  def pack(map) when is_map(map) do
    {
      map
      |> Enum.map(&(pack(&1)))
    }
  end

  def pack({key, value}) when is_map(value),
    do: {key, pack(value)}

  def pack({key, value}) when is_atom(key),
    do: { Atom.to_string(key), value }

  def pack(value), do: value

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
