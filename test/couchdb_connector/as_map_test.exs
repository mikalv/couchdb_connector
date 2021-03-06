defmodule Couchdb.Connector.AsMapTest do
  use ExUnit.Case

  import Couchdb.Connector.AsMap

  test "as_map/1 with invalid json string should raise RuntimeError" do
    invalid = "{\"_id\":\"foo\",\"_rev\":\"1-0f97561a543ed2e9c98a24dea818ec10\",test_key\":\"test_value\"}\n"

    assert_raise(RuntimeError, fn -> as_map(invalid) end)
  end

  test "as_map/1 with empty string should raise RuntimeError" do
    empty = ""

    assert_raise(RuntimeError, fn -> as_map(empty) end)
  end

  test "as_map/1 with valid json string should return decoded Map" do
    valid = "{\"_id\":\"foo\",\"_rev\":\"1-0f97561a543ed2e9c98a24dea818ec10\",\"test_key\":\"test_value\"}\n"
    decoded = as_map(valid)

    assert decoded["_id"] == "foo"
    assert decoded["_rev"] == "1-0f97561a543ed2e9c98a24dea818ec10"
    assert decoded["test_key"] == "test_value"
  end

  test "as_map/1 with a List of String Tuples should return decoded Map" do
    list_of_tuples = [
      {"Server", "CouchDB/1.6.1 (Erlang OTP/19)"},
      {"Location", "http://127.0.0.1:5984/couchdb_connector_test/42"}
    ]
    decoded = as_map(list_of_tuples)

    assert decoded["Server"] == "CouchDB/1.6.1 (Erlang OTP/19)"
  end
end
