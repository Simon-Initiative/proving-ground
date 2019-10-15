defmodule DeliveryWeb.CourseController do
  use DeliveryWeb, :controller

  alias Delivery.Sections
  alias Delivery.Activities
  alias Delivery.Packages

  def index(conn, %{ "section_id" => section_id }) do

    section = Sections.get_section!(section_id)
    pages = Sections.get_pages_for_course(section_id)

    render(conn, "index.html", section_id: section_id, pages: pages, title: section.title)
  end

  def next_page(pages, current_id) do

    case Enum.drop_while(pages, fn p -> p.page_id != String.to_integer(current_id) end) |> tl do
      [] -> nil
      [next|_] -> next
    end

  end

  def page(conn, %{ "section_id" => section_id, "page_id" => page_id }) do

    page = Activities.get_activity!(page_id)
    next = Sections.get_pages_for_course(section_id)
      |> next_page(page_id)

    translated_content = DeliveryWeb.Utils.HTML.to_html(Map.get(page.content, "nodes"))

    render(conn, "page.html", next: next, title: page.title, content: translated_content, section_id: section_id, activity_id: page_id)
  end

  def glossary(conn, %{ "section_id" => section_id }) do

    section = Sections.get_section!(section_id)
    terms = Packages.get_glossary_terms(section.package_id)

    render(conn, "glossary.html", terms: terms)
  end

end
