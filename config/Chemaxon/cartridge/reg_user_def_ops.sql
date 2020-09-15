Rem
Rem List user defined operators with theirs parameters list.
Rem Operators should be separated by comma. 
Rem
Rem Write operator names between the START LISTING OPERATORS and 
Rem STOP LISTING OPERATORS signes. Afer the name list the type of
Rem parameters separated by comma into brackets. 
Rem Don't leave white lines between the rows!
Rem
Rem For exmaple:
Rem
Rem -----------------------------------------
Rem -- START LISTING OPERATORS
Rem -----------------------------------------
Rem molconverter(VARCHAR2),
Rem my_own_op(VARCHAR2, NUMBER),
Rem -----------------------------------------
Rem -- STOP LISTING OPERATORS
Rem -----------------------------------------
Rem

DROP INDEXTYPE jc_idxtype;

CREATE OR REPLACE INDEXTYPE jc_idxtype
FOR
-----------------------------------------
-- START LISTING OPERATORS
-----------------------------------------
-----------------------------------------
-- STOP LISTING OPERATORS
-----------------------------------------
   jc_contains(VARCHAR2, VARCHAR2),
   jc_equals(VARCHAR2, VARCHAR2),
   jc_matchcount(VARCHAR2, VARCHAR2),
   jc_dissimilarity(VARCHAR2, VARCHAR2),
   jc_tanimoto(VARCHAR2, VARCHAR2),
   jc_compare(VARCHAR2, VARCHAR2, VARCHAR2),
   jc_evaluate(VARCHAR2, VARCHAR2),
   jc_logp(VARCHAR2),
   jc_logd(VARCHAR2, NUMBER),
   jc_pka(VARCHAR2, VARCHAR2, NUMBER),
   jc_tpsa(VARCHAR2),
   jc_molweight(VARCHAR2),
   jc_formula(VARCHAR2),
   jc_formula_eq(VARCHAR2, VARCHAR2),
   jc_molconvert(VARCHAR2, VARCHAR2),
   jc_molconvertb(VARCHAR2, VARCHAR2),
   jc_react (VARCHAR2, VARCHAR2, VARCHAR2),
   jc_transform(VARCHAR2, VARCHAR2)
USING jc_idxtype_im;
QUIT
