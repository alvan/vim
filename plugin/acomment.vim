" == "acomment" == {{{
"
"          File:  acomment.vim
"          Path:  ~/.vim/plugin
"        Author:  Alvan
"      Modifier:  Alvan
"      Modified:  2009-09-01 09:45:29  
"   Description:  在文档中快速添加注释的vim插件
"                 可自由添加支持的文件类型、定义注释符号
"                 仅在linux系统下的Vim中测试
"          Note:  在Windows下使用请在Vim配置中将文件编码设为utf-8
"                 或者转换该脚本至你所使用的编码
"       License:  使用公共领域(public domain)许可
"
" --}}}

" Exit if already loaded
if exists("g:loaded_acomment")
    finish
endif

" acomment插件版本号
let g:loaded_acomment = "Version 2.25"

" ***********************************配置*************************************
" 定义键映射
" 
" 切换注释模式，用于普通模式
nmap <silent> <unique> <leader>cs :call <SID>AComment("Comments")<Cr>
" 添加头部注释，用于普通模式
nmap <silent> <unique> <leader>ct :call <SID>AComment("CommentTop")<Cr>
" 添加文件结束注释，用于普通模式
nmap <silent> <unique> <leader>cb :call <SID>AComment("CommentBottom")<Cr>
" 添加注释，新增于当前下一行，用于普通、插入模式
nmap <silent> <unique> <leader>cj :call <SID>AComment("Commentj")<Cr>
imap <silent> <unique> <leader>cj <Esc>:call <SID>AComment("Commentj")<Cr>a
" 添加注释，新增于当前上一行，用于普通、插入模式
nmap <silent> <unique> <leader>ck :call <SID>AComment("Commentk")<Cr>
imap <silent> <unique> <leader>ck <Esc>:call <SID>AComment("Commentk")<Cr>a
" 添加注释，位于当前行末，用于普通、插入模式
nmap <silent> <unique> <leader>cl :call <SID>AComment("Commentl")<Cr>
imap <silent> <unique> <leader>cl <Esc>:call <SID>AComment("Commentl")<Cr>a
" 注释，用于普通、插入、可视、块模式
nmap <silent> <unique> <leader>ch :call <SID>AComment("Comment")<Cr>
imap <silent> <unique> <leader>ch <Esc>:call <SID>AComment("Comment")<Cr>a
vmap <silent> <unique> <leader>ch <Esc>:'<,'>call <SID>AComment("CommentRange")<Cr>
" 删除注释，可用于普通、插入、可视、块模式
nmap <silent> <unique> <leader>cc :call <SID>AComment("UnComment")<Cr>
imap <silent> <unique> <leader>cc <Esc>:call <SID>AComment("UnComment")<Cr>a
vmap <silent> <unique> <leader>cc <Esc>:'<,'>call <SID>AComment("UnCommentRange")<Cr>
" 切换 添加（删除）注释，可用于普通、插入、可视、块模式
nmap <silent> <unique> <leader>x :call <SID>AComment("Commentx")<Cr>
imap <silent> <unique> <leader>x <Esc>:call <SID>AComment("Commentx")<Cr>a
vmap <silent> <unique> <leader>x <Esc>:'<,'>call <SID>AComment("CommentxRange")<Cr>

" 全局变量设置
"
" let g:acommentAutoIndent = 1/0
" 取值1，在添加删除注释时自动缩进
" 取值0，在添加删除注释时不自动缩进，为默认值
" 
" let g:acommentStrictMode = 1/2/3
" 取值1，严格匹配注释模式，注释符号的空白字符不可忽略
" 取值2，过渡匹配注释模式，注释符号中间的空白字符不可忽略
" 取值3，松散匹配注释模式，尽可能多匹配注释，可忽略所有空白字符，为默认值

" 脚本配置字典
let s:aDict = {}
"
" 可在.vimrc文件中以函数 g:acommentSet() 定义字典 s:aDict 的内容
"
" 在函数 g:acommentSet() 中定义一个字典变量 g:acomment
" function g:acommentSet()
"     let g:acomment = {@key:@value, ...}
" endf
"
" 全局字典函数配置
" let g:acomment = {@key:@value, ...}
"
" @key string aDict中对应的键，参考脚本默认定义方式
" Note:由于 cType 和 fType 具有通用性，所以不支持使用全局字典函数定义
"
" @value mixed aDict中对应格式的值，参考脚本默认定义方式
"
"
" Example:
" function g:acommentSet()
"     let g:acomment = {}
"     let g:acomment["user"] = 'Alvan'
"     let g:acomment['cTop'] = [
"                 \ [["          File:  ",'Y'],[expand("%"),'N']]
"                 \,[["          Path:  ",'Y'],[expand("%:p:h"),'REL']]
"                 \,[["        Author:  ",'Y'],[g:acomment["user"],'T']]
"                 \,[["      Modifier:  ",'Y'],[g:acomment["user"],'SIGN']]
"                 \,[["      Modified:  ",'Y'],[strftime("%Y-%m-%d %H:%M:%S"),'N']]
"                 \,[["   Description:  ",'N'],["",'Y']]
"                 \]
"     let g:acomment["reUrl"] = [
"                 \["/var/www","."]
"                 \]
" endfunction

" 定义注释符号
let s:aDict['cType'] = {}
"
" let s:aDict['cType'][@number] = {@type:@value,...}
" @number int 键序号
" @type string:
"       cLine 添加注释的行数，缺省为1
"       cBegin 用在头部注释开始部分，如<?php，缺省为空
"       cEnd 用在头部注释结束部分，如 ?>，缺省为空
"       cHead 用在注释开始部分，如<!-- ，缺省为空
"       cFoot 用在注释结束部分，如 -->，缺省为空
"       cBody 用在单行注释或者没有cHead及cFoot的情况下，如// ，缺省为空
"       cMiddle 用在注释中间占位部分，如 * ，缺省为空
" 可用性：@type 必须至少定义 cBody 或者 成对的cHead和cFoot
"
" @value string 注释符号
"
let s:aDict['cType'][0] = {'cBegin':"\" == \"acomment\" == "."{"."{"."{",'cEnd':"\" --"."}"."}"."}",'cHead':"\"",'cFoot':"\"",'cBody':"\" ",'cMiddle':"\""}
let s:aDict['cType'][1] = {'cLine':3,'cBegin':"<?php",'cHead':"/* ",'cFoot':" */",'cBody':"// ",'cMiddle':" * "}
let s:aDict['cType'][2] = {'cLine':3,'cHead':"/* ",'cFoot':" */",'cBody':"// ",'cMiddle':" * "}
let s:aDict['cType'][3] = {'cHead':"/* ",'cFoot':" */",'cMiddle':" * "}
let s:aDict['cType'][4] = {'cHead':"<!-- ",'cFoot':" -->"}
let s:aDict['cType'][5] = {'cBody':"# "}
let s:aDict['cType'][6] = {'cBody':"; "}
let s:aDict['cType'][7] = {'cBody':"% "}
let s:aDict['cType'][8] = {'cBody':"-- "}
let s:aDict['cType'][9] = {'cBegin':"<?php",'cBody':"// "}

