function [r, c, encontrou] = sudokuEncontrarCelula(S)
    encontrou = false;
    r = 1;
    c = 1;
    for i = 1:9
        for j = 1:9
            if S(i, j) == 0
                r = i;
                c = j;
                encontrou = true;
                return
            end
        end
    end
end