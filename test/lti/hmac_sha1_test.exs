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
      body_params = [
        oauth_consumer_key: "secret",
        oauth_nonce: "nonce",
        oauth_signature_method: "HMAC-SHA1",
        oauth_timestamp: "0",
        oauth_version: "1.0",
        custom_param1: "value1"
      ]

      assert HmacSHA1.build_signature(
        "https://someurl.com/",
        "POST",
        body_params,
        "secret"
      ) === "RPyMwPZb28+EZCEe0uLbO+q8blg="
    end

  end
end
