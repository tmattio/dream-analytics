let event (config : Config.t) req =
  let (module Repo : Store.S) = config.Config.store in
  let parse_event params =
    let json = Yojson.Safe.from_string params in
    let open Yojson.Safe.Util in
    let name = member "n" json |> to_string in
    let url = member "u" json |> to_string in
    let referrer = member "r" json |> to_string_option in
    let domain = member "d" json |> to_string in
    let screen_width = member "w" json |> to_int in
    Event.{ name; url; referrer; domain; screen_width }
  in
  let _created_event =
    let ua = Dream.header "user-agent" req |> Option.map User_agent.parse in
    match ua with
    | None ->
      Lwt.return None
    | Some x when User_agent.is_bot x ->
      Lwt.return None
    | Some _ ->
      let%lwt params = Dream.body req in
      let event = parse_event params in
      let%lwt _ = Repo.create_event event in
      Lwt.return (Some ())
  in
  Dream.empty `OK
