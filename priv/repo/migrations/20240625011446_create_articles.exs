defmodule HelloPhx.Repo.Migrations.CreateArticles do
  use Ecto.Migration

  def change do
    create table(:articles) do
      add :title, :string
      add :body, :string

      timestamps(type: :utc_datetime)
    end
  end
end