" 定义文件类型及对应的注释符号在aDict['cType']中的键序号
"
" 对于多类型注释符号的文件，例如php、html，将该语言的默认注释格式放在第一位
" 依赖性：s:aDict['cType']
"
" let s:aDict['fType'][@suffix] = [@number,...]
" @suffix string 文件后缀名
" @number int 对应的注释符号在aDict['cType']中的键序号
"
let s:aDict['fType'] = {
            \'vim':[0],'vimrc':[0],
            \'php':[1,4,9],
            \'phtml':[4,1,9],
            \'python':[5],
            \'cpp':[2],'java':[2],'js':[2],'go':[2],
            \'css':[3],'c':[3],'h':[3],'pc':[3],
            \'htm':[4,2],'html':[4,2],'xml':[4],'xhtml':[4,2],'tpl':[4,2],
            \'ini':[5,6],'sh':[5],'conkyrc':[5],'list':[5],
            \'tex':[7],
            \'sql':[8]
            \}

" s:CTop()
" 以三维列表形式定义头部注释块的内容
"
" let s:aDict['cTop'] = [[[@key,@keyword],[@value,@keyword]],...]
" @key string 标识
" @value string 值
" @keyword string :
"       Y 用在标识列表中代表必须存在且作为判定旧的头部注释是否存在的依据的文本，用在值列表中代表应该填写的项
"
"       N 用在标识列表中代表不作为判定旧的头部注释是否存在的依据的文本，用在值列表中代表可变值
"       Note:无论是否作为判定依据（Y／N），每个 标识=>值 列表均独占一行
"
"       T 代表应保留旧的值，仅用在值列表
"
"       SIGN 代表用以确认注释身份的信息文本(该标识符唯一)，仅用在值列表
"       Note:该标识符不存在时脚本无法判定当前注释者的身份，因而将始终添加而不是尝试更新注释
"
"       REL 代表优先使用相对路径，仅用在包含路径(可以使用getcwd方法取得)的值列表
"           依赖性:相对路径列表 s:aDict['reUrl']
"
" return list
"
function s:CTop()
    let s:aDict['cTop'] = [
                \ [["          File:  ",'Y'],[expand("%"),'N']]
                \,[["          Path:  ",'Y'],[expand("%:p:h"),'REL']]
                \,[["        Author:  ",'Y'],[s:aDict['user'],'T']]
                \,[["      Modifier:  ",'Y'],[s:aDict['user'],'SIGN']]
                \,[["      Modified:  ",'Y'],[strftime("%Y-%m-%d"),'N']]
                \,[["   Description:  ",'N'],["",'Y']]
                \]

    if exists("g:acomment")
        if has_key(g:acomment,"cTop") &&
                    \type(g:acomment["cTop"]) == type([])
            call g:acommentSet()
            let s:aDict['cTop'] = g:acomment["cTop"]
        endif
    endif

    return deepcopy(s:aDict['cTop'])
endf

" s:CBottom()
" 定义底部注释行的内容
" 最终结果将是此处定义的内容末尾加上文件名
"
" return string
"
function s:CBottom()
    let s:aDict['cBottom'] = "End of file"

    if exists("g:acomment")
        if has_key(g:acomment,"cBottom") &&
                    \type(g:acomment["cBottom"]) == type("")
            call g:acommentSet()
            let s:aDict['cBottom'] = g:acomment["cBottom"]
        endif
    endif
    return s:aDict['cBottom']
endf

" s:ReUrl()
" 定义相对路径列表
" 以二维列表形式定义相对路径的内容
" 依照列表定义的顺序由上至下查找匹配的路径@path，一旦匹配一个值即停止往下查找，以@symbol替换
" 可用性:仅在值部分包含 REL 关键字时
"
" let reUrl = [[@path,@symbol],...]
" @path string 路径
" @symbol string 替换路径的字符
"
" return list
"
function s:ReUrl()
    let s:aDict['reUrl'] = [
                \["/var/www",'.'],
                \[expand("~"),'~']
                \]

    if exists("g:acomment")
        if has_key(g:acomment,"reUrl")
            call g:acommentSet()
            let index = len(g:acomment["reUrl"]) - 1
            while index >= 0 
                call insert(s:aDict['reUrl'],g:acomment["reUrl"][index])
                let index -= 1
            endw
        endif
    endif

    return deepcopy(s:aDict['reUrl'])
endf

" *******************************配置结束***********************************

" {{{
" 动作函数命名空间
let s:aNameSpace = "acomment"
" 重定义动作函数命名空间
let s:aNameSpace = toupper(s:aNameSpace)."_"

