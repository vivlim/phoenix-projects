defmodule SmolForum.Forum do
  @moduledoc """
  The Forum context.
  """

  import Ecto.Query, warn: false
  alias SmolForum.Repo

  alias SmolForum.Forum.Post

  @doc """
  Returns the list of forum_posts.

  ## Examples

      iex> list_forum_posts()
      [%Post{}, ...]

  """
  def list_forum_posts do
    Repo.all(Post)
  end

  @doc """
  Gets a single post.

  Raises `Ecto.NoResultsError` if the Post does not exist.

  ## Examples

      iex> get_post!(123)
      %Post{}

      iex> get_post!(456)
      ** (Ecto.NoResultsError)

  """
  def get_post!(id), do: Repo.get!(Post, id)

  @doc """
  Creates a post.

  ## Examples

      iex> create_post(%{field: value})
      {:ok, %Post{}}

      iex> create_post(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_post(attrs \\ %{}) do
    board = SmolForum.Forum.Board
    |> SmolForum.Repo.get!(attrs["thread"]["board"]["id"])
    thread = %SmolForum.Forum.Thread{board_id: board.id, board: board}
    # todo get existing thread if there is one
    %Post{thread: thread}
    |> Post.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a post.

  ## Examples

      iex> update_post(post, %{field: new_value})
      {:ok, %Post{}}

      iex> update_post(post, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_post(%Post{} = post, attrs) do
    post
    |> Post.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a post.

  ## Examples

      iex> delete_post(post)
      {:ok, %Post{}}

      iex> delete_post(post)
      {:error, %Ecto.Changeset{}}

  """
  def delete_post(%Post{} = post) do
    Repo.delete(post)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking post changes.

  ## Examples

      iex> change_post(post)
      %Ecto.Changeset{data: %Post{}}

  """
  def change_post(%Post{} = post, attrs \\ %{}) do
    Post.changeset(post, attrs)
  end

  alias SmolForum.Forum.Thread

  @doc """
  Returns the list of forum_threads.

  ## Examples

      iex> list_forum_threads()
      [%Thread{}, ...]

  """
  def list_forum_threads do
    Repo.all(Thread)
  end

  @doc """
    Preload the threads belonging to a board.
  """
  def get_board_threads!(board_id) do
    posts_query = from p in Post, order_by: p.inserted_at
    query = from t in Thread, where: t.board_id == ^board_id, preload: [posts: ^posts_query]
    Repo.all(query)
    |> Enum.map(&Thread.with_first_post_info/1)
    # board
    # |> Repo.preload([threads: [posts: from(p in Post, order_by: p.inserted_at, limit: 2)]])
    #SmolForum.Forum.Thread
    # |> where([t], t.board_id == board_id)
  end

  def get_thread_posts!(thread_id) do
    # todo: preload authors
    query = from p in Post, where: p.thread_id == ^thread_id#, preload: [:author]
    Repo.all(query)
    # board
    # |> Repo.preload([threads: [posts: from(p in Post, order_by: p.inserted_at, limit: 2)]])
    #SmolForum.Forum.Thread
    # |> where([t], t.board_id == board_id)
  end

  @doc """
  Gets a single thread.

  Raises `Ecto.NoResultsError` if the Thread does not exist.

  ## Examples

      iex> get_thread!(123)
      %Thread{}

      iex> get_thread!(456)
      ** (Ecto.NoResultsError)

  """
  def get_thread!(id) do
    #posts_query = from p in Post, order_by: p.inserted_at
    posts_query = from p in Post, order_by: p.inserted_at, limit: 1
    query = from t in Thread, preload: [posts: ^posts_query]
    Repo.get!(query, id)
    
    # Repo.get!(Thread, id)
    # |> Repo.preload([:posts])

  end

  @doc """
  Creates a thread.

  ## Examples

      iex> create_thread(%{field: value})
      {:ok, %Thread{}}

      iex> create_thread(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_thread(attrs \\ %{}) do
    %Thread{}
    |> Thread.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a thread.

  ## Examples

      iex> update_thread(thread, %{field: new_value})
      {:ok, %Thread{}}

      iex> update_thread(thread, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_thread(%Thread{} = thread, attrs) do
    thread
    |> Thread.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a thread.

  ## Examples

      iex> delete_thread(thread)
      {:ok, %Thread{}}

      iex> delete_thread(thread)
      {:error, %Ecto.Changeset{}}

  """
  def delete_thread(%Thread{} = thread) do
    Repo.delete(thread)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking thread changes.

  ## Examples

      iex> change_thread(thread)
      %Ecto.Changeset{data: %Thread{}}

  """
  def change_thread(%Thread{} = thread, attrs \\ %{}) do
    Thread.changeset(thread, attrs)
  end

  alias SmolForum.Forum.Board

  @doc """
  Returns the list of forum_boards.

  ## Examples

      iex> list_forum_boards()
      [%Board{}, ...]

  """
  def list_forum_boards do
    Repo.all(Board)
  end

  @doc """
  Gets a single board.

  Raises `Ecto.NoResultsError` if the Board does not exist.

  ## Examples

      iex> get_board!(123)
      %Board{}

      iex> get_board!(456)
      ** (Ecto.NoResultsError)

  """
  def get_board!(id), do: Repo.get!(Board, id)

  @doc """
  Creates a board.

  ## Examples

      iex> create_board(%{field: value})
      {:ok, %Board{}}

      iex> create_board(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_board(attrs \\ %{}) do
    %Board{}
    |> Board.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a board.

  ## Examples

      iex> update_board(board, %{field: new_value})
      {:ok, %Board{}}

      iex> update_board(board, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_board(%Board{} = board, attrs) do
    board
    |> Board.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a board.

  ## Examples

      iex> delete_board(board)
      {:ok, %Board{}}

      iex> delete_board(board)
      {:error, %Ecto.Changeset{}}

  """
  def delete_board(%Board{} = board) do
    Repo.delete(board)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking board changes.

  ## Examples

      iex> change_board(board)
      %Ecto.Changeset{data: %Board{}}

  """
  def change_board(%Board{} = board, attrs \\ %{}) do
    Board.changeset(board, attrs)
  end
end
