defmodule HelloPhx.Repo.Migrations.CreateV1Users do
  use Ecto.Migration

  def change do
    create table(:v1_users) do
      add :name, :string
      add :email, :string
      add :bio, :string
      add :num_of_pets, :integer

      timestamps(type: :utc_datetime)
    end
  end
end
