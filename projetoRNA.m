%{
UNIVERSIDADE FEDERAL DO PAR� - UFPA
INSTITUTO DE TECNOLOGIA - ITEC
FACULDADE DE ENGENHARIA EL�TRICA E BIOM�DICA - FEEB
DISCIPLINA DE INTELIG�NCIA COMPUTACIONAL
PROFESSORA DOUTORA ADRIANA ROSA GARCEZ CASTRO
DISCENTE:   | IGOR DE NARDI - ir.denardi@hotmail.com
            | WOLDSON LEONNE PEREIRA GOMES - wleonne@hotmail.com 
%}

%% %%%%%%%%%%%%%%%%%% IN�CIO DA ROTINA %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Carregar dados e definir vari�veis
 clear all; close all; clc; %limpando a workspace
 data = 'database.xlsx';
 database = xlsread(data);
 CEMEP = database(:,1)'; %concliu o ensino m�dio em escola p�blica 
 GEMEM = database(:,2)'; %gostava de estudar matem�tica ensino m�dio
 PPPE = database(:,3)'; %participou em algum projeto de pesquisa ou extens�o
 IN = [CEMEP;GEMEM;PPPE];
 PC1 = database(:,4)'; %passou em c�lculo 1 de primeira. #sa�da
 %% Cria��o da rede neural
neuro = 5;
net = newff(IN,PC1,neuro);               %criar a rede neural back-propagation.
net.divideFcn='divideind';               %dividir os dados.
net.divideParam.trainInd=[1:200];   %dividir os dados para treinamento.
net.divideParam.valInd=[201;250];   %dividir os dados para valida��o
net.divideParam.testInd=[251:281];  %dividir os dados para testes.
 %% Treinamento e simula��o da rede neural
 a=sim(net,IN); %simula��o da rede neural, sem treinamento
[net,tr] = train(net,IN,PC1); %treinar rede 
ab=sim(net,IN); %simular a rede neural treinada
out_tr = net(IN);
out_testes = [out_tr(251:281)];
out_reais = [IN(251:281)];
figure (1)
plot(out_reais,'or');hold on
plot(out_testes,'^b');hold on
legend ('Reais','RNA');
title('Resultados da rede com dados de testes n�o parametrizado')
 
 %%
  %% ALGORITMO PARA CLUSTER
% vamos tentar uma camada com 2 dimensoes de 64 neuronios dispostos em uma
% grade hexagonal de 8x8 para este exemplo. Em geral, maiores detalhes sao
% obtidos com mais neuronios e mais dimensoes permitem modelar a topologia
% de espa�os de recursos mais complexos.
net_cluster = selforgmap([8 8]);        
view(net_cluster)
%O tamanho da entrada � 0 porque a rede ainda n�o foi configurada para
%corresponder aos nossos dados de entrada. Isso acontecer� quando a rede
%for treinada.

%Agora a rede est� pronta para ser otimizada com o treinamento. A
%ferramenta de treinamento de RNA mostra a rede sendo treinada e 
%os algoritmos usados para trein�-la. Tamb�m exibe o estado de treinamento
%durante o treinamento e os crit�rios que interrompem o treinamento ser�o
%destacados em verde 

%Os bot�es na parte inferior abrem gr�ficos �teis que podem ser abertos
%durante e ap�s o treinamento 
[net_cluster,tr_cluster] = train(net_cluster, IN);
nntraintool
%Aqui o mapa de auto-organiza��o � usado para calcular os vetores de classe
%de cada uma das entradas de treinamento. Essas classifica��es cobrem o
%espa�os de recursos preenchido pelas classes conhecidas e agora podem ser
%usadas para classificar novas classes de acordo. A sa�da da rede ser� uma
%matriz 64x150, onde cada n-coluna representa o k-cluster para cada vetor
%de entrada com um 1 em seu primeiro elemento k.

%A fun��o vec2ind retorna o �ndice do neur�nio com uma sa�da de 1, para
%cada vetor. Os �ndices v�o de 1 a 64 para os 64 clusters representados
%pelos 64 neur�nios.
%%
y = net_cluster(IN);
cluster_index = vec2ind(y);

