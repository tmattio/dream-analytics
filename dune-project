(lang dune 2.0)

(name dream-analytics)

(documentation "https://tmattio.github.io/dream-analytics/")

(source
 (github tmattio/dream-analytics))

(license MIT)

(authors "Thibaut Mattio")

(maintainers "Thibaut Mattio")

(generate_opam_files true)

(package
 (name dream-analytics)
 (synopsis "Analytics framework and dashboard for your Dream applications")
 (description "Analytics framework and dashboard for your Dream applications")
 (depends
  (ocaml
   (>= 4.08.0))
  dune
  crunch
  dream
  js_of_ocaml
  js_of_ocaml-ppx
  user-agent-parser
  (alcotest :with-test)
  (alcotest-lwt :with-test)
  (odoc :with-doc)))
