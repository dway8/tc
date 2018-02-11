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
alias AppWeb.User
alias App.Repo

Repo.insert!(%Theme{
    name: "Nature"
})

Repo.insert!(%Theme{
    name: "History"
})

Repo.insert!(%Theme{
    name: "Culture"
})


for _ <- 1..10 do
  Repo.insert!(%Recording{
    author: Faker.Name.name,
    description: Faker.Lorem.sentence,
    theme_id: Enum.random(1..3),
    address: "10 rue Fernand Rey",
    search_address: "10 rue Fernand Rey, Lyon",
    city: "Lyon",
    coordinates: %Geo.Point{coordinates: {4.829236, 45.769113}, srid: 4326}
  })
end

admin_params = %{email: "diane", password: "admin"}

unless Repo.get_by(User, email: admin_params[:email]) do
  %User{}
  |> User.registration_changeset(admin_params)
  |> Repo.insert!
end

