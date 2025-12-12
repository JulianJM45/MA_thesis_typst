// Shared configuration for the thesis
// This file can be imported by any content file to provide LSP support

// Bibliography path - import this in content files for LSP support
#let bib-path = "/thesis.yml"

// Export the bibliography function for use in content files
// This is a no-op function that helps LSP understand bibliography references
// without actually rendering the bibliography in the content files
#let cite-setup() = {
  // This function does nothing but provides LSP hints
  none
}
