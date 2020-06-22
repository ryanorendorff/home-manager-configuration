Ryan's Home Manager Configuration
=================================

This home manager configuration is set up to enable a few things.

- New modules are defined in `modules`. Most should be attempted to be
  upstreamed at a later point in time.
- Custom modules (for modules that cannot be made open source) are located
  in `./custom-moldules`
- New packages in `./packages` are applied as an overlay to 
- Ideally make it easy for others to use the supplied modules in a consistent
  and simple way.
