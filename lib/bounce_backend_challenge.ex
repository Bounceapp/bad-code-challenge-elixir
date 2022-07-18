defmodule Mix.Tasks.BounceBackendChallenge do
  use Mix.Task

  alias OptionParser
  alias BounceBackendChallenge.Repo
  alias BounceBackendChallenge.Todo

  import Ecto.Query, only: [from: 2]

  def addTodoWithCompleted(todo, completed) do
    repo = Repo.start_link(database: "bounce.db")

    Ecto.Adapters.SQL.query!(
      Repo,
      "INSERT INTO todos (todo, completed) VALUES ('" <>
        todo <> "', " <> (completed |> Kernel.to_string()) <> ")"
    )

    IO.puts("Todo added")
  end

  def addTodo(todo) do
    repo = Repo.start_link(database: "bounce.db")

    if todo do
      Ecto.Adapters.SQL.query!(
        Repo,
        "INSERT INTO todos (todo, completed) VALUES ('" <> todo <> "', FALSE)"
      )

      IO.puts("Todo added")
    else
      IO.puts("Todo is empty")
    end
  end

  def deleteTodo(id) do
    try do
      repo = Repo.start_link(database: "bounce.db")
      Ecto.Adapters.SQL.query!(Repo, "DELETE FROM todos WHERE id=#{id}")
      IO.puts("Todo deleted")
    rescue
      err ->
        IO.inspect(err)
        IO.puts("Please check if the ID is an integer!")
    end
  end

  def listTodos() do
    repo = Repo.start_link(database: "bounce.db")
    query = from(todos in BounceBackendChallenge.Todo, select: todos)
    todos = Repo.all(query)

    Enum.each(todos, fn todo ->
      IO.puts("ID: #{todo.id}, TODO: #{todo.todo}, COMPLETED: #{todo.completed}")
    end)
  end

  def delete_all, do: raise("Please implement.")

  def run(args) do
    Mix.Task.run("app.start")

    {opts, _, _} =
      OptionParser.parse(args,
        strict: [operation: :string, todo: :string, id: :integer, completed: :boolean]
      )

    if opts[:operation] == "add" do
      if opts[:completed] do
        addTodoWithCompleted(opts[:todo], opts[:completed])
      else
        addTodo(opts[:todo])
      end
    else
      if opts[:operation] == "list" do
        listTodos()
      else
        if opts[:operation] == "delete" do
          deleteTodo(opts[:id])
        else
          if opts[:operation] == "delete_all" do
            delete_all()
          else
            raise "Unknown operation: #{opts[:operation]}"
          end
        end
      end
    end
  end
end
