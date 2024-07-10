defmodule HelloPhx.Repo.Migrations.CreateProducts do
  use Ecto.Migration

  def change do
    create table(:products) do
      add :title, :string
      add :description, :string
      add :price, :decimal, precision: 10, scale: 2, null: false
      add :views, :integer, default: 0, null: false

      timestamps(type: :utc_datetime)
    end
  end
end
