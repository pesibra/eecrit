defmodule Eecrit.OldAnimalControllerTest do
  use Eecrit.ConnCase

  alias Eecrit.OldAnimal
  @valid_attrs %{date_removed_from_service: %{day: 17, month: 4, year: 2010}, kind: "some content", name: "some content", nickname: "some content", procedure_description_kind: "some content"}
  @invalid_attrs %{}

  ## Index
  
  @tag accessed_by: "admin"
  test "lists only currently-in-service entries by default", %{conn: conn} do
    retained = insert_old_animal(name: "retained", date_removed_from_service: nil)
    {:ok, removed_at} = Ecto.Date.cast("2012-03-05")
    deleted = insert_old_animal(name: "removed", date_removed_from_service: removed_at)
    conn = get conn, old_animal_path(conn, :index)
    assert html_response(conn, 200) =~ "All animals currently in service"
    assert Enum.find(conn.assigns.animals, &(&1.name == "retained"))
    refute Enum.find(conn.assigns.animals, &(&1.name == "removed"))
  end

  @tag accessed_by: "admin"
  test "animals with future removal dates are still shown", %{conn: conn} do
    retained = insert_old_animal(name: "retained", date_removed_from_service: nil)
    deleted = insert_old_animal(
      name: "removed",
      date_removed_from_service: Ecto.Date.cast!("2092-03-05"))
    conn = get conn, old_animal_path(conn, :index)
    assert html_response(conn, 200) =~ "All animals currently in service"
    assert Enum.find(conn.assigns.animals, &(&1.name == "retained"))
    assert Enum.find(conn.assigns.animals, &(&1.name == "removed"))
  end

  @tag accessed_by: "admin"
  test "Can be made to list out-of-service entries", %{conn: conn} do
    retained = insert_old_animal(name: "retained", date_removed_from_service: nil)
    
    deleted = insert_old_animal(
      name: "removed",
      date_removed_from_service: Ecto.Date.cast!("2012-03-05"))
    conn = get conn, old_animal_path(conn, :index, include_out_of_service: true)
    assert html_response(conn, 200) =~ "All animals"
    refute html_response(conn, 200) =~ "All animals currently in service"
    assert Enum.find(conn.assigns.animals, &(&1.name == "retained"))
    assert Enum.find(conn.assigns.animals, &(&1.name == "removed"))
  end
  
  @tag accessed_by: "admin"
  test "entries are listed in alphabetical order", %{conn: conn} do
    unordered = ~w{s d l b a m o}
    Enum.map(unordered, &(insert_old_animal(name: &1)))
    conn = get conn, old_animal_path(conn, :index)
    assert Enum.map(conn.assigns.animals, &(&1.name)) == Enum.sort(unordered)
  end



  
  @tag accessed_by: "admin", skip: true
  test "renders form for new resources", %{conn: conn} do
    conn = get conn, old_animal_path(conn, :new)
    assert html_response(conn, 200) =~ "New old animal"
  end

  @tag accessed_by: "admin", skip: true
  test "creates resource and redirects when data is valid", %{conn: conn} do
    conn = post conn, old_animal_path(conn, :create), old_animal: @valid_attrs
    assert redirected_to(conn) == old_animal_path(conn, :index)
    assert OldRepo.get_by(OldAnimal, @valid_attrs)
  end

  @tag accessed_by: "admin", skip: true
  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, old_animal_path(conn, :create), old_animal: @invalid_attrs
    assert html_response(conn, 200) =~ "New old animal"
  end

  @tag accessed_by: "admin", skip: true
  test "shows chosen resource", %{conn: conn} do
    old_animal = OldRepo.insert! %OldAnimal{}
    conn = get conn, old_animal_path(conn, :show, old_animal)
    assert html_response(conn, 200) =~ "Show old animal"
  end

  @tag accessed_by: "admin", skip: true
  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, old_animal_path(conn, :show, -1)
    end
  end

  @tag accessed_by: "admin", skip: true
  test "renders form for editing chosen resource", %{conn: conn} do
    old_animal = OldRepo.insert! %OldAnimal{}
    conn = get conn, old_animal_path(conn, :edit, old_animal)
    assert html_response(conn, 200) =~ "Edit old animal"
  end

  @tag accessed_by: "admin", skip: true
  test "updates chosen resource and redirects when data is valid", %{conn: conn} do
    old_animal = OldRepo.insert! %OldAnimal{}
    conn = put conn, old_animal_path(conn, :update, old_animal), old_animal: @valid_attrs
    assert redirected_to(conn) == old_animal_path(conn, :show, old_animal)
    assert OldRepo.get_by(OldAnimal, @valid_attrs)
  end

  @tag accessed_by: "admin", skip: true
  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    old_animal = OldRepo.insert! %OldAnimal{}
    conn = put conn, old_animal_path(conn, :update, old_animal), old_animal: @invalid_attrs
    assert html_response(conn, 200) =~ "Edit old animal"
  end
end