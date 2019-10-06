defmodule DeliveryWeb.InputHelpers do
  use Phoenix.HTML

  def input(form, field) do
    type = Phoenix.HTML.Form.input_type(form, field)

    wrapper_opts = [class: "field #{state_class(form, field)}"]
    label_opts = []
    input_opts = []

    content_tag :div, wrapper_opts do
      label = label(form, field, humanize(field), label_opts)
      input = apply(Phoenix.HTML.Form, type, [form, field, input_opts])
      error = DeliveryWeb.ErrorHelpers.error_tag(form, field)
      [label, input, error]
    end
  end

  def nav_link(conn, text, path) do
    link text, to: path, class: "item #{is_active(conn, path)}"
  end

  defp is_active(conn, path) do
    case conn.request_path do
      ^path -> "active"
      _ -> ""
    end
  end

  defp state_class(form, field) do
    cond do
      # The form was not yet submitted
      !form.source.action -> ""
      form.errors[field] -> "error"
      true -> ""
    end
  end
end
