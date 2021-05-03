let endpoint = "http://localhost:8080/"

let config = Dream_analytics.config ~endpoint ()

let default_script =
  "<script>"
  ^ (Dream_analytics.default_script
    |> Str.(global_replace (regexp (quote "%%ENDPOINT%%")) endpoint))
  ^ "</script>"

let test_inject_script_no_body () =
  let dummy_handler _req = Dream.html "Hello World" in
  let request = Dream.request "" in
  let response =
    Dream.test (Dream_analytics.inject_script config dummy_handler) request
  in
  let body = Lwt_main.run @@ Dream.body response in
  Alcotest.(check string) "same string" body ("Hello World" ^ default_script)

let test_inject_script () =
  let dummy_handler _req =
    Dream.html
      "<html><head><title>Hello World</title></head><body>Hello \
       World</body></html>"
  in
  let request = Dream.request "" in
  let response =
    Dream.test (Dream_analytics.inject_script config dummy_handler) request
  in
  let body = Lwt_main.run @@ Dream.body response in
  Alcotest.(check string)
    "same string"
    body
    ("<html><head><title>Hello World</title></head><body>Hello World"
    ^ default_script
    ^ "</body></html>")

let () =
  let open Alcotest in
  run
    "Dream_analytics"
    [ ( "inject_script"
      , [ test_case
            "injects the script when no body"
            `Quick
            test_inject_script_no_body
        ; test_case "injects the script" `Quick test_inject_script
        ] )
    ]
