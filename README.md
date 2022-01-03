wip

## Requirements

- pandoc

## Example

```vim
" Open url or file path under the cursor.
nnoremap <Space>O <Cmd>lua require("docfilter").open(vim.fn.expand("<cWORD>"))<CR>
```