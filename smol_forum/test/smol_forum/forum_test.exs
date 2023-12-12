defmodule SmolForum.ForumTest do
  use SmolForum.DataCase

  alias SmolForum.Forum

  describe "forum_posts" do
    alias SmolForum.Forum.Post

    import SmolForum.ForumFixtures

    @invalid_attrs %{content: nil, created: nil, modified: nil, subject: nil}

    test "list_forum_posts/0 returns all forum_posts" do
      post = post_fixture()
      assert Forum.list_forum_posts() == [post]
    end

    test "get_post!/1 returns the post with given id" do
      post = post_fixture()
      assert Forum.get_post!(post.id) == post
    end

    test "create_post/1 with valid data creates a post" do
      valid_attrs = %{content: "some content", created: ~U[2023-12-11 08:06:00Z], modified: ~U[2023-12-11 08:06:00Z], subject: "some subject"}

      assert {:ok, %Post{} = post} = Forum.create_post(valid_attrs)
      assert post.content == "some content"
      assert post.created == ~U[2023-12-11 08:06:00Z]
      assert post.modified == ~U[2023-12-11 08:06:00Z]
      assert post.subject == "some subject"
    end

    test "create_post/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Forum.create_post(@invalid_attrs)
    end

    test "update_post/2 with valid data updates the post" do
      post = post_fixture()
      update_attrs = %{content: "some updated content", created: ~U[2023-12-12 08:06:00Z], modified: ~U[2023-12-12 08:06:00Z], subject: "some updated subject"}

      assert {:ok, %Post{} = post} = Forum.update_post(post, update_attrs)
      assert post.content == "some updated content"
      assert post.created == ~U[2023-12-12 08:06:00Z]
      assert post.modified == ~U[2023-12-12 08:06:00Z]
      assert post.subject == "some updated subject"
    end

    test "update_post/2 with invalid data returns error changeset" do
      post = post_fixture()
      assert {:error, %Ecto.Changeset{}} = Forum.update_post(post, @invalid_attrs)
      assert post == Forum.get_post!(post.id)
    end

    test "delete_post/1 deletes the post" do
      post = post_fixture()
      assert {:ok, %Post{}} = Forum.delete_post(post)
      assert_raise Ecto.NoResultsError, fn -> Forum.get_post!(post.id) end
    end

    test "change_post/1 returns a post changeset" do
      post = post_fixture()
      assert %Ecto.Changeset{} = Forum.change_post(post)
    end
  end

  describe "forum_threads" do
    alias SmolForum.Forum.Thread

    import SmolForum.ForumFixtures

    @invalid_attrs %{}

    test "list_forum_threads/0 returns all forum_threads" do
      thread = thread_fixture()
      assert Forum.list_forum_threads() == [thread]
    end

    test "get_thread!/1 returns the thread with given id" do
      thread = thread_fixture()
      assert Forum.get_thread!(thread.id) == thread
    end

    test "create_thread/1 with valid data creates a thread" do
      valid_attrs = %{}

      assert {:ok, %Thread{} = thread} = Forum.create_thread(valid_attrs)
    end

    test "create_thread/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Forum.create_thread(@invalid_attrs)
    end

    test "update_thread/2 with valid data updates the thread" do
      thread = thread_fixture()
      update_attrs = %{}

      assert {:ok, %Thread{} = thread} = Forum.update_thread(thread, update_attrs)
    end

    test "update_thread/2 with invalid data returns error changeset" do
      thread = thread_fixture()
      assert {:error, %Ecto.Changeset{}} = Forum.update_thread(thread, @invalid_attrs)
      assert thread == Forum.get_thread!(thread.id)
    end

    test "delete_thread/1 deletes the thread" do
      thread = thread_fixture()
      assert {:ok, %Thread{}} = Forum.delete_thread(thread)
      assert_raise Ecto.NoResultsError, fn -> Forum.get_thread!(thread.id) end
    end

    test "change_thread/1 returns a thread changeset" do
      thread = thread_fixture()
      assert %Ecto.Changeset{} = Forum.change_thread(thread)
    end
  end

  describe "forum_boards" do
    alias SmolForum.Forum.Board

    import SmolForum.ForumFixtures

    @invalid_attrs %{name: nil}

    test "list_forum_boards/0 returns all forum_boards" do
      board = board_fixture()
      assert Forum.list_forum_boards() == [board]
    end

    test "get_board!/1 returns the board with given id" do
      board = board_fixture()
      assert Forum.get_board!(board.id) == board
    end

    test "create_board/1 with valid data creates a board" do
      valid_attrs = %{name: "some name"}

      assert {:ok, %Board{} = board} = Forum.create_board(valid_attrs)
      assert board.name == "some name"
    end

    test "create_board/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Forum.create_board(@invalid_attrs)
    end

    test "update_board/2 with valid data updates the board" do
      board = board_fixture()
      update_attrs = %{name: "some updated name"}

      assert {:ok, %Board{} = board} = Forum.update_board(board, update_attrs)
      assert board.name == "some updated name"
    end

    test "update_board/2 with invalid data returns error changeset" do
      board = board_fixture()
      assert {:error, %Ecto.Changeset{}} = Forum.update_board(board, @invalid_attrs)
      assert board == Forum.get_board!(board.id)
    end

    test "delete_board/1 deletes the board" do
      board = board_fixture()
      assert {:ok, %Board{}} = Forum.delete_board(board)
      assert_raise Ecto.NoResultsError, fn -> Forum.get_board!(board.id) end
    end

    test "change_board/1 returns a board changeset" do
      board = board_fixture()
      assert %Ecto.Changeset{} = Forum.change_board(board)
    end
  end
end
