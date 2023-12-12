defmodule SmolForumWeb.BoardLiveTest do
  use SmolForumWeb.ConnCase

  import Phoenix.LiveViewTest
  import SmolForum.ForumFixtures

  @create_attrs %{name: "some name"}
  @update_attrs %{name: "some updated name"}
  @invalid_attrs %{name: nil}

  defp create_board(_) do
    board = board_fixture()
    %{board: board}
  end

  describe "Index" do
    setup [:create_board]

    test "lists all forum_boards", %{conn: conn, board: board} do
      {:ok, _index_live, html} = live(conn, ~p"/forum_boards")

      assert html =~ "Listing Forum boards"
      assert html =~ board.name
    end

    test "saves new board", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/forum_boards")

      assert index_live |> element("a", "New Board") |> render_click() =~
               "New Board"

      assert_patch(index_live, ~p"/forum_boards/new")

      assert index_live
             |> form("#board-form", board: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#board-form", board: @create_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/forum_boards")

      html = render(index_live)
      assert html =~ "Board created successfully"
      assert html =~ "some name"
    end

    test "updates board in listing", %{conn: conn, board: board} do
      {:ok, index_live, _html} = live(conn, ~p"/forum_boards")

      assert index_live |> element("#forum_boards-#{board.id} a", "Edit") |> render_click() =~
               "Edit Board"

      assert_patch(index_live, ~p"/forum_boards/#{board}/edit")

      assert index_live
             |> form("#board-form", board: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#board-form", board: @update_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/forum_boards")

      html = render(index_live)
      assert html =~ "Board updated successfully"
      assert html =~ "some updated name"
    end

    test "deletes board in listing", %{conn: conn, board: board} do
      {:ok, index_live, _html} = live(conn, ~p"/forum_boards")

      assert index_live |> element("#forum_boards-#{board.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#forum_boards-#{board.id}")
    end
  end

  describe "Show" do
    setup [:create_board]

    test "displays board", %{conn: conn, board: board} do
      {:ok, _show_live, html} = live(conn, ~p"/forum_boards/#{board}")

      assert html =~ "Show Board"
      assert html =~ board.name
    end

    test "updates board within modal", %{conn: conn, board: board} do
      {:ok, show_live, _html} = live(conn, ~p"/forum_boards/#{board}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Board"

      assert_patch(show_live, ~p"/forum_boards/#{board}/show/edit")

      assert show_live
             |> form("#board-form", board: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert show_live
             |> form("#board-form", board: @update_attrs)
             |> render_submit()

      assert_patch(show_live, ~p"/forum_boards/#{board}")

      html = render(show_live)
      assert html =~ "Board updated successfully"
      assert html =~ "some updated name"
    end
  end
end
