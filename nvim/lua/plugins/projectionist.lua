return {
	"tpope/vim-projectionist",
	config = function()
		vim.g.projectionist_heuristics = {
			["*"] = {
				["src/main/java/*.java"] = {
					alternate = "src/test/java/{}Test.java",
				},
				["src/test/java/*Test.java"] = {
					alternate = "src/main/java/{}.java",
				},
			},
		}
	end,
	event = "VeryLazy",
}
