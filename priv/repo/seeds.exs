# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     App.Repo.insert!(%MyApp.SomeModel{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.


alias AppWeb.Recording
alias AppWeb.Theme
alias App.Repo

Repo.insert!(%Theme{
    name: "Nature"
})

Repo.insert!(%Theme{
    name: "Histoire"
})

Repo.insert!(%Theme{
    name: "Culture"
})

for _ <- 1..10 do
  Repo.insert!(%Recording{
    author: Faker.Name.name,
    description: Faker.Lorem.sentence,
    theme_id: Enum.random(1..3)
  })
end
