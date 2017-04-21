function [] = plotDataNadia( data, ii )

T = data.Ts(ii);
M = 10;

X = data.seq(ii);

xs = 1:T;
%ys = linspace( -3, 3, M);
ys = linspace(min(min(X)), max(max(X)),M);
hold all;
% hIM = imagesc( xs, ys, repmat(data.zTrue(ii), M, 1), [1 max( data.zTrueAll)] );
% set( hIM, 'AlphaData', 0.65 );

for i=1:size(X,1)
plot( xs, X(i,:), 'Color',[rand rand rand],'LineWidth',2);
grid on
end

title( ['Sequence ' num2str(ii)], 'FontSize', 20 );

axis( [1 T ys(1) ys(end)] );

end