" CommentTop动作函数
" 添加头部注释
function s:{s:aNameSpace}CommentTop()
    " 取得实时头部注释内容
    let cTop = s:CTop()
    if exists("*s:ReUrl")
        let reUrl = s:ReUrl()
        for item in reUrl
            if len(item) != 2
                unlet reUrl
                call s:Err(1)
                call s:Msg("T",0,"reUrl定义错误!")
                break
            endif
        endfor
    else
        call s:Err(1)
        call s:Msg("T",0,"缺少reUrl定义!")
    endif

    let cBegin = s:cDict['cBegin']
    let cEnd = s:cDict['cEnd']
    let cHead = s:cDict['cHead']
    let cFoot = s:cDict['cFoot']
    let cBody = s:cDict['cBody']
    let cMiddle = s:cDict['cMiddle']
    if cHead != '' && cMiddle != '' && cHead != cMiddle
        let cHead = s:StrTrim(cHead,2).s:StrTrim(cMiddle,-2)
    endif
    let nBNum = nextnonblank(1)

    " 在头部注释内容的每一行前添加cMiddle注释符号
    let index = 0
    while index < len(cTop)
        let cTop[index][0][0] = cMiddle.cTop[index][0][0]
        let index += 1
    endw

    " 添加包围的cHead、cFoot注释符号
    if cHead != '' && cFoot != ''
        call insert(cTop,[[cHead,'Y'],["",'N']])
        call add(cTop,[[cFoot,'N'],["",'N']])
    endif

    " 添加包围的cBegin、cEnd注释符号
    let lenTCL = 0
    if cBegin != ''
        if nBNum == 0 || (s:StrTrim(getline(nBNum),1) !=? s:StrTrim(cBegin,1))
            let tmpVar = [[cBegin,'N'],["",'N']]
            call insert(cTop,tmpVar)
            if cEnd != ''
                let tmpVar = [[cEnd,'N'],["",'N']]
                call add(cTop,tmpVar)
                let lenTCL += 1
            endif
            let nBNum = 0 
            unlet tmpVar
        endif
    elseif nBNum != 0
        let nBNum -= 1
    endif

    let index = 0
    while index < len(cTop)
        " 将注释所在行的行号加入相应列表的最后
        let nBNum += 1
        call add(cTop[index],[nBNum])
        if cTop[index][0][1] ==? "Y"
            let lenTCL += 1
        endif
        let index += 1
    endw

    let existComment = "FALSE"

    if line("$") >= lenTCL
        " 比较可能存在的头部注释内容
        let index = 0
        while index < len(cTop)
            if cTop[index][0][1] ==? "Y"
                " 完全匹配（过渡匹配）
                if g:acommentStrictMode <= 2
                    if match(tolower(getline(cTop[index][len(cTop[index])-1][0])),
                                \tolower('^\s*'.s:StrToEreg(cTop[index][0][0]))
                                \) != -1
                        let existComment = "TRUE"
                    else
                        let existComment = "FALSE"
                        break
                    endif
                endif
                " 松散匹配
                if g:acommentStrictMode >= 3
                    if match(tolower(s:StrTrim(getline(cTop[index][len(cTop[index])-1][0]),1)),
                                \tolower('^'.s:StrToEreg(s:StrTrim(cTop[index][0][0],1)))
                                \) != -1
                        let existComment = "TRUE"
                    else
                        let existComment = "FALSE"
                        break
                    endif
                endif
            endif
            let index += 1
        endw
    endif

    let existMyComment = "FALSE"
    if existComment ==? "TRUE"
        " 比较可能由当前编辑者所作的的头部注释内容
        let index = 0
        while index < len(cTop)
            let index2 = 0
            while index2 < len(cTop[index]) - 1
                if cTop[index][index2][1] ==? "SIGN"
                    if substitute(tolower(s:StrTrim(getline(cTop[index][index2+1][0]),1)),
                                \tolower(s:StrToEreg(s:StrTrim(cTop[index][index2 - 1][0],1))),"",""
                                \) !=? tolower(s:StrTrim(cTop[index][index2][0],1))
                        let existMyComment = "NONE"
                        break
                    else
                        let existMyComment = "TRUE"
                    endif
                endif
                let index2 += 1
            endw
            if existMyComment ==? "NONE"
                let existMyComment = "FALSE"
                break
            endif
            let index += 1
        endw
    endif

    " 更新列表内容
    let index = 0
    while index < len(cTop)
        let index2 = 0
        while index2 < len(cTop[index]) - 1
            if cTop[index][index2][1] ==? "REL"
                if !exists("reUrl")
                    call s:Msg("add","cTop使用了REL关键字")
                    return 0
                endif
                let index3 = 0
                while index3 < len(reUrl)
                    if cTop[index][index2][0] == reUrl[index3][0]
                        let cTop[index][index2][0] = reUrl[index3][1].s:pathSeparator
                        break
                    endif
                    if match(cTop[index][index2][0],"^".reUrl[index3][0].s:pathSeparator) != -1
                        let cTop[index][index2][0] = substitute(
                                    \cTop[index][index2][0],"^".reUrl[index3][0],
                                    \reUrl[index3][1],
                                    \'')
                        break
                    endif
                    let index3 += 1
                endw
            endif
            let index2 += 1
        endw
        let index += 1
    endw

    if existComment ==? "TRUE"
        let index = 1
        while index < len(cTop)
            let index2 = 0
            while index2 < len(cTop[index]) - 1
                if cTop[index][index2][1] ==? "T"
                    let cTop[index][index2][0] = substitute(
                                \getline(cTop[index][index2 + 1][0]),
                                \'\c^\s*'.
                                \s:StrTrim(
                                \s:StrToEreg(s:StrTrim(cTop[index][index2 - 1][0],1)),
                                \-1).
                                \'\s*',
                                \"",
                                \"")
                endif
                let index2 += 1
            endw
            let index += 1
        endw
    endif

    " 计算文件总的行数
    if existMyComment ==? "TRUE"
        let totaLine = line("$")
    else
        let totaLine = line("$") + len(cTop)
    endif

    " 将列表内容循环取出，作为注释内容添加到文档头部或者更新旧的文档头部注释
    let index = 0
    let tmpStr = ""
    while index < len(cTop)
        let tmpVar = cTop[index][0][0]
        let index2 = 1
        while index2 < len(cTop[index]) - 1
            let tmpVar = tmpVar . cTop[index][index2][0]
            let index2 += 1
        endw
        if existMyComment !=? "TRUE"
            let nBNum = cTop[index][len(cTop[index])-1][0] - 1
            call append(nBNum,tmpVar)
            if !exists("saveLineNum") && cTop[index][1][1] == "Y"
                let saveLineNum = cTop[index][len(cTop[index])-1][0]
                let tmpVar = tmpVar."[按a键在此处输入内容]"
            endif
            let tmpLen = nBNum + 1
            while len(tmpLen) < len(totaLine)
                let tmpLen = " ".tmpLen
            endw
            let tmpStr = tmpStr.tmpLen." ".tmpVar."\n"
            call s:Msg("T",2,"\n\n".tmpStr)
        elseif cTop[index][0][1] ==? "Y" 
            let nBNum = cTop[index][len(cTop[index])-1][0]
            call setline(nBNum,tmpVar)
            let tmpLen = nBNum
            while len(tmpLen) < len(totaLine)
                let tmpLen = " ".tmpLen
            endw
            let tmpStr = tmpStr.tmpLen." ".tmpVar."\n"
            call s:Msg("T","更新头部注释",2,"\n\n".tmpStr)
        endif
        let index += 1
        unlet tmpVar
    endw

    if exists("saveLineNum")
        execute "normal gg" .saveLineNum. "$" 
        redraw
    endif

    unlet cTop
    unlet reUrl
endf

" Commentl动作函数
" 添加注释（位于行末）
function s:{s:aNameSpace}Commentl()
    let lNum = line(".")
    let cHead = s:cDict['cHead']
    let cFoot = s:cDict['cFoot']
    let cBody = s:cDict['cBody']
    " 单行注释时使用头尾注释符号或单行注释符号，例如<!-- -->或//
    let strc = (cBody=="")?(cHead.s:cDict['cFoot']):(cBody)
    let strc = (match(strc,'^\s\+') == -1) ? (" ".strc) : strc 
    call setline(lNum,getline(lNum).strc)
    execute "normal $"

    if s:cDict['cBody'] == ''
        execute "normal" .len(cFoot). "h"
    endif
    call s:Msg("T",2,"按a键输入注释内容")
    redraw
