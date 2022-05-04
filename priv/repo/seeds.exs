# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     PL.Repo.insert!(%PL.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias PL.Repo
alias PL.Accounts.User

Repo.insert!(%User{
  email: "danu@gmail.com",
  id: "7bfd37cb-2a8d-4e66-989d-b0fd10f75fcb",
  api_key: "beefbeef-beef-beef-beef-beefbeefbeef"
})
