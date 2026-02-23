defmodule CounterWeb.CounterLive do
  use CounterWeb, :live_view
  alias Counter.History

  def mount(_params, session, socket) do
    current_user = session["current_user"]

    {:ok,
     assign(socket,
       current_user: current_user,
       name: "",
       val: 0,
       logs: History.list_logs(),
       editing_id: nil,
       edit_name: "",
       edit_count: "0"
     )}
  end

  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} bare={true}>
      <section class="counter-page">
        <div class="counter-glow"></div>
        <div class="mx-auto w-full max-w-6xl px-4 py-8 sm:px-6 sm:py-10">
          <div class="mb-4 flex justify-end">
            <%= if @current_user do %>
              <div class="flex items-center gap-3">
                <img
                  src={@current_user.avatar}
                  alt="Avatar"
                  class="h-8 w-8 rounded-full border border-gray-600"
                />
                <span class="text-sm text-gray-300">Halo, {@current_user.name}</span>
                <.link
                  href={~p"/auth/logout"}
                  method="delete"
                  class="text-xs text-red-400 hover:text-red-300"
                >
                  Logout
                </.link>
              </div>
            <% else %>
              <.link
                href={~p"/auth/google"}
                class="rounded bg-white/10 px-4 py-2 text-sm font-semibold text-white hover:bg-white/20 transition-colors"
              >
                Login dengan Google
              </.link>
            <% end %>
          </div>

          <div class="mb-6 flex flex-wrap items-end justify-between gap-4">
            <div>
              <p class="counter-tag">Counter Playground</p>
              <h1 class="counter-title">First Project Phoenix</h1>
              <p class="counter-subtitle">
                Simpan skor, kelola riwayat, dan pantau update secara realtime.
              </p>
            </div>
            <div class="counter-badge">Records: {length(@logs)}</div>
          </div>

          <div class="mb-5 grid gap-3 sm:grid-cols-3">
            <article class="counter-mini-card">
              <p class="counter-mini-label">Nilai Aktif</p>
              <p class="counter-mini-value">{@val}</p>
            </article>
            <article class="counter-mini-card">
              <p class="counter-mini-label">Nama Aktif</p>
              <p class="counter-mini-value-small">{if @name == "", do: "-", else: @name}</p>
            </article>
            <article class="counter-mini-card">
              <p class="counter-mini-label">Mode</p>
              <p class="counter-mini-value-small">{if @editing_id, do: "Editing", else: "Create"}</p>
            </article>
          </div>

          <div class="grid gap-5 md:grid-cols-[1.15fr_0.85fr]">
            <div class="counter-panel">
              <%= if @editing_id do %>
                <.form for={%{}} id="edit-log-form" phx-change="edit_change" phx-submit="update_log">
                  <label class="counter-label" for="edit-name">Edit Nama</label>
                  <input
                    id="edit-name"
                    name="name"
                    type="text"
                    value={@edit_name}
                    class="counter-input"
                  />

                  <label class="counter-label" for="edit-count">Edit Nilai</label>
                  <input
                    id="edit-count"
                    name="count"
                    type="number"
                    min="0"
                    value={@edit_count}
                    class="counter-input"
                  />

                  <div class="counter-board">
                    <p class="counter-board-title">Preview Nilai</p>
                    <div class="counter-number">{@edit_count}</div>
                  </div>

                  <div class="grid grid-cols-2 gap-3">
                    <button type="submit" class="counter-btn counter-btn-success">Update</button>
                    <button
                      type="button"
                      phx-click="cancel_edit"
                      class="counter-btn counter-btn-primary"
                    >
                      Batal
                    </button>
                  </div>
                </.form>
              <% else %>
                <label class="counter-label" for="counter-name">Nama</label>
                <input
                  id="counter-name"
                  type="text"
                  placeholder="Masukkan nama..."
                  value={@name}
                  phx-keyup="set_name"
                  class="counter-input"
                />

                <div class="counter-board">
                  <p class="counter-board-title">Nilai Saat Ini</p>
                  <div class="counter-number">{@val}</div>
                </div>

                <div class="grid grid-cols-4 gap-3">
                  <button phx-click="inc" class="counter-btn counter-btn-primary">Tambah</button>
                  <button phx-click="save" class="counter-btn counter-btn-success">Simpan</button>
                  <button phx-click="reset" class="counter-btn counter-btn-warning">Reset</button>
                  <button phx-click="dec" class="counter-btn counter-btn-warning">Kurangi</button>
                </div>
              <% end %>
            </div>

            <div class="counter-panel">
              <div class="mb-3 flex items-center justify-between">
                <h2 class="counter-label m-0">Riwayat</h2>
                <span class="counter-tag">Live</span>
              </div>

              <div class="counter-log-list">
                <%= if Enum.empty?(@logs) do %>
                  <div class="counter-empty">
                    Belum ada data. Simpan nilai pertama untuk memulai riwayat.
                  </div>
                <% end %>

                <%= for log <- @logs do %>
                  <div class="counter-item group">
                    <div class="flex flex-col">
                      <span class="counter-item-name">{log.name}</span>
                      <span class="counter-item-time">{format_timestamp(log.inserted_at)}</span>
                    </div>

                    <div class="flex items-center gap-2">
                      <span class="counter-item-value">{log.count}</span>
                      <div class="counter-item-actions">
                        <button
                          phx-click="start_edit"
                          phx-value-id={log.id}
                          class="counter-edit-btn"
                          aria-label="Edit riwayat"
                        >
                          Edit
                        </button>
                        <button
                          phx-click="delete"
                          phx-value-id={log.id}
                          data-confirm="Hapus riwayat ini?"
                          class="counter-delete-btn"
                          aria-label="Hapus riwayat"
                        >
                          Hapus
                        </button>
                      </div>
                    </div>
                  </div>
                <% end %>
              </div>
            </div>
          </div>
        </div>
      </section>
    </Layouts.app>
    """
  end

  def handle_event("set_name", %{"value" => name}, socket) do
    {:noreply, assign(socket, name: name)}
  end

  def handle_event("inc", _params, socket) do
    {:noreply, update(socket, :val, &(&1 + 1))}
  end

  def handle_event("dec", _params, socket) do
    {:noreply, update(socket, :val, &max(&1 - 1, 0))}
  end

  def handle_event("save", _params, socket) do
    name = String.trim(socket.assigns.name)

    if name != "" do
      case History.create_log(%{name: name, count: socket.assigns.val}) do
        {:ok, _log} ->
          {:noreply,
           socket
           |> assign(logs: History.list_logs(), val: 0, name: "")
           |> put_flash(:info, "Berhasil dicatat!")}

        {:error, _changeset} ->
          {:noreply, put_flash(socket, :error, "Gagal simpan!")}
      end
    else
      {:noreply, put_flash(socket, :error, "Isi nama dulu!")}
    end
  end

  def handle_event("reset", _params, socket) do
    {:noreply,
     socket
     |> assign(val: 0, name: "")
     |> put_flash(:info, "Form Direset")}
  end

  def handle_event("start_edit", %{"id" => id}, socket) do
    with {id_int, ""} <- Integer.parse(id),
         log <- History.get_log!(id_int) do
      {:noreply,
       assign(socket,
         editing_id: log.id,
         edit_name: log.name,
         edit_count: Integer.to_string(log.count)
       )}
    else
      _ ->
        {:noreply, put_flash(socket, :error, "Data tidak valid untuk diedit.")}
    end
  end

  def handle_event("edit_change", %{"name" => name, "count" => count}, socket) do
    {:noreply, assign(socket, edit_name: name, edit_count: count)}
  end

  def handle_event("cancel_edit", _params, socket) do
    {:noreply, assign(socket, editing_id: nil, edit_name: "", edit_count: "0")}
  end

  def handle_event("update_log", %{"name" => name, "count" => count_param}, socket) do
    edit_name = String.trim(name)

    with true <- socket.assigns.editing_id != nil,
         true <- edit_name != "",
         {count, ""} <- Integer.parse(count_param),
         true <- count >= 0 do
      log = History.get_log!(socket.assigns.editing_id)

      case History.update_log(log, %{name: edit_name, count: count}) do
        {:ok, _log} ->
          {:noreply,
           socket
           |> assign(logs: History.list_logs(), editing_id: nil, edit_name: "", edit_count: "0")
           |> put_flash(:info, "Riwayat berhasil diupdate.")}

        {:error, _changeset} ->
          {:noreply, put_flash(socket, :error, "Gagal update riwayat.")}
      end
    else
      false ->
        {:noreply, put_flash(socket, :error, "Nama tidak bisa kosong!")}

      _ ->
        {:noreply, put_flash(socket, :error, "Data tidak valid untuk update")}
    end
  end

  def handle_event("delete", %{"id" => id}, socket) do
    with {id_int, ""} <- Integer.parse(id),
         log <- History.get_log!(id_int),
         {:ok, _} <- History.delete_log(log) do
      reset_edit =
        if socket.assigns.editing_id == id_int do
          [editing_id: nil, edit_name: "", edit_count: "0"]
        else
          []
        end

      {:noreply,
       socket
       |> assign([logs: History.list_logs()] ++ reset_edit)
       |> put_flash(:info, "Dihapus.")}
    else
      _ ->
        {:noreply, put_flash(socket, :error, "Gagal menghapus data.")}
    end
  end

  defp format_timestamp(nil), do: "-"

  defp format_timestamp(%DateTime{} = dt) do
    dt
    |> DateTime.add(7 * 3600, :second)
    |> Calendar.strftime("%Y-%m-%d %H:%M:%S")
  end
end
