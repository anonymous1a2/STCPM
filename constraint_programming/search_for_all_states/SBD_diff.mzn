% Use this editor as a MiniZinc scratch book
include "globals.mzn";
include "chuffed.mzn";

int :nr; % Number of Rounds
int :wordsize=64; % word size
int :bit=320; % Number of bits
int: R = nr-1;% just because starting R from 1 doesnt work!
array [0..R,0..4, 0..wordsize-1] of var 0..1: statestart; % before permutation

array [0..R,0..4, 0..wordsize-1] of var 0..1: state_east;% after east
array [0..R,0..4, 0..wordsize-1] of var 0..1: state_F;

array [0..R,0..2, 0..wordsize-1] of var 0..1: state_E;% E0,E1,Eall 

array [0..R,0..4, 0..wordsize-1] of var 0..1: state_Aj;% before west (could be combined with west?)


array [0..R,0..4, 0..wordsize-1] of var 0..1: stateend; % after permutation
array [0..64*(R+1)-1] of var {0,100,200,241,300,400}: prb; % probabilities
var int: obj; % objective value
constraint obj <= 32000;
constraint obj >= 1;
constraint obj = sum(prb); % Objective Function
array [0..R,0..63] of var bool: sboxes;

% Forward Permutation

% Forward Substitution
constraint forall (r in 0..R, i in 0..wordsize-1) (
             table([statestart[r,0,i],statestart[r,1,i], statestart[r,2,i], statestart[r,3,i], statestart[r,4,i],
                    stateend[r,0,i],stateend[r,1,i], stateend[r,2,i], stateend[r,3,i], stateend[r,4,i],
              prb[64*(r)+i]], DDT));

% east   
constraint forall (r in 0..R-1) (
let {
    array [0..wordsize-1] of var 0..1:tmp=array1d(0..wordsize-1,[stateend[r,0,j] | j in 0..wordsize-1]),
    array [0..wordsize-1] of var 0..1:tmpb=array1d(0..wordsize-1,[state_east[r,0,j] | j in 0..wordsize-1])
}
in Xor2(tmp,tmpb)
);

constraint forall (r in 0..R-1) (
let {
    array [0..wordsize-1] of var 0..1:tmp=RRot(array1d(0..wordsize-1,[stateend[r,1,j] | j in 0..wordsize-1]),61),
    array [0..wordsize-1] of var 0..1:tmpb=array1d(0..wordsize-1,[state_east[r,1,j] | j in 0..wordsize-1])
}
in Xor2(tmp,tmpb)
);

constraint forall (r in 0..R-1) (
let {
    array [0..wordsize-1] of var 0..1:tmp=RRot(array1d(0..wordsize-1,[stateend[r,2,j] | j in 0..wordsize-1]),49),
    array [0..wordsize-1] of var 0..1:tmpb=array1d(0..wordsize-1,[state_east[r,2,j] | j in 0..wordsize-1])
}
in Xor2(tmp,tmpb)
);

constraint forall (r in 0..R-1) (
let {
    array [0..wordsize-1] of var 0..1:tmp=RRot(array1d(0..wordsize-1,[stateend[r,3,j] | j in 0..wordsize-1]),13),
    array [0..wordsize-1] of var 0..1:tmpb=array1d(0..wordsize-1,[state_east[r,3,j] | j in 0..wordsize-1])
}
in Xor2(tmp,tmpb)
);

constraint forall (r in 0..R-1) (
let {
    array [0..wordsize-1] of var 0..1:tmp=RRot(array1d(0..wordsize-1,[stateend[r,4,j] | j in 0..wordsize-1]),19),
    array [0..wordsize-1] of var 0..1:tmpb=array1d(0..wordsize-1,[state_east[r,4,j] | j in 0..wordsize-1])
}
in Xor2(tmp,tmpb)
);

% E0 
constraint forall (r in 0..R-1) (
let {
    array [0..wordsize-1] of var 0..1:tmp=array1d(0..wordsize-1,[state_east[r,0,j] | j in 0..wordsize-1]),
    array [0..wordsize-1] of var 0..1:tmpb=array1d(0..wordsize-1,[state_east[r,1,j] | j in 0..wordsize-1]),
    array [0..wordsize-1] of var 0..1:tmpc=array1d(0..wordsize-1,[state_east[r,2,j] | j in 0..wordsize-1]),
    array [0..wordsize-1] of var 0..1:tmpd=array1d(0..wordsize-1,[state_east[r,3,j] | j in 0..wordsize-1]),
    array [0..wordsize-1] of var 0..1:tmpe=array1d(0..wordsize-1,[state_east[r,4,j] | j in 0..wordsize-1]),
    array [0..wordsize-1] of var 0..1:tmpf=array1d(0..wordsize-1,[state_E[r,0,j] | j in 0..wordsize-1])
}
in Xor6(tmp,tmpb,tmpc,tmpd,tmpe,tmpf)
);


% E1
constraint forall (r in 0..R-1) (
let {
    array [0..wordsize-1] of var 0..1:tmp=RRot(array1d(0..wordsize-1,[state_east[r,0,j] | j in 0..wordsize-1]),6),
    array [0..wordsize-1] of var 0..1:tmpb=RRot(array1d(0..wordsize-1,[state_east[r,1,j] | j in 0..wordsize-1]),10),
    array [0..wordsize-1] of var 0..1:tmpc=RRot(array1d(0..wordsize-1,[state_east[r,2,j] | j in 0..wordsize-1]),27),
    array [0..wordsize-1] of var 0..1:tmpd=RRot(array1d(0..wordsize-1,[state_east[r,3,j] | j in 0..wordsize-1]),41),
    array [0..wordsize-1] of var 0..1:tmpe=RRot(array1d(0..wordsize-1,[state_east[r,4,j] | j in 0..wordsize-1]),50),
    array [0..wordsize-1] of var 0..1:tmpf=array1d(0..wordsize-1,[state_E[r,1,j] | j in 0..wordsize-1])
}
in Xor6(tmp,tmpb,tmpc,tmpd,tmpe,tmpf)
);





