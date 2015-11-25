function status = sudokuUseiColuna(S, c, n)
    status = false;
    for r = 1:9
        if S(r, c) == n
            status = true;
            return
        end
    end
end