defmodule GitCommit do
  @moduledoc """
  Get commit info from git command or .git/refs/heads/main file

  git log -1 --format="%H %ct"
  git log -1 origin/main --format="%H %cd" --date=local
  """

  def latest do
    [
      &from_env/0,
      &from_git_cmd/0,
      # &from_head_file/0,
      &from_not_support/0
    ]
    |> Enum.find_value(fn e -> e.() end)
    |> commit_info
  end

  # GIT_COMMIT_INFO="ca9178adfd867375b2eef73c288066c3fcc1bfb0 1719629897"
  def from_env do
    info = System.get_env("GIT_COMMIT_INFO")

    if info not in [nil, ""] do
      do_parse_cmd_or_env(info, :env)
    end
  end

  def from_git_cmd() do
    try do
      do_git_log_query()
      |> do_parse_cmd_or_env(:git_cmd)
    rescue
      _ -> false
    end
  end

  def do_parse_cmd_or_env(info, src) do
    # "ca9178adfd867375b2eef73c288066c3fcc1bfb0 1719629897\n"
    [id, tm_str] =
      info
      |> String.trim()
      |> String.split()

    {id,
     tm_str
     |> String.to_integer()
     |> DateTime.from_unix!(), src}
  end

  def do_git_log_query,
    do:
      System.cmd("git", ["log", "-1", "--format=%H %ct"], stderr_to_stdout: true)
      |> elem(0)

  @git_branch "main"
  @head_file ".git/refs/heads/#{@git_branch}"

  def from_head_file(head_file \\ @head_file) do
    if File.exists?(head_file) do
      {
        head_file |> File.read!() |> String.trim(),
        File.stat!(head_file).mtime
        |> NaiveDateTime.from_erl!()
        |> DateTime.from_naive!("Etc/UTC"),
        :head_file
      }
    end
  end

  def from_not_support do
    {
      String.duplicate("0", 40),
      DateTime.utc_now(),
      :not_support
    }
  end

  def commit_info({<<short_id::binary-size(7), _::binary>> = commit_id, tm, src}) do
    version = "#{Calendar.strftime(tm, "%Y%m%d%H%M%S")}-#{short_id}"

    %{
      id: commit_id,
      short_id: short_id,
      time: tm,
      version: version,
      source: src
    }
  end
end
