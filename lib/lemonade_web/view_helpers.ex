defmodule LemonadeWeb.ViewHelpers do
  import Phoenix.HTML
  import Phoenix.HTML.Form

  def icon(name, attrs \\ []) do
    Phoenix.HTML.raw """
      <svg class="feather-icon #{attrs[:class]}" title="#{attrs[:title]}">
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

  def labeled_radio_button(f, name, value) do
    ~e"""
    <label>
      <%= radio_button f, :type, "all day" %>
      <%= value %>
    </label>
    """
  end
end
