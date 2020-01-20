defmodule LTI.HmacSHA1 do

  alias Phoenix.HTML

  @spec build_signature(
    String.t,
    String.t,
    String.t,
    # [key: String.t],  #FIXME: not sure why this keyword list spec doesnt work
    any,
    String.t,
    String.t | nil) :: String.t
  def build_signature(
    req_url,
    query_params,
    method,
    body_params,
    consumer_secret,
    token \\ ""
  ) do
    [
      String.upcase(method),
      special_encode(req_url),
      process_params(
        body_params,
        params_str_to_keyword_list(query_params)
      )
    ]
    |> Enum.join("&")
    |> sign_text(special_encode(consumer_secret), token)
  end

  @spec sign_text(String.t, String.t) :: String.t
  def sign_text(secret_key, text) do
    sign_text(secret_key, text, "")
  end

  @spec sign_text(String.t, String.t, String.t) :: String.t
  def sign_text(secret_key, text, token) do
    text = "#{text}&#{token}"

    :crypto.hmac(:sha, secret_key, text) |> Base.encode64
  end

  defp params_str_to_keyword_list(str) do
    String.split(str, "&")
    |> Enum.map(fn param_keyval -> Enum.split(param_keyval, "=") end)
    |> Enum.map(fn [key, val] -> {key, val} end)
  end

  defp process_params(body_params, query_params) do
    clean_params(body_params) ++ clean_params(query_params)
    |> Enum.sort
    |> Enum.join("&")
    |> special_encode
  end

  defp special_encode(str) do
    # |> URI.encode(" & ", &URI.char_unreserved?(&1))
    URI.encode(str)
    |> String.replace(~r/[!'()]/, &HTML.javascript_escape(&1))
    |> String.replace(~r/\*/, "%2A")
  end

  @spec clean_params([key: String.t]) :: [String.t]
  defp clean_params(params) do
    Enum.filter(params, fn {key, _val} -> key != "oauth_signature" end)
    |> Enum.map(&encode_param/1)
  end

  @spec encode_param({String.t, String.t}) :: String.t
  defp encode_param({key, val}) do
    "#{key}=#{special_encode(val)}"
  end

end
