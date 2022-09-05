-- Additional Django template surroundings for vim-surround plugin
-- (put it inside $LUNARVIM_CONFIG_DIR/after/ftplugin/ directory)
------------------------------------------------------------------

--   'Sv' or 'S{' - variable
vim.cmd('let b:surround_{char2nr("v")} = "{{ \r }}"')
vim.cmd('let b:surround_{char2nr("{")} = "{{ \r }}"')
--   'S%' - other template tags
vim.cmd('let b:surround_{char2nr("%")} = "{% \r %}"')
--   'Sb' - block
vim.cmd('let b:surround_{char2nr("b")} = "{% block \1block name: \1 %} \r {% endblock \1\1 %}"')
--   'SB' - block with newlines
vim.cmd('let b:surround_{char2nr("B")} = "{% block \1block name: \1 %}\n\r\n{% endblock \1\1 %}"')
--   'Si' -  if statement
vim.cmd('let b:surround_{char2nr("i")} = "{% if \1condition: \1 %}\r{% endif %}"')
--   'Sw' - with statement
vim.cmd('let b:surround_{char2nr("w")} = "{% with \1with: \1 %}\r{% endwith %}"')
--   'Sf' - for statement
vim.cmd('let b:surround_{char2nr("f")} = "{% for \1for loop: \1 %}\r{% endfor %}"')
--   'SF' - for statement with newlines
vim.cmd('let b:surround_{char2nr("F")} = "{% for \1for loop: \1 %}\n\r\n{% endfor %}"')
--   'Sc' - comment
vim.cmd('let b:surround_{char2nr("c")} = "{% comment %}\r{% endcomment %}"')
