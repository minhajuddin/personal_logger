defmodule PLWeb.MagicToken do
  # TODO: Use this everywhere
  def decode("cx_" <> magic_token) do
    with {:base64, {:ok, <<id::binary-size(16), api_key::binary-size(16)>>}} <-
           {:base64, Base.url_decode64(magic_token)},
         {:uuid, {:ok, id}, {:ok, api_key}} <-
           {:uuid, Ecto.UUID.load(id), Ecto.UUID.load(api_key)} do
      {:ok, {id, api_key}}
    else
      {:base64, _} -> {:error, :invalid_magic_token_encoding}
      {:uuid, _, _} -> {:error, :invalid_magic_token_uuid_format}
    end
  end

  def decode(_) do
    {:error, :invalid_magic_token_format}
  end
end
