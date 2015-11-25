function status = sudokuUseiLinha(S, r, n)
    status = false;
    for c = 1:9
        if S(r, c) == n
            status = true;
            return
        end
    end
end