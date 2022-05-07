defmodule PL.Logs do
  alias PL.Repo
  alias PL.Logs.Entry
  alias PL.Accounts.User
  import Ecto.Query

  def list_entries(magic_token) do
    Repo.all(
      from e in Entry,
        join: u in subquery(find_user_id_query(magic_token)),
        on: e.user_id == u.id,
        order_by: [desc: e.inserted_at],
        select: e
    )
  end

  def list_entries_for_user(user_id) do
    Repo.all(
      from e in Entry,
        where: e.user_id == ^user_id,
        order_by: [desc: e.inserted_at],
        select: e
    )
  end

  def create_entry(body, magic_token) when is_binary(body) and is_binary(magic_token) do
    Repo.insert_all(
      Entry,
      [
        [
          body: body,
          user_id: find_user_id_query(magic_token),
          inserted_at: now(),
          updated_at: now()
        ]
      ]
    )
  end

  defp find_user_id_query(magic_token) do
    {id, api_key} = decode_magic_token(magic_token)

    from u in User,
      where: u.id == ^id and u.api_key == ^api_key,
      select: u.id
  end

  def now() do
    NaiveDateTime.utc_now()
    |> NaiveDateTime.truncate(:second)
  end

  defp decode_magic_token("cx_" <> id_api_key) do
    <<id::binary-size(16), api_key::binary-size(16)>> = Base.url_decode64!(id_api_key)
    {Ecto.UUID.load!(id), Ecto.UUID.load!(api_key)}
  end
end
