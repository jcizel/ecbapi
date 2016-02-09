rir_data %>>% names ->
    a
rir_static %>>% names %>>% gsub(pattern = ".+\\[(CL_)(.+)\\]", replacement = '\\2') ->
    b

a[a %in% b] %>>% length
a %>>% length


rir_data

a[!a %in% b] 


rir_static %>>% names
b[!b %in% a]
