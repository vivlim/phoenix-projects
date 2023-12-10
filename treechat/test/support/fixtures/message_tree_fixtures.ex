defmodule Treechat.MessageTreeFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Treechat.MessageTree` context.
  """

  @doc """
  Generate a chat_message.
  """
  def chat_message_fixture(attrs \\ %{}) do
    {:ok, chat_message} =
      attrs
      |> Enum.into(%{
        content: "some content",
        created: ~U[2023-12-09 00:58:00Z]
      })
      |> Treechat.MessageTree.create_chat_message()

    chat_message
  end
end
