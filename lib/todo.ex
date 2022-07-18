defmodule BounceBackendChallenge.Todo do
  use Ecto.Schema

  schema "todos" do
    field :todo, :string
    field :completed, :boolean
  end
end