% Eall
constraint forall (r in 0..R-1) (
let {
    array [0..wordsize-1] of var 0..1:tmp=array1d(0..wordsize-1,[state_E[r,0,j] | j in 0..wordsize-1]),
    array [0..wordsize-1] of var 0..1:tmpb=RRot(array1d(0..wordsize-1,[state_E[r,0,j] | j in 0..wordsize-1]),1),
    array [0..wordsize-1] of var 0..1:tmpc=array1d(0..wordsize-1,[state_E[r,2,j] | j in 0..wordsize-1]),
}
in Xor3(tmp,tmpb,tmpc)
);




% F0
constraint forall (r in 0..R-1) (
let {
    array [0..wordsize-1] of var 0..1:tmp=RRot(array1d(0..wordsize-1,[state_E[r,1,j] | j in 0..wordsize-1]),6),
    array [0..wordsize-1] of var 0..1:tmpb=RRot(array1d(0..wordsize-1,[state_E[r,1,j] | j in 0..wordsize-1]),42),
    array [0..wordsize-1] of var 0..1:tmpc=array1d(0..wordsize-1,[state_F[r,0,j] | j in 0..wordsize-1]),
}
in Xor3(tmp,tmpb,tmpc)
);

% F1
constraint forall (r in 0..R-1) (
let {
    array [0..wordsize-1] of var 0..1:tmp=RRot(array1d(0..wordsize-1,[state_E[r,1,j] | j in 0..wordsize-1]),10),
    array [0..wordsize-1] of var 0..1:tmpb=RRot(array1d(0..wordsize-1,[state_E[r,1,j] | j in 0..wordsize-1]),46),
    array [0..wordsize-1] of var 0..1:tmpc=array1d(0..wordsize-1,[state_F[r,1,j] | j in 0..wordsize-1]),
}
in Xor3(tmp,tmpb,tmpc)
);

% F2
constraint forall (r in 0..R-1) (
let {
    array [0..wordsize-1] of var 0..1:tmp=RRot(array1d(0..wordsize-1,[state_E[r,1,j] | j in 0..wordsize-1]),27),
    array [0..wordsize-1] of var 0..1:tmpb=RRot(array1d(0..wordsize-1,[state_E[r,1,j] | j in 0..wordsize-1]),63),
    array [0..wordsize-1] of var 0..1:tmpc=array1d(0..wordsize-1,[state_F[r,2,j] | j in 0..wordsize-1]),
}
in Xor3(tmp,tmpb,tmpc)
);

% F3
constraint forall (r in 0..R-1) (
let {
    array [0..wordsize-1] of var 0..1:tmp=RRot(array1d(0..wordsize-1,[state_E[r,1,j] | j in 0..wordsize-1]),41),
    array [0..wordsize-1] of var 0..1:tmpb=RRot(array1d(0..wordsize-1,[state_E[r,1,j] | j in 0..wordsize-1]),13),
    array [0..wordsize-1] of var 0..1:tmpc=array1d(0..wordsize-1,[state_F[r,3,j] | j in 0..wordsize-1]),
}
in Xor3(tmp,tmpb,tmpc)
);


% F4
constraint forall (r in 0..R-1) (
let {
    array [0..wordsize-1] of var 0..1:tmp=RRot(array1d(0..wordsize-1,[state_E[r,1,j] | j in 0..wordsize-1]),50),
    array [0..wordsize-1] of var 0..1:tmpb=RRot(array1d(0..wordsize-1,[state_E[r,1,j] | j in 0..wordsize-1]),22),
    array [0..wordsize-1] of var 0..1:tmpc=array1d(0..wordsize-1,[state_F[r,4,j] | j in 0..wordsize-1]),
}
in Xor3(tmp,tmpb,tmpc)
);


%row0 Aj
constraint forall (r in 0..R-1) (
let {
    array [0..wordsize-1] of var 0..1:tmp=array1d(0..wordsize-1,[state_east[r,0,j] | j in 0..wordsize-1]),
    array [0..wordsize-1] of var 0..1:tmpb=RRot(array1d(0..wordsize-1,[state_E[r,2,j] | j in 0..wordsize-1]),26),
    array [0..wordsize-1] of var 0..1:tmpc=RRot(array1d(0..wordsize-1,[state_F[r,0,j] | j in 0..wordsize-1]),26),
    array [0..wordsize-1] of var 0..1:tmpd=array1d(0..wordsize-1,[statestart[r+1,0,j] | j in 0..wordsize-1])
}
in Xor4(tmp,tmpb,tmpc,tmpd)
);



%row1 Aj
constraint forall (r in 0..R-1) (
let {
    array [0..wordsize-1] of var 0..1:tmp=array1d(0..wordsize-1,[state_east[r,1,j] | j in 0..wordsize-1]),
    array [0..wordsize-1] of var 0..1:tmpb=RRot(array1d(0..wordsize-1,[state_E[r,2,j] | j in 0..wordsize-1]),26),
    array [0..wordsize-1] of var 0..1:tmpc=RRot(array1d(0..wordsize-1,[state_F[r,1,j] | j in 0..wordsize-1]),26),
    array [0..wordsize-1] of var 0..1:tmpd=RRot(array1d(0..wordsize-1,[statestart[r+1,1,j] | j in 0..wordsize-1]),3)
}
in Xor4(tmp,tmpb,tmpc,tmpd)
);



%row2 Aj
constraint forall (r in 0..R-1) (
let {
    array [0..wordsize-1] of var 0..1:tmp=array1d(0..wordsize-1,[state_east[r,2,j] | j in 0..wordsize-1]),
    array [0..wordsize-1] of var 0..1:tmpb=RRot(array1d(0..wordsize-1,[state_E[r,2,j] | j in 0..wordsize-1]),26),
    array [0..wordsize-1] of var 0..1:tmpc=RRot(array1d(0..wordsize-1,[state_F[r,2,j] | j in 0..wordsize-1]),26),
    array [0..wordsize-1] of var 0..1:tmpd=RRot(array1d(0..wordsize-1,[statestart[r+1,2,j] | j in 0..wordsize-1]),15)
}
in Xor4(tmp,tmpb,tmpc,tmpd)
);


