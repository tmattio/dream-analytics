(* Configure Dream Analytics. You can use a custom store here for example. *)
let config =
  Dream_analytics.config ~endpoint:"http://localhost:8080/analytics" ()

(* This is your normal application, you need to add the [inject_script]
   middleware inject the analytics scripts in your HTML documents. *)
let app =
  Dream.scope
    "/"
    [ Dream_analytics.inject_script config ]
    [ Dream.get "/" (fun _ -> Dream.html "Good morning, world!") ]

(* The analytics app. We scope it with a prefix so that it doesn't conflict with
   our application routes. *)
let analytics_app = Dream_analytics.scope config "/analytics" []

let () =
  Dream.run
  @@ Dream.logger
  @@ Dream.router [ app; analytics_app ]
  @@ Dream.not_found
