" MIT License. Copyright (c) 2013-2018 Bailey Ling et al.
" vim: et ts=2 sts=2 sw=2
source $VIMDIR/bundle/vim-airline/autoload/airline/extensions/tabline.vim

function! airline#extensions#tabline#load_theme(palette)
  if pumvisible()
    return
  endif
  let colors    = get(a:palette, 'tabline', {})
  let tablabel  = get(colors, 'airline_tablabel', a:palette.normal.airline_b)
  " Theme for tabs on the left
  let tab     = get(colors, 'airline_tab', a:palette.normal.airline_b)
  let tabsel  = get(colors, 'airline_tabsel', a:palette.normal.airline_b)
  let tabtype = get(colors, 'airline_tabtype', a:palette.visual.airline_a)
  let tabfill = get(colors, 'airline_tabfill', a:palette.normal.airline_c)
  let tabmod  = get(colors, 'airline_tabmod', a:palette.normal.airline_b)
  let tabhid  = get(colors, 'airline_tabhid', a:palette.normal.airline_c)
  if has_key(a:palette, 'normal_modified') && has_key(a:palette.normal_modified, 'airline_c')
    let tabmodu = get(colors, 'airline_tabmod_unsel', a:palette.normal_modified.airline_c)
  else
    "Fall back to normal airline_c if modified airline_c isn't present
    let tabmodu = get(colors, 'airline_tabmod_unsel', a:palette.normal.airline_c)
  endif
  call airline#highlighter#exec('airline_tablabel', tablabel)
  call airline#highlighter#exec('airline_tab', tab)
  call airline#highlighter#exec('airline_tabsel', tabsel)
  call airline#highlighter#exec('airline_tabtype', tabtype)
  call airline#highlighter#exec('airline_tabfill', tabfill)
  call airline#highlighter#exec('airline_tabmod', tabmod)
  call airline#highlighter#exec('airline_tabmod_unsel', tabmodu)
  call airline#highlighter#exec('airline_tabhid', tabhid)

  " Theme for tabs on the right
  let tabsel_right  = get(colors, 'airline_tabsel_right', a:palette.normal.airline_a)
  let tab_right     = get(colors, 'airline_tab_right',    a:palette.inactive.airline_c)
  let tabmod_right  = get(colors, 'airline_tabmod_right', a:palette.insert.airline_a)
  let tabhid_right  = get(colors, 'airline_tabhid_right', a:palette.normal.airline_c)
  if has_key(a:palette, 'normal_modified') && has_key(a:palette.normal_modified, 'airline_c')
    let tabmodu_right = get(colors, 'airline_tabmod_unsel_right', a:palette.normal_modified.airline_c)
  else
    "Fall back to normal airline_c if modified airline_c isn't present
    let tabmodu_right = get(colors, 'airline_tabmod_unsel_right', a:palette.normal.airline_c)
  endif
  call airline#highlighter#exec('airline_tab_right',    tab_right)
  call airline#highlighter#exec('airline_tabsel_right', tabsel_right)
  call airline#highlighter#exec('airline_tabmod_right', tabmod_right)
  call airline#highlighter#exec('airline_tabhid_right', tabhid_right)
  call airline#highlighter#exec('airline_tabmod_unsel_right', tabmodu_right)
endfunction
