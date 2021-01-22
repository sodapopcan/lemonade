defmodule Mix.Tasks.Planex do
  use Mix.Task

  def run(_) do
    IO.puts("Seed some data for Planet Express.")
  end

  @shortdoc "Seeds development data with the Planet Express organization"
  defmodule Seed do
    def run(_) do
      Mix.Task.run("app.start")
    end
  end
end
