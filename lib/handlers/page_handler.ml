let index (config : Config.t) _req =
  let (module Repo : Store.S) = config.Config.store in
  let%lwt events = Repo.get_events () in
  match events with
  | Ok events ->
    Layout_template.render
      ~title:"Dream Analytics"
      (Dashboard_template.render events)
    |> Dream.html
  | Error _ ->
    (* TODO: This should be a an error page *)
    Layout_template.render
      ~title:"Dream Analytics"
      (Dashboard_template.render [])
    |> Dream.html
