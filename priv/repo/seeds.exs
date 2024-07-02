# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     ChatApp.Repo.insert!(%ChatApp.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.
alias ChatApp.Account

%{
  "username" => "chris",
  "password" => "pass"
}
|> Account.create_user()

%{
  "username" => "tony",
  "password" => "pass"
}
|> Account.create_user()

%{
  "username" => "bruce",
  "password" => "pass"
}
|> Account.create_user()

%{
  "username" => "odinson",
  "password" => "pass"
}
|> Account.create_user()
