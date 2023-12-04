defmodule MarkerWeb.Router do
  use MarkerWeb, :router

  pipeline :browser do
    plug(:accepts, ["html"])
    plug(:fetch_session)
    plug(:fetch_live_flash)
    plug(:put_root_layout, {MarkerWeb.Layouts, :root})
    plug(:protect_from_forgery)
    plug(:put_secure_browser_headers)
  end

  scope "/", MarkerWeb do
    pipe_through(:browser)

    live("/", MapLive.Index, :index)
  end
end
