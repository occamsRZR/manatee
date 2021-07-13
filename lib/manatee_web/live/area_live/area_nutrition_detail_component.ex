defmodule ManateeWeb.AreaLive.AreaNutritionDetailComponent do
  use Phoenix.LiveComponent

  alias Manatee.Areas
  alias Contex.{BarChart, LinePlot, Dataset, Plot}

  def render_cumulative_totals_plot(assigns) do
    data =
      assigns.id
      |> Areas.get_area_nutrient_totals()
      |> Enum.map(fn app ->
        [
          app.applied_at,
          app.total_n,
          app.total_p,
          app.total_k
        ]
      end)
      |> Enum.scan(fn [applied_at, total_n1, total_p1, total_k1],
                      [_, total_n2, total_p2, total_k2] ->
        [
          applied_at,
          total_n1 + total_n2,
          total_p1 + total_p2,
          total_k1 + total_k2
        ]
      end)

    ds = Dataset.new(data, ["applied_at", "N Total", "P Total", "K Total"])

    plot =
      LinePlot.new(ds,
        mapping: %{x_col: "applied_at", y_cols: ["N Total", "P Total", "K Total"]},
        smoothed: false
      )

    Plot.new(500, 400, plot)
    |> Plot.titles("Total Accumulative NPK Applied by Date", "")
    |> Plot.axis_labels("Date Applied", "#/M")
    |> Plot.plot_options(%{legend_setting: :legend_right})
  end

  def render_app_totals_plot(assigns) do
    data =
      assigns.id
      |> Areas.get_area_nutrient_totals()
      |> Enum.map(fn app ->
        {app.applied_at |> DateTime.to_string(), app.total_n, app.total_p, app.total_k}
      end)

    ds = Dataset.new(data, ["applied_at", "N Total", "P Total", "K Total"])
    IO.inspect(ds)

    options = [
      mapping: %{category_col: "applied_at", value_cols: ["N Total", "P Total", "K Total"]},
      type: :grouped,
      data_labels: true,
      orientation: :vertical
      # phx_event_handler: "chart1_bar_clicked",
    ]

    plot =
      Plot.new(ds, BarChart, 500, 400, options)
      |> Plot.titles("Total NPK Applied by Date", "")
      |> Plot.axis_labels("Date Applied", "#/M")
      |> Plot.plot_options(%{legend_setting: :legend_right})
  end

  def render(assigns) do
    plot = render_app_totals_plot(assigns)
    cumulative_plot = render_cumulative_totals_plot(assigns)

    ~L"""
    <%=  Plot.to_svg(plot) %>
    <%=  Plot.to_svg(cumulative_plot) %>

    """
  end
end
