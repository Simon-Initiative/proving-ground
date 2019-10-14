# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Delivery.Repo.insert!(%Delivery.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias Delivery.Accounts.User
alias Delivery.Packages.Package
alias Delivery.Activities.Activity

alias Delivery.Repo

defmodule Create do

  def default_content() do
    %{ "nodes" =>
    [%{ "object" => "block", "type" => "paragraph", "nodes" =>
      [%{ "object" => "text", "text" => "This is a new page"}]
      }
    ]}
  end

  def page(title, friendly, content) do
    %Activity{
      title: title, friendly: friendly, grading_strategy: "none",
      draft_title: title,
      content: load_content(content), draft_content: load_content(content),
      require_completion: false, tags: [], timed: false, type: "page", is_draft: false}
  end

  def load_content(filename) do
      {:ok, d} = with {:ok, body} <- File.read(filename),
                      {:ok, json} <- Poison.decode(body), do: {:ok, json}
      d
  end
end


arya = Repo.insert!(%User{first_name: "Arya", last_name: "Stark", email: "arya@stark.com" })
sansa = Repo.insert!(%User{first_name: "Sansa", last_name: "Stark", email: "sansa@stark.com" })
rob = Repo.insert!(%User{first_name: "Robb", last_name: "Stark", email: "robb@stark.com" })
ned = Repo.insert!(%User{first_name: "Ned", last_name: "Stark", email: "ned@stark.com" })
bran = Repo.insert!(%User{first_name: "Bran", last_name: "Stark", email: "bran@stark.com" })
catelyn = Repo.insert!(%User{first_name: "Catelyn", last_name: "Stark", email: "catelyn@stark.com" })

Repo.insert!(%Package{title: "Introduction to Programming", friendly: "introduction_to_programming", version: "1.0.0",
  activities: [
    Create.page("Welcome and introduction", "intro", "priv/repo/intro.json")
  ]
})

Repo.insert!(%Package{title: "The American Civil War", friendly: "american_civil_war", version: "1.0.0",
  activities: [
    Create.page("Overview", "intro", "priv/repo/overview.json"),
    Create.page("Causes of Secession", "secession", "priv/repo/secession.json"),
    Create.page("Outbreak of the War", "outbreak", "priv/repo/outbreak.json"),
  ]
})
