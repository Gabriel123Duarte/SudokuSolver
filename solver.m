imOriginal = ajustarImagem('imgs/sudoku2.png');

im = im2bw(imOriginal);

subplot(2, 2, 1);
imshow(im);

% E necessario descobrir os componentes conexos 2 vezes
% A primeira ira me retornar todos cc da imgs, porem, so me interessa os
% quadrados onde podemos inserir numeros, em um total de 81 CCs.
im2 = bwlabel(im);

s = regionprops(im2, 'BoundingBox', 'Centroid', 'Perimeter', 'Area');
componentes = max(im2(:));
media = mean([s(:).Perimeter]);

for i = 1:componentes
    % Removendo os CC baseado na media de valores que tem que ter
    if s(i).Perimeter <= media || s(i).Perimeter >= 2 * media
        im2(im2(:) == i) = 0;
    end
end

% Depois de removido todos os ccs que nao me interessa posso chamar
% novamente e obter somente as casas
im2 = bwlabel(im2);
s = regionprops(im2, 'BoundingBox', 'Centroid', 'Perimeter', 'Area');
componentes = max(im2(:));

subplot(2, 2, 2);
imshow(im);

% Marcando na img os ccs
hold on
for i=1:componentes
rectangle('Position',[s(i).BoundingBox(1) s(i).BoundingBox(2)...
    s(i).BoundingBox(3) ...
    s(i).BoundingBox(4)], 'EdgeColor', 'r');
end
hold off

% E necessario a remocao das linhas do grid para a funcao de OCR encontre as letras
% Duas passadas para remover bordas da img
imAtualizada = im;

if im(1, 1) == 1    
    imAtualizada = bfs(imAtualizada, 1, 1, 0);
end
if imAtualizada(1, 1) == 0
    imAtualizada = bfs(imAtualizada, 1, 1, 1);
end

imAtualizada = ~imAtualizada;

% Encontra todas as casas onde nao possuo numero.
casasVazias = [];

% Para encontrar e simples, basta percorrer todos os CCs e verificar se em
% alguma area e igual a dimensao do BoundingBox
for i = 1:componentes
    if s(i).Area >= s(i).BoundingBox(3) * s(i).BoundingBox(4) - 100
        casasVazias(end + 1) = i;
    end
end

% Baseados nas casas onde foi descoberto que nao tem numero e feito o
% desenho de uma letra I
for i=1:numel(casasVazias)
    centro = int32(s(casasVazias(i)).Centroid);
    imAtualizada(centro(2):centro(2) + 10, centro(1):centro(1) + 6) = 1;
    imAtualizada(centro(2) - 10:centro(2), centro(1):centro(1) + 6) = 1;
end

% Transformo imagem em texto
results = ocr(imAtualizada, 'TextLayout', 'Block');

subplot(2, 2, 3);
imshow(imAtualizada);

subplot(2, 2, 4);
imshow(imAtualizada);
hold on
% Marco somente as casas onde nao tem numero
for i=1:componentes
    if find(casasVazias == i)
        rectangle('Position',[s(i).BoundingBox(1) s(i).BoundingBox(2)...
                s(i).BoundingBox(3) ...
                s(i).BoundingBox(4)], 'EdgeColor', 'r');
    end
end
hold off

% Removo alguns lixos que o OCR utiliza
str = sprintf(results.Text);
newLine = sprintf('\n');
str = strrep(strrep(str, newLine, ''), ' ', '');

matrizAux = [str(1:9)
          str(10:18)
          str(19:27)
          str(28:36)
          str(37:45)
          str(46:54)
          str(55:63)
          str(64:72)
          str(73:81)];
      
matriz = zeros(9, 9);
for i = 1:9
    for j = 1:9
        if matrizAux(i, j) >= '1' && matrizAux(i, j) <= '9'
            matriz(i, j) = matrizAux(i, j) - '0';
        %elseif matrizAux(i, j) == 'l'
        %   matriz(i, j) = 1;
        else
            matriz(i, j) = 0;
        end
    end
end


[~, solucao] = backtrack(matriz);

%%
tic
figure
imAux = imOriginal;
textColor = [255, 0, 0];
%%imshow(imAux);

for i=1:numel(casasVazias)
    idx = casasVazias(i);
       
    textLocation = [round(s(idx).BoundingBox(1)) + 18, round(s(idx).BoundingBox(2)) + 5];               
    textInserter = vision.TextInserter('%d', 'Color', textColor, 'FontSize', 36, 'Location', textLocation);
    
    imAux = step(textInserter, imAux, int32(solucao(idx)));
end

imshow(imAux);
toc
%%
figure
idx = 1;
subImage = imAtualizada(round(s(idx).BoundingBox(2):s(idx).BoundingBox(2)+s(idx).BoundingBox(4)),...
       round(s(idx).BoundingBox(1):s(idx).BoundingBox(1)+s(idx).BoundingBox(3)));
imshow(subImage);
r = ocr(subImage, 'TextLayout', 'Block');
%imwrite(subImage, 'imgs/9.png');
