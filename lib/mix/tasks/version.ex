defmodule Mix.Tasks.Version do
  use Mix.Task

  @shortdoc "Get project version"

  @moduledoc """
  Support version info from git commands or .git/refs/heads/main file

  git log -1 --format="%H %ct"
  git log -1 origin/main --format="%H %cd" --date=local
  """

  @impl Mix.Task

  def run(_args) do
    latest_commit()
    |> inspect(pretty: true, width: 80)
    |> Mix.shell().info
  end

  @branch "main"
  @head_file ".git/refs/heads/#{@branch}"

  def latest_commit do
    git_cmd_path()
    |> case do
      nil ->
        case File.exists?(@head_file) do
          true ->
            commit_from_file(@head_file)

          false ->
            commit_from_error()
        end

      p ->
        commit_from_cmd(p)
    end
    |> commit_info
  end

  def git_cmd_path, do: System.find_executable("git")

  def commit_from_cmd(cmd_path \\ git_cmd_path()) do
    [id, tm_str] =
      System.cmd(cmd_path, ["log", "-1", "--format=%H %ct"])
      |> elem(0)
      |> String.trim()
      |> String.split()

    {id,
     tm_str
     |> String.to_integer()
     |> DateTime.from_unix!(), {:cmd, cmd_path}}
  end

  def commit_from_file(head_file \\ @head_file) do
    {
      head_file |> File.read!() |> String.trim(),
      File.stat!(head_file).mtime
      |> NaiveDateTime.from_erl!()
      |> DateTime.from_naive!("Etc/UTC"),
      {:file, head_file}
    }
  end

  def commit_from_error do
    {String.duplicate("0", 40), Timex.now(), :error}
  end

  def commit_info({<<short_id::binary-size(7), _::binary>> = commit_id, tm, _}) do
    version = "#{Calendar.strftime(tm, "%Y%m%d%H%M%S")}-#{short_id}"

    %{
      id: commit_id,
      short_id: short_id,
      time: tm,
      version: version
    }
  end
end
