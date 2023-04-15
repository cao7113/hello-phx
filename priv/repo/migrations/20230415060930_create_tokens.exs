defmodule Hello.Repo.Migrations.CreateTokens do
  use Ecto.Migration

  def change do
    create table(:tokens) do
      add :name, :string
      add :url, :string
      add :intro, :text

      timestamps()
    end
  end
end
