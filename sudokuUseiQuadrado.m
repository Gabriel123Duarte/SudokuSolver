function status = sudokuUseiQuadrado(S, sR, sC, n)
    status = false;
    for r = 1:3
        for c = 1:3
            if S(r + sR, c + sC) == n
                status = true;
                return
            end
        end
    end
end