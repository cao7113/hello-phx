defmodule Hello.Repo.Migrations.CreateBooks do
  use Ecto.Migration

  def change do
    create table(:books) do
      add :name, :string
      add :url, :string
      add :intro, :text

      timestamps()
    end
  end
end
