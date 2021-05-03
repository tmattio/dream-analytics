type t =
  { name : string
  ; url : string
  ; referrer : string option
  ; domain : string
  ; screen_width : int
  }

let top_pages events =
  let hashtbl = Hashtbl.create 256 in
  let rec aux = function
    | [] ->
      ()
    | el :: rest ->
      (match Hashtbl.find_opt hashtbl el.url with
      | Some i ->
        Hashtbl.replace hashtbl el.url (i + 1)
      | None ->
        Hashtbl.add hashtbl el.url 1);
      aux rest
  in
  aux events;
  hashtbl |> Hashtbl.to_seq |> List.of_seq