endf

" Commentk动作函数
" 添加注释(新增于上一行)
function s:{s:aNameSpace}Commentk()
    let cLine = s:cDict['cLine']
    let cHead = s:cDict['cHead']
    let cFoot = s:cDict['cFoot']
    let cBody = s:cDict['cBody']
    let cMiddle = s:cDict['cMiddle']
    if cLine >= 2
        if cHead != '' && cMiddle != '' && cHead != cMiddle
            let cHead = s:StrTrim(cHead,2).s:StrTrim(cMiddle,-2)
        endif
    endif
    " 相应的注释动作
    normal O
    let lNum = line(".")
    if cLine > 2
        call setline(lNum,cHead)
        let savePos = getpos(".")
        call append(lNum,cFoot)
        let iNum = cLine - 2
        while (iNum > 0)
            call append(lNum,cMiddle)
            let iNum = iNum - 1
        endw
        call setpos(".",savePos)
        " 循环格式化加入的行
        while cLine > 0
            normal ==
            let cLine = cLine -1
            if cLine > 0
                normal j
            endif
        endw
        call setpos(".",savePos)
        normal j$
    elseif cLine == 1
        " 单行注释时使用头尾注释符号或单行注释符号，例如<!---->或//
        let strc = (cBody=='')?(cHead.cFoot):(cBody)
        call setline(lNum,strc)
        normal ==$
        if s:cDict['cBody'] == ''
            let lenCFoot = len(cFoot)
            while lenCFoot > 0
                normal h
                let lenCFoot = lenCFoot - 1
            endw
        endif
    endif
    call s:Msg("T",2,"按a键输入注释内容")
    redraw
endf

" Commentj动作函数
" 添加注释(新增于下一行)
function s:{s:aNameSpace}Commentj()
    let cLine = s:cDict['cLine']
    let cHead = s:cDict['cHead']
    let cFoot = s:cDict['cFoot']
    let cBody = s:cDict['cBody']
    let cMiddle = s:cDict['cMiddle']
    if cLine >= 2
        if cHead != '' && cMiddle != '' && cHead != cMiddle
            let cHead = s:StrTrim(cHead,2).s:StrTrim(cMiddle,-2)
        endif
    endif
    " 相应的注释动作
    normal o
    let lNum = line(".")
    if cLine > 2
        call setline(lNum,cHead)
        let savePos = getpos(".")
        call append(lNum,cFoot)
        let iNum = cLine - 2
        while (iNum > 0)
            call append(lNum,cMiddle)
            let iNum = iNum - 1
        endw
        call setpos(".",savePos)
        " 循环格式化加入的行
        while cLine > 0
            normal ==
            let cLine = cLine -1
            if cLine > 0
                normal j
            endif
        endw
        call setpos(".",savePos)
        normal j$
    elseif cLine == 1
        " 单行注释时使用头尾注释符号或单行注释符号，例如<!---->或//
        let strc = (cBody=="")?(cHead.cFoot):(cBody)
        call setline(lNum,strc)
        normal ==$
        if s:cDict['cBody'] == ''
            let lenCFoot = len(cFoot)
            while lenCFoot > 0
                normal h
                let lenCFoot = lenCFoot - 1
            endw
        endif
    endif
    call s:Msg("T",2,"按a键输入注释内容")
    redraw
endf

" CommentBottom动作函数
" 添加文件结束注释
function s:{s:aNameSpace}CommentBottom()
    let cHead = s:cDict['cHead']
    let cFoot = s:cDict['cFoot']
    let cBody = s:cDict['cBody']
    let cBottom = s:CBottom()

    let strc = (cBody=='')?(cHead.cBottom):(cBody.cBottom)
    let nBNum = prevnonblank(line("$"))

    let existComment = "F"

    if cBody == ''
        if g:acommentStrictMode == 1
            if match(tolower(getline(nBNum)),
                        \'^\s*'.s:StrToEreg(tolower(cHead)).
                        \s:StrToEreg(tolower(cBottom)).'.*'.
                        \s:StrToEreg(tolower(cFoot)).'\s*$'
                        \) != -1
                let existComment = "T"
            endif
        endif
        if g:acommentStrictMode == 2
            if match(tolower(getline(nBNum)),
                        \'^\s*'.s:StrToEreg(tolower(s:StrTrim(s:StrTrim(cHead,-2),2))).
                        \'\s*'.s:StrTrim(s:StrToEreg(s:StrTrim(tolower(cBottom),1)),-1)
                        \) != -1
                let existComment = "T"
            endif
        endif
    else
        if g:acommentStrictMode == 1
            if match(tolower(getline(nBNum)),
                        \'^\s*'.s:StrToEreg(tolower(cBody)).
                        \s:StrToEreg(tolower(cBottom))
                        \) != -1
                let existComment = "T"
            endif
        endif
        if g:acommentStrictMode == 2
            if match(tolower(getline(nBNum)),
                        \'^\s*'.s:StrToEreg(tolower(s:StrTrim(s:StrTrim(cBody,-2),2))).
                        \'\s*'.s:StrTrim(s:StrToEreg(s:StrTrim(tolower(cBottom),1)),-1)
                        \) != -1
                let existComment = "T"
            endif
        endif
    endif

    if g:acommentStrictMode >= 3
        if match(tolower(s:StrTrim(getline(nBNum),1)),
                    \'^'.tolower(s:StrToEreg(s:StrTrim(strc,1)))
                    \) != -1
            let existComment = "T"
        endif
    endif

    let strc = strc." : ".expand("%")

    if existComment ==? "T"
        let strc = (cBody=="")?(strc.cFoot):(strc)
        if getline(nBNum) == strc
            call s:Msg("T",3,"发现已存在的注释符号")
        else
            call setline(nBNum,strc)
            call s:Msg("T","更新".s:fType."文件结束注释符号",2,"\n\n" .nBNum. " " .strc)
        endif
    else
        let strc = (cBody=="")?(strc.cFoot):(strc)
        call append(line("$"),strc)
        call s:Msg("T",2,"\n\n" .line("$"). " " .strc)
    endif
endf

