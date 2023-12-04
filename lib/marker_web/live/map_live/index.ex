defmodule MarkerWeb.MapLive.Index do
  @moduledoc false
  use MarkerWeb, :live_view

  alias Markers.MarkerModel

  @impl Phoenix.LiveView
  def mount(_params, _session, socket) do
    {:ok, stream(socket, :markers, Marker.Markers.list_markers()), layout: {MarkerWeb.Layouts, :map}}
  end

  @impl Phoenix.LiveView
  def handle_params(params, _url, socket) do
    previously_selected_marker = socket.assigns[:selected_marker]
    selected_marker = get_selected_marker(params)

    # convert from [{dom_id, marker}] to [marker]
    markers = Enum.map(socket.assigns.streams.markers.inserts, fn a -> elem(a, 2) end)
    view_coords = get_view_coords(params, selected_marker, markers)

    {:noreply,
     socket
     |> stream_insert_if_not_nil(markers, selected_marker)
     |> stream_insert_if_not_nil(markers, previously_selected_marker)
     |> assign(selected_marker: selected_marker)
     |> assign(view_coords: view_coords)}
  end

  # Insert changed markers if they are not already in the markers array (to prevent duplicates) and if they are not nil (to prevent error)
  defp stream_insert_if_not_nil(socket, markers, marker) when marker != nil do
    if Enum.member?(markers, marker) do
      socket
    else
      stream_insert(socket, :markers, marker)
    end
  end

  defp stream_insert_if_not_nil(socket, _markers, _marker) do
    socket
  end

  @impl Phoenix.LiveView
  def handle_event("select_marker", %{"id" => id, "lat" => lat, "lng" => lng} = _params, socket) do
    params = %{marker_id: id, lat: MarkerModel.format_coord(lat), lng: MarkerModel.format_coord(lng)}

    {:noreply, push_patch(socket, to: ~p"/?#{params}")}
  end

  @impl Phoenix.LiveView
  def handle_event("close_marker_card", _params, socket) do
    {:noreply, push_patch(socket, to: ~p"/")}
  end

  def marker_card(assigns) do
    ~H"""
    <div class="overflow-auto flex flex-col justify-stretch rounded-lg shadow-lg absolute right-10 bottom-10 bg-white z-1 p-4 w-1/3">
      <button class="self-end hover:opacity-50" phx-click="close_marker_card">
        <Heroicons.x_mark solid class="h-5 w-5 stroke-current" />
      </button>
      <div class="grow">
        <table class="table-auto">
          <tbody>
            <tr>
              <td class="text-gray-500 pr-5">ID:</td>
              <td class="font-medium"><%= @marker.id %></td>
            </tr>
            <tr>
              <td class="text-gray-500 pr-5">Latitude:</td>
              <td class="font-medium"><%= MarkerModel.format_coord(@marker.lat) %></td>
            </tr>
            <tr>
              <td class="text-gray-500 pr-5">Longitude:</td>
              <td class="font-medium"><%= MarkerModel.format_coord(@marker.lng) %></td>
            </tr>
          </tbody>
        </table>
      </div>
    </div>
    """
  end

  defp get_view_coords(%{"lat" => lat, "lng" => lng}, _selected_marker, _markers) do
    {MarkerModel.format_coord(lat), MarkerModel.format_coord(lng)}
  end

  defp get_view_coords(_params, selected_marker, markers) do
    case selected_marker do
      nil ->
        case List.first(markers) do
          %MarkerModel{} = marker -> {MarkerModel.format_coord(marker.lat), MarkerModel.format_coord(marker.lng)}
          _ -> {50.75, 4.35}
        end

      %MarkerModel{} = marker ->
        {MarkerModel.format_coord(marker.lat), MarkerModel.format_coord(marker.lng)}
    end
  end

  defp get_selected_marker(%{"marker_id" => marker_id_as_string}) do
    {marker_id, _remainder} = Integer.parse(marker_id_as_string)

    Marker.Markers.get_marker(marker_id)
  end

  defp get_selected_marker(_params) do
    nil
  end

  def marker_url(%{id: marker_id} = _marker, %{id: selected_marker_id} = _selected_marker)
      when marker_id == selected_marker_id do
    "/images/marker-icon-selected.png"
  end

  def marker_url(_, _) do
    "/images/marker-icon.png"
  end
end
