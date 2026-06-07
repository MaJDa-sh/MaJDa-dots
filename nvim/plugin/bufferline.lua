require("bufferline").setup({
  options = {
    mode = "buffers", -- set to "tabs" to only show tabpages instead
    separator_style = "slant", -- can be "slant" | "hollow_slant" | "thick" | "thin" | { 'any', 'any' }
    always_show_bufferline = true,
    show_buffer_close_icons = true,
    show_close_icon = true,
    color_icons = true,
  },
})
