(** Dream Analytics is a library to add analytics capabilities to a Dream
    application.

    It works by providing a set JavaScript script that can be injected in your
    HTML document with a middleware. The script will execute HTTP queries to an
    API endpoint that will store events in a store (in-memory, database, etc.).

    A dashboard is also provided to visualize the collected statistics. *)

(** The interface for an event store.

    This can be a PosgreSQL database, a file on the filesystem, etc. *)
module type Store = sig
  val create_event : Event.t -> (unit, string) result Lwt.t

  val get_events : unit -> (Event.t list, string) result Lwt.t
end

val default_script : string
(** Default analytics string used if no custom script is provided in the config. *)

(** Dream Analytics global configuration.

    Most function of this library take it as a parameter to adapt their
    behavior. *)
type config

val config
  :  endpoint:string
  -> ?store:(module Store)
  -> ?script:string
  -> unit
  -> config
(** Build a new configuration.

    If [store] is not provided, the default in-memory store is used. Not that
    using an in-memory store will cause all of the statistics to be lost when
    the server restarts. *)

val routes : config -> Dream.route list
(** The routes for Dream Analytics API and dashboard. The following routes are
    provided:

    - [GET /] -> The analytics dashboard
    - [POST /event] -> The endpoint used by the analytics script to log new
      events *)

val router : config -> Dream.middleware
(** A Dream router with routes provided by [routes] *)

val scope : config -> string -> Dream.middleware list -> Dream.route
(** Helper function to scope the Dream Analytics routes with a prefix and a list
    of middlewares. *)

val inject_script : config -> Dream.middleware
(** A middleware that injects the analytics script in an HTML document. *)
