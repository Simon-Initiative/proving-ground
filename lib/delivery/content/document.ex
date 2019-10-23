defmodule Delivery.Content.Document do
  defstruct nodes: [], object: "document", data: %{}

  defimpl Inspect do
    def inspect(%Delivery.Content.Document{nodes: nodes}, _) do
      "<Document>: #{length(nodes)} top-level nodes"
    end
  end

  defimpl Enumerable do

    def count(%{nodes: _nodes}) do
      {:error, __MODULE__}
    end

    def member?(%{nodes: _nodes}, _item) do
      {:error, __MODULE__}
    end

    def slice(%{nodes: _nodes}) do
      {:error, __MODULE__}
    end

    def reduce(_, {:halt, acc}, _fun), do: {:halted, acc}

    def reduce(%{nodes: nodes}, {:suspend, acc}, fun) do
      {:suspended, acc, &reduce(%{nodes: nodes}, &1, fun)}
    end

    def reduce(%{nodes: []}, {:cont, acc}, _fun), do: {:done, acc}



    def reduce(%{nodes: [%{ nodes: [] } = head | tail]}, {:cont, acc}, fun) do
      reduce(%{nodes: tail}, fun.(head, acc), fun)
    end

    def reduce(%{nodes: [%{ nodes: [inner_head | inner_tail] } = head | tail]}, {:cont, acc}, fun) do
      case reduce(%{nodes: inner_tail}, fun.(inner_head, acc), fun) do
        {:halted, acc} -> {:halted, acc}
        {:suspended, acc} -> {:suspended, acc}
        {:done, acc} -> reduce(%{nodes: tail}, fun.(head, acc), fun)
      end
    end

    def reduce(%{nodes: [%{ text: _text } = head | tail]}, {:cont, acc}, fun) do
      case fun.(head, acc) do
        {:cont, acc} -> reduce(%{nodes: tail}, {:cont, acc}, fun)
        otherwise -> otherwise
      end
    end

    def reduce(%{nodes: [head | tail]}, {:cont, acc}, fun) do
      reduce(%{nodes: tail}, fun.(head, acc), fun)
    end

  end
end
