function im = ajustarImagem(caminho)
    im = imread(caminho);

    % Alterando as resolucao da imagem
    if size(im) ~= 500
        [x, y] = size(im);
        fator = 500 / x;
        im = imresize(im, fator);      
    end
    imwrite(im, 'imAjustada.png');
    im = imread('imAjustada.png');
    delete('imAjustada.png');
end