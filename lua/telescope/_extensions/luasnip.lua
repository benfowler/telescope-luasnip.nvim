local has_telescope, telescope = pcall(require, 'telescope')
if not has_telescope then
  error('This plugins requires nvim-telescope/telescope.nvim')
end

-- stylua: ignore start
local actions       = require("telescope.actions")
local action_state  = require("telescope.actions.state")
local finders       = require("telescope.finders")
local pickers       = require("telescope.pickers")
local previewers    = require("telescope.previewers")
local entry_display = require("telescope.pickers.entry_display")
local conf          = require("telescope.config").values
local ext_conf      = require("telescope._extensions")
-- stylua: ignore end

local M = {}

local filter_null = function(str, default)
  return str and str or (default and default or '')
end

local filter_description = function(name, description)
  local result = ''
  if description and #description > 1 then
    for _, line in ipairs(description) do
      result = result .. line .. ' '
    end
  elseif name and description and description[1] ~= name then
    result = description[1]
  end

  return result
end

local get_docstring = function(luasnip, ft, context)
  local docstring = {}
  if context then
    local snips_for_ft = luasnip.get_snippets(ft)
    if snips_for_ft then
      for _, snippet in pairs(snips_for_ft) do
        if context.name == snippet.name and context.trigger == snippet.trigger then
          local raw_docstring = snippet:get_docstring()
          if type(raw_docstring) == 'string' then
            for chunk in string.gmatch(snippet:get_docstring(), '[^\n]+') do
              docstring[#docstring + 1] = chunk
            end
          else
            docstring = raw_docstring
          end
        end
      end
    end
  end
  return docstring
end

local default_search_text = function(entry)
  return filter_null(entry.context.trigger)
    .. ' '
    .. filter_null(entry.context.name)
    .. ' '
    .. entry.ft
    .. ' '
    .. filter_description(entry.context.name, entry.context.description)
end

local _opts = {
  preview = {
    check_mime_type = true,
  },
}
M.opts = _opts

M.luasnip_fn = function(opts)
  local opts = vim.tbl_extend('keep', opts or {}, M.opts or _opts)

  -- print(("debug: %s: opts.test"):format(debug.getinfo(1).source))
  -- print(vim.inspect(opts.test))
  local objs = {}

  -- Account for the fact that luasnip may be lazy-loaded
  local has_luasnip, luasnip = pcall(require, 'luasnip')
  if has_luasnip then
    local available = luasnip.available()
    for filename, file in pairs(available) do
      for _, snippet in ipairs(file) do
        table.insert(objs, { ft = filename == '' and '-' or filename, context = snippet })
      end
    end
  else
    print('LuaSnips is not available')
  end

  table.sort(objs, function(a, b)
    if a.ft ~= b.ft then
      return a.ft > b.ft
    elseif a.context.name ~= b.context.name then
      return a.context.name > b.context.name
    else
      return a.context.trigger > b.context.trigger
    end
  end)

  local displayer = entry_display.create({
    separator = ' ',
    items = { { width = 12 }, { width = 24 }, { width = 16 }, { remaining = true } },
  })

  local make_display = function(entry)
    return displayer({
      entry.value.ft,
      entry.value.context.name,
      { entry.value.context.trigger, 'TelescopeResultsNumber' },
      filter_description(entry.value.context.name, entry.value.context.description),
    })
  end

    -- stylua: ignore
    pickers.new(opts, {
        prompt_title = "LuaSnip",
        finder = finders.new_table({
            results = objs,
            entry_maker = function(entry)
                search_fn = ext_conf._config.luasnip
                    and ext_conf._config.luasnip.search
                    or default_search_text
                return {
                    value = entry,
                    display = make_display,
                    ordinal = search_fn(entry),
                    preview_command = function(_, bufnr)
                        local snippet = get_docstring(luasnip, entry.ft, entry.context)
                        if opts.preview.check_mime_type then
                            vim.api.nvim_buf_set_option(bufnr, "filetype", entry.ft)
                        end
                        vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, snippet)
                    end
                }
            end
        }),

        previewer = previewers.display_content.new(opts),
        sorter = conf.generic_sorter(opts),
        attach_mappings = function()
            actions.select_default:replace(function(prompt_bufnr)
                local selection = action_state.get_selected_entry()
                actions.close(prompt_bufnr)

                -- Match snippets to be expanded
                -- Extract them directly
                local snippetsToExpand = {}
                luasnip.available(function(snippet)
                    if snippet.trigger == selection.value.context.trigger then
                        table.insert(snippetsToExpand, snippet)
                    end
                    return nil
                end)

                -- Use first snippet to expand
                if (#snippetsToExpand > 0) then
                    vim.cmd(':startinsert!')
                    vim.defer_fn(function() luasnip.snip_expand(snippetsToExpand[1]) end, 50)
                else
                    error(
                        "telescope-luasnip.nvim: snippet '" .. selection.value.context.name .. "'" ..
                            " was selected, but there are no snippets to expand!")
                end
                -- vim.cmd('stopinsert')
            end)
            return true
        end
    }):find()
end -- end custom function

-- stylua: ignore start
return telescope.register_extension({
  setup = function(optsExt, opts)
    M.opts = vim.tbl_extend('keep', optsExt or {}, opts or {}, M.opts or _opts)
  end,
  exports = {
    luasnip            = M.luasnip_fn,
    filter_null        = filter_null,
    filter_description = filter_description,
    get_docstring      = get_docstring,
  },
})
-- stylua: ignore end