%row3 Aj
constraint forall (r in 0..R-1) (
let {
    array [0..wordsize-1] of var 0..1:tmp=array1d(0..wordsize-1,[state_east[r,3,j] | j in 0..wordsize-1]),
    array [0..wordsize-1] of var 0..1:tmpb=RRot(array1d(0..wordsize-1,[state_E[r,2,j] | j in 0..wordsize-1]),26),
    array [0..wordsize-1] of var 0..1:tmpc=RRot(array1d(0..wordsize-1,[state_F[r,3,j] | j in 0..wordsize-1]),26),
    array [0..wordsize-1] of var 0..1:tmpd=RRot(array1d(0..wordsize-1,[statestart[r+1,3,j] | j in 0..wordsize-1]),51)
}
in Xor4(tmp,tmpb,tmpc,tmpd)
);


%row4 Aj
constraint forall (r in 0..R-1) (
let {
    array [0..wordsize-1] of var 0..1:tmp=array1d(0..wordsize-1,[state_east[r,4,j] | j in 0..wordsize-1]),
    array [0..wordsize-1] of var 0..1:tmpb=RRot(array1d(0..wordsize-1,[state_E[r,2,j] | j in 0..wordsize-1]),26),
    array [0..wordsize-1] of var 0..1:tmpc=RRot(array1d(0..wordsize-1,[state_F[r,4,j] | j in 0..wordsize-1]),26),
    array [0..wordsize-1] of var 0..1:tmpd=RRot(array1d(0..wordsize-1,[statestart[r+1,4,j] | j in 0..wordsize-1]),45)
}
in Xor4(tmp,tmpb,tmpc,tmpd)
);


% eliminating symmetries
% constraint checkActive([statestart[2,i,63] | i in 0..4]) = 1; 
% search strategy
ann: search_ann;
search_ann = seq_search([
    int_search(row(sboxes,2), random_order, indomain_min, complete),
    int_search(row(sboxes,1), random_order, indomain_min, complete),
    int_search(row(sboxes,0), random_order, indomain_min, complete),
    int_search(array1d(prb), occurrence, indomain_min, complete)]);


constraint forall(k in 0..R, j in 0..63) (sboxes[k,j] = checkActive([statestart[k,i,j] | i in 0..4]));
solve :: restart_constant(10000)
:: search_ann minimize obj;



%change to left
% Right rotation of X by val positions
function array[0..wordsize-1] of var 0..1: RRot(array[0..(wordsize-1)] of var 0..1: X, int: val)=
array1d(0..wordsize-1, [X[(j+val) mod wordsize] | j in 0..wordsize-1]);

% XOR of 4 arrays equals zero
predicate Xor4(
  array[0..wordsize-1] of var 0..1: a, 
  array[0..wordsize-1] of var 0..1: b,
  array[0..wordsize-1] of var 0..1: c, 
  array[0..wordsize-1] of var 0..1: d)=
    forall(i in 0..wordsize-1)(a[i]+b[i]+c[i]+d[i] in {0,2,4});

    
predicate Xor3(
  array[0..wordsize-1] of var 0..1: a, 
  array[0..wordsize-1] of var 0..1: b,
  array[0..wordsize-1] of var 0..1: c)=
    forall(i in 0..wordsize-1)(a[i]+b[i]+c[i] in {0,2});
           
             
    
% XOR of 2 arrays equals zero
predicate Xor2(
  array[0..wordsize-1] of var 0..1: a, 
  array[0..wordsize-1] of var 0..1: b,)=
    forall(i in 0..wordsize-1)(a[i]+b[i] in {0,2});
    
% XOR of 5 arrays equals zero
predicate Xor5(
  array[0..wordsize-1] of var 0..1: a, 
  array[0..wordsize-1] of var 0..1: b,
  array[0..wordsize-1] of var 0..1: c, 
  array[0..wordsize-1] of var 0..1: d,
  array[0..wordsize-1] of var 0..1: e)=
    forall(i in 0..wordsize-1)(a[i]+b[i]+c[i]+d[i]+e[i] in {0,2,4});
    

  % XOR of 6 arrays equals zero
predicate Xor6(
  array[0..wordsize-1] of var 0..1: a, 
  array[0..wordsize-1] of var 0..1: b,
  array[0..wordsize-1] of var 0..1: c, 
  array[0..wordsize-1] of var 0..1: d,
  array[0..wordsize-1] of var 0..1: e,
  array[0..wordsize-1] of var 0..1: f)=
    forall(i in 0..wordsize-1)(a[i]+b[i]+c[i]+d[i]+e[i]+f[i] in {0,2,4,6});  

% checking activeness of each Sbox
predicate checkActive(array[int] of var 0..1: a) = 
            let { int: len = length(a) }
          in
            sum(i in 1..len) (a[i]) > 0;

% for printing purposes only
array[0..R] of var int: Sboxes;
constraint forall (k in 0..R)(
  Sboxes[k] = sum(j in 0..63)(bool2int(checkActive([statestart[k,i,j] | i in 0..4])))
);

output [
        if i==0 then "\n Round " ++show(r) ++"\n beforeSB : \n" else "" endif 
        ++ if i<5 then show([statestart[r,i,j] | j in 0..wordsize-1]) ++ " \n" else "" endif ++
        if i==4 then "after SB : \n" else "" endif 
         ++ if i>=4 then show([stateend[r,i-4,j] | j in 0..wordsize-1]) ++ " \n" else "" endif   | r in 0..R, i in 0..8]  
         ++ [show([Sboxes[i] | i in 0..R]) ++ " " ++ show(obj) ++ "\n"] ++ [show([prb[i] | i in 64*k..64*(k+1)-1]) ++ " " ++ show(sum([prb[i] | i in 64*k..64*(k+1)-1])) ++ "\n" | k in 0..R ];
