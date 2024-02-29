return {

	'schrieveslaach/sonarlint.nvim',
	url='https://gitlab.com/schrieveslaach/sonarlint.nvim',
	ft = {
		'typescript',
	},
	config = function()
		require('sonarlint').setup({
			server = {
				cmd = {
					'sonarlint-language-server',
					-- Ensure that sonarlint-language-server uses stdio channel
					'-stdio',
					'-analyzers',
					-- paths to the analyzers you need, using those for python and java in this example
					vim.fn.expand("$MASON/share/sonarlint-analyzers/sonarpython.jar"),
					vim.fn.expand("$MASON/share/sonarlint-analyzers/sonarjs.jar"),
				},
				settings = {
					sonarlint = {
						rules = {
							['typescript:S6606'] = { level = "off" },
							['typescript:S6671'] = { level = "off" }
						}}
				}
			},
			filetypes = {
				-- Tested and working
				'python',
				'javascript',
				'typescript'
			}
		})
	end,
}