" Comment动作模式
"
" 添加注释符号
"
" 尝试匹配头尾注释符号（若存在）
"
" 匹配，则添加一个位于句首的<!--  -->
" 如<!-- Some Code -->
" 得到<!--  --><!-- Some Code -->
"
" 不匹配，则尝试使用单行注释符号（若存在）
" 如 Some Code
" 得到// Some Code
"
function s:{s:aNameSpace}Comment(...)
    if a:0 == 1 && a:1 ==? "range"
        let isRange = "T"
    else
        let isRange = "unknown"
    endif

    let cHead = s:cDict['cHead']
    let cFoot = s:cDict['cFoot']
    let cBody = s:cDict['cBody']
    let strc = getline(line('.'))
    " 空行则跳过
    if strc =~ '^\s*$'
        if isRange ==? "T" && line(".") == line("'>")
            call s:Msg("T",4)
            call s:AutoIndent("range")
            normal j^
            redraw
        else
            call s:Msg("T",3)
            normal j^
        endif
        return 0
    endif

    let existComment = "F"

    if cBody == "" &&
                \match(strc,
                \'^\s*'.s:StrToEreg(cHead).
                \'.*'.s:StrToEreg(cFoot).'\s*$')
                \ != -1
        let cBody = cHead.cFoot
        let existComment = "T"
    endif
    if cBody == "" &&
                \existComment == "F" &&
                \g:acommentStrictMode == 2 &&
                \match(strc,
                \'^\s*'.s:StrToEreg(s:StrTrim(s:StrTrim(cHead,-2),2)).
                \'.*'.s:StrToEreg(s:StrTrim(s:StrTrim(cFoot,-2),2)).'\s*$')
                \ != -1
        let cBody = cHead.cFoot
        let existComment = "T"
    endif
    if cBody == "" &&
                \existComment == "F" &&
                \g:acommentStrictMode == 3 &&
                \match(strc,
                \'^\s*'.s:StrTrim(s:StrToEreg(s:StrTrim(cHead,1)),-1).
                \'.*'.s:StrTrim(s:StrToEreg(s:StrTrim(cFoot,1)),-1).'\s*$')
                \ != -1
        let cBody = cHead.cFoot
    endif

    if cBody == "" && (
                \match(strc,s:StrToEreg(cHead)) != -1 ||
                \(g:acommentStrictMode == 2 &&
                \match(strc,s:StrToEreg(s:StrTrim(s:StrTrim(cHead,-2),2))) != -1) ||
                \(g:acommentStrictMode == 3 &&
                \match(strc,s:StrTrim(s:StrToEreg(s:StrTrim(cHead,1)),-1)) != -1)
                \)
        let strc = substitute(strc,'^\(\s*\)\(.\{-}\)'.s:StrToEreg(cHead),'\1'.cHead.'\2'.cFoot.cHead,'')
    endif

    if strc == getline(line('.'))
        " 添加左侧头尾注释符号或者单行注释符号
        "
        " 如<!-- Some Code -->
        " 则得到<!-- --><!-- Some Code ..>
        "
        " 如 Some Code
        " 则得到// Some Code
        "
        let strc = substitute(strc,'^\(\s*\)','\1'.cBody,"")
    endif
    "
    if strc == getline(line('.'))
        " 
        " 添加头尾注释符号
        " 如 Some Code
        " 得到<!-- Some Code -->
        "
        let strc = substitute(strc,'^\(\s*\)','\1'.cHead,"").cFoot
    endif

    if isRange ==? "T"
        if strc != getline(line("."))
            call setline(line('.'),strc)
        endif
        if line(".") == line("'>")
            call s:Msg("T",4)
            call s:AutoIndent("range")
            normal j^
            redraw
        endif
    else
        if strc != getline(line("."))
            call setline(line('.'),strc)
            call s:Msg("T",2)
            call s:AutoIndent()
            normal j^
        else
            call s:Msg("T",1)
        endif
    endif
endf

