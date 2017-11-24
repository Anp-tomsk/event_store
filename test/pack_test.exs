defmodule PacketTest do
  use ExUnit.Case

  alias EventStore.Couchdb.Packet

  test "pack map with _id key should match couchbeam format" do
    map = %{_id: "uid", text: "This is simple text data"}
    assert {
      [
        {"_id", "uid"},
        {"text", "This is simple text data"}
      ]} = Packet.pack(map)
  end
end
