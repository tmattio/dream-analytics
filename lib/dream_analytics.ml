(** Entrypoint to Dream Analytics' web library. *)

module type Store = Store.S

type config = Config.t

let config = Config.make

let routes config =
  [ Dream.post "/event" (Event_handler.event config)
  ; Dream.get "" (Page_handler.index config)
  ]

let router config = Dream.router (routes config)

let scope config prefix middlewares =
  Dream.scope prefix middlewares (routes config)

let default_script = Asset.read "dream-analytics.js" |> Option.get

let inject_script config =
  let script =
    Option.value config.Config.script ~default:default_script
    |> Str.(
         global_replace (regexp (quote "%%ENDPOINT%%")) config.Config.endpoint)
  in
  let script_with_tags = "<script>" ^ script ^ "</script>" in
  fun (next_handler : Dream.handler) request ->
    let%lwt response = next_handler request in
    match Dream.header "Content-Type" response with
    | Some "text/html" | Some "text/html; charset=utf-8" ->
      let%lwt body = Dream.body response in
      let insert_script s =
        try
          let regexp = Str.regexp "</body>" in
          let index = Str.search_backward regexp s (String.length s) in
          let before_body = String.sub s 0 index in
          let after_body = String.sub s index (String.length s - index) in
          String.concat "" [ before_body; script_with_tags; after_body ]
        with
        | Not_found ->
          s ^ script_with_tags
      in
      Lwt.return (Dream.with_body (insert_script body) response)
    | _ ->
      Lwt.return response