" UnComment动作模式
"
" 删除注释符号
" 尝试多个表达式
" 匹配则删除该注释符号
"
"
" 尝试匹配多个成对（或）单行注释符号的第一个注释（或）最后一个
"
" 如<!--  --><!-- Some Code -->
" 匹配第一个<!--  -->
"
" 如<!-- Some Code --><!--  -->
" 匹配最后一个<!--  -->
"
function s:{s:aNameSpace}UnComment(...)
    if a:0 == 1 && a:1 ==? "range"
        let isRange = "T"
    else
        let isRange = "unknown"
    endif

    let cHead = s:cDict['cHead']
    let cFoot = s:cDict['cFoot']
    let cBody = s:cDict['cBody']
    let strc = getline(line('.'))
    " 空行则跳过
    if strc =~ '^\s*$'
        if isRange ==? "T" && line(".") == line("'>")
            call s:Msg("T",4)
            call s:AutoIndent("range")
            redraw
        else
            call s:Msg("T",3)
        endif
        return 1
    endif

    if cBody == ''
        let cBody = cHead.cFoot
    endif

    " 匹配<!-- -->Some code以及// Some code 的注释
    if strc == getline(line("."))
        " 尝试完全匹配
        let strc = substitute(strc,'^\(\s*\)'.s:StrToEreg(cBody).'\s*','\1',"")
    endif
    if strc == getline(line(".")) && g:acommentStrictMode >= 2
        " 尝试以忽略注释符号两端空白字符的形式进行匹配
        let strc = substitute(strc,
                    \'^\(\s*\)'.s:StrToEreg(s:StrTrim(s:StrTrim(cBody,-2),2)).'\s*',
                    \'\1',
                    \"")
    endif
    if strc == getline(line(".")) && g:acommentStrictMode >= 3
        " 尝试以忽略空白字符的形式进行匹配
        let strc =substitute(strc,
                    \'^\(\s*\)'.s:StrTrim(s:StrToEreg(s:StrTrim(cBody,1)),-1).'\s*',
                    \'\1',
                    \"")
    endif

    if cHead != '' && cFoot != ''
        " 匹配 <!-- Text1 --><!-- Text2 --> 字符串的 <!-- Text1 -->
        if strc == getline(line("."))
            " 尝试完全匹配
            let strc = substitute(strc,
                        \'^\(\s*\)'.s:StrToEreg(cHead).
                        \'\s*\(.\{-}\)'.s:StrToEreg(cFoot),
                        \'\1\2',
                        \"")
        endif
        if strc == getline(line(".")) && g:acommentStrictMode >= 2
            " 尝试忽略两侧空格进行匹配
            let strc = substitute(strc,
                        \'^\(\s*\)'.s:StrToEreg(s:StrTrim(s:StrTrim(cHead,-2),2)).
                        \'\s*\(.\{-}\)'.s:StrToEreg(s:StrTrim(s:StrTrim(cFoot,-2),2)),
                        \'\1\2',
                        \"")
        endif
        if strc == getline(line(".")) && g:acommentStrictMode >= 3
            " 尝试忽略所有空格进行匹配
            let strc = substitute(strc,
                        \'^\(\s*\)'.s:StrTrim(s:StrToEreg(s:StrTrim(cHead,1)),-1).
                        \'\s*\(.\{-}\)'.s:StrTrim(s:StrToEreg(s:StrTrim(cFoot,1)),-1),
                        \'\1\2',
                        \"")
        endif
    endif

    " 匹配Some code<!-- -->以及Some code //的注释
    if strc == getline(line(".")) && cBody !~ '^\s*"\s*$'
        " 尝试完全匹配行末多余的注释符号
        let strc = substitute(strc,'\s*'.s:StrToEreg(cBody).'\s*$','',"")
    endif
    if strc == getline(line(".")) && cBody !~ '^\s*"\s*$'
        if cBody == cHead.cFoot
            " 去除cHead右侧空白字符和cFoot左侧空白字符进行匹配
            let strc = substitute(strc,
                        \'\s*'.
                        \s:StrToEreg(s:StrTrim(cHead,2)).'\s*'.s:StrToEreg(s:StrTrim(cFoot,-2)).
                        \'\s*$',
                        \'',"")
            let cBody = s:StrTrim(cHead,2).s:StrTrim(cFoot,-2)
        endif
    endif
    if strc == getline(line(".")) && g:acommentStrictMode >= 2 && cBody !~ '^\s*"\s*$'
        " 尝试以忽略注释符号两端空白字符的形式匹配行末多余的注释符号
        let strc = substitute(strc,
                    \'\s*'.s:StrToEreg(s:StrTrim(s:StrTrim(cBody,-2),2)).'\s*$',
                    \'',
                    \"")
    endif
    if strc == getline(line(".")) && g:acommentStrictMode >= 3 && cBody !~ '^\s*"\s*$'
        " 尝试以忽略空白字符的形式匹配行末多余的注释符号
        let strc = substitute(strc,
                    \'\s*'.s:StrTrim(s:StrToEreg(s:StrTrim(cBody,1)),-1).'\s*$',
                    \'',
                    \"")
    endif

    " 匹配头尾注释符号如<!-- -->
    "
    if strc == getline(line("."))
        " 尝试完全匹配
        let strc = substitute(strc,
                    \'^\(\s*\)'.s:StrToEreg(cHead).
                    \'\s*\(.*\)\s*'.
                    \s:StrToEreg(cFoot).'\s*$',
                    \'\1\2',
                    \"")
    endif


    if strc == getline(line(".")) && g:acommentStrictMode >= 2
        " 尝试以忽略注释符号两端空白字符的形式进行匹配
        let strc = substitute(strc,
                    \'^\(\s*\)'.s:StrToEreg(s:StrTrim(s:StrTrim(cHead,-2),2)).
                    \'\s*\(.*\)\s*'.
                    \s:StrToEreg(s:StrTrim(s:StrTrim(cFoot,-2),2)).'\s*$',
                    \'\1\2',
                    \"")
    endif

    if strc == getline(line(".")) && g:acommentStrictMode >= 3
        " 尝试以忽略空白字符的形式进行匹配
        let strc = substitute(strc,
                    \'^\(\s*\)'.s:StrTrim(s:StrToEreg(s:StrTrim(cHead,1)),-1).
                    \'\s*\(.*\)\s*'.
                    \s:StrTrim(s:StrToEreg(s:StrTrim(cFoot,1)),-1).'\s*$',
                    \'\1\2',
                    \"")
    endif

    if isRange ==? "T"
        let tmpValue = 0
        if strc != getline(line("."))
            call setline(line('.'),strc)
            let tmpValue = 1
        endif
        if line(".") == line("'>")
            call s:Msg("T",4)
            call s:AutoIndent("range")
            redraw
        endif
        return tmpValue
    else
        if strc != getline(line("."))
            call s:Msg("T",2)
            call setline(line('.'),strc)
            call s:AutoIndent()
            return 1
        else
            call s:Msg("T",1)
            return 0
        endif
    endif
endf

" Commentx动作模式
" 切换注释
function s:{s:aNameSpace}Commentx(...)
    if a:0 == 1 && a:1 ==? "range"
        let isRange = "T"
    else
        let isRange = "unknown"
    endif

    " 空行则跳过
    if getline(".") =~ '^\s*$'
        if isRange ==? "T" && line(".") == line("'>")
            call s:Msg("T",4)
            call s:AutoIndent("range")
        else
            call s:Msg("T",3)
            normal j^
        endif
        return
    endif

    if isRange ==? "T"
        if s:{s:aNameSpace}UnComment("range") == 0
            call s:{s:aNameSpace}Comment("range")
        endif
        call s:Msg("T",4)
    else
        if s:{s:aNameSpace}UnComment() == 0
            call s:{s:aNameSpace}Comment()
        endif
    endif
endf

" Comments动作模式
" 切换注释符号
function s:{s:aNameSpace}Comments()
    call s:Err("clearErr")

    if (len(s:aDict['fType'][s:fType]) - 1) > s:acommentMode
        let s:acommentMode = s:acommentMode + 1
    else
        let s:acommentMode = 0
    endif

    if len(s:aDict['fType'][s:fType]) > 1
        " 设置注释符号
        call s:SetComment(s:acommentMode)
        if s:Err("hasErr")
            call s:Msg("T",0)
            return
        endif
        call s:Msg("T",2,"切换至[\'".s:fType."\'][".s:acommentMode."]  ".
                    \s:cDict['cBegin'].
                    \s:cDict['cEnd'].
                    \s:cDict['cHead'].
                    \s:cDict['cMiddle'].
                    \s:cDict['cFoot'].
                    \s:cDict['cBody']
                    \)
    else
        call s:Err(5)
        call s:Msg("T",0)
    endif
endf

" ==============================================================================
" 初始化插件
"
autocmd BufEnter,BufRead * :call s:InitA()
autocmd Filetype * :call s:InitA()

function s:InitA()
    " 设置初始化状态为F(alse)
    let s:initA = "F"

    " 设置全局变量
    if !exists("g:acommentAutoIndent")
        let g:acommentAutoIndent = 0
    endif
    if !exists("g:acommentStrictMode")
        let g:acommentStrictMode = 3
    endif
    if exists("*g:acommentSet")
        call g:acommentSet()
        if !exists("g:acomment")
            echo "g:acommentSet函数定义错误，缺少g:acomment定义"
        elseif type(g:acomment) != type({})
            echo "g:acomment的设置出现错误，将忽略其值"
            unlet g:acomment
        endif
    endif

    " 是否正用着MS的Windows
    if !exists("s:isMS") || !exists("s:pathSeparator")
        let s:isMS = (has("win16") || has("win32") || has("win64")) ?
                    \"TRUE" : "FALSE"
        let s:pathSeparator = (s:isMS ==? "TRUE") ? '\' : '/'
    endif

    " 插件使用者，缺省由脚本推测为主目录下的用户名或者undefind
    if exists("g:acomment")
        call g:acommentSet()
        if has_key(g:acomment,'user')
            let s:aDict['user'] = g:acomment['user']
        endif
    endif
    if !has_key(s:aDict,"user") || s:aDict['user'] =~ '^\s*$'
        if s:isMS !=? "TRUE"
            let s:aDict['user'] = (strridx(expand("~"),'/') == -1) ?
                        \"undefind" :
                        \strpart(expand("~"),(strridx(expand("~"),'/') + 1))
        else
            let s:aDict['user'] = "undefind"
        endif
    endif

    " 清除错误信息
    call s:Err("clearErr")

    " 取得文件类型
    call s:FType()
    " 发现错误则退出
    if s:Err("hasErr")
        return
    endif

    " 设置注释符号
    let s:acommentMode = 0
    call s:SetComment(s:acommentMode)
    " 发现错误则退出
    if s:Err("hasErr")
        return
    endif

    " 初始化成功，设置状态为T(rue)
    let s:initA = "T"
