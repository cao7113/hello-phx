defmodule HelloPhx.Repo.Migrations.CreateOrders do
  use Ecto.Migration

  def change do
    create table(:orders) do
      add :user_uuid, :uuid
      add :total_price, :decimal, precision: 10, scale: 2, null: false

      timestamps(type: :utc_datetime)
    end
  end
end