%plotsomhits calcula as classes para cada categoria e mostra o n�mero de
%categoria
%em cada classe. �reas de neur�nios com grande n�mero de ocorrencias
%indicam classes representando regi�es altamente populosas semelhantes do
%espa�o de recursos. Considerando que �reas com poucos hits indicam regioes
%pouco povoadas do espa�o de recursos 

figure(2)
plotsomhits(net_cluster,IN)

%plotsomnd mostra quao distante (em termos de distancia Euclidiana) cada
%classe de neuronio � de seus vizinhos. Conex�es que s�o brilhantes indicam
%areas altamente conectadas do espa�o de entrada. Enquanto que conex�es
%escuras indicam classes representando regi�es do espa�o de recursos que
%est�o distantes, com poucas ou nenhuma classe entre elas

%Bordas longas de conex�es escuras que separam grandes regi�es do espa�o de
%entrada indicam que as classes de cada lado da borda representam clases
%com recursos muito diferentes.

figure(3)
plotsomnd(net_cluster)
%%
outputs = net(IN);
outputs_test = [outputs(251:281)];

i = 0;

%parametriza��o do teste
for i = 1:30
if outputs_test(i) > 0.5
    outputs_test(i) = 1;
elseif outputs_test(i) < 0.5
   outputs_test(i) = 0;
end
end
figure (4)
t = [1:31];
PC1_test = [PC1(251:281)];
plot(t,outputs_test,'o')
hold on
plot(t,PC1_test,'g*')
hold on
legend ('Reais','RNA');
title('Resultados da rede com dados de testes parametrizado')
 
%contagem dos acertos
cont = 0;
for i = 1:31
    if outputs_test(i) == PC1_test(i)
        cont = cont + 1;
    end
end

