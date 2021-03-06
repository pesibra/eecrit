defmodule Eecrit.OldReservationSink do
  alias Eecrit.OldGroup
  alias Eecrit.OldUse

  @repo Eecrit.OldRepo

  # TODO: Should this use changesets? Note: as it stands, no
  # validations are done to any of the structs. But at the moment,
  # nothing here is built from user-supplied data.
  def make_full!(reservation_fields, animals, procedures) do
    uses = for a <- animals, p <- procedures, do: %OldUse{animal: a, procedure: p}
    only_group = %OldGroup{uses: uses}
    reservation = %{reservation_fields | groups: [only_group]}

    # Note that this call will turn into multiple inserts. Probably harmless
    # if a reservation is read while partially inserted, but still:
    # wrap in transaction.
    {:ok, reservation} = @repo.transaction(fn -> @repo.insert!(reservation) end)
    reservation
  end
end
