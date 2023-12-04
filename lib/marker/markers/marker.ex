defmodule Markers.MarkerModel do
  @moduledoc false

  defstruct [
    :id,
    :lat,
    :lng
  ]

  @doc """
  Round lat OR lng number or bitstring to 6 decimal points for display.
  """
  @spec format_coord(bitstring()) :: number()
  def format_coord(coord) when is_bitstring(coord) do
    {coord, _binary} = Float.parse(coord)
    Float.round(coord, 6)
  end

  @spec format_coord(float()) :: number()
  def format_coord(coord) when is_float(coord) do
    Float.round(coord, 6)
  end
end
