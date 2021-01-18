defmodule LemonadeWeb.ViewHelpers do
  def initials(string) do
    initials = 
      string
      |> String.split()
      |> Enum.map(&String.first/1)
      |> Enum.join()

    {first, rest} = String.next_grapheme(initials)
    last = String.last(rest)

    "#{first}#{last}"
  end
end
