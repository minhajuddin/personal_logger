defmodule PL.Accounts do
  alias PL.Repo
  alias PL.Accounts.User

  def create_user(email) do
    User.changeset(%User{}, email: email)
    |> User.set_api_key()
    |> Repo.insert()
  end
end