endf

" 全局接口函数
" s:AComment(@funName)
"
" @funcName string 动作名
"
function s:AComment(funcName)
    " 检查插件是否已初始化
    if !exists("s:initA")
        call s:InitA()
        if s:Err("hasErr")
            echo "（".strftime("%H:%M:%S")."）".s:Err("ERR").s:Err()
            return
        endif
    endif

    " 检查入口函数的参数是否符合要求
    if type(a:funcName) != type("")
        " 输出错误
        echo "（".strftime("%H:%M:%S")."）".s:Err("ERR").s:Err(7)
        return
    else
        if match(a:funcName,'Range$') != -1
            let funcName = substitute(a:funcName,'Range$','','')
            let isRange = "T"
            let isLast = (line(".") == line("'>")) ? "T" : "unknown"
        else
            let funcName = a:funcName
            let isRange = "unknown"
        endif
    endif

    if s:initA != "T"
        if isRange ==? "T" && isLast !=? "T"
            return
        endif
        echo "（".strftime("%H:%M:%S")."）".s:Err("ERR")."插件初始化失败，".s:Err()
        return
    endif

    " 清除错误信息
    call s:Err("clearErr")

    " 初始化输出信息
    call s:Msg("init",s:Action(a:funcName))

    " 执行动作
    if exists("*s:".s:aNameSpace.funcName)
        if isRange ==? "T"
            call s:{s:aNameSpace.funcName}("range")
        else
            call s:{s:aNameSpace.funcName}()
        endif
    else
        call s:Err(6)
        call s:Msg("T",0)
    endif

    " 输出最终信息
    if s:Msg() != 0
        if isRange ==? "T" && isLast !=? "T"
            return
        endif
        echo s:Msg()
    endif
endf

" 获取文件类型，返回其小写的后缀名
function s:FType()
    " 获取文件名后缀
    let fType = &filetype
    if fType == ""
        call s:Err(2)
        return
    endif
    let fType = tolower(fType)

    " 是否已经定义了该类文件的注释符号
    if !has_key(s:aDict['fType'],fType)
        call s:Err(3)
        return
    endif

    let s:fType = fType
    return s:fType
endf

" 设置注释符号
function s:SetComment(num)
    if !has_key(s:aDict['cType'],s:aDict['fType'][s:fType][a:num])
        call s:Err(3)
        return
    endif
    let tmpDict = s:aDict['cType'][s:aDict['fType'][s:fType][a:num]]
    let s:cDict = {}
    let s:cDict['cLine'] = (has_key(tmpDict,"cLine") && type(tmpDict["cLine"]) == type(0)) ?
                \(tmpDict['cLine']) :
                \1
    let s:cDict['cBegin'] = (has_key(tmpDict,"cBegin") && tmpDict["cBegin"] !~ '^\s*$') ?
                \(tmpDict['cBegin']) : ""
    let s:cDict['cEnd'] = (has_key(tmpDict,"cEnd") && tmpDict["cEnd"] !~ '^\s*$') ?
                \(tmpDict['cEnd']) : ""
    let s:cDict['cHead'] = (has_key(tmpDict,"cHead") && tmpDict["cHead"] !~ '^\s*$') ?
                \(tmpDict['cHead']) : ""
    let s:cDict['cFoot'] = (has_key(tmpDict,"cFoot") && tmpDict["cFoot"] !~ '^\s*$') ?
                \(tmpDict['cFoot']) : ""
    let s:cDict['cBody'] = (has_key(tmpDict,"cBody") && tmpDict["cBody"] !~ '^\s*$') ?
                \(tmpDict['cBody']) : ""
    let s:cDict['cMiddle'] = (has_key(tmpDict,"cMiddle") && tmpDict["cMiddle"] !~ '^\s*$') ?
                \(tmpDict['cMiddle']) : ""

    if s:cDict['cBody'] == "" && (s:cDict['cHead'] == "" || s:cDict['cFoot'] == "")
        call s:Err(4)
        return
    endif

    if s:cDict['cMiddle'] == "" &&
                \(s:cDict['cHead'] == "" || s:cDict['cFoot'] == "") &&
                \s:cDict['cBody'] != ""
        let s:cDict['cMiddle'] = s:cDict['cBody']
    endif
endf

function s:Action(name)
    " 注册动作字典
    let actionDict = {}
    let actionDict['CommentTop'] = "头部注释"
    let actionDict['CommentBottom'] = "文件结束注释"
    let actionDict['Comments'] = "切换注释模式"
    let actionDict['Commentx'] = "切换注释"
    let actionDict['Commentj'] = "添加注释"
    let actionDict['Commentk'] = "添加注释"
    let actionDict['Commentl'] = "添加注释"
    let actionDict['Comment'] = "注释"
    let actionDict['UnComment'] = "删除注释"

    if has_key(actionDict,a:name)
        return actionDict[a:name]."动作"
    elseif has_key(actionDict,substitute(a:name,'Range$','',''))
        return "批量".actionDict[substitute(a:name,'Range$','','')]."动作"
    else
        return "未注册的动作".a:name
    endif
endf

" 设置动作状态
function s:Status(num)
    let status = {}
    let status[0] = "错误"
    let status[1] = "失败"
    let status[2] = "成功"
    let status[3] = "无效"
    let status[4] = "结束"

    if has_key(status,a:num)
        return status[a:num]
    else
        return ""
    endif
endf

