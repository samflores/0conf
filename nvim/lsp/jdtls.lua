return {
  cmd = { 'jdtls', '-configuration', vim.fn.stdpath('cache') .. '/jdtls/config', '-data', vim.fn.stdpath('cache') .. '/jdtls/workspace' },
  filetypes = { 'java' },
  root_markers = { '.git', 'build.gradle', 'build.gradle.kts', 'build.xml', 'pom.xml', 'settings.gradle', 'settings.gradle.kts' },
}
