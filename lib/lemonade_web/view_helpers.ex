defmodule LemonadeWeb.ViewHelpers do
  def icon(name, attrs \\ []) do
    Phoenix.HTML.raw """
      <svg class="feather-icon" class="#{attrs[:class]}" title="#{attrs[:title]}">
        <use xlink:href="/icons/feather-sprite.svg##{name}" />
      </svg>
    """
  end

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
