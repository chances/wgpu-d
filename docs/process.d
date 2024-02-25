/// Process handlebars templates in API documentation.
///
/// Authors: Chance Snow
/// Copyright: Copyright © 2024 Chance Snow. All rights reserved.
/// License: MIT License
module wgpu.docs.process;

static import std.file;
import std.process;
import std.stdio;

void main(string[] args) {
  import std.array : replace;
  import std.string : strip;

  string template_ = std.file.readText("views/index.hbs");

  struct Constants {
    string DUB_VERSION;
    auto SYMBOLS = new string[0];
    auto MODULES = new string[0];
  }

  auto gitTagCmd = execute(["git", "describe", "--tags", "--abbrev=0"]);
  assert(gitTagCmd.status == 0);
  gitTagCmd.output.write;

  const constants = Constants(gitTagCmd.output.strip);
  const result = template_.replace("{{ DUB_VERSION }}", constants.DUB_VERSION);

  if (std.file.exists("docs/index.html")) std.file.remove("docs/index.html");
  std.file.write("docs/index.html", result);
}
