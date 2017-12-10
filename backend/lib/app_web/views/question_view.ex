defmodule AppWeb.QuestionView do
  use AppWeb, :view
  alias AppWeb.QuestionView

  def render("index.json", %{questions: questions}) do
    %{data: render_many(questions, QuestionView, "question.json")}
  end

  def render("show.json", %{question: question}) do
    %{data: render_one(question, QuestionView, "question.json")}
  end

  def render("question.json", %{question: question}) do
    %{id: question.id,
      text: question.text,
      answers: render_many(question.answers, __MODULE__, "answer.json", as: :answer)}
  end

  def render("answer.json", %{answer: answer}) do
    %{id: answer.id,
      text: answer.text,
      is_correct: answer.is_correct}
  end
end
