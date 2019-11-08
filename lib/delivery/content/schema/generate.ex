defmodule Delivery.Content.Schema.Generator do
  defmacro __using__(_options) do
    quote do
      import unquote(__MODULE__)
      import EEx
      Module.register_attribute(__MODULE__, :blocks, accumulate: true)
      Module.register_attribute(__MODULE__, :inlines, accumulate: true)
      @before_compile unquote(__MODULE__)
    end
  end

  defmacro __before_compile__(_env) do
    echo = Path.join([__DIR__, "echo.eex"])
    schema = Path.join([__DIR__, "schema.ts.eex"])

    quote do
      def as_typescript do
        out = fn content, name ->
          File.write("./assets/src/data/v1/#{String.downcase(name)}.ts", content)
        end

        Enum.map(@blocks, fn b ->
          EEx.eval_file(unquote(echo), name: b.name, fields: b.fields, top_level: @top_level)
          |> out.(b.name)
        end)

        IO.puts("Generating typescript wrappers")
      end

      def as_schema do
        out = fn content ->
          File.write("./assets/src/data/v1/schema.ts", content)
        end

        IO.inspect(@top_level)

        EEx.eval_file(unquote(schema), blocks: @blocks, top_level: @top_level)
        |> out.()

        IO.puts("Generating typescript wrappers")
      end
    end
  end

  defmacro field(name, _attrs) do
    quote do
      %{name: unquote(name)}
    end
  end

  defmacro children(items) do
    quote do
      %{children: unquote(items)}
    end
  end

  defmacro block(name, do: block_content) do
    upcase = fn s ->
      String.upcase(String.slice(s, 0, 1)) <> String.slice(s, 1, String.length(s))
    end

    module_name = upcase.(name)

    {_, _, content} = block_content

    fields =
      Enum.filter(content, fn {type, _, _} -> type == :field end)
      |> Enum.map(fn {_, _, [name, _, d]} ->
        {name,
         if d == :required do
           nil
         else
           d
         end}
      end)

    translate = fn t ->
      case t do
        :string -> "string"
        :integer -> "number"
      end
    end

    field_data =
      Enum.filter(content, fn {type, _, _} -> type == :field end)
      |> Enum.map(fn {_, _, [name, type, d]} ->
        %{
          name: name,
          type: translate.(type),
          required:
            if d == :required do
              true
            else
              false
            end,
          default:
            if d == :required do
              "null"
            else
              d
            end
        }
      end)

    children =
      Enum.filter(content, fn {type, _, _} -> type == :children end)
      |> Enum.map(fn {_, _, [[c]]} ->
        c
      end)

    quote do
      @blocks %{
        name: unquote(module_name),
        children: unquote(Macro.escape(children)),
        fields: unquote(Macro.escape(field_data))
      }
      defmodule String.to_atom(Atom.to_string(__MODULE__) <> "." <> unquote(module_name)) do
        defstruct unquote(fields)
      end
    end
  end
end
