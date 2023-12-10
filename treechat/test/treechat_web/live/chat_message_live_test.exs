defmodule TreechatWeb.ChatMessageLiveTest do
  use TreechatWeb.ConnCase

  import Phoenix.LiveViewTest
  import Treechat.MessageTreeFixtures

  @create_attrs %{content: "some content", created: "2023-12-09T00:58:00Z"}
  @update_attrs %{content: "some updated content", created: "2023-12-10T00:58:00Z"}
  @invalid_attrs %{content: nil, created: nil}

  defp create_chat_message(_) do
    chat_message = chat_message_fixture()
    %{chat_message: chat_message}
  end

  describe "Index" do
    setup [:create_chat_message]

    test "lists all posts", %{conn: conn, chat_message: chat_message} do
      {:ok, _index_live, html} = live(conn, ~p"/posts")

      assert html =~ "Listing Posts"
      assert html =~ chat_message.content
    end

    test "saves new chat_message", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/posts")

      assert index_live |> element("a", "New Chat message") |> render_click() =~
               "New Chat message"

      assert_patch(index_live, ~p"/posts/new")

      assert index_live
             |> form("#chat_message-form", chat_message: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#chat_message-form", chat_message: @create_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/posts")

      html = render(index_live)
      assert html =~ "Chat message created successfully"
      assert html =~ "some content"
    end

    test "updates chat_message in listing", %{conn: conn, chat_message: chat_message} do
      {:ok, index_live, _html} = live(conn, ~p"/posts")

      assert index_live |> element("#posts-#{chat_message.id} a", "Edit") |> render_click() =~
               "Edit Chat message"

      assert_patch(index_live, ~p"/posts/#{chat_message}/edit")

      assert index_live
             |> form("#chat_message-form", chat_message: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#chat_message-form", chat_message: @update_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/posts")

      html = render(index_live)
      assert html =~ "Chat message updated successfully"
      assert html =~ "some updated content"
    end

    test "deletes chat_message in listing", %{conn: conn, chat_message: chat_message} do
      {:ok, index_live, _html} = live(conn, ~p"/posts")

      assert index_live |> element("#posts-#{chat_message.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#posts-#{chat_message.id}")
    end
  end

  describe "Show" do
    setup [:create_chat_message]

    test "displays chat_message", %{conn: conn, chat_message: chat_message} do
      {:ok, _show_live, html} = live(conn, ~p"/posts/#{chat_message}")

      assert html =~ "Show Chat message"
      assert html =~ chat_message.content
    end

    test "updates chat_message within modal", %{conn: conn, chat_message: chat_message} do
      {:ok, show_live, _html} = live(conn, ~p"/posts/#{chat_message}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Chat message"

      assert_patch(show_live, ~p"/posts/#{chat_message}/show/edit")

      assert show_live
             |> form("#chat_message-form", chat_message: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert show_live
             |> form("#chat_message-form", chat_message: @update_attrs)
             |> render_submit()

      assert_patch(show_live, ~p"/posts/#{chat_message}")

      html = render(show_live)
      assert html =~ "Chat message updated successfully"
      assert html =~ "some updated content"
    end
  end
end
