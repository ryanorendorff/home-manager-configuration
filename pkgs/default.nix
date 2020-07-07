self: super: {
  fish-ls-colors = self.callPackage ./fish-ls-colors {};
  zsh-ls-colors = self.callPackage ./zsh-ls-colors {};
} // (import ./dhall)
