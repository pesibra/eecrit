defmodule Eecrit.OldAnimalViewTest do
  use Eecrit.ConnCase, async: true
  import Eecrit.Test.ViewHelpers
  import Phoenix.View
  alias Eecrit.OldAnimalView

  ## :index has two cases: show animals out of service, or just those in service.

  test "only-in-service has affects on the view", %{conn: conn}  do
    content = render_to_string(OldAnimalView, "index.html",
                               conn: conn, animals: [], params: %{})
    assert String.contains?(content, "All animals currently in service")
    assert String.contains?(content, "Include animals out of service")
    assert String.contains?(content, "Date animal will be removed from service")
  end
  
  test "... as does showing out of service animals", %{conn: conn}  do
    content = render_to_string(OldAnimalView, "index.html",
                               conn: conn, animals: [], params: %{"include_out_of_service" => "true"})
    assert String.contains?(content, "All animals, past and present")
    refute String.contains?(content, "Don't show animals that are out of service")
    assert String.contains?(content, "Date animal was or will be removed from service")
  end


  defp removal_message(date_string) do
    make_old_animal(name: "Betsy",
                    date_removed_from_service: date_string && Ecto.Date.cast!(date_string))
    |> OldAnimalView.out_of_service_description()
  end

  test "displaying when the animal was removed from service" do
    content = removal_message("2012-03-05")
    assert safe_substring(content, "Betsy was removed from service on")
    assert safe_substring(content, "March 5, 2012")
  end

  test "displaying when the animal will be removed from service" do
    content = removal_message("2092-03-05")
    assert safe_substring(content, "Betsy will be removed from service on")
    assert safe_substring(content, "March 5, 2092")
  end

  test "displaying when the animal has no removal date" do
    content = removal_message(nil)
    assert safe_substring(content, "Betsy is not scheduled to be removed from service")
  end
end
