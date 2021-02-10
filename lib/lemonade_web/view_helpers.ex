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
      <%= radio_button f, name, value %>
      <%= value %>
    </label>
    """
  end

  def avatar(organization_member, size \\ :normal, online \\ false) do
    dims =
      case size do
        :normal -> "w-20 h-20"
        :small -> "w-6 h-6"
      end

    text =
      case size do
        :normal -> "text-2xl"
        :small -> "text-xs"
      end

    online =
      if online do
        "border border-green-400"
      else
        ""
      end

    if organization_member.avatar_url do
      ~e"""
      <img src="<%= organization_member.avatar_url %>" class="<%= dims %> <%= online %> bg-yellow-300 rounded-full centered text-2xl shadow-md" />
      """
    else
      ~e"""
      <div class="<%= dims %> <%= text %> <%= online %> bg-yellow-300 rounded-full centered shadow-md">
        <%= initials(organization_member.name) %>
      </div>
      """
    end
  end
end
