defmodule Marker.Markers do
  @moduledoc """
  The Markers context.
  """

  @doc """
  Returns the list of markers.
  """
  def list_markers do
    Enum.map(1..10000, fn x ->
      %Markers.MarkerModel{
        id: x,
        lat: 50.75578222222222 + (x / 10000),
        lng: 4.352832222222222
      }
    end)
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
