type t =
  { endpoint : string
  ; script : string option
  ; store : (module Store.S)
  }

let make ~endpoint ?store ?script () =
  let store = Option.value store ~default:(module Store.In_memory : Store.S) in
  { endpoint; store; script }
