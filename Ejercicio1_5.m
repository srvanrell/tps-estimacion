%% Ejercicio 1.5
close all; clear all; clc

t = 0:0.1:1; % instantes de medicion 
x = [1; 1; 1]; % valores verdaderos de x1, x2, x3
m = length(t); % cantidad de mediciones

H = [ones(m,1) sin(10.*t') exp(2 .* t'.^2)]; % matriz de observacion

% y = x(1) + x(2) .* sin(10.*t) + x(3) .* exp(2 .* t.^2);
% Lo siguiente equivale a lo anterior
y = H * x; % mediciones sin error

% mediciones truncadas para simular errores de medición
y1dig = floor(y*10^(1-1))/10^(1-1);    % valores truncados a un digito
y2dig = floor(y*10^(2-1))/10^(2-1);    % valores truncados a dos digitos
y4dig = floor(y*10^(4-1))/10^(4-1);    % valores truncados a cuatro digitos
y6dig = floor(y*10^(6-1))/10^(6-1);    % valores truncados a cuatro digitos


% mediciones con error acomodadas en una misma matriz para automatizar
yNdig = horzcat(y1dig,y2dig,y4dig,y6dig);
Ndig = [1 2 4 6];

for n = 1:4
    yBatch = yNdig(1:3,n); % las tres primeras mediciones para inicializar 
    ySec = yNdig(:,n); % las restantes mediciones para estimacion secuencial

    HBatch = H(1:3,:); % H a partir de los primeros tres instantes
    PBatch = inv(HBatch'*HBatch); % P inicial
    x = zeros(3,m); % valores estimados de x en cada instante k (el inicial se define en k=3)
    errorx = zeros(1,m); % error de los x estimados en cada instante k
    x(:,3) = PBatch * HBatch' * yBatch; % estimacion inicial (k=3)
    
    % Comienza la estimacion secuencial
    Pk = PBatch;
    for kmas1 = 4:m
        k = kmas1 - 1;
        Hkmas1 = H(kmas1,:);
        
        % K_k+1
        Kkmas1 = Pk * Hkmas1' * inv(Hkmas1 * Pk * Hkmas1' + eye(size(Hkmas1,1)));
        % P_k+1
        Pkmas1 = (eye(size(Kkmas1,1)) - Kkmas1 * Hkmas1 ) * Pk;
        % x_k+1
        x(:,kmas1) = x(:,k) + Kkmas1 * (ySec(kmas1) - Hkmas1 * x(:,k));
        
        % guardo el valor de Pkmas1 para la siguiente iteracion
        Pk = Pkmas1;
        % Se calcula el error de las estimaciones actuales
        errorx(kmas1) = norm(ones(size(x(:,kmas1))) - x(:,kmas1));
    end
    
    disp(['Con las mediciones truncadas a ' num2str(Ndig(n)) ...
          ' digitos se obtuvo el siguiente error en la estimacion de x'...
          ' para cada instante k:'])
    disp(errorx)
end

