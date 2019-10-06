defmodule DeliveryWeb.PackageLive.Edit do
  use Phoenix.LiveView

  alias DeliveryWeb.PackageLive
  alias DeliveryWeb.PackageView
  alias DeliveryWeb.Router.Helpers, as: Routes

  alias Delivery.Packages
  alias Delivery.Packages.Package

  def mount(_params, socket) do
    {:ok, socket}
  end

  def handle_params(%{"id" => id }, _uri, socket) do

    package = Packages.get_package!(id)

    {:noreply,
     assign(socket, %{
       package: package,
       changeset: Packages.change_package(package)
     })}
  end

  def render(assigns), do: PackageView.render("edit.html", assigns)

  def handle_event("validate", %{"package" => params}, socket) do
    changeset =
      Package.changeset(socket.assigns.package, params)
      |> Map.put(:action, :insert)

    {:noreply, assign(socket, changeset: changeset)}
  end

  def handle_event("save", %{"package" => package_params}, socket) do
    case Packages.update_package(socket.assigns.package, package_params) do
      {:ok, _package} ->
        {:stop,
         socket
         |> put_flash(:info, "Package updated successfully.")
         |> redirect(to: Routes.live_path(socket, PackageLive.Index))}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
