defmodule RideFastApiWeb.DriverHTML do
  use RideFastApiWeb, :html

  embed_templates "driver_html/*"

  @doc """
  Renders a driver form.

  The form is defined in the template at
  driver_html/driver_form.html.heex
  """
  attr :changeset, Ecto.Changeset, required: true
  attr :action, :string, required: true
  attr :return_to, :string, default: nil

  def driver_form(assigns)
end