%% erro total
e = PC1-outputs;
erro = (e*e')/length(e);
acuracia = 1 - erro;
    disp('Erro n�o parametrizado: ');
    disp(erro)
    disp('N�mero de neuronios: ');
    disp(neuro)
    disp('Acur�cia da rede neural n�o parametrizada: ');
    disp(num2str(acuracia*100))
%% erro de testes
disp('====================== TESTES =====================================')
e_testes = out_reais-out_testes;
erro_testes = (e_testes*e_testes')/length(e_testes);
acuracia_testes = 1 - erro_testes;
   disp('Erro testes n�o parametrizados: ');
    disp(erro_testes)
   disp('N�mero de neuronios: ');
    disp(neuro)
   disp('Acur�cia da rede neural com testes n�o parametrizados: ');
    disp(num2str(acuracia_testes*100))
   disp('Acur�cia dos testes parametrizados: ')
   disp((cont*100)/31)
    erro_parametrizado = 100 - ((cont*100)/31);
   disp('erro testes parametrizado: ')
    disp(erro_parametrizado)
%% Gr�fico das vari�veis de desempenho
figure (5);
set (gcf, 'units', 'normalized', 'outerposition', [0 0 1 1]); % Maximinizar figura.
%erro= erro total
%acuracia = acuracia total
%erro_testes = erro de testes
%acuracia_testes = acuracia dos testes
%cont=numero de acertos nos testes
%erro_parametrizado = erro ap�s parametriza��o


FIT_FK = [erro;acuracia;erro_testes;acuracia_testes;((cont*100)/31);erro_parametrizado];
plot(1,erro*100,'or','LineWidth',8);hold on
plot(2,acuracia*100,'^g','LineWidth',8);hold on
plot(3,erro_testes*100,'*m','LineWidth',8);hold on
plot(4,acuracia_testes*100,'xc','LineWidth',8);hold on
plot(5,((cont*100)/31),'sb','LineWidth',8);hold on
plot(6,erro_parametrizado,'*k','LineWidth',8);hold on
set(gca,'xtick',[1:1:6]); 
legend('erro total(%)','acuracia total(%)','erro de testes(%)','acuracia dos testes(%)',...
    'acur�cia testes parametrizados(%)','erro parametrizado(%)');
title('Vari�veis de desempenho da Rede Neural');





%% fig 6 modelo competitivo

% De aprendizagem competitiva
% Neur�nios em uma camada competitiva aprendem a representar diferentes regi�es do
% de espa�o de entrada onde os vetores de entrada ocorrem.
%

%%
% P � um conjunto de pontos de dados de teste, mas agrupados. Aqui o
% pontos de dados s�o plotados.
%
% Uma rede competitiva ser� usada para classificar esses pontos em
% classes.
limites = [0 1; 0 1];  % Centros de cluster para estarem nesses limites
clusters = 2;          % qtd clusters
pontos = 31;           % N�mero de pontos em cada cluster
dp_c = 0.05;        % Desvio padr�o de cada cluster.

x1 = [database(1:250,1)' ;database(1:250,2)' ;database(1:250,3)'];
figure(6)
% Plot entradas X.
plot(x1(1,:),'+r');
plot(x1(2,:),'og');hold on
plot(x1(3,:),'*y');hold on
title('Vetores de entrada');

%%
% Aqui COMPETLAYER leva dois argumentos, o n�mero de neur�nios e o
% taxa de Aprendizagem.
%
% Podemos configurar as entradas de rede (normalmente feitas automaticamente
% de TRAIN) e plotar os vetores iniciais de peso para ver sua tentativa de
% classifica��o.
%
% Os vetores de peso (o's) ser�o treinados para que ocorram centrados em
% clusters de vetores de entrada (+ 's)

net2 = competlayer(2,.1);
net2 = configure(net2,x1);
w = net2.IW{1};
figure(7)
plot(x1(1,:),'+r');
plot(x1(2,:),'+r');hold on;
plot(x1(3,:),'+r');hold on;

circles = plot(w(:,1),w(:,2),'ob');


%%
% Defina o n�mero de �pocas para treinar antes de parar e treinar esta competi��o
% layer (pode demorar alguns segundos).
%
% Plotar os pesos de camada atualizados no mesmo gr�fico
net.trainParam.epochs = 7;
net = train(net,x1);
w = net.IW{1};
delete(circles);
plot(w(:,1),w(:,2),'ob');
plot(w(:,3),'ob');hold on

%%
% Agora podemos usar a camada competitiva como um classificador, onde cada neur�nio
% corresponde a uma categoria diferente. Aqui n�s definimos um vetor de entrada
% X1 como [0; 0,2].
%
% A sa�da Y, indica qual neur�nio est� respondendo e, portanto, qual classe
% a entrada pertence

testes1 = [database(251:281,1)' ;database(251:281,2)' ;database(251:281,3)'];
y1 = net(testes1);
figure(8)
for i=1:31
plot(i,y1(i),'ok');hold on;
end
title('RNA estrutura competitiva - sa�da nao parametrizada')
%parametriza��o do teste
for i = 1:31
if y1(i) > 0.5
    y1(i) = 1;
elseif y1(i) < 0.5
   y1(i) = 0;
end
end

 
%contagem dos acertos
cont2 = 0;
for i = 1:31
    if y1(i) == PC1_test(i)
        cont2 = cont2 + 1;
    end
end

disp('de 31 amostras de testes, a RNAA competitiva acertou:')
disp(cont2)
disp('Acur�cia dos testes parametrizados(estrutura competitiva): ')
disp((cont2*100)/31)

figure(9)
t2=(1:31);
plot(t2,y1,'ok',t2,PC1_test,'*m');
title('RNA estrutura competitiva - sa�da parametrizada')
legend('Estrutura Competitiva RNAA','Saida Real')

ar1=(cont*100)/31;
er1=100-ar1;
ar2=(cont2*100)/31;
er2=100-ar2;
r1=[ar1;er1]';
r2=[ar2;er2]';
figure(10)
subplot(2,1,1)
pie3(r1)
title('MLP RNA')
legend('acur�cia','erro');
subplot(2,1,2)
pie3(r2)
title('Estrutura Competitiva');
legend('acur�cia','erro');
