defmodule LmgtfyBot.Bot do
  @bot :lmgtfy_bot

  use ExGram.Bot,
    name: @bot

  require Logger

  def bot(), do: @bot

  def start() do
    "Well hello! Want to ask something?\n<b>Let me google that for you!</b>"
  end

  defp query_like(text) do
    text |> String.split() |> Enum.join("+")
  end

  defp search(msg),
    do:
      {"http://lmgtfy.com/?iie=1&q=#{query_like(msg)}",
       "http://lmgtfy.com/?iie=0&q=#{query_like(msg)}"}

  def handle({:command, "start", _msg}, context) do
    msg = start()
    answer(context, msg)
  end

  def handle({:command, "search", %{text: text}}, context) do
    {msg, _} = search(text)
    answer(context, msg, parse_mode: "HTML")
  end

  # Inline queries
  def handle({:update, %{inline_query: %{query: ""}}}, _context) do
    Logger.info("Message without query")
  end

  def handle({:update, %{inline_query: %{id: qid, query: text}}}, _context) do
    {with_tutorial, without_tutorial} = search(text)

    results =
      LmgtfyBot.Utils.generate_inline_response(
        [
          [title: "Send with tutorial", result: with_tutorial],
          [title: "Send without tutorial", result: without_tutorial]
        ],
        "HTML"
      )

    ExGram.answer_inline_query(qid, results)
  end

  def handle({:text, t, %{from: %{id: uid, username: username}}}, _) do
    Logger.info("#{username}[#{uid}] -> #{t}")
  end
end
