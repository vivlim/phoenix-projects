defmodule SmolForumWeb.ThreadLiveTest do
  use SmolForumWeb.ConnCase

  import Phoenix.LiveViewTest
  import SmolForum.ForumFixtures

  @create_attrs %{}
  @update_attrs %{}
  @invalid_attrs %{}

  defp create_thread(_) do
    thread = thread_fixture()
    %{thread: thread}
  end

  describe "Index" do
    setup [:create_thread]

    test "lists all forum_threads", %{conn: conn} do
      {:ok, _index_live, html} = live(conn, ~p"/forum_threads")

      assert html =~ "Listing Forum threads"
    end

    test "saves new thread", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/forum_threads")

      assert index_live |> element("a", "New Thread") |> render_click() =~
               "New Thread"

      assert_patch(index_live, ~p"/forum_threads/new")

      assert index_live
             |> form("#thread-form", thread: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#thread-form", thread: @create_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/forum_threads")

      html = render(index_live)
      assert html =~ "Thread created successfully"
    end

    test "updates thread in listing", %{conn: conn, thread: thread} do
      {:ok, index_live, _html} = live(conn, ~p"/forum_threads")

      assert index_live |> element("#forum_threads-#{thread.id} a", "Edit") |> render_click() =~
               "Edit Thread"

      assert_patch(index_live, ~p"/forum_threads/#{thread}/edit")

      assert index_live
             |> form("#thread-form", thread: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#thread-form", thread: @update_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/forum_threads")

      html = render(index_live)
      assert html =~ "Thread updated successfully"
    end

    test "deletes thread in listing", %{conn: conn, thread: thread} do
      {:ok, index_live, _html} = live(conn, ~p"/forum_threads")

      assert index_live |> element("#forum_threads-#{thread.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#forum_threads-#{thread.id}")
    end
  end

  describe "Show" do
    setup [:create_thread]

    test "displays thread", %{conn: conn, thread: thread} do
      {:ok, _show_live, html} = live(conn, ~p"/forum_threads/#{thread}")

      assert html =~ "Show Thread"
    end

    test "updates thread within modal", %{conn: conn, thread: thread} do
      {:ok, show_live, _html} = live(conn, ~p"/forum_threads/#{thread}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Thread"

      assert_patch(show_live, ~p"/forum_threads/#{thread}/show/edit")

      assert show_live
             |> form("#thread-form", thread: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert show_live
             |> form("#thread-form", thread: @update_attrs)
             |> render_submit()

      assert_patch(show_live, ~p"/forum_threads/#{thread}")

      html = render(show_live)
      assert html =~ "Thread updated successfully"
    end
  end
end
