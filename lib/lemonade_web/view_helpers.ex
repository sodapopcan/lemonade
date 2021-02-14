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

  def avatar(organization_member, size \\ :normal, opts \\ []) do
    class = Keyword.get(opts, :class, "")
    online? = Keyword.get(opts, :online, false)
    online = if online?, do: "border-2 border-green-400", else: ""

    if organization_member && Map.has_key?(organization_member, :avatar_url) && organization_member.avatar_url do
      ~e"""
      <img src="<%= organization_member.avatar_url %>?v=<%= DateTime.utc_now |> DateTime.to_unix() %>" class="<%= avatar_size(size) %> <%= class %> <%= online %> bg-yellow-300 rounded-full centered shadow-md" />
      """
    else
      ~e"""
      <div class="<%= avatar_size(size) %> <%= online %> bg-yellow-300 rounded-full centered shadow-md">
        <%= initials(organization_member.name) %>
      </div>
      """
    end
  end

  defp avatar_size(:normal), do: "w-20 h-20 text-2xl"
  defp avatar_size(:small), do: "w-8 h-8 text-xs"
  defp avatar_size(:x_small), do: "w-4 h-4 text-xs"
end
