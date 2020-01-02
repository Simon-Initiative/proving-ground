defmodule DeliveryWeb.ObjectiveView do
  use DeliveryWeb, :view
  alias Delivery.Objectives.Objective

  def objective_changeset(objective) do
    Objective.changeset(objective)
  end
end
