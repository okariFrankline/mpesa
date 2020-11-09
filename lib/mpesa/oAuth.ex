defmodule Mpesa.Oauth do
  @moduledoc """
    Authenticates the app and returns the
  """
  alias Mpesa.PublicKey

  @doc """
    Returns the access token from mpesa api
  """
  def access_token() do
    # get the base url
    baseUrl = Application.get_env(:mpesa, :baseUrl)
    # get the consumer key
    auth = "#{Application.get_env(:mpesa, :consumer_key)}:#{Application.get_env(:mpesa, :consumer_secret)}" |> Base.encode64()
    # headers
    headers = ["Authorization": "Basic #{auth}", "content-type": "application/json"]
    # start the httpoison
    HTTPoison.start()
    # get the access token
    case HTTPoison.get("#{baseUrl}/oauth/v1/generate?grant_type=client_credentials", headers) do
      {:ok, response} ->
        # get the response
        token = response.body |> Jason.decode!() |> Map.get("access_token")
        # return the token
        {:ok, token}

      {:error, _message} = result -> result
    end # end of gettign the response
  end # end of the auth

  @doc """
    Generates the security credentials for form the certificate
  """
  @spec security_credentials(String.t) :: String.t()
  def security_credentials(plain_text) do
    # get the certificate path
    Application.get_env(:mpesa, :cert_path)
    # extract the public key
    |> PublicKey.extract_public_from()
    # encrypt the data
    |> PublicKey.generate_base64_cypherstring(plain_text)
  end # end of mpesa.public key

end # end of the module
