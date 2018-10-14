defmodule LmgtfyBot do
  use Application

  import Supervisor.Spec

  require Logger

  def start(_type, _args) do
    token = ExGram.Config.get(:ex_gram, :token)

    children = [
      supervisor(ExGram, []),
      supervisor(LmgtfyBot.Bot, [:polling, token])
    ]

    opts = [strategy: :one_for_one, name: LmgtfyBot]

    case Supervisor.start_link(children, opts) do
      {:ok, _} = ok ->
        Logger.info("Starting LmgtfyBot")
        ok

      error ->
        Logger.error("Error starting LmgtfyBot")
        error
    end
  end
end
