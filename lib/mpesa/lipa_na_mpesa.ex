defmodule Mpesa.LipaNaMpesa do
  @moduledoc """
    Defines the function for transacting a lipa na mpesa using the stk
  """
  alias Mpesa.Oauth
  @doc """
    Initiates a lipa na mpesa stk request
  """
  def initiate_payment(sender_msisdn, amount, account_ref, transaction_desc \\ "Lipa na mpesa online") do
    # get the access token
    case Oauth.access_token() do
      {:ok, token} ->
        # get the short code
        short_code = Application.get_env(:lipa_na_mpesa, :short_code)
        # passkey
        passkey = Application.get_env(:lipa_na_mpesa, :passkey)
        # get the current timestamp
        {:ok, timestamp} = Timex.now() |> Timex.format("%Y%m%d%H%M%S", :strftime)
        # generate the password
        password = Base.encode64(short_code <> passkey <> timestamp)
        # headers
        headers = ["Authorization": "Bearer #{token}", "content-type": "application/json; charset=utf-8"]
        # body of the request
        body = %{
          "BusinessShortCode" => short_code,
          "Password" => password,
          "Timestamp" => timestamp,
          "TransactionType" => "CustomerPayBillOnline",
          "Amount" => amount,
          "PartyA" => sender_msisdn,
          "PartyB" =>  short_code,
          "PhoneNumber" => sender_msisdn,
          "CallbackUrl" => Application.get_env(:lipa_na_mpesa, :callback_url),
          "AccountReference" => account_ref,
          "TransacationDesc" => transaction_desc
        }
        # ensode the body
        |> Jason.encode!()

        # post the data to safaricom
        HTTPoison.post(Application.get_env(:mpesa, :baseUrl) <> "/mpesa/stkpush/v1/processrequest", body, headers)

      {:error, _message} = result -> result

    end # end of getting the acces token
  end # end of initiate payment

  @doc """
    API function for checking the status of a Lipa Na M-Pesa Online Payment
  """
  def status_query(checkout_request_id) do
    case Oauth.access_token() do
      # success
      {:ok, token} ->
        # get the short code
        short_code = Application.get_env(:lipa_na_mpesa, :short_code)
        # passkey
        passkey = Application.get_env(:lipa_na_mpesa, :passkey)
        # get the current timestamp
        {:ok, timestamp} = Timex.now() |> Timex.format("%Y%m%d%H%M%S", :strftime)
        # generate the password
        password = Base.encode64(short_code <> passkey <> timestamp)
        # headers
        headers = ["Authorization": "Bearer #{token}", "content-type": "application/json; charset=utf-8"]

        # body
        body = %{
          "BusinessShortCode" => short_code,
          "Password" => password,
          "Timestamp" => timestamp,
          "CheckoutRequestID" => checkout_request_id
        }
        # encode the data
        |> Jason.encode!()

        # post the request to mpesa
        HTTPoison.post(Application.get_env(:mpesa, :baseUrl) <> "/mpesa/stkpushquery/v1/query", body, headers)

      # error
      {:error, _message} = result -> result
    end # end of getting the access token
  end # end of status_query


end # end of LipaNaMpesa module
