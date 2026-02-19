defmodule Counter.HistoryTest do
  use Counter.DataCase

  alias Counter.History

  describe "logs" do
    alias Counter.History.Log

    import Counter.HistoryFixtures

    @invalid_attrs %{count: nil, name: nil}

    test "list_logs/0 returns all logs" do
      log = log_fixture()
      assert History.list_logs() == [log]
    end

    test "get_log!/1 returns the log with given id" do
      log = log_fixture()
      assert History.get_log!(log.id) == log
    end

    test "create_log/1 with valid data creates a log" do
      valid_attrs = %{count: 42, name: "some name"}

      assert {:ok, %Log{} = log} = History.create_log(valid_attrs)
      assert log.count == 42
      assert log.name == "some name"
    end

    test "create_log/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = History.create_log(@invalid_attrs)
    end

    test "update_log/2 with valid data updates the log" do
      log = log_fixture()
      update_attrs = %{count: 43, name: "some updated name"}

      assert {:ok, %Log{} = log} = History.update_log(log, update_attrs)
      assert log.count == 43
      assert log.name == "some updated name"
    end

    test "update_log/2 with invalid data returns error changeset" do
      log = log_fixture()
      assert {:error, %Ecto.Changeset{}} = History.update_log(log, @invalid_attrs)
      assert log == History.get_log!(log.id)
    end

    test "delete_log/1 deletes the log" do
      log = log_fixture()
      assert {:ok, %Log{}} = History.delete_log(log)
      assert_raise Ecto.NoResultsError, fn -> History.get_log!(log.id) end
    end

    test "change_log/1 returns a log changeset" do
      log = log_fixture()
      assert %Ecto.Changeset{} = History.change_log(log)
    end
  end
end
