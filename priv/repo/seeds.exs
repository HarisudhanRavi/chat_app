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
  "username" => "Chris",
  "password" => "pass"
}
|> Account.create_user()

%{
  "username" => "Tony",
  "password" => "pass"
}
|> Account.create_user()

%{
  "username" => "Bruce",
  "password" => "pass"
}
|> Account.create_user()

%{
  "username" => "Odinson",
  "password" => "pass"
}
|> Account.create_user()
