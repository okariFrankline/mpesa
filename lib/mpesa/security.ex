defmodule Mpesa.Security do
  @moduledoc """
    Defines funciton for returing the mpesa certificate
  """

  def credentials(cert_path, short_code_credentials) do
    # change the data to a binary string
    to_encrypt = to_string(short_code_credentials)
    # read from the cert_path
    case File.read(cert_path) do
      # reading is successful
      {:ok, data} ->
        # change the data t string
        private_key = to_string(data)
        # encrypt the data



      # ther was an error
      {:error, reason} ->
        # return the formated error
        reason
        # format reason
        |> :file.format_error()
        # convert to sring
        |> to_string()
        # capitalize the reason
        |> String.capitalize()
    end # end of read file

  end # end of credentials
end # end of Mpesa.Security

# const fs = require('fs')
# const path = require('path')
# const crypto = require('crypto')

# module.exports = (certPath, shortCodeSecurityCredential) => {
#   const bufferToEncrypt = Buffer.from(shortCodeSecurityCredential)
#   const data = fs.readFileSync(path.resolve(certPath))
#   const privateKey = String(data)
#   const encrypted = crypto.publicEncrypt({
#     key: privateKey,
#     padding: crypto.constants.RSA_PKCS1_PADDING
#   }, bufferToEncrypt)
#   const securityCredential = encrypted.toString('base64')
#   return securityCredential
# }
