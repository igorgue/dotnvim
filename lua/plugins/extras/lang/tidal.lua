vim.filetype.add({
  extension = {
    ["tidal"] = "tidal",
  },
})

local ok, icons = pcall(require, "nvim-web-devicons")
if ok then
  icons.set_icon({
    [".tidal"] = { icon = "󰘧 ", color = "#25C2A0", name = "TidalCycles" },
  })
  icons.set_icon({
    tidal = { icon = "󰘧 ", color = "#25C2A0", name = "TidalCycles" },
  })
end

return {
  description = "TidalCycles integration for Neovim",
  {
    -- "grddavies/tidal.nvim",
    "thgrund/tidal.nvim",
    dir = "~/Code/tidal.nvim",
    branch = "develop",
    lazy = false,
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      opts = function(_, opts)
        vim.treesitter.language.register("haskell", "tidal")

        opts.ensure_installed = opts.ensure_installed or {}
        vim.list_extend(opts.ensure_installed, { "haskell", "supercollider" })

        return opts
      end,
    },
    opts = {
      mappings = {
        send_line = { mode = { "n" }, key = "<cr>" },
        send_visual = { mode = { "x" }, key = "<cr>" },
        send_block = { mode = { "n", "x" }, key = "<s-cr>" },
        send_node = { mode = "n", key = "<leader><s-cr>" },
        send_silence = { mode = "n", key = "<leader>0" },
        send_hush = { mode = "n", key = "<leader><esc>" },
      },
      boot = {
        tidal = {
          file = (function()
            local f = vim.fn.findfile("BootTidal.hs", ".;")
            if f ~= "" then
              return f
            end
            return vim.api.nvim_get_runtime_file("bootfiles/BootTidal.hs", false)[1]
          end)(),
          highlight = {
            styles = {
              osc = {
                ip = "127.0.0.1",
                port = 3335,
              },
              custom = {
                ["1"] = { bg = "#875fff", foreground = "#dadaee" },
                ["2"] = { bg = "#00cd9b", foreground = "#dadaee" },
                ["3"] = { bg = "#ffd75f", foreground = "#161925" },
                ["4"] = { bg = "#cbe6ff", foreground = "#161925" },
                ["5"] = { bg = "#fa96a0", foreground = "#161925" },
                ["6"] = { bg = "#46e1b9", foreground = "#161925" },
                ["7"] = { bg = "#fa7878", foreground = "#dadaee" },
                ["8"] = { bg = "#8b8baf", foreground = "#dadaee" },
                ["9"] = { bg = "#c7a0c3", foreground = "#161925" },
                ["10"] = { bg = "#7fff00", foreground = "#161925" },
                ["11"] = { bg = "#fa7878", foreground = "#dadaee" },
                ["12"] = { bg = "#cbe6ff", foreground = "#161925" },
                ["13"] = { bg = "#eac9e4", foreground = "#161925" },
                ["14"] = { bg = "#46e1b9", foreground = "#161925" },
                ["15"] = { bg = "#fa7878", foreground = "#dadaee" },
                ["16"] = { bg = "#8b8baf", foreground = "#dadaee" },
              },
              global = { baseName = "CodeHighlight", style = { bg = "#875fff", foreground = "#dadaee" } },
            },
            events = {
              osc = {
                ip = "127.0.0.1",
                port = 6013,
              },
            },
            fps = 55,
          },
        },
        sclang = {
          file = (function()
            local f = vim.fn.findfile("BootSuperDirt.scd", ".;")
            if f ~= "" then
              return f
            end
            return vim.api.nvim_get_runtime_file("bootfiles/BootSuperDirt.scd", false)[1]
          end)(),
          enabled = true,
        },
      },
      filetype = "tidal",
    },
    keys = {
      {
        "<leader>;;",
        function()
          vim.cmd([[
            TidalLaunch
            TidalNotification
            SuperColliderNotification
            TidalStartEventHighlighting
          ]])
          vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<c-w>w", true, false, true), "n", false)
        end,
        ft = "tidal",
        desc = "Tidal Launch",
      },
      {
        "<leader>;:",
        function()
          vim.cmd([[
            TidalStopEventHighlighting
            TidalQuit
          ]])
        end,
        ft = "tidal",
        desc = "Tidal Quit",
      },
      {
        "<leader>;t",
        "<cmd>TidalNotification<cr>",
        ft = "tidal",
      },
      {
        "<leader>;s",
        "<cmd>SuperColliderNotification<cr>",
        ft = "tidal",
      },
      {
        "<c-s-a>",
        function()
          require("dial.map").manipulate("increment", "normal")
          require("tidal").api.send_line()
        end,
        ft = "tidal",
        desc = "Tidal Increment and Send Line",
      },
      {
        "<c-s-x>",
        function()
          require("dial.map").manipulate("decrement", "normal")
          require("tidal").api.send_line()
        end,
        ft = "tidal",
        desc = "Tidal Decrement and Send Line",
      },
      {
        "<s-cr>",
        function()
          require("tidal").api.send_block()
        end,
        ft = "tidal",
        mode = { "i" },
        desc = "Tidal Send Block",
      },
    },
  },
  {
    "saghen/blink.cmp",
    dependencies = {
      {
        "l00sed/cmp-tidal",
        dir = "~/Code/cmp-tidal",
        dependencies = {
          "nvim-lua/plenary.nvim",
        },
        ft = "tidal",
      },
    },
    opts = {
      completion = {
        accept = {
          auto_brackets = {
            kind_resolution = {
              blocked_filetypes = { "tidal" },
            },
            semantic_token_resolution = {
              blocked_filetypes = { "tidal" },
            },
          },
        },
      },
      sources = {
        default = { "tidal", "tidal_samples" },
        providers = {
          tidal = {
            name = "tidal",
            module = "blink.compat.source",
          },
          tidal_samples = {
            name = "tidal_samples",
            module = "blink.compat.source",
            opts = {
              custom_samples = (function()
                local f = vim.fn.finddir("Dirt/samples", ".;")
                if f ~= "" then
                  return { f }
                end
                return {}
              end)(),
            },
          },
        },
      },
    },
  },
}
