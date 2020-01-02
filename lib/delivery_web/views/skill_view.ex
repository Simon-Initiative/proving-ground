defmodule DeliveryWeb.SkillView do
  use DeliveryWeb, :view
  alias Delivery.Objectives.Skill

  def skill_changeset(skill) do
    Skill.changeset(skill)
  end
end