array [1..392, 1..11] of int : DDT = array2d(1..392,1..11,[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 300, 0, 0, 0, 0, 1, 0, 0, 0, 1, 0, 300, 0, 0, 0, 0, 1, 0, 0, 0, 1, 1, 400, 0, 0, 0, 0, 1, 0, 0, 1, 0, 0, 400, 0, 0, 0, 0, 1, 0, 0, 1, 1, 0, 400, 0, 0, 0, 0, 1, 0, 1, 0, 0, 0, 300, 0, 0, 0, 0, 1, 0, 1, 0, 0, 1, 300, 0, 0, 0, 0, 1, 0, 1, 0, 1, 0, 400, 0, 0, 0, 0, 1, 0, 1, 1, 0, 0, 400, 0, 0, 0, 0, 1, 0, 1, 1, 1, 0, 400, 0, 0, 0, 0, 1, 1, 0, 0, 0, 1, 400, 0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 400, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1, 300, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 400, 0, 0, 0, 1, 0, 0, 0, 0, 1, 1, 400, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 300, 0, 0, 0, 1, 0, 0, 0, 1, 0, 1, 400, 0, 0, 0, 1, 0, 0, 0, 1, 1, 0, 400, 0, 0, 0, 1, 0, 0, 0, 1, 1, 1, 400, 0, 0, 0, 1, 0, 0, 1, 1, 0, 0, 400, 0, 0, 0, 1, 0, 1, 0, 0, 0, 0, 300, 0, 0, 0, 1, 0, 1, 0, 0, 0, 1, 400, 0, 0, 0, 1, 0, 1, 0, 1, 0, 0, 300, 0, 0, 0, 1, 0, 1, 1, 0, 0, 0, 400, 0, 0, 0, 1, 1, 0, 0, 0, 1, 0, 300, 0, 0, 0, 1, 1, 0, 0, 1, 0, 1, 400, 0, 0, 0, 1, 1, 0, 0, 1, 1, 0, 400, 0, 0, 0, 1, 1, 0, 0, 1, 1, 1, 300, 0, 0, 0, 1, 1, 0, 1, 0, 0, 0, 400, 0, 0, 0, 1, 1, 0, 1, 0, 1, 1, 400, 0, 0, 0, 1, 1, 1, 0, 1, 0, 0, 400, 0, 0, 0, 1, 1, 1, 0, 1, 1, 0, 400, 0, 0, 0, 1, 1, 1, 1, 0, 0, 0, 241, 0, 0, 0, 1, 1, 1, 1, 0, 1, 0, 400, 0, 0, 0, 1, 1, 1, 1, 1, 0, 1, 300, 0, 0, 1, 0, 0, 0, 0, 0, 0, 1, 400, 0, 0, 1, 0, 0, 0, 0, 0, 1, 0, 300, 0, 0, 1, 0, 0, 0, 0, 0, 1, 1, 400, 0, 0, 1, 0, 0, 0, 0, 1, 1, 0, 400, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 300, 0, 0, 1, 0, 0, 0, 1, 0, 1, 0, 300, 0, 0, 1, 0, 0, 0, 1, 1, 0, 0, 400, 0, 0, 1, 0, 0, 1, 0, 0, 0, 0, 300, 0, 0, 1, 0, 0, 1, 0, 0, 0, 1, 400, 0, 0, 1, 0, 0, 1, 0, 0, 1, 0, 400, 0, 0, 1, 0, 0, 1, 0, 0, 1, 1, 400, 0, 0, 1, 0, 0, 1, 1, 0, 0, 0, 400, 0, 0, 1, 0, 1, 0, 0, 0, 1, 1, 300, 0, 0, 1, 0, 1, 0, 1, 0, 0, 0, 400, 0, 0, 1, 0, 1, 0, 1, 0, 0, 1, 400, 0, 0, 1, 0, 1, 0, 1, 0, 1, 0, 300, 0, 0, 1, 0, 1, 0, 1, 0, 1, 1, 241, 0, 0, 1, 0, 1, 0, 1, 1, 1, 0, 400, 0, 0, 1, 0, 1, 1, 0, 0, 0, 0, 400, 0, 0, 1, 0, 1, 1, 0, 1, 0, 0, 400, 0, 0, 1, 0, 1, 1, 1, 0, 0, 1, 400, 0, 0, 1, 0, 1, 1, 1, 0, 1, 1, 400, 0, 0, 1, 0, 1, 1, 1, 1, 0, 0, 400, 0, 0, 1, 0, 1, 1, 1, 1, 1, 0, 400, 0, 0, 1, 1, 0, 0, 0, 0, 0, 1, 300, 0, 0, 1, 1, 0, 0, 0, 0, 1, 1, 400, 0, 0, 1, 1, 0, 0, 0, 1, 0, 0, 400, 0, 0, 1, 1, 0, 0, 1, 0, 1, 0, 400, 0, 0, 1, 1, 0, 0, 1, 0, 1, 1, 400, 0, 0, 1, 1, 0, 0, 1, 1, 0, 0, 241, 0, 0, 1, 1, 0, 0, 1, 1, 0, 1, 400, 0, 0, 1, 1, 0, 1, 0, 0, 1, 0, 400, 0, 0, 1, 1, 0, 1, 0, 0, 1, 1, 300, 0, 0, 1, 1, 0, 1, 0, 1, 0, 1, 400, 0, 0, 1, 1, 0, 1, 1, 1, 1, 0, 300, 0, 0, 1, 1, 1, 0, 0, 1, 0, 0, 400, 0, 0, 1, 1, 1, 0, 0, 1, 0, 1, 400, 0, 0, 1, 1, 1, 0, 0, 1, 1, 0, 400, 0, 0, 1, 1, 1, 0, 1, 0, 0, 0, 400, 0, 0, 1, 1, 1, 0, 1, 0, 0, 1, 400, 0, 0, 1, 1, 1, 0, 1, 0, 1, 0, 400, 0, 0, 1, 1, 1, 0, 1, 0, 1, 1, 400, 0, 0, 1, 1, 1, 0, 1, 1, 0, 1, 400, 0, 0, 1, 1, 1, 0, 1, 1, 1, 0, 400, 0, 0, 1, 1, 1, 0, 1, 1, 1, 1, 400, 0, 0, 1, 1, 1, 1, 0, 0, 1, 0, 400, 0, 0, 1, 1, 1, 1, 1, 0, 1, 0, 400, 0, 0, 1, 1, 1, 1, 1, 0, 1, 1, 300, 0, 0, 1, 1, 1, 1, 1, 1, 0, 0, 400, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 400, 0, 1, 0, 0, 0, 0, 0, 0, 0, 1, 300, 0, 1, 0, 0, 0, 0, 0, 0, 1, 1, 400, 0, 1, 0, 0, 0, 0, 0, 1, 0, 0, 300, 0, 1, 0, 0, 0, 0, 0, 1, 0, 1, 300, 0, 1, 0, 0, 0, 0, 0, 1, 1, 0, 400, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 300, 0, 1, 0, 0, 0, 0, 1, 0, 0, 1, 400, 0, 1, 0, 0, 0, 0, 1, 1, 0, 0, 400, 0, 1, 0, 0, 0, 1, 0, 0, 0, 0, 400, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1, 400, 0, 1, 0, 0, 0, 1, 1, 0, 0, 0, 400, 0, 1, 0, 0, 0, 1, 1, 0, 0, 1, 400, 0, 1, 0, 0, 1, 0, 0, 0, 0, 1, 400, 0, 1, 0, 0, 1, 0, 0, 0, 1, 0, 400, 0, 1, 0, 0, 1, 0, 0, 1, 0, 1, 400, 0, 1, 0, 0, 1, 0, 0, 1, 1, 1, 400, 0, 1, 0, 0, 1, 0, 1, 0, 0, 1, 300, 0, 1, 0, 0, 1, 0, 1, 1, 0, 0, 300, 0, 1, 0, 0, 1, 0, 1, 1, 0, 1, 241, 0, 1, 0, 0, 1, 0, 1, 1, 1, 1, 400, 0, 1, 0, 0, 1, 1, 0, 0, 1, 0, 400, 0, 1, 0, 0, 1, 1, 0, 0, 1, 1, 400, 0, 1, 0, 0, 1, 1, 1, 0, 0, 1, 400, 0, 1, 0, 0, 1, 1, 1, 0, 1, 1, 400, 0, 1, 0, 1, 0, 0, 0, 1, 0, 0, 400, 0, 1, 0, 1, 0, 0, 0, 1, 0, 1, 300, 0, 1, 0, 1, 0, 0, 0, 1, 1, 1, 400, 0, 1, 0, 1, 0, 0, 1, 0, 0, 0, 400, 0, 1, 0, 1, 0, 0, 1, 0, 1, 0, 400, 0, 1, 0, 1, 0, 0, 1, 1, 1, 0, 400, 0, 1, 0, 1, 0, 0, 1, 1, 1, 1, 400, 0, 1, 0, 1, 0, 1, 0, 0, 0, 1, 300, 0, 1, 0, 1, 0, 1, 0, 1, 0, 0, 400, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 241, 0, 1, 0, 1, 0, 1, 1, 1, 0, 0, 400, 0, 1, 0, 1, 0, 1, 1, 1, 0, 1, 400, 0, 1, 0, 1, 1, 0, 0, 0, 1, 1, 400, 0, 1, 0, 1, 1, 0, 0, 1, 0, 0, 400, 0, 1, 0, 1, 1, 0, 0, 1, 0, 1, 400, 0, 1, 0, 1, 1, 0, 0, 1, 1, 0, 400, 0, 1, 0, 1, 1, 0, 1, 0, 1, 1, 400, 0, 1, 0, 1, 1, 0, 1, 1, 0, 1, 400, 0, 1, 0, 1, 1, 0, 1, 1, 1, 0, 400, 0, 1, 0, 1, 1, 0, 1, 1, 1, 1, 400, 0, 1, 0, 1, 1, 1, 0, 0, 1, 1, 400, 0, 1, 0, 1, 1, 1, 0, 1, 1, 1, 400, 0, 1, 0, 1, 1, 1, 1, 0, 0, 1, 400, 0, 1, 0, 1, 1, 1, 1, 1, 0, 0, 300, 0, 1, 0, 1, 1, 1, 1, 1, 0, 1, 300, 0, 1, 0, 1, 1, 1, 1, 1, 1, 0, 400, 0, 1, 1, 0, 0, 0, 0, 0, 1, 0, 400, 0, 1, 1, 0, 0, 0, 0, 1, 0, 1, 400, 0, 1, 1, 0, 0, 0, 0, 1, 1, 0, 241, 0, 1, 1, 0, 0, 0, 1, 0, 0, 1, 400, 0, 1, 1, 0, 0, 0, 1, 1, 1, 1, 300, 0, 1, 1, 0, 0, 1, 0, 0, 0, 0, 300, 0, 1, 1, 0, 0, 1, 0, 0, 0, 1, 400, 0, 1, 1, 0, 0, 1, 0, 1, 0, 1, 400, 0, 1, 1, 0, 0, 1, 0, 1, 1, 0, 400, 0, 1, 1, 0, 0, 1, 1, 0, 0, 1, 300, 0, 1, 1, 0, 0, 1, 1, 0, 1, 0, 400, 0, 1, 1, 0, 1, 0, 0, 0, 0, 1, 400, 0, 1, 1, 0, 1, 0, 0, 1, 1, 1, 300, 0, 1, 1, 0, 1, 0, 1, 0, 0, 1, 400, 0, 1, 1, 0, 1, 0, 1, 0, 1, 1, 400, 0, 1, 1, 0, 1, 0, 1, 1, 1, 0, 400, 0, 1, 1, 0, 1, 0, 1, 1, 1, 1, 300, 0, 1, 1, 0, 1, 1, 0, 0, 0, 1, 400, 0, 1, 1, 0, 1, 1, 0, 0, 1, 1, 400, 0, 1, 1, 0, 1, 1, 0, 1, 1, 1, 400, 0, 1, 1, 0, 1, 1, 1, 0, 0, 0, 400, 0, 1, 1, 0, 1, 1, 1, 0, 1, 0, 400, 0, 1, 1, 0, 1, 1, 1, 0, 1, 1, 400, 0, 1, 1, 0, 1, 1, 1, 1, 0, 0, 400, 0, 1, 1, 0, 1, 1, 1, 1, 0, 1, 400, 0, 1, 1, 1, 0, 0, 0, 0, 1, 0, 400, 0, 1, 1, 1, 0, 0, 0, 0, 1, 1, 400, 0, 1, 1, 1, 0, 0, 0, 1, 0, 0, 400, 0, 1, 1, 1, 0, 0, 0, 1, 0, 1, 400, 0, 1, 1, 1, 0, 0, 0, 1, 1, 1, 400, 0, 1, 1, 1, 0, 0, 1, 0, 0, 1, 400, 0, 1, 1, 1, 0, 0, 1, 1, 0, 1, 400, 0, 1, 1, 1, 0, 0, 1, 1, 1, 0, 400, 0, 1, 1, 1, 0, 1, 0, 0, 1, 0, 400, 0, 1, 1, 1, 0, 1, 0, 1, 0, 0, 400, 0, 1, 1, 1, 0, 1, 0, 1, 0, 1, 400, 0, 1, 1, 1, 0, 1, 0, 1, 1, 0, 400, 0, 1, 1, 1, 0, 1, 0, 1, 1, 1, 400, 0, 1, 1, 1, 0, 1, 1, 1, 0, 1, 300, 0, 1, 1, 1, 0, 1, 1, 1, 1, 1, 400, 0, 1, 1, 1, 1, 0, 0, 0, 0, 1, 400, 0, 1, 1, 1, 1, 0, 0, 0, 1, 1, 400, 0, 1, 1, 1, 1, 0, 0, 1, 0, 1, 400, 0, 1, 1, 1, 1, 0, 1, 1, 0, 0, 400, 0, 1, 1, 1, 1, 0, 1, 1, 0, 1, 241, 0, 1, 1, 1, 1, 0, 1, 1, 1, 0, 400, 0, 1, 1, 1, 1, 1, 0, 0, 1, 0, 400, 0, 1, 1, 1, 1, 1, 0, 1, 1, 0, 400, 0, 1, 1, 1, 1, 1, 0, 1, 1, 1, 400, 0, 1, 1, 1, 1, 1, 1, 0, 1, 1, 400, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 300, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 300, 1, 0, 0, 0, 0, 0, 0, 0, 1, 0, 300, 1, 0, 0, 0, 0, 0, 0, 0, 1, 1, 400, 1, 0, 0, 0, 0, 0, 0, 1, 0, 0, 300, 1, 0, 0, 0, 0, 0, 0, 1, 1, 0, 400, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 400, 1, 0, 0, 0, 0, 0, 1, 1, 0, 0, 400, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 300, 1, 0, 0, 0, 0, 1, 0, 0, 0, 1, 400, 1, 0, 0, 0, 0, 1, 0, 0, 1, 0, 300, 1, 0, 0, 0, 0, 1, 0, 1, 0, 0, 400, 1, 0, 0, 0, 0, 1, 1, 0, 0, 0, 400, 1, 0, 0, 0, 0, 1, 1, 1, 0, 0, 400, 1, 0, 0, 0, 1, 0, 0, 1, 0, 0, 300, 1, 0, 0, 0, 1, 0, 1, 0, 0, 1, 400, 1, 0, 0, 0, 1, 0, 1, 0, 1, 0, 400, 1, 0, 0, 0, 1, 0, 1, 1, 0, 0, 400, 1, 0, 0, 0, 1, 0, 1, 1, 0, 1, 400, 1, 0, 0, 0, 1, 0, 1, 1, 1, 0, 300, 1, 0, 0, 0, 1, 1, 0, 0, 0, 0, 400, 1, 0, 0, 0, 1, 1, 0, 0, 0, 1, 241, 1, 0, 0, 0, 1, 1, 0, 1, 0, 1, 400, 1, 0, 0, 0, 1, 1, 0, 1, 1, 0, 400, 1, 0, 0, 0, 1, 1, 1, 0, 1, 1, 300, 1, 0, 0, 1, 0, 0, 0, 0, 0, 1, 400, 1, 0, 0, 1, 0, 0, 0, 1, 1, 0, 300, 1, 0, 0, 1, 0, 0, 1, 0, 0, 1, 400, 1, 0, 0, 1, 0, 1, 0, 0, 0, 0, 400, 1, 0, 0, 1, 0, 1, 0, 0, 1, 0, 400, 1, 0, 0, 1, 0, 1, 0, 0, 1, 1, 400, 1, 0, 0, 1, 0, 1, 0, 1, 0, 0, 300, 1, 0, 0, 1, 0, 1, 0, 1, 1, 0, 241, 1, 0, 0, 1, 0, 1, 0, 1, 1, 1, 400, 1, 0, 0, 1, 0, 1, 1, 0, 0, 1, 400, 1, 0, 0, 1, 0, 1, 1, 1, 0, 0, 400, 1, 0, 0, 1, 0, 1, 1, 1, 0, 1, 400, 1, 0, 0, 1, 1, 0, 0, 1, 0, 1, 400, 1, 0, 0, 1, 1, 0, 1, 0, 0, 0, 400, 1, 0, 0, 1, 1, 0, 1, 0, 1, 0, 400, 1, 0, 0, 1, 1, 0, 1, 1, 0, 0, 400, 1, 0, 0, 1, 1, 1, 0, 0, 0, 0, 400, 1, 0, 0, 1, 1, 1, 0, 0, 1, 0, 400, 1, 0, 0, 1, 1, 1, 0, 1, 0, 0, 400, 1, 0, 0, 1, 1, 1, 0, 1, 0, 1, 400, 1, 0, 0, 1, 1, 1, 0, 1, 1, 0, 400, 1, 0, 0, 1, 1, 1, 0, 1, 1, 1, 300, 1, 0, 0, 1, 1, 1, 1, 0, 0, 1, 400, 1, 0, 0, 1, 1, 1, 1, 0, 1, 0, 400, 1, 0, 0, 1, 1, 1, 1, 1, 0, 0, 400, 1, 0, 0, 1, 1, 1, 1, 1, 1, 0, 400, 1, 0, 0, 1, 1, 1, 1, 1, 1, 1, 400, 1, 0, 1, 0, 0, 0, 0, 0, 1, 0, 400, 1, 0, 1, 0, 0, 0, 0, 1, 0, 0, 400, 1, 0, 1, 0, 0, 0, 0, 1, 0, 1, 400, 1, 0, 1, 0, 0, 0, 0, 1, 1, 1, 400, 1, 0, 1, 0, 0, 0, 1, 0, 1, 0, 400, 1, 0, 1, 0, 0, 0, 1, 1, 1, 0, 400, 1, 0, 1, 0, 0, 1, 0, 0, 1, 0, 300, 1, 0, 1, 0, 0, 1, 0, 0, 1, 1, 400, 1, 0, 1, 0, 0, 1, 0, 1, 1, 1, 400, 1, 0, 1, 0, 0, 1, 1, 0, 0, 0, 300, 1, 0, 1, 0, 0, 1, 1, 0, 1, 0, 241, 1, 0, 1, 0, 0, 1, 1, 1, 1, 0, 400, 1, 0, 1, 0, 1, 0, 0, 1, 1, 0, 400, 1, 0, 1, 0, 1, 0, 0, 1, 1, 1, 400, 1, 0, 1, 0, 1, 0, 1, 0, 0, 0, 400, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 400, 1, 0, 1, 0, 1, 0, 1, 1, 0, 0, 400, 1, 0, 1, 0, 1, 0, 1, 1, 1, 1, 400, 1, 0, 1, 0, 1, 1, 0, 0, 1, 1, 400, 1, 0, 1, 0, 1, 1, 0, 1, 1, 0, 400, 1, 0, 1, 0, 1, 1, 1, 0, 0, 1, 300, 1, 0, 1, 0, 1, 1, 1, 0, 1, 0, 400, 1, 0, 1, 0, 1, 1, 1, 0, 1, 1, 300, 1, 0, 1, 0, 1, 1, 1, 1, 0, 0, 400, 1, 0, 1, 0, 1, 1, 1, 1, 0, 1, 400, 1, 0, 1, 0, 1, 1, 1, 1, 1, 0, 400, 1, 0, 1, 1, 0, 0, 0, 0, 1, 0, 400, 1, 0, 1, 1, 0, 0, 0, 0, 1, 1, 400, 1, 0, 1, 1, 0, 0, 0, 1, 1, 1, 400, 1, 0, 1, 1, 0, 0, 1, 1, 1, 0, 300, 1, 0, 1, 1, 0, 0, 1, 1, 1, 1, 400, 1, 0, 1, 1, 0, 1, 0, 0, 0, 1, 400, 1, 0, 1, 1, 0, 1, 0, 0, 1, 0, 400, 1, 0, 1, 1, 0, 1, 0, 1, 0, 1, 400, 1, 0, 1, 1, 0, 1, 0, 1, 1, 0, 400, 1, 0, 1, 1, 0, 1, 0, 1, 1, 1, 400, 1, 0, 1, 1, 0, 1, 1, 0, 0, 1, 400, 1, 0, 1, 1, 0, 1, 1, 0, 1, 1, 400, 1, 0, 1, 1, 0, 1, 1, 1, 0, 0, 400, 1, 0, 1, 1, 0, 1, 1, 1, 1, 0, 300, 1, 0, 1, 1, 1, 0, 0, 0, 1, 0, 400, 1, 0, 1, 1, 1, 0, 0, 1, 0, 1, 400, 1, 0, 1, 1, 1, 0, 0, 1, 1, 0, 400, 1, 0, 1, 1, 1, 0, 1, 0, 1, 0, 400, 1, 0, 1, 1, 1, 0, 1, 1, 0, 1, 400, 1, 0, 1, 1, 1, 0, 1, 1, 1, 1, 400, 1, 0, 1, 1, 1, 1, 0, 1, 1, 1, 400, 1, 0, 1, 1, 1, 1, 1, 0, 0, 0, 400, 1, 0, 1, 1, 1, 1, 1, 0, 1, 0, 241, 1, 0, 1, 1, 1, 1, 1, 1, 0, 0, 400, 1, 0, 1, 1, 1, 1, 1, 1, 0, 1, 300, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 300, 1, 1, 0, 0, 0, 0, 0, 0, 0, 1, 400, 1, 1, 0, 0, 0, 0, 0, 0, 1, 1, 241, 1, 1, 0, 0, 0, 0, 1, 0, 0, 0, 300, 1, 1, 0, 0, 0, 0, 1, 0, 1, 1, 400, 1, 1, 0, 0, 0, 0, 1, 1, 0, 1, 400, 1, 1, 0, 0, 0, 1, 0, 0, 1, 0, 400, 1, 1, 0, 0, 0, 1, 0, 1, 0, 0, 400, 1, 1, 0, 0, 0, 1, 0, 1, 1, 1, 300, 1, 1, 0, 0, 0, 1, 1, 0, 0, 0, 400, 1, 1, 0, 0, 0, 1, 1, 0, 1, 0, 400, 1, 1, 0, 0, 0, 1, 1, 1, 0, 0, 300, 1, 1, 0, 0, 1, 0, 0, 0, 0, 1, 400, 1, 1, 0, 0, 1, 0, 0, 1, 0, 1, 400, 1, 1, 0, 0, 1, 0, 1, 0, 0, 1, 400, 1, 1, 0, 0, 1, 0, 1, 0, 1, 0, 400, 1, 1, 0, 0, 1, 0, 1, 0, 1, 1, 400, 1, 1, 0, 0, 1, 0, 1, 1, 0, 1, 400, 1, 1, 0, 0, 1, 0, 1, 1, 1, 1, 300, 1, 1, 0, 0, 1, 1, 0, 0, 0, 0, 400, 1, 1, 0, 0, 1, 1, 0, 0, 1, 1, 400, 1, 1, 0, 0, 1, 1, 0, 1, 0, 0, 400, 1, 1, 0, 0, 1, 1, 0, 1, 0, 1, 400, 1, 1, 0, 0, 1, 1, 1, 0, 0, 0, 400, 1, 1, 0, 0, 1, 1, 1, 0, 0, 1, 400, 1, 1, 0, 0, 1, 1, 1, 1, 0, 1, 400, 1, 1, 0, 0, 1, 1, 1, 1, 1, 1, 400, 1, 1, 0, 1, 0, 0, 0, 1, 1, 1, 400, 1, 1, 0, 1, 0, 0, 1, 1, 0, 0, 400, 1, 1, 0, 1, 0, 0, 1, 1, 0, 1, 400, 1, 1, 0, 1, 0, 0, 1, 1, 1, 0, 400, 1, 1, 0, 1, 0, 1, 0, 0, 0, 0, 400, 1, 1, 0, 1, 0, 1, 0, 0, 1, 1, 300, 1, 1, 0, 1, 0, 1, 0, 1, 0, 0, 400, 1, 1, 0, 1, 0, 1, 0, 1, 0, 1, 400, 1, 1, 0, 1, 0, 1, 0, 1, 1, 1, 300, 1, 1, 0, 1, 0, 1, 1, 0, 0, 0, 400, 1, 1, 0, 1, 0, 1, 1, 0, 0, 1, 400, 1, 1, 0, 1, 0, 1, 1, 0, 1, 1, 400, 1, 1, 0, 1, 0, 1, 1, 1, 0, 1, 400, 1, 1, 0, 1, 0, 1, 1, 1, 1, 0, 400, 1, 1, 0, 1, 1, 0, 0, 1, 0, 0, 400, 1, 1, 0, 1, 1, 0, 1, 0, 1, 0, 400, 1, 1, 0, 1, 1, 0, 1, 1, 0, 0, 400, 1, 1, 0, 1, 1, 0, 1, 1, 1, 1, 400, 1, 1, 0, 1, 1, 1, 0, 0, 0, 1, 400, 1, 1, 0, 1, 1, 1, 0, 1, 0, 0, 400, 1, 1, 0, 1, 1, 1, 0, 1, 0, 1, 241, 1, 1, 0, 1, 1, 1, 1, 0, 0, 1, 400, 1, 1, 0, 1, 1, 1, 1, 0, 1, 0, 400, 1, 1, 0, 1, 1, 1, 1, 0, 1, 1, 300, 1, 1, 0, 1, 1, 1, 1, 1, 1, 0, 400, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 300, 1, 1, 1, 0, 0, 0, 0, 0, 0, 1, 400, 1, 1, 1, 0, 0, 0, 0, 0, 1, 0, 400, 1, 1, 1, 0, 0, 0, 0, 1, 1, 1, 400, 1, 1, 1, 0, 0, 0, 1, 0, 0, 1, 400, 1, 1, 1, 0, 0, 0, 1, 0, 1, 0, 400, 1, 1, 1, 0, 0, 0, 1, 0, 1, 1, 400, 1, 1, 1, 0, 0, 1, 0, 0, 0, 1, 400, 1, 1, 1, 0, 0, 1, 0, 0, 1, 0, 400, 1, 1, 1, 0, 0, 1, 0, 0, 1, 1, 400, 1, 1, 1, 0, 0, 1, 0, 1, 0, 0, 400, 1, 1, 1, 0, 0, 1, 0, 1, 1, 0, 400, 1, 1, 1, 0, 0, 1, 1, 0, 1, 0, 400, 1, 1, 1, 0, 0, 1, 1, 0, 1, 1, 400, 1, 1, 1, 0, 0, 1, 1, 1, 1, 0, 300, 1, 1, 1, 0, 0, 1, 1, 1, 1, 1, 400, 1, 1, 1, 0, 1, 0, 0, 0, 1, 1, 400, 1, 1, 1, 0, 1, 0, 1, 0, 0, 0, 400, 1, 1, 1, 0, 1, 0, 1, 0, 0, 1, 400, 1, 1, 1, 0, 1, 0, 1, 0, 1, 1, 241, 1, 1, 1, 0, 1, 1, 0, 0, 1, 1, 400, 1, 1, 1, 0, 1, 1, 0, 1, 0, 0, 400, 1, 1, 1, 0, 1, 1, 0, 1, 0, 1, 400, 1, 1, 1, 0, 1, 1, 0, 1, 1, 1, 300, 1, 1, 1, 0, 1, 1, 1, 0, 0, 0, 400, 1, 1, 1, 0, 1, 1, 1, 1, 0, 1, 400, 1, 1, 1, 0, 1, 1, 1, 1, 1, 0, 400, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 300, 1, 1, 1, 1, 0, 0, 0, 1, 1, 0, 400, 1, 1, 1, 1, 0, 0, 0, 1, 1, 1, 400, 1, 1, 1, 1, 0, 0, 1, 0, 0, 1, 400, 1, 1, 1, 1, 0, 0, 1, 0, 1, 1, 400, 1, 1, 1, 1, 0, 0, 1, 1, 1, 1, 300, 1, 1, 1, 1, 0, 1, 0, 0, 0, 0, 400, 1, 1, 1, 1, 0, 1, 0, 0, 0, 1, 400, 1, 1, 1, 1, 0, 1, 0, 0, 1, 0, 400, 1, 1, 1, 1, 0, 1, 0, 1, 1, 0, 241, 1, 1, 1, 1, 0, 1, 1, 0, 1, 1, 400, 1, 1, 1, 1, 0, 1, 1, 1, 0, 1, 400, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 300, 1, 1, 1, 1, 1, 0, 0, 1, 1, 1, 300, 1, 1, 1, 1, 1, 0, 1, 0, 1, 1, 400, 1, 1, 1, 1, 1, 0, 1, 1, 0, 1, 400, 1, 1, 1, 1, 1, 0, 1, 1, 1, 0, 300, 1, 1, 1, 1, 1, 1, 0, 0, 1, 1, 300, 1, 1, 1, 1, 1, 1, 0, 1, 0, 1, 400, 1, 1, 1, 1, 1, 1, 0, 1, 1, 0, 400, 1, 1, 1, 1, 1, 1, 1, 0, 0, 1, 300, 1, 1, 1, 1, 1, 1, 1, 0, 1, 0, 400, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 300, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 400]);
