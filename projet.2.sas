%let path= C:\Users\ayadm\Documents\Examen 2018\Partie2;
libname Partie2 "C:\Users\ayadm\Documents\Examen 2018\Partie2";
ods graphics; 
/*Analyse univarié des variables quantitatives*/

PROC UNIVARIATE data=Partie2.Credittraining;
var Number_Of_Dependant ;
run;
/*Traitemanent des valeurs manquantes*/
proc freq data=Partie2.Credittraining nlevels;
	tables _all_ / noprint;
run;
/*Pour les variables numérique on a trois avec des valeurs manquante.
Chacune de variable manquante à précisement une variable manquante.
Comme la frequence des valeurs manquantes est aussi faible on se limitera
à les remplacer âr la médiane. ce choix n est pas le meilleur qui existe mais 
il nous permattra de bien améliorer  modèle*
*/
data table1;
	set Partie2.Credittraining ;
run;

data Work.table1 ;
    set Work.table1;
    if missing(Number_Of_Dependant)  /* si la variable contient une valeur manquante*/
        then Number_Of_Dependant = 0;/* alors on remplace avec les valeurs manquantes par */
run ;

data Work.table1 ;
    set Work.table1;
	if missing(Net_Annual_Income)  
		then Net_Annual_Income = 36;
run ;

proc freq data=Partie2.Credittraining nlevels;
	tables Net_Annual_Income / noprint;
run;

data table1 ;
    set table1;
	if missing(Years_At_Business)  
		then Years_At_Business = 1;
run ;

proc freq data=Work.table1 nlevels;
	tables _All_ / noprint;
run;

/*analyse de la présence d'éventuelles valeurs aberrantes*/
/*Pour identifier les valeurs abérantes et les valeurs isollées, plusieurs méthodes s'offrent à nous.
On peut utiliser la distance de cook, se fixer un seuil et regarder les observations qui dépassent
ce seuil sont considérées comme étant isolées ou abérante.
Une autrre méthode consiste à utiliser les boxplot et identifier l'existence de queues lourdes avec 
des observations depassant les deux queeus de la distribution.
Dans cette on utilisera les boxplot pour l'identification des valeurs aberantes e isolées.*/
/* pour la variable Net_Annual_Income on  a une valeur isolée = 10 000
   pour la variable Number_Of_Dependant on a deux valeurs isolée >=10
	pour la variable Years_At_Residence on garde toutes les variables. 
	On a pas vraiment besoin de supprimer des observations.
	pour la variable Years_At_Business on une bonne quantité d'obvservations isolée 
	qu'on supprimera.*/
proc ttest data=Work.table1 plots(shownull)=interval H0=135000; 
	var Net_Annual_Income Number_Of_Dependant Years_At_Residence Years_At_Business; 
run;

/*affichage du boxplot*/
proc sgplot data=Work.table1;
	vbox Number_Of_Dependant;
	vbox Years_At_Residence;
	vbox Net_Annual_Income;
	vbox Years_At_Business; 
run;

/*étude de la présence d'éventuelles variables confusionnelles*/
proc freq data= Work.table1;
	tables P_Client*Marital_Status;
run;
/*A finir avec totes les variables quanlitative*/

proc freq data=Work.table1;
	table Prod_Category;
run;







/*pour autres choses d autre en dehors du projet*/
/*j ai commmenté les problemes qui enpechés la création de la table*/
data Work.USAGERS_9;
	SET Work.USAGER_2013;
	if SECU=1 THEN SECU2="OUI"; 
	else if SECU=11 THEN SECU2="OUI" ;/*il faut fair une condition if pour chaque condition*/
	else if SECU=21  THEN SECU2="OUI" ;
	else if SECU=31 THEN SECU2="OUI" ;
	else if SECU=41 THEN SECU2="OUI" ;
	else if SECU=91 THEN SECU2="OUI" ;
	else if SECU=2 THEN SECU2="NON";
	else if SECU=12  THEN SECU2="NON;*";
	else if SECU=22  THEN SECU2="NON";
	else if SECU=32  THEN SECU2="NON";
	else if SECU=42 THEN SECU2="NON";
	else if SECU=92 THEN SECU2="NON";
	else if  SECU="." THEN SECU2="AUTRE";/*il faut une condition pour les valeurs manquantes*/
	else SECU2="AUTRE";
run;

