defmodule DeliveryWeb.CourseController do
  use DeliveryWeb, :controller

  alias Delivery.Sections
  alias Delivery.Activities

  def index(conn, %{ "section_id" => section_id }) do

    section = Sections.get_section!(section_id)
    pages = Sections.get_pages_for_course(section_id)

    render(conn, "index.html", section_id: section_id, pages: pages, title: section.title)
  end

  def page(conn, %{ "section_id" => section_id, "page_id" => page_id }) do

    page = Activities.get_activity!(page_id)
    pages = Sections.get_pages_for_course(section_id)
    IO.inspect(page.content)
    translated_content = DeliveryWeb.Utils.HTML.to_html(Map.get(page.content, "nodes"))

    render(conn, "page.html", pages: pages, title: page.title, content: translated_content, activity_id: page_id)
  end


end
