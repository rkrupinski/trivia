# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     App.Repo.insert!(%App.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.
alias App.Questions


defmodule Utils do
  def populate_question(body) do
    Enum.each body, fn item ->
      if String.length(item.question) <= 255 do
        {:ok, question} = Questions.create_question(%{text: item.question})
        Enum.each item.choices, fn answer_text ->
          {:ok, answer} = Questions.create_answer(%{question_id: question.id, text: answer_text, is_correct: answer_text == item.answer})
        end
      end
    end
  end
end


case File.read("priv/repo/general.json") do
  {:ok, body}      -> Utils.populate_question(Poison.Parser.parse!(body, keys: :atoms!))
  {:error, reason} -> IO.puts("There was an error: #{reason}")
end
