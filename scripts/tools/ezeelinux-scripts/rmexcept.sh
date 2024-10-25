rmexcept()
{
    files=()
    for pattern in "$@"
    do
        files+=(`find . -maxdepth 1 -type f -not -iname "$pattern"`)
    done

    # filter for duplicates only when more than one pattern provided
    if (($# > 1))
    then
        printf "%s\n" ${files[@]} | sort | uniq -d | xargs rm
    else
        printf "%s\n" ${files[@]} | xargs rm
    fi
}