" 设置错误信息
function s:Err(...)
    let err = "acomment.ERR : "
    let errMsg = {}
    let errMsg[0] = "出现未知的错误"
    let errMsg[1] = "自定义错误信息："
    let errMsg[2] = "检测不到文件后缀名"
    let errMsg[3] = "该类型文件对应的注释符号尚未定义"
    let errMsg[4] = "该类型文件对应的注释符号定义错误"
    let errMsg[5] = "该动作不适用于该类型文件"
    let errMsg[6] = "该动作尚未定义"
    let errMsg[7] = "参数不正确"

    if !exists("s:errNum")
        let s:errNum = 0
    endif

    if a:0 == 0
        if has_key(errMsg,s:errNum)
            return errMsg[s:errNum]
        endif
        return errMsg[0]
    endif

    if a:0 == 1
        if has_key(errMsg,a:1) && a:1 != 0
            let s:errNum = a:1
        endif
        if a:1 ==? "ERR"
            return err
        endif
        if a:1 ==? "hasErr"
            if s:errNum != 0 && has_key(errMsg,s:errNum)
                return 1
            endif
            return 0
        endif
        if a:1 ==? "clearErr"
            let s:errNum = 0
        endif
        if a:1 ==? "errNum"
            return s:errNum
        endif
    endif
endf

" 设置输出信息，返回受影响的值
function s:Msg(...)
    if a:0 == 0
        if s:msg['flag'] != "F"
            if s:msg['echo'] =~ '^\s*$'
                if s:msg['status'] != 0
                    " 输出信息
                    let s:msg['echo'] = (s:msg['action'] !~ '^\s*$') ?
                                \(s:msg['echo']."执行".s:msg['action']."：") :
                                \(s:msg['echo'])
                    let s:msg['echo'] = (s:Status(s:msg['status']) !~ '^\s*$') ?
                                \(s:msg['echo'].s:Status(s:msg['status'])) :
                                \(s:msg['echo'])
                    let s:msg['echo'] = (s:msg['info'] !~ '^\s*$') ?
                                \(s:msg['echo']."；".s:msg['info']) :
                                \(s:msg['echo'])
                else
                    " 输出错误信息
                    let s:msg['echo'] = s:Err("ERR")
                    let s:msg['echo'] = (s:msg['action'] !~ '^\s*$') ?
                                \(s:msg['echo']."执行".s:msg['action']."失败；") :
                                \(s:msg['echo'])
                    let s:msg['echo'] = s:msg['echo'].s:Err()

                    if s:errNum == 1
                        let s:msg['echo'] = (s:msg['info'] !~ '^\s*$') ?
                                    \(s:msg['echo'].s:msg['info']) :
                                    \(s:msg['echo'])
                    endif
                endif

                if s:msg['echo'] !~ '^\s*$'
                    let s:msg['echo'] = "（".strftime("%H:%M:%S")."）".s:msg['echo']
                    return 1
                endif
                return 0
            endif
            return s:msg['echo']
        endif
        return 0
    endif

    if a:0 == 1 && (a:1 ==? "T" || a:1 ==? "F")
        let s:msg['flag'] = a:1
        return 1
    endif
    if a:0 == 1 && type(a:1) == type("")
        let s:msg['info'] = a:1
        return 1
    endif
    if a:0 == 1 && type(a:1) == type(0)
        let s:msg['status'] = a:1
        return 1
    endif
    if a:0 == 2 && a:1 ==? "init"
        let s:msg = {}
        let s:msg['flag'] = "F"
        let s:msg['status'] = ""
        let s:msg['info'] = ""
        let s:msg['echo'] = ""
        if  type(a:2) == type("") && a:2 !~ '^\s*$'
            let s:msg['action'] = a:2
        else
            let s:msg['action'] = ""
        endif
        return 1
    endif
    if a:0 == 2 && a:1 ==? "add" && type(a:2) == type("")
        let s:msg['info'] = s:msg['info'].a:2
        return 1
    endif
    if a:0 == 2 && (a:1 ==? "T" || a:1 ==? "F") && type(a:2) == type("")
        let s:msg['flag'] = a:1
        let s:msg['info'] = a:2
        return 2
    endif
    if a:0 == 2 && (a:1 ==? "T" || a:1 ==? "F") && type(a:2) == type(0)
        let s:msg['flag'] = a:1
        let s:msg['status'] = a:2
        return 2
    endif
    if a:0 == 3 && (a:1 ==? "T" || a:1 ==? "F") &&
                \ type(a:2) == type(0) && type(a:3) == type("")
        let s:msg['flag'] = a:1
        let s:msg['status'] = a:2
        let s:msg['info'] = a:3
        return 3
    endif
    if a:0 == 4 && (a:1 ==? "T" || a:1 ==? "F") && type(a:2) == type("") && 
                \type(a:3) == type(0) && type(a:4) == type("")
        let s:msg['flag'] = a:1
        let s:msg['action'] = a:2
        let s:msg['status'] = a:3
        let s:msg['info'] = a:4
        return 4
    endif
    return 0
endf

" 依据g:acommentAutoIndent值自动缩进
function s:AutoIndent(...)
    if exists("g:acommentAutoIndent") && g:acommentAutoIndent == 1
        if a:0 == 1 && a:1 ==? "range"
            execute "normal " .line("'<"). "gg"
            while line(".") <= line("'>")
                execute "normal =="
                if line(".") < line("'>")
                    execute "normal j"
                endif
            endw
        else
            execute "normal =="
        endif
        call s:Msg("add","（自动缩进）")
        return 1
    endif
    return 0
endf

" ==============================================================================
" 工具函数
"
" 转换一般字符串
function s:StrTrim(cStr,CT)
    let cStr = a:cStr
    let CT = a:CT
    if CT == 1
        " 去除所有空格
        let cStr = substitute(cStr,'\s*','',"g")
    elseif CT == -1
        " 加入任意空格，字符串头部和尾部无空格
        let cStr = substitute(cStr,'\([^\\]\)','\1\\s\*',"g")
        let cStr = substitute(cStr,'\\s\*$','',"")
    elseif CT == -2
        " 去除左侧空格
        let cStr = substitute(cStr,'^\s*','',"")
    elseif CT == 2
        " 去除右侧空格
        let cStr = substitute(cStr,'\s*$','',"")
    elseif CT == -3
        " 得到左侧空格
        let cStr = matchstr(cStr,'^\s*')
    elseif CT == 3
        " 得到右侧空格
        let cStr = matchstr(cStr,'\s*$')
    endif

    return cStr
endf

" 转换一般字符串,使之成为可用正则表达式的一部分
function s:StrToEreg(cStr)
    let cStr = a:cStr
    let cStr = substitute(cStr,'\(\"\|\*\)','\\\1',"g")
    return cStr
endf

" ==============================================================================
" vim相应配置
" GVIM下编辑该插件脚本时不折行，显示水平滚动条
if has("gui_running") && bufname("%") ==? "acomment.vim"
    set nowrap
    set guioptions+=b
endif

" }}}
" vim:ft=vim:ff=unix:tabstop=4:shiftwidth=4:softtabstop=4:expandtab
" End of file : acomment.vim
