Ryan's Home Manager Configuration
=================================

This home manager configuration is set up to enable a few things.

- New modules are defined in `modules`. Ideally some could be
  upstreamed at a later point in time.
- Custom modules (for modules that cannot be made open source) are located
  in `./custom-moldules`
- New packages in `./packages` are applied as an overlay to home.nix
- Ideally make it easy for others to use the supplied modules in a consistent
  and simple way.
