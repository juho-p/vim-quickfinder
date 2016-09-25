fu! s:files(pattern)
    let pat = a:pattern
    let command = "git ls-files -o --exclude-standard -c '*/" . pat . "' '" . pat . "'"
    return systemlist(command)
endf

fu! s:try_open(path)
    if filereadable(a:path)
        exe 'e ' . a:path
    else
        let matches = s:files(a:path)
        let cnt = len(matches)
        if cnt > 100
            echo 'too many matches'
        elseif cnt > 1
            call setloclist(0, map(matches, {i, x -> {'filename': x}}))
            lopen
        elseif cnt == 1
            exe 'e ' . matches[0]
        else
            echo 'no matches'
        end
    end
endf

fu! quickfinder#find(...)
    if a:0 == 0 || empty(a:1)
        call s:try_open(input('Find: ', '', 'customlist,ListGitFiles'))
    else
        call s:try_open(a:1)
    en
endf

function! ListGitFiles(ArgLead, CmdLine, CursorPos)
    let filelist = s:files(a:ArgLead . '*')
    let g:foo = filelist
    return filelist
endf

command! -nargs=? -complete=customlist,ListGitFiles Find call quickfinder#find( '<args>' )
