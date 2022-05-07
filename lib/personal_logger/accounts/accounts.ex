defmodule PL.Accounts do
  alias PL.Repo
  alias PL.Accounts.User

  def new_user_changeset do
    User.changeset(%User{}, %{})
  end

  def find_user_by_connect_key({id, api_key}) do
    Repo.get_by(User, id: id, api_key: api_key)
  end
    

  def create_user(email) do
    User.changeset(%User{}, %{email: email})
    |> User.set_api_key()
    |> Repo.insert()
  end

  def connect_key(user = %User{id: id, api_key: api_key})
      when not is_nil(id) and not is_nil(api_key) do
    "cx_" <> Base.url_encode64(Ecto.UUID.dump!(id) <> Ecto.UUID.dump!(api_key))
  end
end
