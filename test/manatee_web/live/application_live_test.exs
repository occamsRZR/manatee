defmodule ManateeWeb.ApplicationLiveTest do
  use ManateeWeb.ConnCase

  import Phoenix.LiveViewTest

  alias Manatee.Applications

  @create_attrs %{applied_at: "2010-04-17T14:00:00Z", description: "some description"}
  @update_attrs %{applied_at: "2011-05-18T15:01:01Z", description: "some updated description"}
  @invalid_attrs %{applied_at: nil, description: nil}

  defp fixture(:application) do
    {:ok, application} = Applications.create_application(@create_attrs)
    application
  end

  defp create_application(_) do
    application = fixture(:application)
    %{application: application}
  end

  describe "Index" do
    setup [:create_application]

    test "lists all applications", %{conn: conn, application: application} do
      {:ok, _index_live, html} = live(conn, Routes.application_index_path(conn, :index))

      assert html =~ "Listing Applications"
      assert html =~ application.description
    end

    test "saves new application", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, Routes.application_index_path(conn, :index))

      assert index_live |> element("a", "New Application") |> render_click() =~
               "New Application"

      assert_patch(index_live, Routes.application_index_path(conn, :new))

      assert index_live
             |> form("#application-form", application: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#application-form", application: @create_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.application_index_path(conn, :index))

      assert html =~ "Application created successfully"
      assert html =~ "some description"
    end

    test "updates application in listing", %{conn: conn, application: application} do
      {:ok, index_live, _html} = live(conn, Routes.application_index_path(conn, :index))

      assert index_live |> element("#application-#{application.id} a", "Edit") |> render_click() =~
               "Edit Application"

      assert_patch(index_live, Routes.application_index_path(conn, :edit, application))

      assert index_live
             |> form("#application-form", application: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#application-form", application: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.application_index_path(conn, :index))

      assert html =~ "Application updated successfully"
      assert html =~ "some updated description"
    end

    test "deletes application in listing", %{conn: conn, application: application} do
      {:ok, index_live, _html} = live(conn, Routes.application_index_path(conn, :index))

      assert index_live |> element("#application-#{application.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#application-#{application.id}")
    end
  end

  describe "Show" do
    setup [:create_application]

    test "displays application", %{conn: conn, application: application} do
      {:ok, _show_live, html} = live(conn, Routes.application_show_path(conn, :show, application))

      assert html =~ "Show Application"
      assert html =~ application.description
    end

    test "updates application within modal", %{conn: conn, application: application} do
      {:ok, show_live, _html} = live(conn, Routes.application_show_path(conn, :show, application))

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Application"

      assert_patch(show_live, Routes.application_show_path(conn, :edit, application))

      assert show_live
             |> form("#application-form", application: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        show_live
        |> form("#application-form", application: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.application_show_path(conn, :show, application))

      assert html =~ "Application updated successfully"
      assert html =~ "some updated description"
    end
  end
end
