" Vim syntax extension for EDA Simulation & Synthesis Logs

" UVM & SystemVerilog Reporting
syn match logUvmFatal   '\c\<UVM_FATAL\>'
syn match logUvmError   '\c\<UVM_ERROR\>'
syn match logUvmWarn    '\c\<UVM_WARNING\>'
syn match logUvmInfo    '\c\<UVM_INFO\>'

" Cadence Incisive / Xcelium / SimVision log tags (*E, *W, *I)
syn match logCadenceErr  '\*[EF],\w\+'
syn match logCadenceWarn '\*[W],\w\+'
syn match logCadenceInfo '\*[IN],\w\+'

" Synopsys / EDA Timing Violations & Errors
syn match logViolation  '\c\<.*VIOLATION\>'
syn match logTimingErr  '\c\<SLACK\s*(VIOLATED)\>'
syn match logEdaPass    '\c\<\(SIMULATION\s\+\)\?\(PASSED\|SUCCESS\|PASS\)\>'
syn match logEdaFail    '\c\<\(SIMULATION\s\+\)\?\(FAILED\|FAIL\)\>'
syn match logVerilogEnd '\c\<\$finish\>\|\<\$stop\>'

" Bracketed severity tags [ERROR], [FATAL], etc.
syn match logBracketFatal '\[\c\(FATAL\|CRIT\|CRITICAL\)\s*\]'
syn match logBracketError '\[\c\(ERROR\|ERR\)\s*\]'
syn match logBracketWarn  '\[\c\(WARN\|WARNING\)\s*\]'
syn match logBracketInfo  '\[\c\(INFO\|NOTE\)\s*\]'

" Highlight Linkings
hi def link logUvmFatal      ErrorMsg
hi def link logUvmError      ErrorMsg
hi def link logUvmWarn       WarningMsg
hi def link logUvmInfo       Type
hi def link logCadenceErr    ErrorMsg
hi def link logCadenceWarn   WarningMsg
hi def link logCadenceInfo   Special
hi def link logViolation     ErrorMsg
hi def link logTimingErr     ErrorMsg
hi def link logBracketFatal  ErrorMsg
hi def link logBracketError  ErrorMsg
hi def link logBracketWarn   WarningMsg
hi def link logBracketInfo   Special
hi def link logVerilogEnd    Statement

" Distinctive Green/Red for Pass/Fail
hi def logEdaPass ctermfg=10 guifg=#b8bb26 gui=bold
hi def logEdaFail ctermfg=9  guifg=#fb4934 gui=bold
