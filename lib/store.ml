module type S = sig
  val create_event : Event.t -> (unit, string) result Lwt.t

  val get_events : unit -> (Event.t list, string) result Lwt.t
end

module In_memory : S = struct
  let events = ref []

  let create_event event =
    events := event :: !events;
    Lwt.return (Ok ())

  let get_events () = Lwt.return (Ok !events)
end
