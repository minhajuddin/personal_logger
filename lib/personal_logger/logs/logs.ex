defmodule PL.Logs do
  alias PL.Repo
  alias PL.Logs.Entry
  alias PL.Accounts.User
  import Ecto.Query

  def list_entries(connect_key) do
    Repo.all(
      from e in Entry,
        join: u in subquery(find_user_id_query(connect_key)),
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

  def create_entry(body, connect_key) when is_binary(body) and is_binary(connect_key) do
    Repo.insert_all(
      Entry,
      [
        [
          body: body,
          user_id: find_user_id_query(connect_key),
          inserted_at: now(),
          updated_at: now()
        ]
      ]
    )
  end

  defp find_user_id_query(connect_key) do
    {id, api_key} = decode_connect_key(connect_key)

    from u in User,
      where: u.id == ^id and u.api_key == ^api_key,
      select: u.id
  end

  def now() do
    NaiveDateTime.utc_now()
    |> NaiveDateTime.truncate(:second)
  end

  defp decode_connect_key("cx_" <> id_api_key) do
    <<id::binary-size(16), api_key::binary-size(16)>> = Base.url_decode64!(id_api_key)
    {Ecto.UUID.load!(id), Ecto.UUID.load!(api_key)}
  end
end
