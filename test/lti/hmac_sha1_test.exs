defmodule LTI.HmacSHA1Test do
  alias LTI.HmacSHA1

  use ExUnit.Case, async: true

  describe "build_signature" do

    test "signs a string using SHA1 without token" do
      assert HmacSHA1.sign_text("somesecret", "somestring") === "b4I/0mJP8Ge4vMU5kjfx6Lapat8="
    end

    test "signs a string using SHA1 with token" do
      assert HmacSHA1.sign_text("somesecret", "somestring", "sometoken") === "JIwdEm5bo8nY4jyPfZhtDibB6RY="
    end

    test "builds the correct signature" do
      body_params = [param1: "value1"]

      assert HmacSHA1.build_signature(
        "https://someurl.com",
        "?query=true",
        "POST",
        body_params,
        "secret"
      ) === ""
    end

  end
end
