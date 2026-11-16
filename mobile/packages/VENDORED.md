# Vendored core packages

These four packages are copied from
`RVM-BEYOND-PRIVATE-LIMITED/team_app` at commit
`07bb9e3dbbf52e41182c36bf94e9d3ba05f97bfa` (`flutter_app/packages/`).

`core_network`, `core_auth`, `core_bloc` and `core_ui` are pinned git
dependencies in `mobile/pubspec.yaml` in `team_app`. Mobile CI has no
credential for that private repository, so `flutter pub get` failed before any
check ran. Issue #1 allows the fallback: vendor a copy under `mobile/packages/`
and record the source commit. Keep this copy unchanged except for removing the
`resolution: workspace` line, which belongs to team_app's own workspace.
