defmodule ComeoninTest do
  use ExUnit.Case

  alias Comeonin.Bcrypt

  test "Openwall Bcrypt tests" do
    test_vectors = [
      ["U*U", "$2a$05$CCCCCCCCCCCCCCCCCCCCC.", "$2a$05$CCCCCCCCCCCCCCCCCCCCC.E5YPO9kmyuRGyh0XouQYb4YMJKvyOeW"],
      ["U*U*", "$2a$05$CCCCCCCCCCCCCCCCCCCCC.", "$2a$05$CCCCCCCCCCCCCCCCCCCCC.VGOzA784oUp/Z0DY336zx7pLYAy0lwK"],
      ["U*U*U", "$2a$05$XXXXXXXXXXXXXXXXXXXXXO", "$2a$05$XXXXXXXXXXXXXXXXXXXXXOAcXxm9kjPGEMsLznoKqmqw7tc8WCx4a"],
      ["", "$2a$05$CCCCCCCCCCCCCCCCCCCCC.", "$2a$05$CCCCCCCCCCCCCCCCCCCCC.7uG0VCzI2bS7j6ymqJi9CdcdxiRTWNy"],
      ["0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789",
        "$2a$05$abcdefghijklmnopqrstuu", "$2a$05$abcdefghijklmnopqrstuu5s2v8.iXieOjg/.AySBTTZIIVFJeBui"]]
    for {password, salt, stored_hash} <- test_vectors do
      {:ok, hash} = Bcrypt.hashpw(password, salt)
      assert :erlang.list_to_binary(hash) == stored_hash
    end
  end

  test "Bcrypt dummy check" do
    assert Bcrypt.checkpw == false
  end

  test "Bcrypt log_rounds error" do
    assert_raise ArgumentError, fn -> Bcrypt.gensalt(3) end
    assert_raise ArgumentError, fn -> Bcrypt.gensalt(32) end
  end

  test "hashing and checking passwords" do
    hash = Comeonin.hash_password("password")
    assert Comeonin.check_password("password", hash) == true
    assert Comeonin.check_password("passwor", hash) == false
    assert Comeonin.check_password("passwords", hash) == false
    assert Comeonin.check_password("pasword", hash) == false
  end
end