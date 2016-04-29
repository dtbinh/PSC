%% Joint Limits
limiti_giunto_inf = [-2.9671   -3.0543    -1.5708    -3.6652    -2.2689    -43.9823]; %m m radx6
limiti_giunto_sup = [2.9671    1.1345     1.3963     3.6652     2.2689     50.2655]; %m m radx6

scene_dim = 1.2;
z_limit = 0.3;
G1 = [];
G2 = [];
min_v1 = [];
max_v1 = [];
min_v2 = [];
max_v2 = [];
l = 1;
step = 0.2;
isBreak = false;
for i=limiti_giunto_inf(1):step:limiti_giunto_sup(1)
    for j=limiti_giunto_inf(2):step:limiti_giunto_sup(2)
        for k=limiti_giunto_inf(3):step:limiti_giunto_sup(3)
            q = [0,0,i,j,k,0,0,0];
            [p] = cindir(q, 'ZYZ');
            if(abs(p(1))>= scene_dim || abs(p(2))>= scene_dim || p(3) <= z_limit)
              isBreak = true;
              break;
            end
            G1 = [G1; k];
        end
        min_v1 = [min_v1, min(G1)];
        max_v1 = [max_v1, max(G1)];
        G1 = [];
        if(isBreak)
           break;
        end
        G2 = [G2; j];
    end
    min_v2 = [min_v2, min(G2)];
    max_v2 = [max_v2, max(G2)];
    G2 = [];
    isBreak = false;
end
disp('Riga1: Minimo, Riga2: Massimo, Colonna1: Giunto1, Colonna2: Giunto2, Colonna3: Giunto3');
lim = [max(min_v2), max(min_v1);
       min(max_v2), min(max_v1)]

for i=limiti_giunto_inf(1):step:limiti_giunto_sup(1)
    for j=lim(1,1):step:lim(2,1)
        for k=lim(2,2):step:lim(1,2)
            q = [0,0,i,j,k,0,0,0];
            [p, ~, ~, ~] = cindir(q, 'ZYZ');
            if(abs(p(1))>= scene_dim || abs(p(2))>= scene_dim || p(3) <= z_limit)
              isBreak = true;
              break;
            end
        end
        if(isBreak)
           break;
        end
    end
    if(isBreak)
       break;
    end
end
if(isBreak)
    disp('fail');
else
    disp('success');
end

% 
% JOINT = [0 0 0 lim(1,1) lim(2,2) 0 0 0];
% SendPoseToVRep(JOINT);
% pause
% JOINT = [0 0 0 lim(2,1) lim(1,2) 0 0 0];
% SendPoseToVRep(JOINT);


