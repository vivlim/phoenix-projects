defmodule Treechat.MessageTreeTest do
  use Treechat.DataCase

  alias Treechat.MessageTree

  describe "posts" do
    alias Treechat.MessageTree.ChatMessage

    import Treechat.MessageTreeFixtures

    @invalid_attrs %{content: nil, created: nil}

    test "list_posts/0 returns all posts" do
      chat_message = chat_message_fixture()
      assert MessageTree.list_posts() == [chat_message]
    end

    test "get_chat_message!/1 returns the chat_message with given id" do
      chat_message = chat_message_fixture()
      assert MessageTree.get_chat_message!(chat_message.id) == chat_message
    end

    test "create_chat_message/1 with valid data creates a chat_message" do
      valid_attrs = %{content: "some content", created: ~U[2023-12-09 00:58:00Z]}

      assert {:ok, %ChatMessage{} = chat_message} = MessageTree.create_chat_message(valid_attrs)
      assert chat_message.content == "some content"
      assert chat_message.created == ~U[2023-12-09 00:58:00Z]
    end

    test "create_chat_message/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = MessageTree.create_chat_message(@invalid_attrs)
    end

    test "update_chat_message/2 with valid data updates the chat_message" do
      chat_message = chat_message_fixture()
      update_attrs = %{content: "some updated content", created: ~U[2023-12-10 00:58:00Z]}

      assert {:ok, %ChatMessage{} = chat_message} = MessageTree.update_chat_message(chat_message, update_attrs)
      assert chat_message.content == "some updated content"
      assert chat_message.created == ~U[2023-12-10 00:58:00Z]
    end

    test "update_chat_message/2 with invalid data returns error changeset" do
      chat_message = chat_message_fixture()
      assert {:error, %Ecto.Changeset{}} = MessageTree.update_chat_message(chat_message, @invalid_attrs)
      assert chat_message == MessageTree.get_chat_message!(chat_message.id)
    end

    test "delete_chat_message/1 deletes the chat_message" do
      chat_message = chat_message_fixture()
      assert {:ok, %ChatMessage{}} = MessageTree.delete_chat_message(chat_message)
      assert_raise Ecto.NoResultsError, fn -> MessageTree.get_chat_message!(chat_message.id) end
    end

    test "change_chat_message/1 returns a chat_message changeset" do
      chat_message = chat_message_fixture()
      assert %Ecto.Changeset{} = MessageTree.change_chat_message(chat_message)
    end
  end
end
