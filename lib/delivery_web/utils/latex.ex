defmodule DeliveryWeb.Utils.Latex do

  def to_latex(%{"object" => "block", "type" => "paragraph", "nodes" => nodes}) do
    to_latex(nodes) <> "\n\n"
  end

  def to_latex(%{"object" => "block", "type" => "heading-one", "nodes" => nodes}) do
    "\\section{" <> to_latex(nodes) <> "}\n\n"
  end

  def to_latex(%{"object" => "block", "type" => "heading-two", "nodes" => nodes}) do
    "\\section{" <> to_latex(nodes) <> "}\n\n"
  end

  def to_latex(%{"object" => "block", "type" => "heading-three", "nodes" => nodes}) do
    "\\section{" <> to_latex(nodes) <> "}\n\n"
  end

  def to_latex(%{"object" => "block", "type" => "heading-four", "nodes" => nodes}) do
    "\\subsection{" <> to_latex(nodes) <> "}\n\n"
  end

  def to_latex(%{"object" => "block", "type" => "heading-five", "nodes" => nodes}) do
    "\\subsubsection{" <> to_latex(nodes) <> "}\n\n"
  end

  def to_latex(%{"object" => "block", "type" => "heading-six", "nodes" => nodes}) do
    "\\subsubsection{" <> to_latex(nodes) <> "}\n\n"
  end

  def to_latex(%{"object" => "text", "text" => text, "marks" => marks}) do
    IO.puts "text-marks"
    wrap_marks(text, marks)
  end

  def to_latex(%{"object" => "text", "text" => text}) do
    IO.puts "text"
    text
  end

  def to_latex(%{"object" => "block"}) do
    IO.puts "block empty"
    ""
  end

  def to_latex(nodes) when is_list(nodes) do
    Enum.map(nodes, fn n -> to_latex(n) end)
      |> Enum.join("")
  end

  def to_latex(_) do
    IO.puts "empty"
    ""
  end

  def to(title, nodes) do
    """
    \\documentclass{article}
    \\usepackage[utf8]{inputenc}
    \\usepackage{soul}
    \\title{#{title}}
    \\begin{document}
    """ <> to_latex(nodes) <>
    """
    \\end{document}
    """
  end

  def wrap_marks(text, marks) do
    IO.puts "wrap-marks"
    IO.inspect text
    IO.inspect marks
    map = %{
      "sub" => "\\textsubscript{",
      "sup" => "\\textsuperscript{",
      "bold" => "\\textbf{",
      "underline" => "\\underline{",
      "code" => "\\texttt{",
      "italic" => "\\textit{",
      "strikethrough" => "\\st{",
      "mark" => "\\hl{"
    }
    Enum.reverse(marks)
      |> Enum.reduce(text,
        fn %{"type" => m}, t ->
          Map.get(map, m) <> t <> "}"
        end)
  end

end
