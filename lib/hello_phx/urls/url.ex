defmodule HelloPhx.Urls.Url do
  use Ecto.Schema
  use Endon
  import Ecto.Changeset

  schema "urls" do
    field :link, :string
    field :title, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(url, attrs) do
    url
    |> cast(attrs, [:link, :title])
    |> validate_required([:link, :title])
  end
end
