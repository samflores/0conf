return {
  'jim-fx/sudoku.nvim',
  cmd = "Sudoku",
  config = function()
    require("sudoku").setup({
      -- configuration ...
    })
  end
}