data Work.VEHICULE13_3;
SET Work.vehicules_2013;
if(catv=1) THEN catv2="bicyclete" ;
else if(catv=2) THEN catv2="cyclomoteur" ;
else if(catv=3) THEN catv2="voiturette";
else if(catv=4) THEN catv2="scooter_immatricule" ;
else if(catv=5) THEN catv2="motocyclete";
else if(catv=6) THEN catv2="side_car" ;
else if(catv=7) THEN catv2="VL_SEUL" ;
else if(CATV=8) THEN CATV2="VL_CARAVANE" ;
else if(CAVT=9) THEN CAVT2="VL_REMORQUE";
else if(CATV=10) THEN CATV2="VU_SEUL" ;
else if(CATV=11) THEN CATV2="VU10_CARAVANE";
else if(CATV=12) THEN CATV2="VU10_REMORQUE" ;
else if(CATV=13) THEN CATV2="PL_SEUL_infegal7,57T" ;
else if(CATV=14) THEN CATV2="PL_SEUL_sup_7,57T" ;
else if(CATV=15) THEN CATV2="PL_SEUL_supegal3,5_REMORQUET" ;
else if(catv=16) THEN catv2="TRACTEUR_ROUTIERE_SEUL" ;
else if(catv=17) THEN catv2="TRACTEUR_ROUTIERE_SEMI_REMORQUE";
else if(catv=18) THEN catv2="TRANSPORT_EN_COMMUN" ;
else if(catv=19) THEN catv2="TRAMWAY_utiliser_depuis_2006";
else if(catv=20) THEN catv2="ENGIN_SPECIALE" ;
else if(catv=21) THEN catv2="TRACTEUR_AGRICOLE" ;
else if(CATV=30) THEN CATV2="SCOOTER_inf_50CM" ;
else if(CAVT=31) THEN CAVT2="MOTOCYCLETE_sup_50CM3_infegal_125CM3";
else if(CATV=32) THEN CATV2="SCOUTER_sup125CM3_infegal_125CM3" ;
else if(CATV=33) THEN CATV2="MOTOCYCLETTE_sup_125CM3";
else if(CATV=34) THEN CATV2="SCOOTER_inf_125CM3" ;
else if(CATV=35) THEN CATV2="QUAD_LEGER" ;
else if(CATV=36) THEN CATV2="QUAD_LOURD" ;
else if(CATV=37) THEN CATV2="AUTOBUS";
else if(CATV=38) THEN CATV2="AUTOCAR" ;
else if(CATV=39) THEN CATV2="TRAIN" ;
else if(CATV=40) THEN CATV2="TRAMWAY";
else CATV2="AUTRE_VEHICULE";
run;

Data Maladie; 
	input Trait $ Age Duree Gueri $ @@; 
	datalines; 
			B 74 16 Non P 66 26 Oui A 71 17 Oui 
			A 62 42 Non P 74 4 Non P 70 1 Oui 
			B 66 19 Non B 59 29 Non A 70 28 Non 
			A 69 1 Non P 83 1 Oui B 75 30 Oui 
			P 77 29 Oui A 70 12 Non B 70 1 Non 
			B 67 23 Non A 76 25 Oui P 78 12 Oui 
; 
run ;

proc logistic data=Partie2.Credittraining plots(only)=roc; 
	class Customer_Type P_Client Educational_Level Marital_Status Prod_Sub_Category Source Type_Of_Residence Nb_Of_Products;
	model Y= Customer_Type P_Client Educational_Level Marital_Status Number_of_Dependant Years_At_Residence Net_Annual_Income Years_At_Business Prod_Sub_Category Source Type_Of_Residence Nb_Of_Products Educational_Level*Marital_Status / nofit; 
	roc 'Selected Model' Customer_Type P_Client Educational_Level Marital_Status Number_of_Dependant Years_At_Residence Net_Annual_Income Years_At_Business Prod_Sub_Category Nb_Of_Products;
	roccontrast 'Overlay of ROC Curves' / estimate=allpairs;
	title "Comparing ROC Curves";
run;

/*cours 4 pareil pour les varioable abbérante et isolées
roc 'Selected Model' Customer_Type P_Client Educational_Level Marital_Status Number_of_Dependant Years_At_Residence Net_Annual_Income Years_At_Business Prod_Sub_Category Nb_Of_Products;
	roc 'All Main Effects Model' Customer_Type P_Client Educational_Level Marital_Status Number_of_Dependant Years_At_Residence Net_Annual_Income Years_At_Business Prod_Sub_Category Source Type_Of_Residence Nb_Of_Products;
	roc "Mother's Weight Model"  Customer_Type P_Client Educational_Level Marital_Status Number_of_Dependant Years_At_Residence Net_Annual_Income Years_At_Business;
	*/
