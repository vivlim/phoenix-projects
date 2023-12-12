defmodule SmolForum.ForumFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `SmolForum.Forum` context.
  """

  @doc """
  Generate a post.
  """
  def post_fixture(attrs \\ %{}) do
    {:ok, post} =
      attrs
      |> Enum.into(%{
        content: "some content",
        created: ~U[2023-12-11 08:06:00Z],
        modified: ~U[2023-12-11 08:06:00Z],
        subject: "some subject"
      })
      |> SmolForum.Forum.create_post()

    post
  end

  @doc """
  Generate a thread.
  """
  def thread_fixture(attrs \\ %{}) do
    {:ok, thread} =
      attrs
      |> Enum.into(%{

      })
      |> SmolForum.Forum.create_thread()

    thread
  end

  @doc """
  Generate a board.
  """
  def board_fixture(attrs \\ %{}) do
    {:ok, board} =
      attrs
      |> Enum.into(%{
        name: "some name"
      })
      |> SmolForum.Forum.create_board()

    board
  end
end
