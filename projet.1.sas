%let path= C:\Users\ayadm\Documents\Examen 2018\Partie1;
libname Partie1 "C:\Users\ayadm\Documents\Examen 2018\Partie1";
data Personne;
	set Partie1.Personne;
run;/*pour copier la table Personne dans la Work*/

/*question 2 :Quelle est la r�partition des assur�s par ville */
PROC FREQ data=Partie1.personne; 
TABLE sexe*ville ;
run;
/*question 3 : Vous cr�erez une variable � Age � 
�gale � l'�ge qu'ont eu les assur�s en 2017 dans une nouvelle table nouvelle_personne*/
DATA Partie1.personne;
	SET Partie1.personne;
	Age=2017-YEAR(DateNaissance);
RUN;
/*question 4: �ge moyen des assur�s global*/
PROC means data=Partie1.personne mean; 
var Age;
run;
/*question 4: �ge moyen des assur�s par villes*/
PROC means data=Partie1.personne mean; 
var Age;
class ville;
run;
/*qusetion 5: Vous cr�erez une nouvelle table temporaire � Contrat_Personne � avec les
informations suivantes*/
DATA Partie1.Contrat_personne;
	merge Partie1.personne (in=Emps) 
		  Partie1.Contrat (in=cell);/*je concatene les deux tables*/
	by identifiantContrat;/*je concatene par identification du contrat dans les deux tables*/
	if Emps=1 and Cell=1;
	keep identifiantContrat Garantie NbAss Ville;/*je selectionne les variables que je veux*/
RUN;
/*pour �liminer les doublons au niveau des observation*/
proc sort data=Partie1.Contrat_personne out=Partie1.Contrat_personne noduprecs /*nodup*/;
   by identifiantContrat;
run;
proc print data=Partie1.Contrat_personne;
run;
/*question 6:ajout d'une variable structure dans la table contrat_personne*/
Data Partie1.Contrat_personne;
Set  Partie1.Contrat_personne;
	if (NbAss > 1) then Structure = 'Famille';
	else if (NbAss=1) then Structure = 'Solo';
RUN;
/*question 8: r�partition des assur�s contrats selon les structures familiales et les
villes*/
PROC FREQ data=Partie1.Contrat_personne; 
TABLE Structure*ville ;
run;
/*question 9: r�partition de contrats selon les niveaux de garantie par ville*/
PROC FREQ data=Partie1.Contrat_personne; 
TABLE Garantie*ville ;
run;
/*question 10: creation de la base flux*/
DATA Partie1.Flux;
	merge Partie1.Contrat_personne(in=Emps)
		  Partie1.Primes (in=Cell1) 
	      Partie1.Sinistres (in=Cell2);/*je concatenne les deux tables*/
	if Emps=1 and Cell1=1 and Cell2=1;
	keep identifiantContrat Garantie Ville Structure Primes Sinistres;/*je selectionne les variables que je veux*/
RUN;
/*on a 32 observation tout comme la table contrat*/
/*question 13: Calculer les montants de primes moyens par contrat selon la ville*/
PROC means data=Partie1.Flux mean; 
	var Primes;
	class ville;
	RUN;
/*Lille est la ville avec le plus haut montant de primes en moyenne par contrat
 Annecy ville avec le plus bas montant de primes en moyenne par contrat*/

/*question 14:Ajout � la base � Flux �,un indicateur de risque SP*/
DATA Partie1.Flux;
	SET Partie1.Flux;
	SP=Sinistres/Primes;
RUN;

/*question 15:
J'ai fait un proc means pour identifier le min et max de SP est de la je peux conclure que
Plus le ratio est �l�v� moins le niveau de sinistralit� est bon
le contrat avec le plus mauvais niveau de sinistralit� est  C027 � lyon (3.8854500)
le contrat avec le meilleur niveau de sinistralit� est  C014 � Annecy (0.0086600)*/
Proc means data=Partie1.Flux;
RUN;
/*question 16: la valeur du ratio SP par niveau de garantie*/
PROC means data=Partie1.Flux; 
	var SP;
	class Garantie;
	weight SP;/*option weight SP par exemple les cofficient d'une mati�re pour le calcul de moyenne*/
run;
/*question 17: le niveau de SP est il significativement diff�rent selon la structure
familiale
On voit bien qie oui selon la structure familliale le SP varie significativement*/
PROC ttest data=Partie1.Flux; 
	var SP;
	class Structure;
	/*weight Garantie;*/
run;
/*pour v�rifier la normalit� des observations*/
PROC univariate data=Partie1.Flux normal; 
	var SP;
	class Structure;
	/*weight Garantie;*/
run;
