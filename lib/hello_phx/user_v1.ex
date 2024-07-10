defmodule HelloPhx.UserV1 do
  use Ecto.Schema
  use Endon
  import Ecto.Changeset

  schema "v1_users" do
    field :name, :string
    field :email, :string
    field :bio, :string
    field :num_of_pets, :integer

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:name, :email, :bio, :num_of_pets])
    |> validate_required([:name, :email, :bio, :num_of_pets])
  end
end
