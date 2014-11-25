%% Ejercicio 1.4
close all; clear all; clc

t = 0:0.1:1; % instantes de medicion 
x = [1; 1; 1]; % valores verdaderos de x1, x2, x3
m = length(t); % cantidad de mediciones

H = [ones(m,1) sin(10.*t') exp(2 .* t'.^2)]; % matriz de observacion

% y = x(1) + x(2) .* sin(10.*t) + x(3) .* exp(2 .* t.^2);
% Lo siguiente equivale a lo anterior
y = H * x; % mediciones sin error

% mediciones truncadas (simulando errores de medición)
y1dig = floor(y*10^(1-1))/10^(1-1);    % valores truncados a un digito
y2dig = floor(y*10^(2-1))/10^(2-1);    % valores truncados a dos digitos
y4dig = floor(y*10^(4-1))/10^(4-1);    % valores truncados a cuatro digitos
y6dig = floor(y*10^(6-1))/10^(6-1);    % valores truncados a cuatro digitos

% norma del error en las mediciones
error1dig = norm(y - y1dig);
error2dig = norm(y - y2dig);
error4dig = norm(y - y4dig);
error6dig = norm(y - y6dig);

% Estimación de las x a partir de las mediciones con distinto ruido
x1dig = inv(H'*H) * H' * y1dig;
x2dig = inv(H'*H) * H' * y2dig;
x4dig = inv(H'*H) * H' * y4dig;
x6dig = inv(H'*H) * H' * y6dig;

% Error en las estimaciones de x1, x2 y x3 para comparar con los valores
% reales [1; 1; 1]
errorx1dig = norm(x - x1dig);
errorx2dig = norm(x - x2dig);
errorx4dig = norm(x - x4dig);
errorx6dig = norm(x - x6dig);

disp(['Con las mediciones truncadas a 1 digito se obtuvo el siguiente ' ...
      'error en la estimacion de x:'])
disp(errorx1dig)
disp(['Con las mediciones truncadas a 2 digitos se obtuvo el siguiente '...
      'error en la estimacion de x:'])
disp(errorx2dig)
disp(['Con las mediciones truncadas a 4 digitos se obtuvo el siguiente '...
      'error en la estimacion de x:'])
disp(errorx4dig)
disp(['Con las mediciones truncadas a 6 digitos se obtuvo el siguiente '...
      'error en la estimacion de x:'])
disp(errorx6dig)


% Grafica de los valores medidos con y sin error
plot(t,y,t,y1dig,t,y2dig,t,y4dig,t,y6dig)
legend('original','1 dig','2 dig','4 dig','6 dig')
