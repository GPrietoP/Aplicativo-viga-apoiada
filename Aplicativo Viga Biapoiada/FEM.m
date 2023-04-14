% Funções para Resolver MEF
%
% Alunos:                          RA:
% Beatriz de Souza Silva           11024516
% Gabriel Prieto Paris             11052516 
% Haroldo de Oliveira Brito Filho  11110814 
% Ricardo Oliveira da Mata         11036313 
% Lucas Paradinovic Coelho         11201721086 
classdef FEM
    methods (Static)
        function y = BeamElementStiffness(E,I,L)
            % Retorna a matriz de rigidez do elemento.
            y = E*I/(L*L*L) * [12 6*L -12 6*L ; 6*L 4*L*L -6*L 2*L*L ;
                -12 -6*L 12 -6*L ; 6*L 2*L*L -6*L 4*L*L];
        end
        function y = BeamAssemble(K,k,i,j)
            % Retorna a matriz de rigidez global
            K(2*i-1,2*i-1) = K(2*i-1,2*i-1) + k(1,1);
            K(2*i-1,2*i) = K(2*i-1,2*i) + k(1,2);
            K(2*i-1,2*j-1) = K(2*i-1,2*j-1) + k(1,3);
            K(2*i-1,2*j) = K(2*i-1,2*j) + k(1,4);
            K(2*i,2*i-1) = K(2*i,2*i-1) + k(2,1);
            K(2*i,2*i) = K(2*i,2*i) + k(2,2);
            K(2*i,2*j-1) = K(2*i,2*j-1) + k(2,3);
            K(2*i,2*j) = K(2*i,2*j) + k(2,4);
            K(2*j-1,2*i-1) = K(2*j-1,2*i-1) + k(3,1);
            K(2*j-1,2*i) = K(2*j-1,2*i) + k(3,2);
            K(2*j-1,2*j-1) = K(2*j-1,2*j-1) + k(3,3);
            K(2*j-1,2*j) = K(2*j-1,2*j) + k(3,4);
            K(2*j,2*i-1) = K(2*j,2*i-1) + k(4,1);
            K(2*j,2*i) = K(2*j,2*i) + k(4,2);
            K(2*j,2*j-1) = K(2*j,2*j-1) + k(4,3);
            K(2*j,2*j) = K(2*j,2*j) + k(4,4);
            y = K;
        end
        function y = BeamElementShearDiagram(f1, f2, L1, L2)
            % Diagrama de força cortante
            x = [0 ; L1 ; L1 ; L1+L2];
            z = [f1(1) ; -f1(3) ; f2(1) ; -f2(3)];
            shear = plot(x,z,'b');
            set(shear,'LineWidth',[1])
        end
        function y = BeamElementMomentDiagram(f1, f2, L1, L2)
            % Diagrama de momento fletor
            x = [0 ; L1 ; L1 ; L1+L2];
            z = [-f1(2) ; f1(4) ; -f2(2) ; f2(4)];
            moment = plot(x,z,'r');
            set(moment,'LineWidth',[2])
        end
    end
end