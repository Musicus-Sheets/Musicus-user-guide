#import "template.typ": *

// Release version on the title page: `typst compile --input version=1.2.0`
// (build.sh passes it); "dev" when built without one.
#let musicus-version = sys.inputs.at("version", default: "dev")

#show: guide.with(
  title: "Musicus",
  subtitle: "Your sheet music, on every music stand",
  version: if musicus-version == "dev" { "User guide for a development version of Musicus" } else {
    "User guide for Musicus " + musicus-version
  },
)

#include "chapters/01-welcome.typ"
#include "chapters/02-installation.typ"
#include "chapters/03-admin.typ"
#include "chapters/04-librarian.typ"
#include "chapters/05-member.typ"
#include "chapters/06-faq.typ"
