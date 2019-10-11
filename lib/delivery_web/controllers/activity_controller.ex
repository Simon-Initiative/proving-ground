defmodule DeliveryWeb.ActivityController do
  use DeliveryWeb, :controller

  alias Delivery.Activities
  alias Delivery.Activities.Activity

  def index(conn, %{"package_id" => package_id}) do
    activities = Activities.list_activities_for(package_id)
    render(conn, "index.html", activities: activities, package_id: package_id)
  end

  def publish_all(conn, %{"package_id" => package_id}) do
    Activities.publish_all(package_id)

    conn
      |> redirect(to: Routes.activity_path(conn, :index, package_id))
  end

  def publish(conn, %{"package_id" => package_id, "activity_id" => activity_id}) do
    Activities.publish(activity_id)
    DeliveryWeb.Endpoint.broadcast!("notification:" <> activity_id, "publish", %{user: get_session(conn, :user)})

    conn
      |> redirect(to: Routes.activity_path(conn, :index, package_id))
  end


  def new(conn, %{"package_id" => package_id}) do

    changeset = Activities.change_activity(%Activity{ type: "page", package_id: package_id })
    render(conn, "new.html", changeset: changeset, package_id: package_id)
  end

  def create(conn, %{"activity" => activity_params }) do

    case Activities.create_activity(activity_params) do
      {:ok, activity} ->
        conn
        |> put_flash(:info, "Activity created successfully.")
        |> redirect(to: Routes.activity_path(conn, :show, activity_params["package_id"], activity))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset, package_id: activity_params["package_id"])
    end
  end

  def show(conn, %{"id" => id, "package_id" => package_id}) do
    activity = Activities.get_activity!(id)
    render(conn, "show.html", activity: activity, package_id: package_id)
  end

  def edit(conn, %{"id" => id, "package_id" => package_id}) do
    activity = Activities.get_activity!(id)
    changeset = Activities.change_activity(activity)
    render(conn, "edit.html", activity: activity, changeset: changeset, package_id: package_id)
  end

  def update(conn, %{"id" => id, "package_id" => package_id, "activity" => activity_params}) do
    activity = Activities.get_activity!(id)

    case Activities.update_activity(activity, activity_params) do
      {:ok, activity} ->
        conn
        |> put_flash(:info, "Activity updated successfully.")
        |> redirect(to: Routes.activity_path(conn, :show, package_id, activity))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", activity: activity, changeset: changeset, package_id: package_id)
    end
  end

  def delete(conn, %{"id" => id, "package_id" => package_id}) do
    activity = Activities.get_activity!(id)
    {:ok, _activity} = Activities.delete_activity(activity)

    conn
    |> put_flash(:info, "Activity deleted successfully.")
    |> redirect(to: Routes.activity_path(conn, :index, package_id))
  end
end
