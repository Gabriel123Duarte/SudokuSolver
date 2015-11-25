function caminho = sudokuCaminho(S, r, c, n)
    diffr =  mod(r, 3);
    if diffr == 0
        diffr = 3;
    end
    diffc =  mod(c, 3);
    if diffc == 0
        diffc = 3;
    end
    caminho = ~sudokuUseiLinha(S, r, n) && ~sudokuUseiColuna(S, c, n) && ~sudokuUseiQuadrado(S, r - diffr, c - diffc, n);
end