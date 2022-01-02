local M = {}

-- https://pandoc.org/lua-filters.html#lua-type-reference

function M.Div(e)
  return e.content
end

function M.Span(e)
  return e.content
end

function M.Image()
  return {}
end

function M.Link(e)
  e.attr = {}
  return e
end

function M.Header(e)
  e.attr = {}
  return e
end

return { { Div = M.Div, Span = M.Span, Image = M.Image, Link = M.Link, Header = M.Header } }
