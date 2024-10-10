hook global BufCreate .*\.(ll) %{
    set-option buffer filetype llvm
}


hook -group llvm-highlight global WinSetOption filetype=llvm %{
    add-highlighter window/llvm ref llvm
    hook -once -always window WinSetOption filetype=.* %{ remove-highlighter window/llvm }
}

add-highlighter shared/llvm regions
add-highlighter shared/llvm/code default-region group
add-highlighter shared/llvm/arithmetic region -recurse \(.*?\( (\$|(?<=for)\h*)\(\( \)\) group
add-highlighter shared/llvm/double_string region  %{(?<!\\)(?:\\\\)*\K"} %{(?<!\\)(?:\\\\)*"} group
add-highlighter shared/llvm/single_string region %{(?<!\\)(?:\\\\)*\K'} %{'} fill string
add-highlighter shared/llvm/comment region (?<!\\)(?:\\\\)*(?:^|\h)\K\; '$' fill comment

add-highlighter shared/llvm/arithmetic/expansion ref sh/double_string/expansion
add-highlighter shared/llvm/double_string/fill fill string

evaluate-commands %sh{
    keywords="i32 i16 i8 i1"

    builtins="define declare call store"

    join() { sep=$2; eval set -- $1; IFS="$sep"; echo "$*"; }

    printf %s\\n "add-highlighter shared/llvm/code/ regex (?<!-)\b($(join "${keywords}" '|'))\b(?!-) 0:keyword"

    printf %s "add-highlighter shared/llvm/code/builtin regex (?<!-)\b($(join "${builtins}" '|'))\b(?!-) 0:builtin"
}

add-highlighter shared/llvm/code/values regex (\s[0-9]*) 0:keyword
add-highlighter shared/llvm/code/negative_values regex (\s-[0-9]*) 0:keyword
add-highlighter shared/llvm/code/register regex (%[0-9a-zA-Z.]*) 0:keyword
