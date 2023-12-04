defmodule Marker.Markers do
  @moduledoc """
  The Markers context.
  """

  @doc """
  Returns the list of markers.
  """
  def list_markers do
    [
      %Markers.MarkerModel{
        id: 2,
        lat: 50.75578222222222,
        lng: 4.352832222222222,
      },
      %Markers.MarkerModel{
        id: 4,
        lat: 50.75573222222222,
        lng: 4.352971944444444,
      }
    ]
  end

  @doc """
  Gets a single marker.
  """
  def get_marker!(id) do
    Enum.find(list_markers(), fn v -> v.id == id end)
  end

  @doc """
  Gets a single marker.
  """
  def get_marker(id) do
    Enum.find(list_markers(), fn v -> v.id == id end)
  end
end
