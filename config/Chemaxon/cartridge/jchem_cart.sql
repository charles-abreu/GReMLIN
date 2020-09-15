Rem
Rem Copyright (c) 1998-2010 ChemAxon Ltd. All Rights Reserved.
Rem This software is the confidential and proprietary information of
Rem ChemAxon. You shall not disclose such Confidential Information
Rem and shall use it only in accordance with the terms of the agreements
Rem you entered into with ChemAxon.
Rem

whenever sqlerror exit 1

---------------------------------------------------------------------
--    			JChem Data Cartridge			   --
---------------------------------------------------------------------

-- Type used for storing the results of screenning
--CREATE OR REPLACE TYPE SMI_ARRAY is VARRAY(1000000000) OF VARCHAR2(32767)
--/

CREATE OR REPLACE TYPE CD_ID_ARRAY is VARRAY(1000000000) OF INTEGER;
/

-- Type used for storing the results of sss
CREATE OR REPLACE TYPE RESARRAY is VARRAY(1000000000) OF VARCHAR2(256)
/

-- Type used for storing the results of sss
CREATE OR REPLACE TYPE RIDARRAY is VARRAY(1000000000) OF VARCHAR2(20)
/

CREATE OR REPLACE TYPE MOLPROPS_ARRAY is VARRAY(1000000000) OF VARCHAR(2000)
/

CREATE OR REPLACE TYPE MOLPROPS_ARRAY_ARRAY is VARRAY(1000000000) OF MOLPROPS_ARRAY
/
show errors;

CREATE OR REPLACE TYPE CHAR_ARRAY is VARRAY(2000000000) OF VARCHAR2(32767)
/
show errors;

CREATE OR REPLACE TYPE COMPOSITE_CHAR as OBJECT (c VARCHAR2(32767));
/
show errors;

CREATE OR REPLACE TYPE COMP_CHAR_ARRAY is VARRAY(20000000) OF COMPOSITE_CHAR;
/
show errors;

CREATE OR REPLACE TYPE CLOB_ARRAY is VARRAY(2000000000) OF CLOB
/
show errors;

CREATE OR REPLACE TYPE COMPOSITE_CLOB as OBJECT (b CLOB);
/
show errors;

CREATE OR REPLACE TYPE COMP_CLOB_ARRAY is varray(20000000) OF COMPOSITE_CLOB;
/
show errors;

CREATE OR REPLACE TYPE BLOB_ARRAY is VARRAY(2000000000) OF BLOB
/
show errors;

CREATE OR REPLACE TYPE COMPOSITE_BLOB as OBJECT (b BLOB);
/
show errors;

CREATE OR REPLACE TYPE COMP_BLOB_ARRAY is varray(20000000) OF COMPOSITE_BLOB;
/
show errors;

CREATE OR REPLACE TYPE CHAR_PRODUCT_RECORD AS OBJECT (product VARCHAR2(32767), synthesis_code VARCHAR2(32767));
/
show errors;

CREATE OR REPLACE TYPE CHAR_PRODUCT_ARRAY IS VARRAY(20000000) OF CHAR_PRODUCT_RECORD;
/
show errors;

CREATE OR REPLACE TYPE CLOB_PRODUCT_RECORD AS OBJECT (product CLOB, synthesis_code VARCHAR2(32767));
/
show errors;

CREATE OR REPLACE TYPE CLOB_PRODUCT_ARRAY IS VARRAY(20000000) OF CLOB_PRODUCT_RECORD;
/
show errors;

CREATE OR REPLACE TYPE BLOB_PRODUCT_RECORD AS OBJECT (product BLOB, synthesis_code VARCHAR2(32767));
/
show errors;

CREATE OR REPLACE TYPE BLOB_PRODUCT_ARRAY IS VARRAY(20000000) OF BLOB_PRODUCT_RECORD;
/
show errors;

create or replace type gmem_util_record as object (description varchar2(300), util_mb number);
/
show errors;

create or replace type gmem_util_array is VARRAY(20000000) of gmem_util_record;
/
show errors;

create or replace type taskinfo_record as object (
  id number,
  user_name varchar2(100),
  description varchar2(4000),
  start_time varchar(100),
  estim_memory_use number,
  timeout number,
  last_rescheduled varchar(100)
  );
/
show errors;

create or replace type taskinfo_array is varray(20000000) of taskinfo_record;
/
show errors;

create or replace package jchem_refcur_pkg is
  type refcur_t is ref cursor;
end jchem_refcur_pkg;
/
show errors;

-- CREATE INDEXTYPE IMPLEMENTATION TYPE
CREATE OR REPLACE TYPE jc_idxtype_im AUTHID CURRENT_USER AS OBJECT
(
  ia sys.odciindexinfo,
  scan_num number,
  cnum number,

  STATIC FUNCTION ODCIGetInterfaces(ifclist OUT sys.ODCIObjectList) 
								RETURN NUMBER PARALLEL_ENABLE,
  STATIC FUNCTION ODCIIndexCreate(ia sys.odciindexinfo, parms VARCHAR2, 
						env sys.ODCIEnv) RETURN NUMBER PARALLEL_ENABLE,
  STATIC FUNCTION ODCIIndexAlter(ia SYS.ODCIIndexInfo, parms IN OUT VARCHAR2, 
				 alter_option NUMBER, env sys.ODCIEnv)
      RETURN NUMBER PARALLEL_ENABLE,

  STATIC FUNCTION ODCIIndexDrop(ia sys.odciindexinfo, 
				env sys.ODCIEnv) RETURN NUMBER PARALLEL_ENABLE,

  STATIC FUNCTION ODCIIndexTruncate(ia sys.ODCIIndexInfo,
                                env sys.ODCIEnv) RETURN NUMBER PARALLEL_ENABLE,
                                
  STATIC FUNCTION ODCIIndexStart(sctx in out jc_idxtype_im, 
			 ia sys.odciindexinfo,
                         op sys.odciPredInfo, 
                         qi sys.ODCIQueryInfo, 
                         strt VARCHAR2, 
                         stop VARCHAR2,
                         env sys.ODCIEnv) RETURN NUMBER PARALLEL_ENABLE,

  STATIC FUNCTION ODCIIndexStart(sctx in out NOCOPY jc_idxtype_im, 
			 ia sys.odciindexinfo,
                         op sys.odciPredInfo, 
                         qi sys.ODCIQueryInfo, 
                         strt VARCHAR2, 
                         stop VARCHAR2,
                         query CLOB, env sys.ODCIEnv)
            RETURN NUMBER PARALLEL_ENABLE,

  STATIC FUNCTION ODCIIndexStart(sctx in out jc_idxtype_im, 
			 ia sys.odciindexinfo,
                         op sys.odciPredInfo, 
                         qi sys.ODCIQueryInfo, 
                         strt VARCHAR2, 
                         stop VARCHAR2,
                         query CLOB, 
			 param VARCHAR2, env sys.ODCIEnv)
      RETURN NUMBER PARALLEL_ENABLE,

  STATIC FUNCTION ODCIIndexStart(sctx in out jc_idxtype_im, 
			 ia sys.odciindexinfo,
                         op sys.odciPredInfo, 
                         qi sys.ODCIQueryInfo, 
                         strt VARCHAR2, 
                         stop VARCHAR2,
                         query CLOB, 
			 param1 number,
                         param2 number,
                         env sys.ODCIEnv)
      RETURN NUMBER PARALLEL_ENABLE,

  STATIC FUNCTION ODCIIndexStart(sctx in out NOCOPY jc_idxtype_im, 
        ia sys.odciindexinfo,
        op sys.odciPredInfo, 
        qi sys.ODCIQueryInfo, 
        strt VARCHAR2, 
        stop VARCHAR2,
        query BLOB, env sys.ODCIEnv) RETURN NUMBER PARALLEL_ENABLE,

  STATIC FUNCTION ODCIIndexStart(sctx in out jc_idxtype_im, 
        ia sys.odciindexinfo,
        op sys.odciPredInfo, 
        qi sys.ODCIQueryInfo, 
        strt VARCHAR2, 
        stop VARCHAR2,
        query BLOB, 
        param VARCHAR2, env sys.ODCIEnv) RETURN NUMBER PARALLEL_ENABLE,

  STATIC FUNCTION ODCIIndexStart(sctx in out jc_idxtype_im, 
        ia sys.odciindexinfo,
        op sys.odciPredInfo, 
        qi sys.ODCIQueryInfo, 
        strt VARCHAR2, 
        stop VARCHAR2,
        query BLOB, 
        param1 number,
        param2 number,
        env sys.ODCIEnv) RETURN NUMBER PARALLEL_ENABLE,

  MEMBER FUNCTION ODCIIndexFetch(self IN OUT NOCOPY jc_idxtype_im, 
	nrows NUMBER, rids OUT sys.odciridlist, env sys.ODCIEnv)
    RETURN NUMBER PARALLEL_ENABLE,

  MEMBER FUNCTION ODCIIndexClose(self IN OUT jc_idxtype_im, 
						env sys.ODCIEnv) RETURN NUMBER PARALLEL_ENABLE,

  STATIC FUNCTION ODCIIndexInsert(ia sys.odciindexinfo, rid VARCHAR2, 
	               	       newval VARCHAR2, env sys.ODCIEnv)
      RETURN NUMBER PARALLEL_ENABLE,
  
  STATIC FUNCTION ODCIIndexDelete(ia sys.odciindexinfo, rid VARCHAR2, 
            		       oldval VARCHAR2, env sys.ODCIEnv)
      RETURN NUMBER PARALLEL_ENABLE,
  
  STATIC FUNCTION ODCIIndexUpdate(ia sys.odciindexinfo, rid VARCHAR2, 
       	      oldval VARCHAR2, newval VARCHAR2, env sys.ODCIEnv)
      RETURN NUMBER PARALLEL_ENABLE,

  STATIC FUNCTION ODCIIndexInsert(ia sys.odciindexinfo, rid VARCHAR2, 
             newval CLOB, env sys.ODCIEnv)
      RETURN NUMBER PARALLEL_ENABLE,
          
  STATIC FUNCTION ODCIIndexDelete(ia sys.odciindexinfo, rid VARCHAR2, 
             oldval CLOB, env sys.ODCIEnv)
      RETURN NUMBER PARALLEL_ENABLE,

  STATIC FUNCTION ODCIIndexUpdate(ia sys.odciindexinfo, rid VARCHAR2, 
       	      oldval CLOB, newval CLOB, env sys.ODCIEnv)
      RETURN NUMBER PARALLEL_ENABLE,

  STATIC FUNCTION ODCIIndexInsert(ia sys.odciindexinfo, rid VARCHAR2, 
        newval BLOB, env sys.ODCIEnv) RETURN NUMBER PARALLEL_ENABLE,
  
  STATIC FUNCTION ODCIIndexDelete(ia sys.odciindexinfo, rid VARCHAR2, 
        oldval BLOB, env sys.ODCIEnv) RETURN NUMBER PARALLEL_ENABLE,
  
  STATIC FUNCTION ODCIIndexUpdate(ia sys.odciindexinfo, rid VARCHAR2,
        oldval BLOB, newval BLOB, env sys.ODCIEnv) RETURN NUMBER PARALLEL_ENABLE,

  STATIC FUNCTION ODCIIndexExchangePartition(ia sys.ODCIIndexInfo, 
        ia1 sys.ODCIIndexInfo, env sys.ODCIEnv) RETURN NUMBER PARALLEL_ENABLE,
  STATIC FUNCTION ODCIIndexMergePartition(ia sys.ODCIIndexInfo, 
        part_name1 sys.ODCIPartInfo, part_name2 sys.ODCIPartInfo, 
        parms VARCHAR2, env sys.ODCIEnv) RETURN NUMBER PARALLEL_ENABLE,
  STATIC FUNCTION ODCIIndexSplitPartition(ia sys.ODCIIndexInfo, 
        part_name1 sys.ODCIPartInfo, part_name2 sys.ODCIPartInfo, 
        parms VARCHAR2, env sys.ODCIEnv) RETURN NUMBER PARALLEL_ENABLE
);
/
show errors


-------------------------------------------------------------------
-- Create package used by ODCIIndexGetMetadata and jc_idxtype_im 
-------------------------------------------------------------------
CREATE OR REPLACE PACKAGE jchem_core_pkg AUTHID CURRENT_USER AS

  lastError varchar2(2000);

  simCalcSeparator varchar2(1) := ';';

  function test(password varchar2) return varchar2;

  function trim_error_messages return number as language java
      name 'chemaxon.jchem.cartridge.JFunctions.trimErrorMessages() return int';
  
  procedure handle_java_error(errm varchar2);

  FUNCTION get_cartowner_schema RETURN VARCHAR2 DETERMINISTIC PARALLEL_ENABLE;

  FUNCTION getJChemVersion RETURN VARCHAR2 DETERMINISTIC PARALLEL_ENABLE;

  FUNCTION getTableVersion RETURN NUMBER DETERMINISTIC PARALLEL_ENABLE;

  PROCEDURE init PARALLEL_ENABLE AS LANGUAGE JAVA NAME
      'chemaxon.jchem.cartridge.JFunctions.getRmiTunnel()';

  PROCEDURE check_master_table PARALLEL_ENABLE AS LANGUAGE JAVA NAME
      'chemaxon.jchem.cartridge.JFunctions.checkMasterTable()';

  PROCEDURE set_master_property(idx_schema varchar2, prop_name varchar2, prop_value varchar2)
      PARALLEL_ENABLE AS LANGUAGE JAVA NAME
      'chemaxon.jchem.cartridge.JFunctions.setMasterProperty(
                                                      java.lang.String,
                                                      java.lang.String,
                                                      java.lang.String)';

  PROCEDURE upgr_from_pre24 AS LANGUAGE JAVA NAME
        'chemaxon.jchem.cartridge.JFunctions.upgradeAllFromPre_2_4()';

  FUNCTION get_remote_environment RETURN VARCHAR2 PARALLEL_ENABLE AS LANGUAGE JAVA NAME
	'chemaxon.jchem.cartridge.JFunctions.getEnvironment()
            return java.lang.String';

  FUNCTION getEnvironment RETURN VARCHAR2 PARALLEL_ENABLE;

  FUNCTION jctf_autocalccts(index_schema VARCHAR2,
                            index_name VARCHAR2)
  RETURN COMP_CHAR_ARRAY PIPELINED;
  FUNCTION jctf_autocalccts(index_schema VARCHAR2,
                            index_name VARCHAR2,
                            index_part VARCHAR2)
  RETURN COMP_CHAR_ARRAY PIPELINED;
  FUNCTION jctf_autocalccts_bycol(table_schema VARCHAR2,
                                  table_name VARCHAR2,
                                  table_col VARCHAR2)
  RETURN COMP_CHAR_ARRAY PIPELINED;

  function use_password0(login varchar2, password VARCHAR2) return varchar2
      PARALLEL_ENABLE AS LANGUAGE JAVA NAME
        'chemaxon.jchem.cartridge.JFunctions.usePassword(
          java.lang.String, java.lang.String)
          return java.lang.String';

  procedure use_password(password varchar2) parallel_enable;

  procedure use_password(login varchar2, password varchar2) parallel_enable;

  function use_default_account0 return varchar2
      PARALLEL_ENABLE AS LANGUAGE JAVA NAME
        'chemaxon.jchem.cartridge.JFunctions.useDefaultAccount()
          return java.lang.String';

  procedure use_default_account;

  function set_password(password varchar2) return number parallel_enable;

  PROCEDURE checkTableVersion(
        indexSchema VARCHAR2, idxName VARCHAR2, idxPartition VARCHAR2,
        tblSchema VARCHAR2, tblName VARCHAR2, colName VARCHAR2) PARALLEL_ENABLE 
        AS LANGUAGE JAVA NAME
        'chemaxon.jchem.cartridge.JFunctions.checkTableVersion(
        java.lang.String, java.lang.String, java.lang.String,
        java.lang.String, java.lang.String, java.lang.String)';

  PROCEDURE checkTableVersionEx(func_name VARCHAR2,
                                indexctx IN SYS.ODCIIndexCtx) PARALLEL_ENABLE;

  PROCEDURE regenIndexes(indexSchema VARCHAR2, idxName VARCHAR2,
              qualifTblName VARCHAR2) PARALLEL_ENABLE
    AS LANGUAGE JAVA NAME 'chemaxon.jchem.cartridge.JFunctions.checkTableVersion(
          java.lang.String, java.lang.String, java.lang.String)';

  FUNCTION indexCreate(indexSchema VARCHAR2, indexName VARCHAR2,
    indexPartition VARCHAR2, tblSchema VARCHAR2, tblName VARCHAR2,tblPartition VARCHAR2,
    colName VARCHAR2, parms VARCHAR2) RETURN VARCHAR2
    PARALLEL_ENABLE AS LANGUAGE JAVA NAME 
	'chemaxon.jchem.cartridge.Indexing.indexCreate(java.lang.String, 
		java.lang.String, java.lang.String, java.lang.String, java.lang.String,
		java.lang.String, java.lang.String, java.lang.String)
            return java.lang.String';

  FUNCTION indexAlter(indexSchema VARCHAR2, idxName VARCHAR2,
                      indexPartition VARCHAR2, tblSchema VARCHAR2,
                      tblName VARCHAR2, tablePartition VARCHAR2,
                      colName VARCHAR2, parms VARCHAR2, alter_option NUMBER)
    RETURN NUMBER PARALLEL_ENABLE AS LANGUAGE JAVA NAME 
	'chemaxon.jchem.cartridge.Indexing.indexAlter(java.lang.String, 
        java.lang.String, java.lang.String, java.lang.String, java.lang.String,
        java.lang.String, java.lang.String, java.lang.String, int) return int';

  FUNCTION indexDrop(schemaName VARCHAR2, idxName VARCHAR2,
        idxPartition VARCHAR2, tblSchema VARCHAR2, tblName VARCHAR2)
    RETURN NUMBER PARALLEL_ENABLE AS LANGUAGE JAVA NAME 
	'chemaxon.jchem.cartridge.Indexing.indexDrop(java.lang.String,
        java.lang.String, java.lang.String, java.lang.String,
        java.lang.String) return int';

  FUNCTION indexTruncate(schemaName VARCHAR2, idxName VARCHAR2,
        idxPartition VARCHAR2, tblSchema VARCHAR2, tblName VARCHAR2)
    RETURN NUMBER PARALLEL_ENABLE AS LANGUAGE JAVA NAME 
	'chemaxon.jchem.cartridge.Indexing.indexTruncate(java.lang.String,
        java.lang.String, java.lang.String, java.lang.String,
        java.lang.String) return int';

  function get_idxtable_qname(idxSchema VARCHAR2,
                              idxName VARCHAR2,
                              partition VARCHAR2,
                              jctable number) return varchar2
    as language java name
    'chemaxon.jchem.cartridge.JFunctions.getIdxTableQName(java.lang.String,
                                    java.lang.String,java.lang.String, int)
     return java.lang.String';

  FUNCTION exchangePartitions(localIdxSchema VARCHAR2,
        localIdxName VARCHAR2, localIdxPartition VARCHAR2,
        globalIdxSchema VARCHAR2, globalIdxName VARCHAR2)
    RETURN NUMBER PARALLEL_ENABLE AS LANGUAGE JAVA NAME
	'chemaxon.jchem.cartridge.JFunctions.exchangePartitions(
        java.lang.String, java.lang.String, java.lang.String, 
        java.lang.String, java.lang.String) return int';

  FUNCTION evaluate(target VARCHAR2, options VARCHAR2, rid VARCHAR2,
        idxSchema VARCHAR2, idxName VARCHAR2, idxPartition VARCHAR2,
        tblSchema VARCHAR2, tblName VARCHAR2)
    RETURN VARCHAR2 PARALLEL_ENABLE AS LANGUAGE JAVA NAME 
    'chemaxon.jchem.cartridge.JFunctions.evaluate(java.lang.String,
      java.lang.String, java.lang.String, java.lang.String,
      java.lang.String, java.lang.String, java.lang.String,
      java.lang.String) return java.lang.String';

  FUNCTION evaluate_arr(target VARCHAR2, options VARCHAR2, rid VARCHAR2,
        idxSchema VARCHAR2, idxName VARCHAR2, idxPartition VARCHAR2,
        tblSchema VARCHAR2, tblName VARCHAR2)
    RETURN CHAR_ARRAY PARALLEL_ENABLE AS LANGUAGE JAVA NAME 
    'chemaxon.jchem.cartridge.JFunctions.evaluateArr(java.lang.String,
      java.lang.String, java.lang.String, java.lang.String,
      java.lang.String, java.lang.String, java.lang.String,
      java.lang.String) return java.lang.String[]';

  FUNCTION autocalccts(index_schema VARCHAR2,
                       index_name VARCHAR2,
                       index_partition VARCHAR2)
  RETURN CHAR_ARRAY PARALLEL_ENABLE AS LANGUAGE JAVA NAME
    'chemaxon.jchem.cartridge.ctcol.ChemTermColSupport.getAutoCalcCtsARR(
    java.lang.String, java.lang.String, java.lang.String) return
    java.lang.String[]';

  FUNCTION autocalccts_bycol(table_schema VARCHAR2,
                             table_name VARCHAR2,
                             col_name VARCHAR2)
  RETURN CHAR_ARRAY PARALLEL_ENABLE AS LANGUAGE JAVA NAME
    'chemaxon.jchem.cartridge.ctcol.ChemTermColSupport.getAutoCalcCtsByColARR(
    java.lang.String, java.lang.String, java.lang.String) return
    java.lang.String[]';

  FUNCTION calc_value(query VARCHAR2, rid VARCHAR2, 
	params VARCHAR2, method VARCHAR2, idxSchema VARCHAR2, idxName VARCHAR2, 
    idxPartition VARCHAR2,
	tblSchema VARCHAR2, tblName VARCHAR2) RETURN VARCHAR2 PARALLEL_ENABLE AS 
	LANGUAGE JAVA NAME 'chemaxon.jchem.cartridge.JFunctions.calcValue(
		java.lang.String, java.lang.String, java.lang.String, 
		java.lang.String, java.lang.String, java.lang.String, 
		java.lang.String, java.lang.String, java.lang.String)
        return java.lang.String';

  FUNCTION calc_value_from_idx(rid VARCHAR2, params VARCHAR2, 
	method VARCHAR2, idxSchema VARCHAR2, idxName VARCHAR2, 
    idxPartition VARCHAR2,
	tblSchema VARCHAR2, tableName VARCHAR2) RETURN VARCHAR2 PARALLEL_ENABLE AS 
	LANGUAGE JAVA NAME 'chemaxon.jchem.cartridge.JFunctions.calcValueFromRowid(
		java.lang.String, java.lang.String, java.lang.String, 
		java.lang.String, java.lang.String, java.lang.String,
		java.lang.String, java.lang.String) return java.lang.String';

  FUNCTION index_scan(indexSchema VARCHAR2, idxName VARCHAR2,
                       indexPartition VARCHAR2, tblSchema VARCHAR2,
                       tblname VARCHAR2, colName VARCHAR2, optype VARCHAR2,
                       opflavor VARCHAR2, predinfo VARCHAR2, query VARCHAR2,
                       options VARCHAR2, scannum number) RETURN VARCHAR2 PARALLEL_ENABLE AS
                       LANGUAGE JAVA NAME
	'chemaxon.jchem.cartridge.JFunctions.indexScan(java.lang.String, 
			java.lang.String, java.lang.String, java.lang.String, 
			java.lang.String, java.lang.String, java.lang.String, 
                        java.lang.String, java.lang.String, java.lang.String,
                        java.lang.String, long) return java.lang.String'; 

  FUNCTION get_hit_count(tblSchema VARCHAR2, tblname VARCHAR2, colName VARCHAR2,
                         query VARCHAR2, options VARCHAR2) RETURN NUMBER
                         PARALLEL_ENABLE AS LANGUAGE JAVA NAME
	'chemaxon.jchem.cartridge.JFunctions.getHitCount(java.lang.String, 
			java.lang.String, java.lang.String, java.lang.String, 
                        java.lang.String) return int'; 

  FUNCTION similaritySearch(query VARCHAR2, stype VARCHAR2,
        pred_str VARCHAR2, searchOptions VARCHAR2, indexSchema VARCHAR2,
        idxName VARCHAR2, idxPartition VARCHAR2, tblSchema VARCHAR2,
        tblname VARCHAR2, colName VARCHAR2, scannum number) RETURN VARCHAR2
      PARALLEL_ENABLE AS LANGUAGE JAVA NAME 
	'chemaxon.jchem.cartridge.JcSimilarity.getSimilarity(
                java.lang.String, java.lang.String,
	 	java.lang.String, java.lang.String,
		java.lang.String, java.lang.String, java.lang.String, 
		java.lang.String, java.lang.String, java.lang.String, long)
          return java.lang.String';
  
  FUNCTION get_rowids(scannum NUMBER, nrows NUMBER)
      return jchem_refcur_pkg.refcur_t PARALLEL_ENABLE is language java name
      'chemaxon.jchem.cartridge.JFunctions.getRowids(long, int)
      return java.sql.ResultSet';

  FUNCTION  nr_remaining_rowids(scannum NUMBER) return NUMBER
      PARALLEL_ENABLE is language java name
      'chemaxon.jchem.cartridge.JFunctions.nrRemainingRowids(long) return int';

  PROCEDURE close_scan_resultset(scannum NUMBER)
      PARALLEL_ENABLE is language java name
      'chemaxon.jchem.cartridge.JFunctions.closeScanResultSet(long)';

  FUNCTION exec_function(sqlOperator VARCHAR2, target VARCHAR2,
              query VARCHar2, options VARCHAR2, rid VARCHAR2,
              idxSchema VARCHAR2, idxName VARCHAR2, idxPartition VARCHAR2,
              tblSchema VARCHAR2, tblname VARCHAR2, colName VARCHAR2,
              result out varchar2)
    RETURN VARCHAR2 PARALLEL_ENABLE
	AS LANGUAGE JAVA NAME 'chemaxon.jchem.cartridge.JFunctions.execFunction(
		java.lang.String, java.lang.String, java.lang.String,
		java.lang.String, java.lang.String, java.lang.String, 
                java.lang.String, java.lang.String, java.lang.String,
                java.lang.String, java.lang.String, java.lang.String[])
                return java.lang.String';

  FUNCTION insert_mol_into_idxtable(str VARCHAR2, indexSchema VARCHAR2,
                idxName VARCHAR2, idxPartition VARCHAR2,
                tblSchema VARCHAR2, tblname VARCHAR2, colName VARCHAR2,
                rid VARCHAR2) RETURN VARCHAR2
        PARALLEL_ENABLE AS LANGUAGE JAVA NAME
		'chemaxon.jchem.cartridge.JCartDml.insertMolIntoIndexTable(
		java.lang.String, java.lang.String, java.lang.String, java.lang.String,
		java.lang.String, java.lang.String, java.lang.String, java.lang.String)
                return java.lang.String';

  PROCEDURE delete_mol_from_idxtable(idxSchema VARCHAR2, idxName VARCHAR2,
		idxPartition VARCHAR2, tblSchema VARCHAR2, tblname VARCHAR2, 
		rid VARCHAR2) PARALLEL_ENABLE AS LANGUAGE JAVA NAME
		'chemaxon.jchem.cartridge.JCartDml.deleteMolFromIndexTable(java.lang.String, 
		java.lang.String, java.lang.String, java.lang.String,
		java.lang.String, java.lang.String)';

  FUNCTION update_mol_idxtable(oldval VARCHAR2, str VARCHAR2,
                indexSchema VARCHAR2, idxName VARCHAR2, idxPartition VARCHAR2,
                tblSchema VARCHAR2, tblname VARCHAR2, colName VARCHAR2,
                rid VARCHAR2)
        RETURN VARCHAR2
        PARALLEL_ENABLE AS LANGUAGE JAVA NAME
		'chemaxon.jchem.cartridge.JCartDml.updateMolIndexTable(java.lang.String,
		java.lang.String, java.lang.String, java.lang.String, java.lang.String,
		java.lang.String, java.lang.String, java.lang.String, java.lang.String)
                return java.lang.String';

  FUNCTION calc_molProp(query VARCHAR2, propName VARCHAR2, rid VARCHAR2, 
		idxSchema VARCHAR2, idxName VARCHAR2, idxPartition VARCHAR2,
        tblSchema VARCHAR2, tableName VARCHAR2)
        RETURN VARCHAR2 PARALLEL_ENABLE AS LANGUAGE JAVA NAME 
		'chemaxon.jchem.cartridge.JFunctions.calcMolProp(
                java.lang.String, java.lang.String, java.lang.String,
		java.lang.String, java.lang.String, java.lang.String,
		java.lang.String, java.lang.String) return java.lang.String';

  FUNCTION calc_molProp_from_idx(rid VARCHAR2, propName VARCHAR2, 
	idxSchema VARCHAR2, idxName VARCHAR2, idxPartition VARCHAR2,
    tblSchema VARCHAR2, tableName VARCHAR2)
    RETURN VARCHAR2 PARALLEL_ENABLE AS LANGUAGE JAVA NAME 
	'chemaxon.jchem.cartridge.JFunctions.calcMolPropFromRowid(
    java.lang.String, java.lang.String, java.lang.String, java.lang.String,
    java.lang.String, java.lang.String, java.lang.String)
    return java.lang.String';

  FUNCTION molconvert(query VARCHAR2, inputFormat VARCHAR2, type VARCHAR2, rid VARCHAR2,
        idxSchema VARCHAR2, idxName VARCHAR2, idxPartition VARCHAR2,
        tblSchema VARCHAR2, tableName VARCHAR2)
        RETURN VARCHAR2 PARALLEL_ENABLE AS LANGUAGE JAVA NAME
        'chemaxon.jchem.cartridge.JFunctions.molconvert(java.lang.String,
        java.lang.String, java.lang.String, java.lang.String, java.lang.String,
        java.lang.String, java.lang.String, java.lang.String, java.lang.String)
        return java.lang.String';

  FUNCTION molconvert_from_idx(rid VARCHAR2, type VARCHAR2,
        idxSchema VARCHAR2, idxName VARCHAR2, idxPartition VARCHAR2,
        tblSchema VARCHAR2, tableName VARCHAR2)
        RETURN VARCHAR2 PARALLEL_ENABLE AS LANGUAGE JAVA NAME
        'chemaxon.jchem.cartridge.JFunctions.molconvertFromRowId(
        java.lang.String, java.lang.String, java.lang.String,
        java.lang.String, java.lang.String, java.lang.String)
        return java.lang.String';
  
  FUNCTION molconvertb(query VARCHAR2, inputFormat VARCHAR2, type VARCHAR2, rid VARCHAR2,
        idxSchema VARCHAR2, idxName VARCHAR2, idxPartition VARCHAR2,
        tblSchema VARCHAR2, tableName VARCHAR2, tmp BLOB)
        RETURN BLOB PARALLEL_ENABLE AS LANGUAGE JAVA NAME
        'chemaxon.jchem.cartridge.JFunctions.molconvertb(java.lang.String,
        java.lang.String, java.lang.String, java.lang.String,
        java.lang.String, java.lang.String, java.lang.String, 
        java.lang.String, java.lang.String, oracle.sql.BLOB) return oracle.sql.BLOB';

  FUNCTION molconvertb_from_idx(rid VARCHAR2, type VARCHAR2,
        idxSchema VARCHAR2, idxName VARCHAR2, idxPartition VARCHAR2, 
        tblSchema VARCHAR2, tableName VARCHAR2, tmpBlob BLOB)
        RETURN BLOB PARALLEL_ENABLE AS LANGUAGE JAVA NAME
        'chemaxon.jchem.cartridge.JFunctions.molconvertBFromRowId(
        java.lang.String, java.lang.String, java.lang.String,
        java.lang.String, java.lang.String, java.lang.String, java.lang.String, oracle.sql.BLOB)
        return oracle.sql.BLOB';
  
  FUNCTION send_user_func(name VARCHAR2, delim VARCHAR2, 
	params VARCHAR2) RETURN VARCHAR2 AS LANGUAGE JAVA NAME 
		'chemaxon.jchem.cartridge.JFunctions.sendUserFunc(java.lang.String, 
		java.lang.String, java.lang.String) return java.lang.String';

  PROCEDURE send_user_func_batch(opName VARCHAR2, fieldName VARCHAR2, 
		params VARCHAR2, indexSchema VARCHAR2, tableSchema VARCHAR2,
		tableName VARCHAR2, idxSchema VARCHAR2, scannum NUMBER)
      AS LANGUAGE JAVA NAME
	'chemaxon.jchem.cartridge.JFunctions.sendUserFuncBatch(java.lang.String,
		java.lang.String, java.lang.String, java.lang.String,
		java.lang.String, java.lang.String, java.lang.String, long)';

  PROCEDURE register_user_func(opname VARCHAR2, params VARCHAR2, class VARCHAR2)
	AS LANGUAGE JAVA NAME 'chemaxon.jchem.cartridge.JFunctions.registerUserOps(java.lang.String, 
				java.lang.String, java.lang.String)';

  FUNCTION is_jchem_table(indexSchema VARCHAR2, idxName VARCHAR2,
	tableSchema VARCHAR2, tblName VARCHAR2) RETURN VARCHAR2 AS
	LANGUAGE JAVA NAME 'chemaxon.jchem.cartridge.JFunctions.isJChemTable(
        java.lang.String, java.lang.String, java.lang.String, java.lang.String)
		return java.lang.String';

  PROCEDURE invert_result(res IN OUT NOCOPY CD_ID_ARRAY, tableName VARCHAR2);

  FUNCTION getMolsByField(ftype VARCHAR2, idxSchema VARCHAR2, idxName VARCHAR2,
		 idxPartition VARCHAR2, tblSchema VARCHAR2, tblName VARCHAR2,
         opstr VARCHAR2, strt NUMBER) RETURN VARCHAR2 PARALLEL_ENABLE
         AS LANGUAGE JAVA NAME
    'chemaxon.jchem.cartridge.JFunctions.getMolsByField(java.lang.String,
    java.lang.String, java.lang.String, java.lang.String, java.lang.String,
    java.lang.String, java.lang.String, int) return java.lang.String';

  FUNCTION react(reaction VARCHAR2, reactant1 VARCHAR2, reactant2 VARCHAR2,
                 reactant3 VARCHAR2, reactant4 VARCHAR2, options VARCHAR2,
                 old_jc_react VARCHAR)
      RETURN VARCHAR2 PARALLEL_ENABLE AS LANGUAGE JAVA NAME 
        'chemaxon.jchem.cartridge.JFunctions.react(java.lang.String,
        java.lang.String, java.lang.String, java.lang.String, java.lang.String,
        java.lang.String, java.lang.String) return java.lang.String';

  FUNCTION react_arr(reaction VARCHAR2, reactant1 VARCHAR2, reactant2 VARCHAR2,
                 reactant3 VARCHAR2, reactant4 VARCHAR2, options VARCHAR2,
                 old_jc_react VARCHAR)
      RETURN CHAR_PRODUCT_ARRAY PARALLEL_ENABLE AS LANGUAGE JAVA NAME 
        'chemaxon.jchem.cartridge.JFunctions.reactArr(java.lang.String,
        java.lang.String, java.lang.String, java.lang.String, java.lang.String,
        java.lang.String, java.lang.String) return oracle.sql.ARRAY';

  FUNCTION standardize(structure VARCHAR2, param VARCHAR2)
      RETURN VARCHAR2 PARALLEL_ENABLE AS LANGUAGE JAVA NAME
              'chemaxon.jchem.cartridge.JFunctions.standardize(
            java.lang.String, java.lang.String) return java.lang.String';

  PROCEDURE insert_into_idxtbl(idxtbl_name IN OUT NOCOPY VARCHAR2,
                               cdid_seq_name IN OUT NOCOPY VARCHAR2,
                               molprops IN OUT NOCOPY MOLPROPS_ARRAY_ARRAY);

  FUNCTION create_parse_insidxtbl_cur(idxtbl_name IN OUT NOCOPY VARCHAR2,
                                      cdid_seq_name IN OUT NOCOPY VARCHAR2,
                                      molprops IN OUT NOCOPY MOLPROPS_ARRAY) RETURN INTEGER;

  PROCEDURE insert_into_idxtbl_single(idxtbl_name IN OUT NOCOPY VARCHAR2,
                                     cdid_seq_name IN OUT NOCOPY VARCHAR2,
                                     molprops IN OUT NOCOPY MOLPROPS_ARRAY,
                                     cn INTEGER);

  function get_idx_stats(idx_schema varchar2, idx_name varchar2,
                         idx_partition varchar2) return varchar2
    as language java name
    'chemaxon.jchem.cartridge.Indexing.getIndexStatistics(java.lang.String,
     java.lang.String, java.lang.String) return java.lang.String';

  FUNCTION suspend_idx_update(idx_schema VARCHAR2, idx_name VARCHAR2,
                              idx_partition VARCHAR2, options VARCHAR2)
      RETURN VARCHAR2 AS LANGUAGE JAVA NAME
      'chemaxon.jchem.cartridge.Indexing.suspendIndexUpdate(java.lang.String,
      java.lang.String, java.lang.String, java.lang.String) return java.lang.String';

  PROCEDURE resume_idx_update(idx_schema VARCHAR2, idx_name VARCHAR2,
                                 options VARCHAR2) AS LANGUAGE JAVA NAME
      'chemaxon.jchem.cartridge.Indexing.resumeIndexUpdate(java.lang.String,
      java.lang.String, java.lang.String)';

  procedure purge_connection_cache as language java name
      'chemaxon.jchem.cartridge.JFunctions.purgeConnectionCache()';

  function get_gmemutil_arr return gmem_util_array
      as language java name
      'chemaxon.jchem.cartridge.JFunctions.getGlobalMemUtil()
        return oracle.sql.ARRAY';

  function get_taskinfo_arr return taskinfo_array
      as language java name
      'chemaxon.jchem.cartridge.JFunctions.getTaskInfos()
        return oracle.sql.ARRAY';

END jchem_core_pkg;
/
show errors;

------------------
-- jchem_clob_pkg
------------------
CREATE OR REPLACE PACKAGE jchem_clob_pkg AUTHID CURRENT_USER AS

  FUNCTION exec_function_cv(sqlOperator VARCHAR2, target CLOB, query VARCHAR2, 
        options VARCHAR2, rid VARCHAR2, idxSchema VARCHAR2, idxName VARCHAR2,
        idxPartition VARCHAR2, tblSchema VARCHAR2, tblName VARCHAR2, colName VARCHAR2,
        result out varchar2)
    RETURN VARCHAR2 PARALLEL_ENABLE AS LANGUAGE JAVA NAME 
    'chemaxon.jchem.cartridge.JCFunctionsClob.execFunction(
        java.lang.String, oracle.sql.CLOB, java.lang.String, java.lang.String,
        java.lang.String, java.lang.String, java.lang.String,  java.lang.String,
        java.lang.String, java.lang.String, java.lang.String, java.lang.String[])
      return java.lang.String';

  FUNCTION exec_function_vc(sqlOperator VARCHAR2, target VARCHAR2, query CLOB, 
        options VARCHAR2, rid VARCHAR2, idxSchema VARCHAR2, idxName VARCHAR2,
        idxPartition VARCHAR2, tblSchema VARCHAR2, tblName VARCHAR2, colName VARCHAR2,
        result out varchar2)
    RETURN VARCHAR2 PARALLEL_ENABLE AS LANGUAGE JAVA NAME 
    'chemaxon.jchem.cartridge.JCFunctionsClob.execFunction(java.lang.String,
    java.lang.String, oracle.sql.CLOB, java.lang.String, java.lang.String,
    java.lang.String, java.lang.String,  java.lang.String, java.lang.String,
    java.lang.String, java.lang.String, java.lang.String[]) return java.lang.String';

  FUNCTION exec_function_cb(sqlOperator VARCHAR2, target CLOB, query BLOB, 
        options VARCHAR2, rid VARCHAR2, idxSchema VARCHAR2, idxName VARCHAR2,
        idxPartition VARCHAR2, tblSchema VARCHAR2, tblName VARCHAR2, colName VARCHAR2,
        result out varchar2)
    RETURN VARCHAR2 PARALLEL_ENABLE AS LANGUAGE JAVA NAME 
    'chemaxon.jchem.cartridge.JCFunctionsClob.execFunction(java.lang.String,
    oracle.sql.CLOB, oracle.sql.BLOB, java.lang.String, java.lang.String,
    java.lang.String, java.lang.String,  java.lang.String, java.lang.String,
    java.lang.String, java.lang.String, java.lang.String[]) return java.lang.String';

  FUNCTION exec_function(sqlOperator VARCHAR2, target CLOB, query CLOB, 
        options VARCHAR2, rid VARCHAR2, idxSchema VARCHAR2, idxName VARCHAR2,
        idxPartition VARCHAR2, tblSchema VARCHAR2, tblName VARCHAR2, colName VARCHAR2,
        result out varchar2)
    RETURN VARCHAR2 PARALLEL_ENABLE AS LANGUAGE JAVA NAME 
    'chemaxon.jchem.cartridge.JCFunctionsClob.execFunction(java.lang.String,
    oracle.sql.CLOB, oracle.sql.CLOB, java.lang.String, java.lang.String,
    java.lang.String, java.lang.String,  java.lang.String, java.lang.String,
    java.lang.String, java.lang.String, java.lang.String[]) return java.lang.String';

  FUNCTION exec_function__c(sqlOperator VARCHAR2, query CLOB, target CLOB, 
        options VARCHAR2, rid VARCHAR2, idxSchema VARCHAR2, idxName VARCHAR2,
        idxPartition VARCHAR2, tblSchema VARCHAR2, tblName VARCHAR2, colName VARCHAR2,
        result out CLOB)
    RETURN VARCHAR2 PARALLEL_ENABLE AS LANGUAGE JAVA NAME 
    'chemaxon.jchem.cartridge.JCFunctionsClob.execFunctionC(java.lang.String,
    oracle.sql.CLOB, oracle.sql.CLOB, java.lang.String, java.lang.String,
    java.lang.String, java.lang.String,  java.lang.String, java.lang.String,
    java.lang.String, java.lang.String, oracle.sql.CLOB[]) return java.lang.String';

  FUNCTION evaluate_arr(target CLOB, options VARCHAR2, rid VARCHAR2,
        idxSchema VARCHAR2, idxName VARCHAR2, idxPartition VARCHAR2,
        tblSchema VARCHAR2, tblName VARCHAR2)
    RETURN CLOB_ARRAY PARALLEL_ENABLE AS LANGUAGE JAVA NAME 
    'chemaxon.jchem.cartridge.JCFunctionsClob.evaluateArr(oracle.sql.CLOB,
      java.lang.String, java.lang.String, java.lang.String,
      java.lang.String, java.lang.String, java.lang.String,
      java.lang.String) return oracle.sql.CLOB[]';

  FUNCTION hitColorAndAlign(tblSchema VARCHAR2, tblName VARCHAR2,
              colName VARCHAR2, query CLOB, rowids VARCHAR2,
              options VARCHAR2, hitColorAndAlignOptions VARCHAR2)
              RETURN CLOB_ARRAY PARALLEL_ENABLE AS LANGUAGE JAVA NAME 
    'chemaxon.jchem.cartridge.JCFunctionsClob.hitColorAndAlignOptions(
      java.lang.String, java.lang.String, java.lang.String,
      oracle.sql.CLOB, java.lang.String, java.lang.String, java.lang.String)
      return oracle.sql.CLOB[]';

  FUNCTION calc_value(query CLOB, rid VARCHAR2, params VARCHAR2,
    method VARCHAR2, idxSchema VARCHAR2, idxName VARCHAR2, idxPartition VARCHAR2,
	tblSchema VARCHAR2, tblName VARCHAR2) RETURN VARCHAR2 PARALLEL_ENABLE AS 
	LANGUAGE JAVA NAME 'chemaxon.jchem.cartridge.JCFunctionsClob.calcValue(
        oracle.sql.CLOB, java.lang.String, java.lang.String, java.lang.String,
		java.lang.String, java.lang.String, java.lang.String, 
		java.lang.String, java.lang.String) return java.lang.String';

  FUNCTION index_scan(indexSchema VARCHAR2, idxName VARCHAR2,
                       indexPartition VARCHAR2, tblSchema VARCHAR2,
                       tblname VARCHAR2, colName VARCHAR2, optype VARCHAR2,
                       opflavor VARCHAR2, predinfo VARCHAR2, query clob,
                       options VARCHAR2, scannum number) RETURN VARCHAR2 PARALLEL_ENABLE AS
                       LANGUAGE JAVA NAME
	'chemaxon.jchem.cartridge.JCFunctionsClob.indexScan(java.lang.String, 
			java.lang.String, java.lang.String, java.lang.String, 
			java.lang.String, java.lang.String, java.lang.String, 
                        java.lang.String, java.lang.String, oracle.sql.CLOB,
                        java.lang.String, long) return java.lang.String'; 

  FUNCTION get_hit_count(tblSchema VARCHAR2, tblname VARCHAR2, colName VARCHAR2,
                         query CLOB, options VARCHAR2) RETURN NUMBER
                         PARALLEL_ENABLE AS LANGUAGE JAVA NAME
	'chemaxon.jchem.cartridge.JCFunctionsClob.getHitCount(java.lang.String, 
			java.lang.String, java.lang.String, oracle.sql.CLOB,
                        java.lang.String) return int'; 

  FUNCTION similaritySearch(query CLOB, stype VARCHAR2,
            pred_str VARCHAR2, searchOptions VARCHAR2, indexSchema VARCHAR2,
            idxName VARCHAR2, idxPartition VARCHAR2, tblSchema VARCHAR2,
            tblname VARCHAR2, colName VARCHAR2, scannum NUMBER) RETURN VARCHAR2
    PARALLEL_ENABLE AS LANGUAGE JAVA NAME 
	'chemaxon.jchem.cartridge.JCFunctionsClob.getSimilarity(
        oracle.sql.CLOB, java.lang.String, java.lang.String,
        java.lang.String, java.lang.String, java.lang.String,
        java.lang.String, java.lang.String,
        java.lang.String, java.lang.String, long)
          return java.lang.String';
  
  FUNCTION insert_mol_into_idxtable(str CLOB, 
		indexSchema VARCHAR2, idxName VARCHAR2, idxPartition VARCHAR2,
                tblSchema VARCHAR2, tblname VARCHAR2, colName VARCHAR2, rid VARCHAR2)
        RETURN VARCHAR2 PARALLEL_ENABLE AS LANGUAGE JAVA NAME
		'chemaxon.jchem.cartridge.JCFunctionsClob.insertMolIntoIndexTable(
		oracle.sql.CLOB, java.lang.String, java.lang.String, java.lang.String,
		java.lang.String, java.lang.String, java.lang.String, java.lang.String)
                return java.lang.String';

  FUNCTION update_mol_idxtable(oldval CLOB, str CLOB, 
                  indexSchema VARCHAR2, idxName VARCHAR2, idxPartition VARCHAR2,
                  tblSchema VARCHAR2, tblname VARCHAR2, colName VARCHAR2,
                  rid VARCHAR2)
        RETURN VARCHAR2
        PARALLEL_ENABLE AS LANGUAGE JAVA NAME
		'chemaxon.jchem.cartridge.JCFunctionsClob.updateMolIndexTable(
                 oracle.sql.CLOB,
                 oracle.sql.CLOB, java.lang.String, java.lang.String, java.lang.String,
		 java.lang.String, java.lang.String, java.lang.String, java.lang.String)
                return java.lang.String';

  FUNCTION calc_molProp(query CLOB, propName VARCHAR2, rid VARCHAR2, 
		idxSchema VARCHAR2, idxName VARCHAR2, idxPartition VARCHAR2, 
        tblSchema VARCHAR2, tableName VARCHAR2) RETURN CLOB
        PARALLEL_ENABLE AS LANGUAGE JAVA NAME 
		'chemaxon.jchem.cartridge.JCFunctionsClob.calcMolProp(
        oracle.sql.CLOB, java.lang.String, java.lang.String, 
		java.lang.String, java.lang.String, java.lang.String,
		java.lang.String, java.lang.String) return oracle.sql.CLOB';

  FUNCTION get_molweight(query CLOB, rid VARCHAR2, 
		idxSchema VARCHAR2, idxName VARCHAR2, idxPartition VARCHAR2,
        tblSchema VARCHAR2, tableName VARCHAR2) RETURN VARCHAR2
        PARALLEL_ENABLE AS LANGUAGE JAVA NAME 
		'chemaxon.jchem.cartridge.JCFunctionsClob.getMolweight(
        oracle.sql.CLOB, java.lang.String,java.lang.String,
        java.lang.String, java.lang.String, java.lang.String,
        java.lang.String) return java.lang.String';

  FUNCTION get_molformula(query CLOB, rid VARCHAR2, 
		idxSchema VARCHAR2, idxName VARCHAR2,  idxPartition VARCHAR2,
        tblSchema VARCHAR2, tableName VARCHAR2) RETURN VARCHAR2
        PARALLEL_ENABLE AS LANGUAGE JAVA NAME 
		'chemaxon.jchem.cartridge.JCFunctionsClob.getMolformula(
        oracle.sql.CLOB, java.lang.String, java.lang.String,
        java.lang.String, java.lang.String, java.lang.String,
        java.lang.String) return java.lang.String';

  FUNCTION calc_molProp_from_idx(rid VARCHAR2, propName VARCHAR2, 
	idxSchema VARCHAR2, idxName VARCHAR2,  idxPartition VARCHAR2,
    tblSchema VARCHAR2, tableName VARCHAR2) RETURN CLOB
    PARALLEL_ENABLE AS LANGUAGE JAVA NAME 
	'chemaxon.jchem.cartridge.JCFunctionsClob.calcMolPropFromRowid(
    java.lang.String, java.lang.String, java.lang.String, java.lang.String,
    java.lang.String, java.lang.String, java.lang.String)
	return oracle.sql.CLOB';

  FUNCTION molconvertc(query CLOB, inputFormat VARCHAR2, type VARCHAR2, rid VARCHAR2,
        idxSchema VARCHAR2, idxName VARCHAR2, idxPartition VARCHAR2, 
        tblSchema VARCHAR2, tableName VARCHAR2, tmpBlob CLOB)
        RETURN CLOB PARALLEL_ENABLE AS LANGUAGE JAVA NAME
        'chemaxon.jchem.cartridge.JCFunctionsClob.molconvertc(
        oracle.sql.CLOB, java.lang.String,java.lang.String,java.lang.String,
        java.lang.String, java.lang.String, java.lang.String,
        java.lang.String, java.lang.String, oracle.sql.CLOB)
        return oracle.sql.CLOB';

  FUNCTION molconvertc_from_idx(rid VARCHAR2, type VARCHAR2,
        idxSchema VARCHAR2, idxName VARCHAR2, idxPartition VARCHAR2, 
        tblSchema VARCHAR2, tableName VARCHAR2, tmpBlob CLOB)
        RETURN CLOB PARALLEL_ENABLE AS LANGUAGE JAVA NAME
        'chemaxon.jchem.cartridge.JCFunctionsClob.molconvertCFromRowId(
        java.lang.String, java.lang.String, java.lang.String, java.lang.String,
        java.lang.String, java.lang.String, java.lang.String, oracle.sql.CLOB)
        return oracle.sql.CLOB';
  
  FUNCTION molconvertb(query CLOB, inputFormat VARCHAR2, type VARCHAR2, rid VARCHAR2,
        idxSchema VARCHAR2, idxName VARCHAR2, idxPartition VARCHAR2, 
        tblSchema VARCHAR2, tableName VARCHAR2, tmpBlob BLOB)
        RETURN BLOB PARALLEL_ENABLE AS LANGUAGE JAVA NAME
        'chemaxon.jchem.cartridge.JCFunctionsClob.molconvertb(
        oracle.sql.CLOB, java.lang.String,java.lang.String,java.lang.String,
        java.lang.String, java.lang.String, java.lang.String,
        java.lang.String, java.lang.String, oracle.sql.BLOB)
        return oracle.sql.BLOB';

  FUNCTION send_user_func(name VARCHAR2, delim VARCHAR2, 
	params CLOB) RETURN CLOB AS LANGUAGE JAVA NAME 
		'chemaxon.jchem.cartridge.JCFunctionsClob.sendUserFunc(
        java.lang.String, java.lang.String, oracle.sql.CLOB)
        return oracle.sql.CLOB';

  PROCEDURE send_user_func_batch(opName VARCHAR2, fieldName VARCHAR2, 
		operator_str VARCHAR2, params CLOB, indexSchema VARCHAR2,
        tableSchema VARCHAR2, tableName VARCHAR2,
        idxSchema VARCHAR2, scannum NUMBER) AS LANGUAGE JAVA NAME
	'chemaxon.jchem.cartridge.JCFunctionsClob.sendUserFuncBatch(
        java.lang.String, java.lang.String,
		oracle.sql.CLOB, java.lang.String, java.lang.String,
		java.lang.String, java.lang.String, long)';

  FUNCTION getMolsByField(ftype VARCHAR2, idxSchema VARCHAR2, idxName VARCHAR2,
		 idxPartition VARCHAR2, tblSchema VARCHAR2, tblName VARCHAR2,
         opstr CLOB, strt NUMBER) RETURN VARCHAR2 PARALLEL_ENABLE
         AS LANGUAGE JAVA NAME
    'chemaxon.jchem.cartridge.JCFunctionsClob.getMolsByField(java.lang.String,
    java.lang.String, java.lang.String, java.lang.String, java.lang.String,
    java.lang.String, oracle.sql.CLOB, int) return java.lang.String';

  FUNCTION react(reaction CLOB, reactant1 CLOB, reactant2 CLOB, reactant3 CLOB,
          reactant4 CLOB, options VARCHAR2, tempBlob CLOB, old_jc_react VARCHAR)
          RETURN CLOB PARALLEL_ENABLE AS LANGUAGE JAVA NAME 
        'chemaxon.jchem.cartridge.JCFunctionsClob.react( oracle.sql.CLOB,
        oracle.sql.CLOB, oracle.sql.CLOB, oracle.sql.CLOB, oracle.sql.CLOB,
        java.lang.String, oracle.sql.CLOB, java.lang.String)
        return oracle.sql.CLOB';

  FUNCTION react_arr(reaction CLOB, reactant1 CLOB, reactant2 CLOB, reactant3 CLOB,
          reactant4 CLOB, options VARCHAR2, tempBlob CLOB)
          RETURN CLOB_PRODUCT_ARRAY PARALLEL_ENABLE AS LANGUAGE JAVA NAME 
        'chemaxon.jchem.cartridge.JCFunctionsClob.reactArr(oracle.sql.CLOB,
        oracle.sql.CLOB, oracle.sql.CLOB, oracle.sql.CLOB, oracle.sql.CLOB,
        java.lang.String, oracle.sql.CLOB)
        return oracle.sql.ARRAY';

  FUNCTION standardize(structure CLOB, param VARCHAR2, temp_blob CLOB)
      RETURN CLOB PARALLEL_ENABLE AS LANGUAGE JAVA NAME
      'chemaxon.jchem.cartridge.JCFunctionsClob.standardize(
      oracle.sql.CLOB, java.lang.String, oracle.sql.CLOB)
      return oracle.sql.CLOB';

  FUNCTION equals(b1 CLOB, b2 CLOB) RETURN NUMBER PARALLEL_ENABLE
        AS LANGUAGE JAVA NAME 
		'chemaxon.jchem.cartridge.JCFunctionsClob.equals(
        oracle.sql.CLOB, oracle.sql.CLOB) return int';
END jchem_clob_pkg;
/
show errors;

------------------
-- jchem_blob_pkg
------------------
CREATE OR REPLACE PACKAGE jchem_blob_pkg AUTHID CURRENT_USER AS

  FUNCTION exec_function_vb(sqlOperator VARCHAR2, target VARCHAR2, query BLOB,
        options VARCHAR2, rid VARCHAR2, idxSchema VARCHAR2,
        idxName VARCHAR2, idxPartition VARCHAR2, 
        tblSchema VARCHAR2, tblName VARCHAR2, colName VARCHAR2,
        result out varchar2)
    RETURN VARCHAR2 PARALLEL_ENABLE AS LANGUAGE JAVA NAME 
    'chemaxon.jchem.cartridge.JCFunctionsBlob.execFunction(
      java.lang.String, java.lang.String, oracle.sql.BLOB, java.lang.String,
      java.lang.String, java.lang.String, java.lang.String,  java.lang.String,
      java.lang.String, java.lang.String, java.lang.String, java.lang.String[])
      return java.lang.String';

  FUNCTION exec_function_bv(sqlOperator VARCHAR2, target BLOB, query VARCHAR2, 
        options VARCHAR2, rid VARCHAR2, idxSchema VARCHAR2, idxName VARCHAR2,
        idxPartition VARCHAR2, tblSchema VARCHAR2, tblName VARCHAR2, colName VARCHAR2,
        result out varchar2)
    RETURN VARCHAR2 PARALLEL_ENABLE AS LANGUAGE JAVA NAME 
    'chemaxon.jchem.cartridge.JCFunctionsBlob.execFunction(java.lang.String,
    oracle.sql.BLOB, java.lang.String, java.lang.String, java.lang.String,
    java.lang.String, java.lang.String,  java.lang.String, java.lang.String,
    java.lang.String, java.lang.String,
    java.lang.String[]) return java.lang.String';

  FUNCTION exec_function(sqlOperator VARCHAR2, query BLOB, target BLOB, 
        options VARCHAR2, rid VARCHAR2, idxSchema VARCHAR2, idxName VARCHAR2,
        idxPartition VARCHAR2, tblSchema VARCHAR2, tblName VARCHAR2, colName VARCHAR2,
        result out varchar2)
    RETURN VARCHAR2 PARALLEL_ENABLE AS LANGUAGE JAVA NAME 
    'chemaxon.jchem.cartridge.JCFunctionsBlob.execFunction(java.lang.String,
    oracle.sql.BLOB, oracle.sql.BLOB, java.lang.String, java.lang.String,
    java.lang.String, java.lang.String,  java.lang.String, java.lang.String,
    java.lang.String, java.lang.String, java.lang.String[]) return java.lang.String';

  FUNCTION exec_function__b(sqlOperator VARCHAR2, query BLOB, target BLOB, 
        options VARCHAR2, rid VARCHAR2, idxSchema VARCHAR2, idxName VARCHAR2,
        idxPartition VARCHAR2, tblSchema VARCHAR2, tblName VARCHAR2, colName VARCHAR2,
        result out BLOB)
    RETURN VARCHAR2 PARALLEL_ENABLE AS LANGUAGE JAVA NAME 
    'chemaxon.jchem.cartridge.JCFunctionsBlob.execFunctionB(java.lang.String,
    oracle.sql.BLOB, oracle.sql.BLOB, java.lang.String, java.lang.String,
    java.lang.String, java.lang.String,  java.lang.String, java.lang.String,
    java.lang.String, java.lang.String, oracle.sql.BLOB[]) return java.lang.String';

  FUNCTION evaluate_arr(target BLOB, options VARCHAR2, rid VARCHAR2,
        idxSchema VARCHAR2, idxName VARCHAR2, idxPartition VARCHAR2,
        tblSchema VARCHAR2, tblName VARCHAR2)
    RETURN BLOB_ARRAY PARALLEL_ENABLE AS LANGUAGE JAVA NAME 
    'chemaxon.jchem.cartridge.JCFunctionsBlob.evaluateArr(oracle.sql.BLOB,
      java.lang.String, java.lang.String, java.lang.String,
      java.lang.String, java.lang.String, java.lang.String,
      java.lang.String) return oracle.sql.BLOB[]';


  FUNCTION hitColorAndAlign(tblSchema VARCHAR2, tblName VARCHAR2,
              colName VARCHAR2, query BLOB, rowids VARCHAR2,
              options VARCHAR2, hitColorAndAlignOptions VARCHAR2)
              RETURN BLOB_ARRAY PARALLEL_ENABLE AS LANGUAGE JAVA NAME 
    'chemaxon.jchem.cartridge.JCFunctionsBlob.hitColorAndAlignOptions(
      java.lang.String, java.lang.String, java.lang.String,
      oracle.sql.BLOB, java.lang.String, java.lang.String, java.lang.String)
      return oracle.sql.BLOB[]';

  FUNCTION calc_value(query BLOB, rid VARCHAR2, params VARCHAR2,
    method VARCHAR2, idxSchema VARCHAR2, idxName VARCHAR2, idxPartition VARCHAR2,
	tblSchema VARCHAR2, tblName VARCHAR2) RETURN VARCHAR2 PARALLEL_ENABLE AS 
	LANGUAGE JAVA NAME 'chemaxon.jchem.cartridge.JCFunctionsBlob.calcValue(
        oracle.sql.BLOB, java.lang.String, java.lang.String, java.lang.String,
		java.lang.String, java.lang.String, java.lang.String, 
		java.lang.String, java.lang.String) return java.lang.String';

  FUNCTION index_scan(indexSchema VARCHAR2, idxName VARCHAR2,
                       indexPartition VARCHAR2, tblSchema VARCHAR2,
                       tblname VARCHAR2, colName VARCHAR2, optype VARCHAR2,
                       opflavor VARCHAR2, predinfo VARCHAR2, query blob,
                       options VARCHAR2, scannum number) RETURN VARCHAR2 PARALLEL_ENABLE AS
                       LANGUAGE JAVA NAME
	'chemaxon.jchem.cartridge.JCFunctionsBlob.indexScan(java.lang.String, 
			java.lang.String, java.lang.String, java.lang.String, 
			java.lang.String, java.lang.String, java.lang.String, 
                        java.lang.String, java.lang.String, oracle.sql.BLOB,
                        java.lang.String, long) return java.lang.String'; 

  FUNCTION get_hit_count(tblSchema VARCHAR2, tblname VARCHAR2, colName VARCHAR2,
                         query BLOB, options VARCHAR2) RETURN NUMBER
                         PARALLEL_ENABLE AS LANGUAGE JAVA NAME
	'chemaxon.jchem.cartridge.JCFunctionsBlob.getHitCount(java.lang.String, 
			java.lang.String, java.lang.String, oracle.sql.BLOB,
                        java.lang.String) return int'; 

  FUNCTION similaritySearch(query BLOB, stype VARCHAR2,
                pred_str VARCHAR2, searchOptions VARCHAR2, indexSchema VARCHAR2,
                idxName VARCHAR2, idxPartition VARCHAR2, tblSchema VARCHAR2,
                tblname VARCHAR2, colName VARCHAR2, scannum NUMBER) RETURN VARCHAR2
    PARALLEL_ENABLE AS LANGUAGE JAVA NAME 
	'chemaxon.jchem.cartridge.JCFunctionsBlob.getSimilarity(
        oracle.sql.BLOB, java.lang.String, java.lang.String, java.lang.String,
        java.lang.String, java.lang.String, java.lang.String,
        java.lang.String, java.lang.String, java.lang.String, long)
          return java.lang.String';
  
  FUNCTION insert_mol_into_idxtable(str BLOB, 
		indexSchema VARCHAR2, idxName VARCHAR2, idxPartition VARCHAR2,
        tblSchema VARCHAR2, tblname VARCHAR2, colName VARCHAR2, rid VARCHAR2)
        RETURN VARCHAR2
        PARALLEL_ENABLE AS LANGUAGE JAVA NAME
		'chemaxon.jchem.cartridge.JCFunctionsBlob.insertMolIntoIndexTable(
		oracle.sql.BLOB, java.lang.String, java.lang.String, java.lang.String,
		java.lang.String, java.lang.String, java.lang.String, java.lang.String)
                return java.lang.String';

  FUNCTION update_mol_idxtable(oldval BLOB, str BLOB, 
		indexSchema VARCHAR2, idxName VARCHAR2, idxPartition VARCHAR2,
                tblSchema VARCHAR2, tblname VARCHAR2, colName VARCHAR2,
                rid VARCHAR2)
        RETURN VARCHAR2
        PARALLEL_ENABLE AS LANGUAGE JAVA NAME
		'chemaxon.jchem.cartridge.JCFunctionsBlob.updateMolIndexTable(
                 oracle.sql.BLOB,
                 oracle.sql.BLOB, java.lang.String, java.lang.String, java.lang.String,
		 java.lang.String, java.lang.String, java.lang.String, java.lang.String)
                return java.lang.String';

  FUNCTION calc_molProp(query BLOB, propName VARCHAR2, rid VARCHAR2, 
		idxSchema VARCHAR2, idxName VARCHAR2, idxPartition VARCHAR2, 
        tblSchema VARCHAR2, tableName VARCHAR2) RETURN BLOB
        PARALLEL_ENABLE AS LANGUAGE JAVA NAME 
		'chemaxon.jchem.cartridge.JCFunctionsBlob.calcMolProp(
        oracle.sql.BLOB, java.lang.String, java.lang.String, 
		java.lang.String, java.lang.String, java.lang.String,
		java.lang.String, java.lang.String) return oracle.sql.BLOB';

  FUNCTION get_molweight(query BLOB, rid VARCHAR2, 
		idxSchema VARCHAR2, idxName VARCHAR2, idxPartition VARCHAR2,
        tblSchema VARCHAR2, tableName VARCHAR2) RETURN VARCHAR2
        PARALLEL_ENABLE AS LANGUAGE JAVA NAME 
		'chemaxon.jchem.cartridge.JCFunctionsBlob.getMolweight(
        oracle.sql.BLOB, java.lang.String,java.lang.String,
        java.lang.String, java.lang.String, java.lang.String,
        java.lang.String) return java.lang.String';

  FUNCTION get_molformula(query BLOB, rid VARCHAR2, 
		idxSchema VARCHAR2, idxName VARCHAR2,  idxPartition VARCHAR2,
        tblSchema VARCHAR2, tableName VARCHAR2) RETURN VARCHAR2
        PARALLEL_ENABLE AS LANGUAGE JAVA NAME 
		'chemaxon.jchem.cartridge.JCFunctionsBlob.getMolformula(
        oracle.sql.BLOB, java.lang.String, java.lang.String,
        java.lang.String, java.lang.String, java.lang.String,
        java.lang.String) return java.lang.String';

  FUNCTION calc_molProp_from_idx(rid VARCHAR2, propName VARCHAR2, 
	idxSchema VARCHAR2, idxName VARCHAR2,  idxPartition VARCHAR2,
    tblSchema VARCHAR2, tableName VARCHAR2) RETURN BLOB
    PARALLEL_ENABLE AS LANGUAGE JAVA NAME 
	'chemaxon.jchem.cartridge.JCFunctionsBlob.calcMolPropFromRowid(
    java.lang.String, java.lang.String, java.lang.String, java.lang.String,
    java.lang.String, java.lang.String, java.lang.String)
	return oracle.sql.BLOB';

  FUNCTION molconvertb(query BLOB, inputFormat VARCHAR2, type VARCHAR2, rid VARCHAR2,
        idxSchema VARCHAR2, idxName VARCHAR2, idxPartition VARCHAR2, 
        tblSchema VARCHAR2, tableName VARCHAR2, tmpBlob BLOB)
        RETURN BLOB PARALLEL_ENABLE AS LANGUAGE JAVA NAME
        'chemaxon.jchem.cartridge.JCFunctionsBlob.molconvertb(
        oracle.sql.BLOB, java.lang.String,java.lang.String,java.lang.String,
        java.lang.String, java.lang.String, java.lang.String,
        java.lang.String, java.lang.String, oracle.sql.BLOB)
        return oracle.sql.BLOB';

  FUNCTION send_user_func(name VARCHAR2, delim VARCHAR2, 
	params BLOB) RETURN BLOB AS LANGUAGE JAVA NAME 
		'chemaxon.jchem.cartridge.JCFunctionsBlob.sendUserFunc(
        java.lang.String, java.lang.String, oracle.sql.BLOB)
        return oracle.sql.BLOB';

  PROCEDURE send_user_func_batch(opName VARCHAR2, fieldName VARCHAR2, 
		operator_str VARCHAR2, params BLOB, indexSchema VARCHAR2,
        tableSchema VARCHAR2, tableName VARCHAR2,
        idxSchema VARCHAR2, scannum NUMBER) AS LANGUAGE JAVA NAME
	'chemaxon.jchem.cartridge.JCFunctionsBlob.sendUserFuncBatch(
        java.lang.String, java.lang.String,
		oracle.sql.BLOB, java.lang.String, java.lang.String,
		java.lang.String, java.lang.String, long)';

  FUNCTION getMolsByField(ftype VARCHAR2, idxSchema VARCHAR2, idxName VARCHAR2,
		 idxPartition VARCHAR2, tblSchema VARCHAR2, tblName VARCHAR2,
         opstr BLOB, strt NUMBER) RETURN VARCHAR2 PARALLEL_ENABLE
         AS LANGUAGE JAVA NAME
    'chemaxon.jchem.cartridge.JCFunctionsBlob.getMolsByField(java.lang.String,
    java.lang.String, java.lang.String, java.lang.String, java.lang.String,
    java.lang.String, oracle.sql.BLOB, int) return java.lang.String';

  FUNCTION react(reaction BLOB, reactant1 BLOB, reactant2 BLOB, reactant3 BLOB,
          reactant4 BLOB, options VARCHAR2, tempBlob BLOB, old_jc_react VARCHAR)
          RETURN BLOB PARALLEL_ENABLE AS LANGUAGE JAVA NAME 
        'chemaxon.jchem.cartridge.JCFunctionsBlob.react( oracle.sql.BLOB,
        oracle.sql.BLOB, oracle.sql.BLOB, oracle.sql.BLOB, oracle.sql.BLOB,
        java.lang.String, oracle.sql.BLOB, java.lang.String)
        return oracle.sql.BLOB';

  FUNCTION react_arr(reaction BLOB, reactant1 BLOB, reactant2 BLOB, reactant3 BLOB,
          reactant4 BLOB, options VARCHAR2, tempBlob BLOB)
          RETURN BLOB_PRODUCT_ARRAY PARALLEL_ENABLE AS LANGUAGE JAVA NAME 
        'chemaxon.jchem.cartridge.JCFunctionsBlob.reactArr(oracle.sql.BLOB,
        oracle.sql.BLOB, oracle.sql.BLOB, oracle.sql.BLOB, oracle.sql.BLOB,
        java.lang.String, oracle.sql.BLOB)
        return oracle.sql.ARRAY';

  FUNCTION standardize(structure BLOB, param VARCHAR2, temp_blob BLOB)
      RETURN BLOB PARALLEL_ENABLE AS LANGUAGE JAVA NAME
      'chemaxon.jchem.cartridge.JCFunctionsBlob.standardize(
      oracle.sql.BLOB, java.lang.String, oracle.sql.BLOB)
      return oracle.sql.BLOB';

  FUNCTION equals(b1 BLOB, b2 BLOB) RETURN NUMBER PARALLEL_ENABLE
        AS LANGUAGE JAVA NAME 
		'chemaxon.jchem.cartridge.JCFunctionsBlob.equals(
        oracle.sql.BLOB, oracle.sql.BLOB) return int';

END jchem_blob_pkg;
/
show errors;

CREATE OR REPLACE PACKAGE jchem_misc_pkg AUTHID CURRENT_USER AS

  is_profiling boolean;

  PROCEDURE put_time as language java name 'chemaxon.jchem.cartridge.JFunctions.putTime()';

  FUNCTION get_jchemstreams_url RETURN VARCHAR2;

  PROCEDURE memstat(dir VARCHAR2, name VARCHAR2) AS LANGUAGE JAVA NAME
      'chemaxon.jchem.cartridge.JFunctions.memstat(java.lang.String,
                                                   java.lang.String)';
  PROCEDURE setDbCallback(host VARCHAR2, port number, dbname VARCHAR2) AS
        LANGUAGE JAVA NAME
      'chemaxon.jchem.cartridge.JFunctions.setDbCallback(java.lang.String, int,
      java.lang.String)';

  PROCEDURE start_profiling AS LANGUAGE JAVA NAME
      'chemaxon.jchem.cartridge.JFunctions.startProfiling()';

  FUNCTION stop_profiling(options VARCHAR2) RETURN BLOB AS LANGUAGE JAVA NAME
       'chemaxon.jchem.cartridge.JFunctions.stopProfiling(java.lang.String)
        return oracle.sql.BLOB';

  PROCEDURE trace(msg VARCHAR2) AS LANGUAGE JAVA NAME
        'chemaxon.jchem.cartridge.JFunctions.trace(java.lang.String)';

  FUNCTION get_time RETURN VARCHAR2 as language java name 
	'chemaxon.jchem.cartridge.JFunctions.getTime() return java.lang.String';

  FUNCTION get_time_diff(time_p VARCHAR2) RETURN NUMBER as language java name
    'chemaxon.jchem.cartridge.JFunctions.getTimeDiff(
    java.lang.String) return long';

  PROCEDURE put_any_line (pstrText IN VARCHAR2) ;

  --Functions for reading and writing row types
	-- Offers conversions raw and char formats
  FUNCTION chartoraw(v_char varchar2) return long raw;
  FUNCTION rawtochar(v_raw long raw) return varchar2;

	-- Offers conversions between decimal and hex format
  FUNCTION numtohex(v_hex number) return varchar2;
  FUNCTION hextonum(v_hex varchar2) return number;


  PROCEDURE new_profile_point AS LANGUAGE JAVA NAME
        'chemaxon.jchem.cartridge.JFunctions.newProfilePoint()';

  PROCEDURE new_profile_point_set AS LANGUAGE JAVA NAME
        'chemaxon.jchem.cartridge.JFunctions.newProfilePointSet()';

END jchem_misc_pkg;
/
show errors;


CREATE OR REPLACE PACKAGE BODY jchem_core_pkg AS

  function test(password varchar2) return varchar2 is
  begin
    jchem_core_pkg.use_password(null, password);
    return jchem_core_pkg.getEnvironment();
  end;

  procedure handle_java_error(errm varchar2) is
    em VARCHAR2(4000);
    pos integer;
    key1 VARCHAR2(4000) := 'Java call terminated by uncaught Java exception: ';
    key2 VARCHAR2(4000) := 'Exception: ';
    enostr varchar2(3);
    eno number := -20101;
  begin
    em := errm;

    -- Starts with   [1][0-9][0-9]~   ?
    pos := instr(em, '~');
--    jchem_misc_pkg.trace('Processing `' || em || '`');
    if (pos = 4) then
      enostr := substr(em, 1, 3);
      begin
        eno := to_number(enostr);
        eno := -20000 - eno;
        em := substr(em, 5);
      exception
        when others then
        eno := eno;
      end;
    end if;

    raise_application_error(eno, em);
  end;

  FUNCTION get_cartowner_schema RETURN VARCHAR2 IS
  BEGIN
    return '&1';
  END;

  FUNCTION getJChemVersion RETURN VARCHAR2 IS
  BEGIN
    return '&2';
  END;

  FUNCTION getTableVersion RETURN NUMBER IS
  BEGIN
    return &3;
  END;

  procedure use_password(password varchar2) is
    errm varchar2(32767);
  begin
    errm := use_password0(null, password);
    if errm is not null then
      jchem_core_pkg.handle_java_error(errm);
    end if;
  end;

  procedure use_password(login varchar2, password varchar2) is
    errm varchar2(32767);
  begin
    errm := use_password0(login, password);
    if errm is not null then
      jchem_core_pkg.handle_java_error(errm);
    end if;
  end;

  function set_password(password varchar2) return number is
    errm varchar2(32767);
  begin
    errm := use_password0(null, password);
    if errm is null then
      return 0;
    else
      return -1;
    end if;
  end;

  procedure use_default_account is
    errm varchar2(32767);
  begin
    errm := use_default_account0();
    if errm is not null then
      jchem_core_pkg.handle_java_error(errm);
    end if;
  end;

  PROCEDURE checkTableVersionEx(func_name VARCHAR2,
                                indexctx IN SYS.ODCIIndexCtx) IS
    ia          SYS.ODCIIndexInfo;
    schema_name VARCHAR2(255);
    table_name  VARCHAR2(255);
    dobject_id  NUMBER;
    err_num     NUMBER;
  BEGIN

    IF indexctx.IndexInfo IS NOT NULL THEN
      -- The first argument has an index on it

      ia := indexctx.IndexInfo;
      IF ia.IndexSchema IS NOT NULL THEN
        -- Has index
        jchem_core_pkg.checkTableVersion(
                  ia.IndexSchema,
                  ia.IndexName,
                  ia.IndexPartition,
                  ia.IndexCols(1).TableSchema,
                  ia.IndexCols(1).TableName,
                  ia.IndexCols(1).ColName);
      ELSE
        raise_application_error(-20102,
              'checkTableVersionEx: indexctx.IndexInfo NOT IS NULL, but indexctx.IndexInfo.IndexSchema IS NULL');
      END IF;
    ELSE 
        -- Does not have index
        IF indexctx.rid IS NOT NULL THEN
          -- The first argument is a column
          dobject_id := DBMS_ROWID.ROWID_OBJECT(indexctx.rid);

--            SELECT owner, object_name INTO schema_name, table_name
--                  FROM sys.dba_objects WHERE DATA_OBJECT_ID = dobject_id;

          raise_application_error(-20101,
                  'Please, create domain index on the column referenced in the operator '
                  || func_name || ' of the table with DATA_OBJECT_ID=' || dobject_id
                  || '. You can find out the name of the table by executing:
SELECT owner, object_name INTO schema_name, table_name
FROM sys.dba_objects WHERE DATA_OBJECT_ID = ' || dobject_id);

--          raise_application_error(-20101,
--                  'Please, create domain index on the column referenced in the operator '
--                  || func_name || ' of the table ' || schema_name
--                  || '.' || table_name);

        -- ELSE
        --   the first argument is a literal value instead of a column
        END IF;
    END IF;
  END; -- PROCEDURE checkTableVersionEx


  FUNCTION getEnvironment RETURN VARCHAR2 IS
    cursor cur is select banner from sys.v_$version;
    res varchar2(4000);
  BEGIN
    check_master_table();

    res := 'Oracle environment: ' || chr(10);
    for t in cur loop
        res := res || t.banner || chr(10);
        exit when cur%notfound;
    end loop;

    res := res || chr(10) || 'JChem Server environment: ' || chr(10);
    return res || get_remote_environment();
  END;

  FUNCTION jctf_autocalccts(index_schema VARCHAR2,
                            index_name VARCHAR2)
  RETURN COMP_CHAR_ARRAY PIPELINED AS
    carr CHAR_ARRAY;
  BEGIN
    IF index_schema IS NULL OR index_name IS NULL THEN
      RETURN;
    END IF;

    carr := jchem_core_pkg.autocalccts(index_schema, index_name, null);
    FOR i IN 1..carr.count LOOP
      PIPE ROW(COMPOSITE_CHAR(carr(i)));
    END LOOP;

    RETURN;
  END;

  FUNCTION jctf_autocalccts(index_schema VARCHAR2,
                            index_name VARCHAR2,
                            index_part VARCHAR2)
  RETURN COMP_CHAR_ARRAY PIPELINED AS
    carr CHAR_ARRAY;
  BEGIN
    IF index_schema IS NULL OR index_name IS NULL THEN
      RETURN;
    END IF;

    carr := jchem_core_pkg.autocalccts(index_schema, index_name, index_part);
    FOR i IN 1..carr.count LOOP
      PIPE ROW(COMPOSITE_CHAR(carr(i)));
    END LOOP;

    RETURN;
  END;

  FUNCTION jctf_autocalccts_bycol(table_schema VARCHAR2,
                                  table_name VARCHAR2,
                                  table_col VARCHAR2)
  RETURN COMP_CHAR_ARRAY PIPELINED AS
    carr CHAR_ARRAY;
  BEGIN
    IF table_schema IS NULL OR table_name IS NULL THEN
      RETURN;
    END IF;

    carr := jchem_core_pkg.autocalccts_bycol(table_schema, table_name, table_col);
    FOR i IN 1..carr.count LOOP
      PIPE ROW(COMPOSITE_CHAR(carr(i)));
    END LOOP;

    RETURN;
  END;

  PROCEDURE invert_result(res IN OUT NOCOPY CD_ID_ARRAY, tableName VARCHAR2) IS
    inv_array CD_ID_ARRAY := CD_ID_ARRAY(); 
    cdid INTEGER;
    nrows INTEGER;
    cnum INTEGER;
    done BOOLEAN := FALSE;
    equals BOOLEAN := FALSE;
  BEGIN 
    cnum := dbms_sql.open_cursor;
    dbms_sql.parse(cnum, 'select cd_id from ' || tableName,
		   dbms_sql.native);
    dbms_sql.define_column(cnum, 1, cdid);
    nrows := dbms_sql.execute(cnum);
    WHILE NOT done LOOP
        IF dbms_sql.fetch_rows(cnum) > 0 THEN
	    dbms_sql.column_value(cnum, 1, cdid);
	    FOR i in 1 .. res.count LOOP
		IF res(i) = cdid THEN
		    equals := TRUE;
		END IF;
   	    END LOOP;
	    IF equals = FALSE THEN
		inv_array.extend;
		inv_array(inv_array.count) := cdid;
	    END IF;
	    equals := FALSE;
	ELSE 
	    done := TRUE;
	END IF;
    END LOOP;
    dbms_sql.close_cursor(cnum);
    res := inv_array;
  END;

  PROCEDURE insert_into_idxtbl(idxtbl_name IN OUT NOCOPY VARCHAR2,
                               cdid_seq_name IN OUT NOCOPY VARCHAR2,
                               molprops IN OUT NOCOPY MOLPROPS_ARRAY_ARRAY) AS
    cn INTEGER;
  BEGIN
    cn := create_parse_insidxtbl_cur(idxtbl_name, cdid_seq_name, molprops(1));

    BEGIN
      FOR idx in 1 .. molprops.count LOOP
        insert_into_idxtbl_single(idxtbl_name, cdid_seq_name,
                                  molprops(idx), cn);
        molprops(idx).delete;
      END LOOP;

      molprops.delete;

      DBMS_SQL.CLOSE_CURSOR(cn);
    EXCEPTION
    WHEN OTHERS THEN
      IF DBMS_SQL.IS_OPEN(cn) THEN
        DBMS_SQL.CLOSE_CURSOR(cn);
      END IF;
      RAISE;
    END;
  END;

  PROCEDURE insert_into_idxtbl_single(idxtbl_name IN OUT NOCOPY VARCHAR2,
                                     cdid_seq_name IN OUT NOCOPY VARCHAR2,
                                     molprops IN OUT NOCOPY MOLPROPS_ARRAY,
                                     cn INTEGER)
  AS
    ignore NUMBER;
  BEGIN
    FOR idx in 1 .. molprops.count LOOP
      DBMS_SQL.BIND_VARIABLE(cn, ':var' || to_char(idx), molprops(idx));
    END LOOP;

    ignore := DBMS_SQL.EXECUTE(cn);
  END;


  FUNCTION create_parse_insidxtbl_cur(idxtbl_name IN OUT NOCOPY VARCHAR2,
                                      cdid_seq_name IN OUT NOCOPY VARCHAR2,
                                      molprops IN OUT NOCOPY MOLPROPS_ARRAY)
  RETURN INTEGER
  AS
    cn INTEGER;
    insert_stmt VARCHAR2(2000);
  BEGIN
    insert_stmt := 'INSERT INTO ' || idxtbl_name || ' VALUES(' ||
                      cdid_seq_name || '.nextval';

    FOR idx in 1 .. molprops.count LOOP
      insert_stmt := insert_stmt || ', :var' || to_char(idx);
    END LOOP;
    insert_stmt := insert_stmt || ')';

--    jchem_misc_pkg.trace('create_parse_insidxtbl_cur: stmt=' ||
--                         insert_stmt);

    cn := DBMS_SQL.OPEN_CURSOR;
    DBMS_SQL.PARSE(cn, insert_stmt, DBMS_SQL.NATIVE);
    RETURN cn;
  END;

END jchem_core_pkg;
/
SHOW ERRORS;

-- Defines procedures/functions with definer rights
create or replace package jchem_defright_pkg as
  function get_next_scan_num return number;
end jchem_defright_pkg;
/
show errors;

create or replace package body jchem_defright_pkg as
  function get_next_scan_num return number as
    sqname varchar2(50) := 'jchem_idxscan_no_sq';
    scannum number;
  begin
    execute immediate 'SELECT ' || sqname || '.nextval FROM dual' into scannum;
    return scannum;
  end;
end jchem_defright_pkg;
/
show errors


CREATE OR REPLACE PACKAGE BODY jchem_misc_pkg AS

  FUNCTION get_jchemstreams_url RETURN VARCHAR2 IS
  BEGIN
    return 'JCHEM_SERVLET_URL';
  END;

  PROCEDURE put_any_line (pstrText IN VARCHAR2) IS
    cnumLineSize  CONSTANT NUMBER := 255;   -- Maximum size of DBMS_OUTPUT 
    lstrLeft  VARCHAR2 (32767);
    lstrRight VARCHAR2 (32767);
    lnumPos   NUMBER;
  BEGIN
    IF LENGTH(pstrText) <= cnumLineSize THEN
         -- Line short enough to go to PUT_LINE
      DBMS_OUTPUT.PUT_LINE(pstrText);
    ELSE
         -- Line is too long, attempt to split it at a space
      lstrLeft := SUBSTR(pstrText,1,cnumLineSize);
      lnumPos := INSTR(lstrLeft,' ',-1);
      IF lnumPos = 0 THEN
            -- No spaces in the line, so just split it regardless
        lstrRight := SUBSTR(pstrText,cnumLineSize+1);
      ELSE
        lstrLeft := SUBSTR(lstrLeft,1,lnumPos-1);
        lstrRight := SUBSTR(pstrText,lnumPos+1);
      END IF;
        -- lstrLeft is small enough to send to put_line...
        DBMS_OUTPUT.PUT_LINE (lstrLeft);
        -- ...but lstrRight may not be. Make a recursive call to deal with it
        put_any_line (lstrRight);
      END IF;
   END;

  FUNCTION chartoraw(v_char varchar2) RETURN LONG RAW IS
    rawdata long raw;
    rawlen number;
    hex varchar2(32760);
    i number;
  BEGIN
    rawlen := length(v_char);
    i := 1;
    WHILE i <= rawlen LOOP
      hex := numtohex(ascii(substrb(v_char,i,1)));
      rawdata := rawdata || HEXTORAW(hex);
      i := i + 1;
    END LOOP;
    RETURN rawdata;
  END;


  FUNCTION rawtochar(v_raw long raw) RETURN VARCHAR2 IS
    rawlen number;
    hex varchar2(32760);
    rawparam varchar2(32760);
    i number;
  BEGIN
    hex := rawtohex(v_raw);
    rawlen := length(hex);
    i := 1;
    WHILE i <= rawlen LOOP
      rawparam := rawparam||CHR(HEXTONUM(substrb(hex,i,2)));
      i := i + 2;
    END LOOP;
    RETURN rawparam;
  END;


  FUNCTION numtohex(v_hex number) return varchar2 IS 
    hex varchar2(4);
    num1 number;
    num2 number;
  BEGIN
    num1 := trunc(v_hex/16);
    num2 := v_hex-(num1*16);

    IF ( num1 >= 0 and num1 <= 9 ) THEN
      hex := hex||to_char(num1);
    END IF; 
    if num1 = 10 then hex := hex||'A'; end if; 
    if num1 = 11 then hex := hex||'B'; end if; 
    if num1 = 12 then hex := hex||'C'; end if; 
    if num1 = 13 then hex := hex||'D'; end if; 
    if num1 = 14 then hex := hex||'E'; end if; 
    if num1 = 15 then hex := hex||'F'; end if; 

    if ( num2 >= 0 and num2 <= 9 ) then 
      hex := hex||to_char(num2);
    end if; 
    if num2 = 10 then hex := hex||'A'; end if; 
    if num2 = 11 then hex := hex||'B'; end if; 
    if num2 = 12 then hex := hex||'C'; end if; 
    if num2 = 13 then hex := hex||'D'; end if; 
    if num2 = 14 then hex := hex||'E'; end if; 
    if num2 = 15 then hex := hex||'F'; end if; 

    return hex;
  end;


  FUNCTION hextonum(v_hex varchar2) return number IS 
    hex varchar2(4);
    num number;
    num1 number;
    num2 number;
  BEGIN
    hex := substrb(v_hex,1,1);

    if ( hex >= '0' and hex <= '9' ) then 
      num1 := to_number(hex);
    end if; 
    if hex = 'A' then num1 := 10; end if; 
    if hex = 'B' then num1 := 11; end if; 
    if hex = 'C' then num1 := 12; end if; 
    if hex = 'D' then num1 := 13; end if; 
    if hex = 'E' then num1 := 14; end if; 
    if hex = 'F' then num1 := 15; end if; 

    hex := substrb(v_hex,2,1);

    if ( hex >= '0' and hex <= '9' ) then 
      num2 := to_number(hex);
    end if; 
    if hex = 'A' then num2 := 10; end if; 
    if hex = 'B' then num2 := 11; end if; 
    if hex = 'C' then num2 := 12; end if; 
    if hex = 'D' then num2 := 13; end if; 
    if hex = 'E' then num2 := 14; end if; 
    if hex = 'F' then num2 := 15; end if; 

   num := (num1*16)+num2;
   return num;
  END;

END jchem_misc_pkg;
/
show errors;


CREATE OR REPLACE PACKAGE jchem_func_pkg AUTHID CURRENT_USER AS

  function format_hits(target VARCHAR2, query VARCHAR2, options VARCHAR2,
                       tmpBlob BLOB)
        RETURN BLOB PARALLEL_ENABLE  AS LANGUAGE JAVA NAME
        'chemaxon.jchem.cartridge.orastub.JcDisplayFunctions.formatHits(
                   java.lang.String, java.lang.String, java.lang.String,
                   oracle.sql.BLOB) return oracle.sql.BLOB';

  function format_hits(target BLOB, query BLOB, options VARCHAR2, tmpBlob BLOB)
        RETURN BLOB PARALLEL_ENABLE  AS LANGUAGE JAVA NAME
        'chemaxon.jchem.cartridge.orastub.JcDisplayFunctions.formatHits(
                   oracle.sql.BLOB, oracle.sql.BLOB, java.lang.String,
                   oracle.sql.BLOB) return oracle.sql.BLOB';
end jchem_func_pkg;
/
show errors;

create or replace package jchem_table_pkg authid current_user as

  procedure create_jctable(jchem_table_name varchar2,
                               jchem_property_table_name varchar2,
                               number_of_ints number,
                               number_of_ones number,
                               number_of_edges number,
                               coldefs varchar2,
                               standardizerConfig varchar2,
                               absoluteStereo number,
                               options varchar2) as language java name
  'chemaxon.jchem.cartridge.JcTableFunctions.createJChemTable(java.lang.String,
  java.lang.String, int, int, int, java.lang.String, java.lang.String,
  int, java.lang.String)';
                               
  procedure drop_jctable(jchem_table_name varchar2,
                             jchem_property_table_name varchar2)
  as language java name
  'chemaxon.jchem.cartridge.JcTableFunctions.dropJChemTable(java.lang.String,
  java.lang.String)';

  function list_arr(jcproptable varchar2)
    return char_array parallel_enable as language java name 
    'chemaxon.jchem.cartridge.JcTableFunctions.listJChemTablesArr(java.lang.String)
    return java.lang.String[]';

  function list_jctables(jcproptable varchar2) return comp_char_array
  pipelined;

  FUNCTION insert_structure(str VARCHAR2, table_name VARCHAR2, jcprop_name VARCHAR2,
          dup_chk VARCHAR2, halt_on_err VARCHAR2, options VARCHAR2)
        RETURN CD_ID_ARRAY PARALLEL_ENABLE   AS LANGUAGE JAVA NAME
	    'chemaxon.jchem.cartridge.JCartDml.insertMol(java.lang.String,
				  java.lang.String, java.lang.String,
				  java.lang.String, java.lang.String,
                  java.lang.String) return int[]';

  FUNCTION insert_structure(str CLOB, table_name VARCHAR2, jcprop_name VARCHAR2,
                    dup_chk VARCHAR2, halt_on_err VARCHAR2, options VARCHAR2)
        RETURN CD_ID_ARRAY PARALLEL_ENABLE AS LANGUAGE JAVA NAME
	    'chemaxon.jchem.cartridge.JCFunctionsClob.insertMol(oracle.sql.CLOB,
            java.lang.String, java.lang.String, java.lang.String,
            java.lang.String, java.lang.String) return int[]';

  FUNCTION insert_structure(str BLOB, table_name VARCHAR2, jcprop_name VARCHAR2,
                    dup_chk VARCHAR2, halt_on_err VARCHAR2, options VARCHAR2)
        RETURN CD_ID_ARRAY PARALLEL_ENABLE AS LANGUAGE JAVA NAME
	    'chemaxon.jchem.cartridge.JCFunctionsBlob.insertMol(oracle.sql.BLOB,
        java.lang.String, java.lang.String, java.lang.String,
        java.lang.String, java.lang.String) return int[]';

  PROCEDURE update_structure(str VARCHAR2, table_name VARCHAR2, id NUMBER, 
	    jcprop_name VARCHAR2, options VARCHAR2)
          PARALLEL_ENABLE   AS LANGUAGE JAVA NAME
	    'chemaxon.jchem.cartridge.JCartDml.updateMol(java.lang.String,
                  java.lang.String, int, java.lang.String, java.lang.String)';

  PROCEDURE update_structure(str CLOB, table_name VARCHAR2, id NUMBER, 
	    jcprop_name VARCHAR2, options VARCHAR2)
        PARALLEL_ENABLE AS LANGUAGE JAVA NAME
	    'chemaxon.jchem.cartridge.JCFunctionsClob.updateMol(
        oracle.sql.CLOB, java.lang.String, int, java.lang.String,
        java.lang.String)';

  PROCEDURE update_structure(str BLOB, table_name VARCHAR2, id NUMBER, 
	    jcprop_name VARCHAR2, options VARCHAR2)
        PARALLEL_ENABLE AS LANGUAGE JAVA NAME
	    'chemaxon.jchem.cartridge.JCFunctionsBlob.updateMol(
        oracle.sql.BLOB, java.lang.String, int, java.lang.String,
        java.lang.String)';

  PROCEDURE delete_structure(table_name VARCHAR2, condition VARCHAR2,
                       jcprop_name VARCHAR2) AS LANGUAGE JAVA NAME
	    'chemaxon.jchem.cartridge.JCartDml.deleteMol(java.lang.String,
				  java.lang.String, java.lang.String)';

  function jc_insert(str varchar2, table_name varchar2, 
                     jcprop_name varchar2 := '', duplicate_check varchar2 :=
                     '', halt_on_error varchar2 := '', options varchar2 := '')
                     return CD_ID_ARRAY;

  function jc_insert(str CLOB, table_name VARCHAR2,
                      jcprop_name VARCHAR2 := '', duplicate_check VARCHAR2 :=
                      '', halt_on_error VARCHAR2 := '', options VARCHAR2 := '')
        return cd_id_array;

  function jc_insert(str BLOB, table_name VARCHAR2,
                      jcprop_name VARCHAR2 := '', duplicate_check VARCHAR2 :=
                      '', halt_on_error VARCHAR2 := '', options VARCHAR2 := '')
        return cd_id_array;

  procedure jc_update(str varchar2, table_name varchar2,
                      id NUMBER, jcprop_name varchar2 := null,
                      options varchar2 := null);
  
  procedure jc_update(str CLOB, table_name VARCHAR2,
                           id NUMBER, jcprop_name VARCHAR2 := null,
                           options VARCHAR2 := null);

  procedure jc_update(str BLOB, table_name VARCHAR2,
                           id NUMBER, jcprop_name VARCHAR2 := null,
                           options VARCHAR2 := null);

  procedure jc_delete(table_name varchar2, condition varchar2,
                      jcprop_name varchar2 := null);

  function jc_insertb(str BLOB, table_name VARCHAR2,
                      jcprop_name VARCHAR2 := '', duplicate_check VARCHAR2 :=
                      '', halt_on_error VARCHAR2 := '', options VARCHAR2 := '')
        return cd_id_array;

  procedure jc_updateb(str BLOB, table_name VARCHAR2,
                           id NUMBER, jcprop_name VARCHAR2 := null,
                           options VARCHAR2 := null);
end jchem_table_pkg;
/
show errors;

create or replace package body jchem_table_pkg as
  function list_jctables(jcproptable varchar2) return comp_char_array pipelined
  as
    chararr char_array;
  begin
    chararr := list_arr(jcproptable);
    for i in 1..chararr.count loop
      pipe row(COMPOSITE_CHAR(chararr(i)));
    end loop;

    return;
  end;

  function jc_insert(str varchar2, table_name varchar2, 
                     jcprop_name varchar2 := '', duplicate_check varchar2 :=
                     '', halt_on_error varchar2 := '', options varchar2 := '')
                     return CD_ID_ARRAY as
  begin
    begin
      return jchem_table_pkg.insert_structure(str, table_name,
          jcprop_name, duplicate_check, halt_on_error, options);
    exception
    when others then
      if sqlcode = -29532 then
        jchem_core_pkg.handle_java_error(sqlerrm);
      else
        raise;
      end if;
    end;
  end;

  function jc_insert(str CLOB, table_name VARCHAR2,
                      jcprop_name VARCHAR2 := '', duplicate_check VARCHAR2 :=
                      '', halt_on_error VARCHAR2 := '', options VARCHAR2 := '')
        return cd_id_array as
  begin
    begin
      return jchem_table_pkg.insert_structure(str, table_name,
          jcprop_name, duplicate_check, halt_on_error, options);
    exception
    when others then
      if sqlcode = -29532 then
        jchem_core_pkg.handle_java_error(sqlerrm);
      else
        raise;
      end if;
    end;
  end;

  function jc_insert(str BLOB, table_name VARCHAR2,
                      jcprop_name VARCHAR2 := '', duplicate_check VARCHAR2 :=
                      '', halt_on_error VARCHAR2 := '', options VARCHAR2 := '')
        return cd_id_array as
  begin
    begin
      return jchem_table_pkg.insert_structure(str, table_name,
          jcprop_name, duplicate_check, halt_on_error, options);
    exception
    when others then
      if sqlcode = -29532 then
        jchem_core_pkg.handle_java_error(sqlerrm);
      else
        raise;
      end if;
    end;
  end;

  procedure jc_update(str varchar2, table_name varchar2,
                      id NUMBER, jcprop_name varchar2 := null,
                      options varchar2 := null) as
  begin
    jchem_table_pkg.update_structure(str, table_name, id, jcprop_name, options);
  end;
  
  procedure jc_update(str CLOB, table_name VARCHAR2,
                           id NUMBER, jcprop_name VARCHAR2 := null,
                           options VARCHAR2 := null) AS
  begin
    jchem_table_pkg.update_structure(str, table_name, id, jcprop_name, options);
  end;

  procedure jc_update(str BLOB, table_name VARCHAR2,
                           id NUMBER, jcprop_name VARCHAR2 := null,
                           options VARCHAR2 := null) AS
  begin
    jchem_table_pkg.update_structure(str, table_name, id, jcprop_name, options);
  end;

  procedure jc_delete(table_name varchar2, condition varchar2,
                      jcprop_name varchar2 := null) as
  begin
    jchem_table_pkg.delete_structure(table_name, condition, jcprop_name);
  end;

  function jc_insertb(str BLOB, table_name VARCHAR2,
                      jcprop_name VARCHAR2 := '', duplicate_check VARCHAR2 :=
                      '', halt_on_error VARCHAR2 := '', options VARCHAR2 := '')
        return cd_id_array as
    cdidarr cd_id_array;
  begin
      cdidarr := jchem_table_pkg.insert_structure(str, table_name,
          jcprop_name, duplicate_check, halt_on_error, options);
      if (cdidarr is null) then
        jchem_core_pkg.handle_java_error(jchem_core_pkg.lastError);
      else
        return cdidarr;
      end if;
  end;

  procedure jc_updateb(str BLOB, table_name VARCHAR2,
                           id NUMBER, jcprop_name VARCHAR2 := null,
                           options VARCHAR2 := null) AS
  begin
    jchem_table_pkg.update_structure(str, table_name, id, jcprop_name, options);
  end;

end jchem_table_pkg;
/
show errors;

---------------------------------
--  CREATE IMPLEMENTATION UNIT --
---------------------------------

-- CREATE TYPE BODY
CREATE OR REPLACE TYPE BODY jc_idxtype_im IS

   STATIC FUNCTION ODCIGetInterfaces(ifclist OUT sys.ODCIObjectList) 
							RETURN NUMBER IS
   BEGIN
       ifclist := sys.ODCIObjectList(sys.ODCIObject('SYS','ODCIINDEX2'));
       RETURN ODCIConst.Success;
   END ODCIGetInterfaces;

  STATIC FUNCTION ODCIIndexCreate (ia sys.odciindexinfo, 
                                   parms VARCHAR2,
                                   env sys.ODCIEnv) RETURN NUMBER IS
    errmsg varchar2(32767);
  BEGIN
      IF ( (env.CallProperty IS NULL) OR
           (env.CallProperty = SYS.ODCIConst.IntermediateCall) ) THEN
        errmsg := jchem_core_pkg.indexCreate(ia.IndexSchema, 
            ia.IndexName, ia.IndexPartition, ia.IndexCols(1).TableSchema, 
            ia.IndexCols(1).TableName, ia.IndexCols(1).TablePartition,
            ia.IndexCols(1).colName, parms);
      END IF;

      if errmsg is null then
        RETURN ODCICONST.SUCCESS;
      else
        jchem_core_pkg.handle_java_error(errmsg);
      end if;

      RETURN ODCIConst.SUCCESS;
  END;

  STATIC FUNCTION ODCIIndexAlter(ia SYS.ODCIIndexInfo, parms IN OUT VARCHAR2, 
                                 alter_option NUMBER, env sys.ODCIEnv)
  RETURN NUMBER IS
    ret NUMBER;
  BEGIN
    /* begin */
      ret := jchem_core_pkg.indexAlter(ia.IndexSchema, 
          ia.IndexName, ia.IndexPartition, ia.IndexCols(1).TableSchema,
          ia.IndexCols(1).TableName, ia.IndexCols(1).TablePartition,
          ia.IndexCols(1).colName, parms, alter_option);
      RETURN ret;
    /*
    exception
    when others then
      if sqlcode = -29532 then
        jchem_core_pkg.handle_java_error(sqlerrm);
      else
        raise;
      end if;
    end;
    */
  END;

  STATIC FUNCTION ODCIIndexDrop(ia sys.odciindexinfo, env sys.ODCIEnv)
    RETURN NUMBER IS
    junk PLS_INTEGER;
  BEGIN
    /* begin */
      IF ( (env.CallProperty IS NULL) OR
           (env.CallProperty = SYS.ODCIConst.IntermediateCall) ) THEN
        RETURN jchem_core_pkg.indexDrop(ia.IndexSchema, ia.IndexName,
                  ia.IndexPartition, ia.IndexCols(1).TableSchema,
                  ia.IndexCols(1).TableName);
      END IF;
      RETURN ODCIConst.Success;
    /*
    exception
    when others then
      if sqlcode = -29532 then
        jchem_core_pkg.handle_java_error(sqlerrm);
      else
        raise;
      end if;
    end;
    */
  END;

  STATIC FUNCTION ODCIIndexTruncate(ia sys.odciindexinfo, env sys.ODCIEnv)
    RETURN NUMBER IS
    junk PLS_INTEGER;
  BEGIN
    /* begin */
      IF ( (env.CallProperty IS NULL) OR
           (env.CallProperty = SYS.ODCIConst.IntermediateCall) ) THEN
        RETURN jchem_core_pkg.indexTruncate(ia.IndexSchema, ia.IndexName,
                  ia.IndexPartition, ia.IndexCols(1).TableSchema,
                  ia.IndexCols(1).TableName);
      END IF;
      RETURN ODCIConst.Success;
    /*
    exception
    when others then
      if sqlcode = -29532 then
        jchem_core_pkg.handle_java_error(sqlerrm);
      else
        raise;
      end if;
    end;
    */
  END;

  STATIC FUNCTION ODCIIndexStart(sctx IN OUT jc_idxtype_im, 
                        ia sys.odciindexinfo,
                        op sys.odciPredInfo, 
                        qi sys.ODCIQueryInfo, 
                        strt VARCHAR2, 
                        stop VARCHAR2,
                        env sys.ODCIEnv) RETURN NUMBER IS
    scannum number;
    cnum INTEGER;
    stmt VARCHAR2(32000);
    rid ROWID;
    nrows INTEGER;
    pred_str VARCHAR2(2000);

    errmsg varchar2(32767);
  BEGIN
      jchem_core_pkg.checkTableVersion(
                ia.IndexSchema,
                ia.IndexName,
                ia.IndexPartition,
                ia.IndexCols(1).TableSchema,
                ia.IndexCols(1).TableName,
                ia.IndexCols(1).ColName);

      scannum := jchem_defright_pkg.get_next_scan_num();

      IF strt IS NULL THEN
        pred_str := 'null/' || stop || '/' || op.Flags;
      ELSIF stop IS NULL THEN
        pred_str := strt || '/null/' || op.Flags;
      ELSE
        pred_str := strt || '/' || stop || '/' || op.Flags;
      END IF;

      IF op.ObjectName = 'JC_LOGP' THEN

          errmsg := jchem_core_pkg.index_scan(ia.IndexSchema, ia.IndexName,
                          ia.IndexPartition, ia.IndexCols(1).TableSchema,
                          ia.IndexCols(1).TableName, ia.IndexCols(1).colName,
                          'calc', 'logp', pred_str, null, null, scannum);

      ELSIF op.ObjectName = 'JC_TPSA' THEN

         errmsg := jchem_core_pkg.index_scan(ia.IndexSchema, ia.IndexName,
                          ia.IndexPartition, ia.IndexCols(1).TableSchema,
                          ia.IndexCols(1).TableName, ia.IndexCols(1).colName,
                          'calc', 'tpsa', pred_str, null, null, scannum);

      ELSIF op.ObjectName = 'JC_MOLWEIGHT' OR op.ObjectName = 'JC_MOLWEIGHTB' THEN
        stmt := jchem_core_pkg.getMolsByField('molweight', ia.IndexSchema,
                      ia.IndexName, ia.IndexPartition, ia.IndexCols(1).TableSchema,
                      ia.IndexCols(1).TableName, pred_str, 1);
        cnum := dbms_sql.open_cursor;
        dbms_sql.parse(cnum, stmt, dbms_sql.native);
        dbms_sql.define_column_rowid(cnum, 1, rid);
        nrows := dbms_sql.execute(cnum);
        sctx := jc_idxtype_im(ia, scannum, cnum);
        return ODCICONST.SUCCESS;
      ELSE
          errmsg := jchem_clob_pkg.index_scan(ia.IndexSchema, ia.IndexName,
                          ia.IndexPartition, ia.IndexCols(1).TableSchema,
                          ia.IndexCols(1).TableName, ia.IndexCols(1).colName,
                          'userdef', 'dflt', pred_str, null, op.ObjectName,
                          scannum);
          -- dbms_output.put_line('user def batch');
          --   raise_application_error(-20101, 'Unsupported operator: '
          --              || op.ObjectName);
      END IF;

      jchem_misc_pkg.new_profile_point();
      sctx := jc_idxtype_im(ia, scannum, null);

      if errmsg is null then
        RETURN ODCICONST.SUCCESS;
      else
        jchem_core_pkg.handle_java_error(errmsg);
      end if;

      RETURN ODCICONST.SUCCESS;
  END;  

  STATIC FUNCTION ODCIIndexStart(sctx IN OUT NOCOPY jc_idxtype_im, 
          ia sys.odciindexinfo,
          op sys.odciPredInfo, 
          qi sys.ODCIQueryInfo, 
          strt VARCHAR2, 
          stop VARCHAR2,
          query CLOB,
          env sys.ODCIEnv) RETURN NUMBER IS
    scannum number;
    cnum INTEGER;
    stmt varchar2(32000);
    rid ROWID;
    nrows INTEGER;
    pred_str VARCHAR2(2000);
    regCode VARCHAR2(20);
    errmsg varchar2(32767);
  BEGIN

--    jchem_core_pkg.profile_array := TIMESTAMP_ARRAY();

      jchem_core_pkg.checkTableVersion(
                ia.IndexSchema,
                ia.IndexName,ia.IndexPartition,
                ia.IndexCols(1).TableSchema,
                ia.IndexCols(1).TableName,
                ia.IndexCols(1).ColName);

      scannum := jchem_defright_pkg.get_next_scan_num();

      IF strt IS NULL THEN
        pred_str := 'null/' || stop || '/' || op.Flags;
      ELSIF stop IS NULL THEN
        pred_str := strt || '/null/' || op.Flags;
      ELSE
        pred_str := strt || '/' || stop || '/' || op.Flags;
      END IF;

      IF op.ObjectName = 'JC_CONTAINS' THEN

  --      jchem_misc_pkg.trace('JC_CONTAINSB: colname=' || ia.IndexCols(1).colName);

          errmsg := jchem_clob_pkg.index_scan(ia.IndexSchema, ia.IndexName,
                          ia.IndexPartition, ia.IndexCols(1).TableSchema,
                          ia.IndexCols(1).TableName, ia.IndexCols(1).colName,
                          'search', 'sbstr', pred_str, query, null, scannum);

      ELSIF op.ObjectName = 'JC_EQUALS' THEN

          errmsg := jchem_clob_pkg.index_scan(ia.IndexSchema, ia.IndexName,
                          ia.IndexPartition, ia.IndexCols(1).TableSchema,
                          ia.IndexCols(1).TableName, ia.IndexCols(1).colName,
                          'search', 'perfect', pred_str, query, null, scannum);

      ELSIF op.ObjectName = 'JC_MATCHCOUNT' THEN

          errmsg := jchem_clob_pkg.index_scan(ia.IndexSchema, ia.IndexName,
                          ia.IndexPartition, ia.IndexCols(1).TableSchema,
                          ia.IndexCols(1).TableName, ia.IndexCols(1).colName,
                          'search', 'mtcnt', pred_str, query, null, scannum);

      ELSIF op.ObjectName = 'JC_TANIMOTO' THEN

        errmsg := jchem_clob_pkg.similaritySearch(query, 'similarity',
                  pred_str, 'dissimilarityMetric:tanimoto', ia.IndexSchema,
                  ia.IndexName,ia.IndexPartition, ia.IndexCols(1).TableSchema,
                  ia.IndexCols(1).TableName, ia.IndexCols(1).colName, scannum);

      ELSIF op.ObjectName = 'JC_DISSIMILARITY' THEN

        errmsg := jchem_clob_pkg.similaritySearch(query, 'dissimilarity',
                  pred_str, 'dissimilarityMetric:tanimoto', ia.IndexSchema,
                  ia.IndexName,ia.IndexPartition, ia.IndexCols(1).TableSchema,
                  ia.IndexCols(1).TableName, ia.IndexCols(1).colName, scannum);
        
      ELSIF op.ObjectName = 'JC_FORMULA_EQ' THEN

        stmt := jchem_clob_pkg.getMolsByField('formula',
              ia.IndexSchema, ia.IndexName, ia.IndexPartition,
              ia.IndexCols(1).TableSchema,  
                      ia.IndexCols(1).TableName, query, strt);

        cnum := dbms_sql.open_cursor; 
        dbms_sql.parse(cnum, stmt, dbms_sql.native);
        dbms_sql.define_column_rowid(cnum, 1, rid);    
        nrows := dbms_sql.execute(cnum);

        sctx := jc_idxtype_im(ia, scannum, cnum);
        return ODCICONST.SUCCESS;
      ELSIF op.ObjectName = 'JC_EVALUATE' THEN
          errmsg := jchem_clob_pkg.index_scan(ia.IndexSchema, ia.IndexName,
                          ia.IndexPartition, ia.IndexCols(1).TableSchema,
                          ia.IndexCols(1).TableName, ia.IndexCols(1).colName,
                          'eval', 'dflt', pred_str, query, null, scannum);
      ELSE
          errmsg := jchem_clob_pkg.index_scan(ia.IndexSchema, ia.IndexName,
                          ia.IndexPartition, ia.IndexCols(1).TableSchema,
                          ia.IndexCols(1).TableName, ia.IndexCols(1).colName,
                          'userdef', 'dflt', pred_str, query, op.ObjectName,
                          scannum);
          --raise_application_error(-20101, 
          --		'Unsupported operator: '|| op.ObjectName);
      END IF;

      sctx := jc_idxtype_im(ia, scannum, null);

  --    jchem_misc_pkg.trace(op.ObjectName || ': BATCH END');

      jchem_misc_pkg.new_profile_point();

      if errmsg is null then
        RETURN ODCICONST.SUCCESS;
      else
        jchem_core_pkg.handle_java_error(errmsg);
      end if;

      RETURN ODCICONST.SUCCESS;
  END;
 
  STATIC FUNCTION ODCIIndexStart(sctx IN OUT NOCOPY jc_idxtype_im, 
          ia sys.odciindexinfo,
          op sys.odciPredInfo, 
          qi sys.ODCIQueryInfo, 
          strt VARCHAR2, 
          stop VARCHAR2,
          query BLOB,
          env sys.ODCIEnv) RETURN NUMBER IS
    scannum number;
    cnum INTEGER;
    stmt varchar2(32000);
    rid ROWID;
    nrows INTEGER;
    pred_str VARCHAR2(2000);
    regCode VARCHAR2(20);
    errmsg varchar2(32767);
  BEGIN

--    jchem_core_pkg.profile_array := TIMESTAMP_ARRAY();

      jchem_core_pkg.checkTableVersion(
                ia.IndexSchema,
                ia.IndexName,ia.IndexPartition,
                ia.IndexCols(1).TableSchema,
                ia.IndexCols(1).TableName,
                ia.IndexCols(1).ColName);

      scannum := jchem_defright_pkg.get_next_scan_num();

      IF strt IS NULL THEN
        pred_str := 'null/' || stop || '/' || op.Flags;
      ELSIF stop IS NULL THEN
        pred_str := strt || '/null/' || op.Flags;
      ELSE
        pred_str := strt || '/' || stop || '/' || op.Flags;
      END IF;

      IF op.ObjectName = 'JC_CONTAINSB' or op.ObjectName = 'JC_CONTAINS' THEN

  --      jchem_misc_pkg.trace('JC_CONTAINSB: colname=' || ia.IndexCols(1).colName);

          errmsg := jchem_blob_pkg.index_scan(ia.IndexSchema, ia.IndexName,
                          ia.IndexPartition, ia.IndexCols(1).TableSchema,
                          ia.IndexCols(1).TableName, ia.IndexCols(1).colName,
                          'search', 'sbstr', pred_str, query, null, scannum);

      ELSIF op.ObjectName = 'JC_EQUALSB' or op.ObjectName = 'JC_EQUALS' THEN

          errmsg := jchem_blob_pkg.index_scan(ia.IndexSchema, ia.IndexName,
                          ia.IndexPartition, ia.IndexCols(1).TableSchema,
                          ia.IndexCols(1).TableName, ia.IndexCols(1).colName,
                          'search', 'perfect', pred_str, query, null, scannum);

      ELSIF op.ObjectName = 'JC_MATCHCOUNTB' or op.ObjectName = 'JC_MATCHCOUNT' THEN

          errmsg := jchem_blob_pkg.index_scan(ia.IndexSchema, ia.IndexName,
                          ia.IndexPartition, ia.IndexCols(1).TableSchema,
                          ia.IndexCols(1).TableName, ia.IndexCols(1).colName,
                          'search', 'mtcnt', pred_str, query, null, scannum);

      ELSIF op.ObjectName = 'JC_TANIMOTOB' or op.ObjectName = 'JC_TANIMOTO' THEN

        errmsg := jchem_blob_pkg.similaritySearch(query, 'similarity',
                  pred_str, 'dissimilarityMetric:tanimoto', ia.IndexSchema,
                  ia.IndexName,ia.IndexPartition, ia.IndexCols(1).TableSchema,
                  ia.IndexCols(1).TableName, ia.IndexCols(1).colName, scannum);

      ELSIF op.ObjectName = 'JC_DISSIMILARITYB' or op.ObjectName = 'JC_DISSIMILARITY' THEN

        errmsg := jchem_blob_pkg.similaritySearch(query, 'dissimilarity',
                  pred_str, 'dissimilarityMetric:tanimoto', ia.IndexSchema,
                  ia.IndexName,ia.IndexPartition, ia.IndexCols(1).TableSchema,
                  ia.IndexCols(1).TableName, ia.IndexCols(1).colName, scannum);
        
      ELSIF op.ObjectName = 'JC_FORMULA_EQB' or op.ObjectName = 'JC_FORMULA_EQ' THEN

        stmt := jchem_blob_pkg.getMolsByField('formula',
              ia.IndexSchema, ia.IndexName, ia.IndexPartition,
              ia.IndexCols(1).TableSchema,  
                      ia.IndexCols(1).TableName, query, strt);

        cnum := dbms_sql.open_cursor; 
        dbms_sql.parse(cnum, stmt, dbms_sql.native);
        dbms_sql.define_column_rowid(cnum, 1, rid);    
        nrows := dbms_sql.execute(cnum);

        sctx := jc_idxtype_im(ia, scannum, cnum);
        return ODCICONST.SUCCESS;
      ELSE
          raise_application_error(-20101, 'Unsupported operator: '
              || op.ObjectName);
      END IF;

      sctx := jc_idxtype_im(ia, scannum, null);

  --    jchem_misc_pkg.trace(op.ObjectName || ': BATCH END');

      if errmsg is null then
        RETURN ODCICONST.SUCCESS;
      else
        jchem_core_pkg.handle_java_error(errmsg);
      end if;

      jchem_misc_pkg.new_profile_point();
      RETURN ODCICONST.SUCCESS;
  END;
 
  STATIC FUNCTION ODCIIndexStart(sctx IN OUT jc_idxtype_im, 
                                 ia sys.odciindexinfo,
                                 op sys.odciPredInfo,
                                 qi sys.ODCIQueryInfo,
                                 strt VARCHAR2,
                                 stop VARCHAR2,
                                 query CLOB,
                                 param VARCHAR2,
                                 env sys.ODCIEnv) RETURN NUMBER IS
    scannum number;
    pred_str VARCHAR2(2000);
    errmsg varchar2(32767);
  BEGIN

--    jchem_core_pkg.profile_array := TIMESTAMP_ARRAY();

      jchem_core_pkg.checkTableVersion(
                ia.IndexSchema,
                ia.IndexName, ia.IndexPartition,
                ia.IndexCols(1).TableSchema,
                ia.IndexCols(1).TableName,
                ia.IndexCols(1).ColName);

      scannum := jchem_defright_pkg.get_next_scan_num();

      IF strt IS NULL THEN
        pred_str := 'null/' || stop || '/' || op.Flags;
      ELSIF stop IS NULL THEN
        pred_str := strt || '/null/' || op.Flags;
      ELSE
        pred_str := strt || '/' || stop || '/' || op.Flags;
      END IF;

      IF op.ObjectName = 'JC_COMPARE' THEN

          errmsg := jchem_clob_pkg.index_scan(ia.IndexSchema, ia.IndexName,
                          ia.IndexPartition, ia.IndexCols(1).TableSchema,
                          ia.IndexCols(1).TableName, ia.IndexCols(1).colName,
                          'search', 'generic', pred_str, query, param, scannum);

      ELSIF op.ObjectName = 'JC_DISSIMILARITY' THEN

        errmsg := jchem_clob_pkg.similaritySearch(query, 'dissimilarity',
                  pred_str, param, ia.IndexSchema, ia.IndexName,ia.IndexPartition,
                  ia.IndexCols(1).TableSchema, ia.IndexCols(1).TableName,
                  ia.IndexCols(1).colName, scannum);
        
      ELSIF op.ObjectName = 'JC_EVALUATE' THEN

          errmsg := jchem_clob_pkg.index_scan(ia.IndexSchema, ia.IndexName,
                          ia.IndexPartition, ia.IndexCols(1).TableSchema,
                          ia.IndexCols(1).TableName, ia.IndexCols(1).colName,
                          'eval', 'dflt', pred_str, query, param, scannum);
        
      ELSE
          raise_application_error(-20101, 'Unsupported operator: '
              || op.ObjectName);
      END IF;

      sctx := jc_idxtype_im(ia, scannum, null); 
    
      if errmsg is null then
        RETURN ODCICONST.SUCCESS;
      else
        jchem_core_pkg.handle_java_error(errmsg);
      end if;

      jchem_misc_pkg.new_profile_point();
      RETURN ODCICONST.SUCCESS;
  END;


  STATIC FUNCTION ODCIIndexStart(sctx IN OUT jc_idxtype_im, 
                                 ia sys.odciindexinfo,
                                 op sys.odciPredInfo,
                                 qi sys.ODCIQueryInfo,
                                 strt VARCHAR2,
                                 stop VARCHAR2,
                                 query BLOB,
                                 param VARCHAR2,
                                 env sys.ODCIEnv) RETURN NUMBER IS
    scannum number;
    pred_str VARCHAR2(2000);
    errmsg varchar2(32767);
  BEGIN

--    jchem_core_pkg.profile_array := TIMESTAMP_ARRAY();

      jchem_core_pkg.checkTableVersion(
                ia.IndexSchema,
                ia.IndexName, ia.IndexPartition,
                ia.IndexCols(1).TableSchema,
                ia.IndexCols(1).TableName,
                ia.IndexCols(1).ColName);

      scannum := jchem_defright_pkg.get_next_scan_num();

      IF strt IS NULL THEN
        pred_str := 'null/' || stop || '/' || op.Flags;
      ELSIF stop IS NULL THEN
        pred_str := strt || '/null/' || op.Flags;
      ELSE
        pred_str := strt || '/' || stop || '/' || op.Flags;
      END IF;

      IF op.ObjectName = 'JC_COMPAREB'
              OR op.ObjectName = 'JC_COMPARE_VB'
              OR op.ObjectName = 'JC_COMPARE' THEN

          errmsg := jchem_blob_pkg.index_scan(ia.IndexSchema, ia.IndexName,
                          ia.IndexPartition, ia.IndexCols(1).TableSchema,
                          ia.IndexCols(1).TableName, ia.IndexCols(1).colName,
                          'search', 'generic', pred_str, query, param, scannum);

      ELSIF op.ObjectName = 'JC_DISSIMILARITY' THEN

        errmsg := jchem_blob_pkg.similaritySearch(query, 'dissimilarity',
                  pred_str, param, ia.IndexSchema, ia.IndexName,ia.IndexPartition,
                  ia.IndexCols(1).TableSchema, ia.IndexCols(1).TableName,
                  ia.IndexCols(1).colName, scannum);
        
      ELSIF op.ObjectName = 'JC_EVALUATE' THEN

          errmsg := jchem_blob_pkg.index_scan(ia.IndexSchema, ia.IndexName,
                          ia.IndexPartition, ia.IndexCols(1).TableSchema,
                          ia.IndexCols(1).TableName, ia.IndexCols(1).colName,
                          'eval', 'dflt', pred_str, query, param, scannum);
        
      END IF;

      sctx := jc_idxtype_im(ia, scannum, null); 
    
      if errmsg is null then
        RETURN ODCICONST.SUCCESS;
      else
        jchem_core_pkg.handle_java_error(errmsg);
      end if;

      jchem_misc_pkg.new_profile_point();
      RETURN ODCICONST.SUCCESS;
  END;

  STATIC FUNCTION ODCIIndexStart(sctx IN OUT jc_idxtype_im, 
                                 ia sys.odciindexinfo,
                                 op sys.odciPredInfo,
                                 qi sys.ODCIQueryInfo,
                                 strt VARCHAR2,
                                 stop VARCHAR2,
                                 query CLOB,
                                 param1 number, param2 number,
                                 env sys.ODCIEnv) RETURN NUMBER IS
    scannum number;
    pred_str VARCHAR2(2000);
    errmsg varchar2(32767);
  BEGIN

--    jchem_core_pkg.profile_array := TIMESTAMP_ARRAY();

      jchem_core_pkg.checkTableVersion(
                ia.IndexSchema,
                ia.IndexName, ia.IndexPartition,
                ia.IndexCols(1).TableSchema,
                ia.IndexCols(1).TableName,
                ia.IndexCols(1).ColName);

      scannum := jchem_defright_pkg.get_next_scan_num();

      IF strt IS NULL THEN
        pred_str := 'null/' || stop || '/' || op.Flags;
      ELSIF stop IS NULL THEN
        pred_str := strt || '/null/' || op.Flags;
      ELSE
        pred_str := strt || '/' || stop || '/' || op.Flags;
      END IF;

      IF op.ObjectName = 'JC_TVERSKY' THEN
          errmsg := jchem_clob_pkg.similaritySearch(query,
                  'similarity', pred_str,
                  'dissimilarityMetric:tversky' || jchem_core_pkg.simCalcSeparator || param2 || jchem_core_pkg.simCalcSeparator || param1, 
                  ia.IndexSchema, ia.IndexName,ia.IndexPartition,
                  ia.IndexCols(1).TableSchema, ia.IndexCols(1).TableName,
                  ia.IndexCols(1).colName, scannum);
      ELSE
          raise_application_error(-20101, 'Unsupported operator: '
              || op.ObjectName);
      END IF;

      sctx := jc_idxtype_im(ia, scannum, null); 
    
      if errmsg is null then
        RETURN ODCICONST.SUCCESS;
      else
        jchem_core_pkg.handle_java_error(errmsg);
      end if;

      jchem_misc_pkg.new_profile_point();
      RETURN ODCICONST.SUCCESS;

  END;


  STATIC FUNCTION ODCIIndexStart(sctx IN OUT jc_idxtype_im, 
                                 ia sys.odciindexinfo,
                                 op sys.odciPredInfo,
                                 qi sys.ODCIQueryInfo,
                                 strt VARCHAR2,
                                 stop VARCHAR2,
                                 query BLOB,
                                 param1 number, param2 number,
                                 env sys.ODCIEnv) RETURN NUMBER IS
    scannum number;
    pred_str VARCHAR2(2000);
    errmsg varchar2(32767);
  BEGIN

--    jchem_core_pkg.profile_array := TIMESTAMP_ARRAY();

      jchem_core_pkg.checkTableVersion(
                ia.IndexSchema,
                ia.IndexName, ia.IndexPartition,
                ia.IndexCols(1).TableSchema,
                ia.IndexCols(1).TableName,
                ia.IndexCols(1).ColName);

      scannum := jchem_defright_pkg.get_next_scan_num();

      IF strt IS NULL THEN
        pred_str := 'null/' || stop || '/' || op.Flags;
      ELSIF stop IS NULL THEN
        pred_str := strt || '/null/' || op.Flags;
      ELSE
        pred_str := strt || '/' || stop || '/' || op.Flags;
      END IF;

      IF op.ObjectName = 'JC_TVERSKY' THEN
          errmsg := jchem_blob_pkg.similaritySearch(query, 'similarity',
                  pred_str, 'dissimilarityMetric=tversky' || jchem_core_pkg.simCalcSeparator || param2 || jchem_core_pkg.simCalcSeparator || param1,
                  ia.IndexSchema, ia.IndexName,ia.IndexPartition,
                  ia.IndexCols(1).TableSchema, ia.IndexCols(1).TableName, 
                  ia.IndexCols(1).colName, scannum);
      ELSE
          raise_application_error(-20101, 'Unsupported operator: '
              || op.ObjectName);
      END IF;

      sctx := jc_idxtype_im(ia, scannum, null); 
    
      if errmsg is null then
        RETURN ODCICONST.SUCCESS;
      else
        jchem_core_pkg.handle_java_error(errmsg);
      end if;

      jchem_misc_pkg.new_profile_point();
      RETURN ODCICONST.SUCCESS;

  END;



  MEMBER FUNCTION ODCIIndexFetch(self IN OUT NOCOPY jc_idxtype_im, nrows NUMBER,
                                 rids OUT SYS.ODCIRidList, env sys.ODCIEnv)
  RETURN NUMBER IS
    l_idx_out    INTEGER := 1;
    l_rlist      sys.ODCIRidList := sys.ODCIRidList();
    l_refcur     jchem_refcur_pkg.refcur_t;
    l_rid        ROWID;
    l_s          VARCHAR2(4000);

    l_count      integer := 1;
    l_done       boolean := false;

    invalid_rowid exception;
    pragma exception_init(invalid_rowid, -1410);
  BEGIN
    /* begin */
--    jchem_misc_pkg.trace('scannum=' || to_char(self.scan_num));

      if cnum is not null then
        WHILE not l_done LOOP
          IF l_count > nrows THEN
            l_done := TRUE;
          ELSE
            l_rlist.extend;
            IF dbms_sql.fetch_rows(cnum) > 0 THEN
              dbms_sql.column_value_rowid(cnum, 1, l_rlist(l_count));
              l_count := l_count + 1;
            ELSE
              l_rlist(l_count) := null;
              l_done := TRUE;
              dbms_sql.close_cursor(cnum);
              cnum := null;
            END IF;
          END IF;
        END LOOP;
      else
        if jchem_core_pkg.nr_remaining_rowids(self.scan_num) = 0 then
          l_rlist.extend;
          l_rlist(l_idx_out) := null;
        else
          l_refcur := jchem_core_pkg.get_rowids(self.scan_num, nrows);
          begin
            loop
              fetch l_refcur into l_rid;
              exit when l_refcur%notfound;
              if l_rid is not null then
                l_rlist.extend;
  --              jchem_misc_pkg.trace(l_rid);
                l_rlist(l_idx_out) := l_rid;
                l_idx_out := l_idx_out + 1;
              else
                exit;
              end if;
            end loop;
          exception
            when invalid_rowid then
              fetch l_refcur into l_s;
              raise_application_error(-20101, 
                    'Fake ROWID: '''|| l_s || ''', l_idx_out=' ||
                    to_char(l_idx_out));
          end;
          if jchem_core_pkg.nr_remaining_rowids(self.scan_num) = 0 then
            l_rlist.extend;
            l_rlist(l_idx_out) := null;
          end if;
          close l_refcur;
        end if;
      end if;

      rids := l_rlist;
      RETURN ODCICONST.SUCCESS;
    /*
    exception
    when others then
      if sqlcode = -29532 then
        jchem_core_pkg.handle_java_error(sqlerrm);
      else
        raise;
      end if;
    end;
    */
  END;

  MEMBER FUNCTION ODCIIndexClose(self IN OUT jc_idxtype_im, 
					env sys.ODCIEnv) RETURN NUMBER IS
  BEGIN
--    jchem_misc_pkg.trace('ODCIIndexClose BEGIN');
    if cnum is not null and dbms_sql.is_open(cnum) then
      dbms_sql.close_cursor(cnum);
      cnum := null;
    end if;
    jchem_core_pkg.close_scan_resultset(self.scan_num);
    jchem_misc_pkg.new_profile_point();
    RETURN ODCICONST.SUCCESS;
  END;

  STATIC FUNCTION ODCIIndexInsert(ia sys.odciindexinfo, rid VARCHAR2, 
                          newval VARCHAR2, env sys.ODCIEnv) RETURN NUMBER IS 
    errmsg varchar2(32767);
  BEGIN
--    jchem_core_pkg.checkTableVersion(
--              ia.IndexSchema,
--              ia.IndexName,
--              ia.IndexCols(1).TableSchema,
--              ia.IndexCols(1).TableName,
--              ia.IndexCols(1).ColName);

      if jchem_misc_pkg.is_profiling then
        jchem_misc_pkg.new_profile_point_set();
      end if;

      errmsg := jchem_core_pkg.insert_mol_into_idxtable(newval,
            ia.IndexSchema, ia.IndexName, ia.IndexPartition,
            ia.IndexCols(1).TableSchema, ia.IndexCols(1).TableName,
            ia.IndexCols(1).ColName,
            rid);

      if jchem_misc_pkg.is_profiling then
        jchem_misc_pkg.new_profile_point();
      end if;

      if errmsg is null then
        RETURN ODCICONST.SUCCESS;
      else
        jchem_core_pkg.handle_java_error(errmsg);
      end if;

      RETURN ODCICONST.SUCCESS;
  END;  

  STATIC FUNCTION ODCIIndexDelete(ia sys.odciindexinfo, rid VARCHAR2, 
			  oldval VARCHAR2, env sys.ODCIEnv) RETURN NUMBER IS 
   BEGIN
    /* begin */
      jchem_core_pkg.delete_mol_from_idxtable(
          ia.IndexSchema, ia.IndexName, ia.IndexPartition,
                  ia.IndexCols(1).TableSchema, ia.IndexCols(1).TableName, rid);
      RETURN ODCICONST.SUCCESS;
    /*
    exception
    when others then
      if sqlcode = -29532 then
        jchem_core_pkg.handle_java_error(sqlerrm);
      else
        raise;
      end if;
    end;
    */
  END;
  
  STATIC FUNCTION ODCIIndexUpdate(ia sys.odciindexinfo, rid VARCHAR2, 
         oldval VARCHAR2, newval VARCHAR2, env sys.ODCIEnv) RETURN NUMBER IS 
    errmsg varchar2(32767);
  BEGIN
--    jchem_core_pkg.checkTableVersion(
--              ia.IndexSchema,
--              ia.IndexName,
--              ia.IndexCols(1).TableSchema,
--              ia.IndexCols(1).TableName,
--              ia.IndexCols(1).ColName);

      errmsg := jchem_core_pkg.update_mol_idxtable(oldval, newval, 
                      ia.IndexSchema, ia.IndexName, ia.IndexPartition,
                      ia.IndexCols(1).TableSchema, ia.IndexCols(1).TableName,
                      ia.IndexCols(1).ColName, rid);    

      if errmsg is null then
        RETURN ODCICONST.SUCCESS;
      else
        jchem_core_pkg.handle_java_error(errmsg);
      end if;

      RETURN ODCICONST.SUCCESS;
  END;

  STATIC FUNCTION ODCIIndexInsert(ia sys.odciindexinfo, rid VARCHAR2, 
                                  newval CLOB, env sys.ODCIEnv) RETURN NUMBER IS 
    errmsg varchar2(32767);
  BEGIN
  --    jchem_core_pkg.checkTableVersion(
  --              ia.IndexSchema,
  --              ia.IndexName,
  --              ia.IndexCols(1).TableSchema,
  --              ia.IndexCols(1).TableName,
  --            ia.IndexCols(1).ColName);

      if jchem_misc_pkg.is_profiling then
        jchem_misc_pkg.new_profile_point_set();
      end if;

      errmsg := jchem_clob_pkg.insert_mol_into_idxtable(newval, 
                    ia.IndexSchema, ia.IndexName, ia.IndexPartition,
                    ia.IndexCols(1).TableSchema, ia.IndexCols(1).TableName,
                    ia.IndexCols(1).ColName,
                    rid);

      if jchem_misc_pkg.is_profiling then
        jchem_misc_pkg.new_profile_point();
      end if;

      if errmsg is null then
        RETURN ODCICONST.SUCCESS;
      else
        jchem_core_pkg.handle_java_error(errmsg);
      end if;

      RETURN ODCICONST.SUCCESS;
  END;  

  STATIC FUNCTION ODCIIndexDelete(ia sys.odciindexinfo, rid VARCHAR2, 
                                  oldval CLOB, env sys.ODCIEnv) RETURN NUMBER IS 
  BEGIN
    /* begin */
      jchem_core_pkg.delete_mol_from_idxtable(
              ia.IndexSchema, ia.IndexName, ia.IndexPartition,
              ia.IndexCols(1).TableSchema, ia.IndexCols(1).TableName, rid);
      RETURN ODCICONST.SUCCESS;
    /*
    exception
    when others then
      if sqlcode = -29532 then
        jchem_core_pkg.handle_java_error(sqlerrm);
      else
        raise;
      end if;
    end;
    */
  END;

  STATIC FUNCTION ODCIIndexUpdate(ia sys.odciindexinfo, rid VARCHAR2, 
         oldval CLOB, newval CLOB, env sys.ODCIEnv) RETURN NUMBER IS 
    errmsg varchar2(32767);
  BEGIN
--    jchem_core_pkg.checkTableVersion(
--              ia.IndexSchema,
--              ia.IndexName,
--              ia.IndexCols(1).TableSchema,
--              ia.IndexCols(1).TableName,
--              ia.IndexCols(1).ColName);

      errmsg := jchem_clob_pkg.update_mol_idxtable(oldval, newval, 
                      ia.IndexSchema, ia.IndexName, ia.IndexPartition,
                      ia.IndexCols(1).TableSchema, ia.IndexCols(1).TableName,
                      ia.IndexCols(1).ColName, rid);

      if errmsg is null then
        RETURN ODCICONST.SUCCESS;
      else
        jchem_core_pkg.handle_java_error(errmsg);
      end if;

      RETURN ODCICONST.SUCCESS;
  END;

  STATIC FUNCTION ODCIIndexInsert(ia sys.odciindexinfo, rid VARCHAR2, 
                          newval BLOB, env sys.ODCIEnv) RETURN NUMBER IS 
    errmsg varchar2(32767);
  BEGIN
--    jchem_core_pkg.checkTableVersion(
--              ia.IndexSchema,
--              ia.IndexName,
--              ia.IndexCols(1).TableSchema,
--              ia.IndexCols(1).TableName,
--              ia.IndexCols(1).ColName);

      if jchem_misc_pkg.is_profiling then
        jchem_misc_pkg.new_profile_point_set();
      end if;

      errmsg := jchem_blob_pkg.insert_mol_into_idxtable(newval, 
                      ia.IndexSchema, ia.IndexName, ia.IndexPartition,
                      ia.IndexCols(1).TableSchema, ia.IndexCols(1).TableName,
                      ia.IndexCols(1).ColName,
                      rid);

      if jchem_misc_pkg.is_profiling then
        jchem_misc_pkg.new_profile_point();
      end if;

      if errmsg is null then
        RETURN ODCICONST.SUCCESS;
      else
        jchem_core_pkg.handle_java_error(errmsg);
      end if;

      RETURN ODCICONST.SUCCESS;
  END;  

  STATIC FUNCTION ODCIIndexDelete(ia sys.odciindexinfo, rid VARCHAR2, 
			  oldval BLOB, env sys.ODCIEnv) RETURN NUMBER IS 
  BEGIN
    /* begin */
      jchem_core_pkg.delete_mol_from_idxtable(
          ia.IndexSchema, ia.IndexName, ia.IndexPartition,
                  ia.IndexCols(1).TableSchema, ia.IndexCols(1).TableName, rid);
      RETURN ODCICONST.SUCCESS;
    /*
    exception
    when others then
      if sqlcode = -29532 then
        jchem_core_pkg.handle_java_error(sqlerrm);
      else
        raise;
      end if;
    end;
    */
  END;
  
  STATIC FUNCTION ODCIIndexUpdate(ia sys.odciindexinfo, rid VARCHAR2, 
         oldval BLOB, newval BLOB, env sys.ODCIEnv) RETURN NUMBER IS 
    errmsg varchar2(32767);
  BEGIN
--    jchem_core_pkg.checkTableVersion(
--              ia.IndexSchema,
--              ia.IndexName,
--              ia.IndexCols(1).TableSchema,
--              ia.IndexCols(1).TableName,
--              ia.IndexCols(1).ColName);

      errmsg := jchem_blob_pkg.update_mol_idxtable(oldval, newval,
                      ia.IndexSchema, ia.IndexName, ia.IndexPartition,
                      ia.IndexCols(1).TableSchema, ia.IndexCols(1).TableName,
                      ia.IndexCols(1).ColName, rid);    

      if errmsg is null then
        RETURN ODCICONST.SUCCESS;
      else
        jchem_core_pkg.handle_java_error(errmsg);
      end if;

      RETURN ODCICONST.SUCCESS;
  END;

  STATIC FUNCTION ODCIIndexExchangePartition(ia sys.ODCIIndexInfo, 
        ia1 sys.ODCIIndexInfo, env sys.ODCIEnv) RETURN NUMBER IS
  BEGIN
    /* begin */
      RETURN jchem_core_pkg.exchangePartitions(ia.IndexSchema,
          ia.IndexName, ia.IndexPartition, ia1.IndexSchema, ia1.IndexName);
    /*
    exception
    when others then
      if sqlcode = -29532 then
        jchem_core_pkg.handle_java_error(sqlerrm);
      else
        raise;
      end if;
    end;
    */
  END;

  STATIC FUNCTION ODCIIndexMergePartition(ia sys.ODCIIndexInfo, 
        part_name1 sys.ODCIPartInfo, part_name2 sys.ODCIPartInfo, 
        parms VARCHAR2, env sys.ODCIEnv) RETURN NUMBER IS
    ret number;
    errmsg varchar2(32767);
  BEGIN
      IF (ia.IndexPartition IS NOT NULL) THEN
        ret := jchem_core_pkg.indexDrop(ia.IndexSchema, ia.IndexName,
                  ia.IndexPartition, null, null);
      END IF;

      IF (part_name1.IndexPartition IS NOT NULL) THEN
        ret := jchem_core_pkg.indexDrop(ia.IndexSchema,
            ia.IndexName, part_name1.IndexPartition,
            null, null);
      END IF;

      IF (part_name2.IndexPartition IS NOT NULL) THEN
        errmsg := jchem_core_pkg.indexCreate(ia.IndexSchema, 
            ia.IndexName, part_name2.IndexPartition, ia.IndexCols(1).TableSchema, 
            ia.IndexCols(1).TableName, part_name2.TablePartition,
            ia.IndexCols(1).colName, parms);

        if errmsg is null then
          ret := ODCICONST.SUCCESS;
        else
          jchem_core_pkg.handle_java_error(errmsg);
        end if;

      END IF;

      RETURN ret;
  END;

  STATIC FUNCTION ODCIIndexSplitPartition(ia sys.ODCIIndexInfo, 
        part_name1 sys.ODCIPartInfo, part_name2 sys.ODCIPartInfo, 
        parms VARCHAR2, env sys.ODCIEnv) RETURN NUMBER IS
    ret number;
    errmsg varchar2(32767);
  BEGIN
      IF (ia.IndexPartition IS NOT NULL) THEN
        ret := jchem_core_pkg.indexDrop(ia.IndexSchema, ia.IndexName,
                  ia.IndexPartition, null, null);
      END IF;

      IF (part_name1.IndexPartition IS NOT NULL) THEN
        errmsg := jchem_core_pkg.indexCreate(ia.IndexSchema, 
            ia.IndexName, part_name1.IndexPartition, ia.IndexCols(1).TableSchema, 
            ia.IndexCols(1).TableName, part_name1.TablePartition,
            ia.IndexCols(1).colName, parms);

        if errmsg is null then
          ret := ODCICONST.SUCCESS;
        else
          jchem_core_pkg.handle_java_error(errmsg);
        end if;
      END IF;

      IF (part_name2.IndexPartition IS NOT NULL) THEN
        errmsg := jchem_core_pkg.indexCreate(ia.IndexSchema, 
            ia.IndexName, part_name2.IndexPartition, ia.IndexCols(1).TableSchema, 
            ia.IndexCols(1).TableName, part_name2.TablePartition,
            ia.IndexCols(1).colName, parms);

        if errmsg is null then
          ret := ODCICONST.SUCCESS;
        else
          jchem_core_pkg.handle_java_error(errmsg);
        end if;
      END IF;

      RETURN ret;
  END;
END;
/
show errors;

------------------------------------------------------
-- CREATE OR REPLACE FUNCTIONAL IMPLEMENTATIONS for operators
------------------------------------------------------

CREATE OR REPLACE FUNCTION Exec_Func(sqlOperator VARCHAR2, target VARCHAR2,
                    query VARCHAR2, options VARCHAR2,
                    indexctx IN SYS.ODCIIndexCtx,
                    scanctx IN OUT jc_idxtype_im, scanflg IN NUMBER,
                    queryRequired IN NUMBER := 1)
      RETURN NUMBER AUTHID CURRENT_USER PARALLEL_ENABLE AS
  error varchar2(32767);
  result varchar2(32767);
BEGIN
  jchem_core_pkg.checkTableVersionEx('jc_' || sqlOperator, indexctx);

  IF query is null and queryRequired = 1 THEN 
    result := null;
  END IF;
  IF target is null THEN
    IF indexctx.IndexInfo IS NOT NULL THEN
      error := jchem_core_pkg.exec_function(
                    sqlOperator, null, query, options,
                    indexctx.Rid,
                    indexctx.IndexInfo.IndexSchema,
                    indexctx.IndexInfo.IndexName,
                    indexctx.IndexInfo.IndexPartition,
                    indexctx.IndexInfo.IndexCols(1).TableSchema,
                    indexctx.IndexInfo.IndexCols(1).TableName,
                    indexctx.IndexInfo.IndexCols(1).ColName,
                    result);
    ELSE 
      result := null;
    END IF;
  ELSE
    IF indexctx.IndexInfo IS NOT NULL THEN
      error := jchem_core_pkg.exec_function(
                    sqlOperator, target, query, options,
                    indexctx.Rid,
                    indexctx.IndexInfo.IndexSchema,
                    indexctx.IndexInfo.IndexName,
                    indexctx.IndexInfo.IndexPartition,
                    indexctx.IndexInfo.IndexCols(1).TableSchema,
                    indexctx.IndexInfo.IndexCols(1).TableName,
                    indexctx.IndexInfo.IndexCols(1).ColName,
                    result);
    ELSE
      error := jchem_core_pkg.exec_function(
                sqlOperator, target, query, options,
                null, null, null, null, null, null, null,
                result);
    END IF;
  END IF;

--  raise_application_error(-20102,
--    'error=' || error || ', result=' || result);

  if error is null then
    return result;
  else
    jchem_core_pkg.handle_java_error(error);
  end if;
END;
/
show errors;

CREATE OR REPLACE FUNCTION Exec_FuncV(sqlOperator VARCHAR2,
                              target CLOB, query CLOB, options VARCHAR2,
                              indexctx IN SYS.ODCIIndexCtx, 
                              scanctx IN OUT jc_idxtype_im,
                              scanflg IN NUMBER,
                              queryRequired IN NUMBER := 1)
      RETURN VARCHAR2 AUTHID CURRENT_USER PARALLEL_ENABLE AS
  error varchar2(32767);
  result varchar2(32767);
BEGIN
  jchem_core_pkg.checkTableVersionEx('jc_' || sqlOperator, indexctx);

  IF query is null and queryRequired = 1 THEN 
    return null; 
  END IF;
  IF target is null THEN
        return NULL;
  ELSE
    IF indexctx.IndexInfo IS NOT NULL THEN
      error := jchem_clob_pkg.exec_function(
                    sqlOperator, target, query, options,
                    indexctx.Rid,
                    indexctx.IndexInfo.IndexSchema,
                    indexctx.IndexInfo.IndexName,
                    indexctx.IndexInfo.IndexPartition,
                    indexctx.IndexInfo.IndexCols(1).TableSchema,
                    indexctx.IndexInfo.IndexCols(1).TableName,
                    indexctx.IndexInfo.IndexCols(1).ColName, result);

    ELSE
      error := jchem_clob_pkg.exec_function(
                sqlOperator, target, query, options,
                null, null, null, null, null, null, null, result);
    END IF;
  END IF;

  if error is null then
    return result;
  else
    jchem_core_pkg.handle_java_error(error);
  end if;
END;
/
show errors;

CREATE OR REPLACE FUNCTION Exec_FuncC(sqlOperator VARCHAR2,
                              target CLOB, query CLOB, options VARCHAR2,
                              indexctx IN SYS.ODCIIndexCtx, 
                              scanctx IN OUT jc_idxtype_im,
                              scanflg IN NUMBER,
                              queryRequired IN NUMBER := 1)
      RETURN NUMBER AUTHID CURRENT_USER PARALLEL_ENABLE AS
  error varchar2(32767);
  result varchar2(32767);
BEGIN
  jchem_core_pkg.checkTableVersionEx('jc_' || sqlOperator, indexctx);

  IF query is null and queryRequired = 1 THEN 
    return null; 
  END IF;
  IF target is null THEN
        return NULL;
  ELSE
    IF indexctx.IndexInfo IS NOT NULL THEN
      error := jchem_clob_pkg.exec_function(
                    sqlOperator, target, query, options,
                    indexctx.Rid,
                    indexctx.IndexInfo.IndexSchema,
                    indexctx.IndexInfo.IndexName,
                    indexctx.IndexInfo.IndexPartition,
                    indexctx.IndexInfo.IndexCols(1).TableSchema,
                    indexctx.IndexInfo.IndexCols(1).TableName,
                    indexctx.IndexInfo.IndexCols(1).ColName,
                    result);

    ELSE
      error := jchem_clob_pkg.exec_function(
                sqlOperator, target, query, options,
                null, null, null, null, null, null, null,
                result);
    END IF;
  END IF;

  if error is null then
    return result;
  else
    jchem_core_pkg.handle_java_error(error);
  end if;
END;
/
show errors;

CREATE OR REPLACE FUNCTION Exec_FuncB(sqlOperator VARCHAR2,
                              target BLOB, query BLOB, options VARCHAR2,
                              indexctx IN SYS.ODCIIndexCtx, 
                              scanctx IN OUT jc_idxtype_im,
                              scanflg IN NUMBER,
                              queryRequired IN NUMBER := 1)
      RETURN NUMBER AUTHID CURRENT_USER PARALLEL_ENABLE AS
  error varchar2(32767);
  result varchar2(32767);
BEGIN
  jchem_core_pkg.checkTableVersionEx('jc_' || sqlOperator, indexctx);

  IF query is null and queryRequired = 1 THEN 
    return null; 
  END IF;
  IF target is null THEN
        return NULL;
  ELSE
    IF indexctx.IndexInfo IS NOT NULL THEN
      error := jchem_blob_pkg.exec_function(
                    sqlOperator, target, query, options,
                    indexctx.Rid,
                    indexctx.IndexInfo.IndexSchema,
                    indexctx.IndexInfo.IndexName,
                    indexctx.IndexInfo.IndexPartition,
                    indexctx.IndexInfo.IndexCols(1).TableSchema,
                    indexctx.IndexInfo.IndexCols(1).TableName,
                    indexctx.IndexInfo.IndexCols(1).ColName,
                    result);

    ELSE
      error := jchem_blob_pkg.exec_function(
                sqlOperator, target, query, options,
                null, null, null, null, null, null, null,
                result);
    END IF;
  END IF;

  if error is null then
    return result;
  else
    jchem_core_pkg.handle_java_error(error);
  end if;
END;
/
show errors;

CREATE OR REPLACE FUNCTION Exec_FuncCC(sqlOperator VARCHAR2,
                              target CLOB, query CLOB, options VARCHAR2,
                              indexctx IN SYS.ODCIIndexCtx, 
                              scanctx IN OUT jc_idxtype_im,
                              scanflg IN NUMBER,
                              queryRequired IN NUMBER := 1)
      RETURN CLOB AUTHID CURRENT_USER PARALLEL_ENABLE AS
  error varchar2(32767);
  result CLOB;
BEGIN
  jchem_core_pkg.checkTableVersionEx('jc_' || sqlOperator, indexctx);

  IF query is null and queryRequired = 1 THEN 
    return null; 
  END IF;
  IF target is null THEN
        return NULL;
  ELSE
    IF indexctx.IndexInfo IS NOT NULL THEN
      error := jchem_clob_pkg.exec_function__c(
                    sqlOperator, target, query, options,
                    indexctx.Rid,
                    indexctx.IndexInfo.IndexSchema,
                    indexctx.IndexInfo.IndexName,
                    indexctx.IndexInfo.IndexPartition,
                    indexctx.IndexInfo.IndexCols(1).TableSchema,
                    indexctx.IndexInfo.IndexCols(1).TableName,
                    indexctx.IndexInfo.IndexCols(1).ColName,
                    result);

    ELSE
      error := jchem_clob_pkg.exec_function__c(
                sqlOperator, target, query, options,
                null, null, null, null, null, null, null,
                result);
    END IF;
  END IF;

  if error is null then
    return result;
  else
    jchem_core_pkg.handle_java_error(error);
  end if;
END;
/
show errors;

CREATE OR REPLACE FUNCTION Exec_FuncBB(sqlOperator VARCHAR2,
                              target BLOB, query BLOB, options VARCHAR2,
                              indexctx IN SYS.ODCIIndexCtx, 
                              scanctx IN OUT jc_idxtype_im,
                              scanflg IN NUMBER,
                              queryRequired IN NUMBER := 1)
      RETURN BLOB AUTHID CURRENT_USER PARALLEL_ENABLE AS
  error varchar2(32767);
  result BLOB;
BEGIN
  jchem_core_pkg.checkTableVersionEx('jc_' || sqlOperator, indexctx);

  IF query is null and queryRequired = 1 THEN 
    return null; 
  END IF;
  IF target is null THEN
        return NULL;
  ELSE
    IF indexctx.IndexInfo IS NOT NULL THEN
      error := jchem_blob_pkg.exec_function__b(
                    sqlOperator, target, query, options,
                    indexctx.Rid,
                    indexctx.IndexInfo.IndexSchema,
                    indexctx.IndexInfo.IndexName,
                    indexctx.IndexInfo.IndexPartition,
                    indexctx.IndexInfo.IndexCols(1).TableSchema,
                    indexctx.IndexInfo.IndexCols(1).TableName,
                    indexctx.IndexInfo.IndexCols(1).ColName,
                    result);

    ELSE
      error := jchem_blob_pkg.exec_function__b(
                sqlOperator, target, query, options,
                null, null, null, null, null, null, null,
                result);
    END IF;
  END IF;

  if error is null then
    return result;
  else
    jchem_core_pkg.handle_java_error(error);
  end if;
END;
/
show errors;

CREATE OR REPLACE FUNCTION Contains_Func(target VARCHAR2, query VARCHAR2,
                              indexctx IN SYS.ODCIIndexCtx, 
                              scanctx IN OUT jc_idxtype_im,
                              scanflg IN NUMBER)
RETURN NUMBER AUTHID CURRENT_USER PARALLEL_ENABLE AS
BEGIN
  return Exec_Func('contains', target, query, null, indexctx, scanctx, scanflg);
END;
/
show errors;

CREATE OR REPLACE FUNCTION Contains_FuncC(target CLOB, query CLOB,
                              indexctx IN SYS.ODCIIndexCtx, 
                              scanctx IN OUT jc_idxtype_im,
                              scanflg IN NUMBER)
RETURN NUMBER AUTHID CURRENT_USER PARALLEL_ENABLE AS
BEGIN
  return Exec_FuncC('contains', target, query, null, indexctx, scanctx, scanflg);
END;
/
show errors;

CREATE OR REPLACE FUNCTION Contains_FuncB(target BLOB, query BLOB,
                              indexctx IN SYS.ODCIIndexCtx, 
                              scanctx IN OUT jc_idxtype_im,
                              scanflg IN NUMBER)
RETURN NUMBER AUTHID CURRENT_USER PARALLEL_ENABLE AS
BEGIN
  return Exec_FuncB('contains', target, query, null, indexctx, scanctx, scanflg);
END;
/
show errors;

CREATE OR REPLACE FUNCTION Equals_Func(target VARCHAR2, query VARCHAR2,
                            indexctx IN SYS.ODCIIndexCtx, 
                            scanctx IN OUT jc_idxtype_im,
                            scanflg IN NUMBER)
    RETURN NUMBER AUTHID CURRENT_USER PARALLEL_ENABLE AS
BEGIN
  return Exec_Func('equals', target, query, null, indexctx, scanctx, scanflg);
END;
/
show errors;

CREATE OR REPLACE FUNCTION Equals_FuncC(target CLOB, query CLOB,
                            indexctx IN SYS.ODCIIndexCtx, 
                            scanctx IN OUT jc_idxtype_im,
                            scanflg IN NUMBER)
    RETURN NUMBER AUTHID CURRENT_USER PARALLEL_ENABLE AS
BEGIN
  return Exec_FuncC('equals', target, query, null, indexctx, scanctx, scanflg);
END;
/
show errors;

CREATE OR REPLACE FUNCTION Equals_FuncB(target BLOB, query BLOB,
                            indexctx IN SYS.ODCIIndexCtx, 
                            scanctx IN OUT jc_idxtype_im,
                            scanflg IN NUMBER)
    RETURN NUMBER AUTHID CURRENT_USER PARALLEL_ENABLE AS
BEGIN
  return Exec_FuncB('equals', target, query, null, indexctx, scanctx, scanflg);
END;
/
show errors;

CREATE OR REPLACE FUNCTION Evaluate_Func(target VARCHAR2, ct VARCHAR2,
                                         indexctx IN SYS.ODCIIndexCtx, 
                                         scanctx IN OUT jc_idxtype_im,
                                         scanflg IN NUMBER)
      RETURN NUMBER AUTHID CURRENT_USER PARALLEL_ENABLE AS
BEGIN
  return Exec_Func('evaluate', target, null, ct,
                   indexctx, scanctx, scanflg, 0);
END;
/
show errors;

CREATE OR REPLACE FUNCTION Evaluate_FuncC(target CLOB, ct VARCHAR2,
                                         indexctx IN SYS.ODCIIndexCtx, 
                                         scanctx IN OUT jc_idxtype_im,
                                         scanflg IN NUMBER)
      RETURN NUMBER AUTHID CURRENT_USER PARALLEL_ENABLE AS
BEGIN
  return Exec_FuncC('evaluate', target, null, ct,
                    indexctx, scanctx, scanflg, 0);
END;
/
show errors;

CREATE OR REPLACE FUNCTION Evaluate_FuncB(target BLOB, ct VARCHAR2,
                                         indexctx IN SYS.ODCIIndexCtx, 
                                         scanctx IN OUT jc_idxtype_im,
                                         scanflg IN NUMBER)
      RETURN NUMBER AUTHID CURRENT_USER PARALLEL_ENABLE AS
BEGIN
  return Exec_FuncB('evaluate', target, null, ct,
                    indexctx, scanctx, scanflg, 0);
END;
/
show errors;

CREATE OR REPLACE FUNCTION Evaluate3_Func(target VARCHAR2, ct VARCHAR2,
                                          options VARCHAR2,
                                          indexctx IN SYS.ODCIIndexCtx, 
                                          scanctx IN OUT jc_idxtype_im,
                                          scanflg IN NUMBER)
      RETURN NUMBER AUTHID CURRENT_USER PARALLEL_ENABLE AS
BEGIN
  raise_application_error(-20102,
    'options are not currently supported for jc_eval in functional mode');
--  return null;
END;
/
show errors;

CREATE OR REPLACE FUNCTION Evaluate3_FuncC(target CLOB, ct VARCHAR2,
                                          options VARCHAR2,
                                          indexctx IN SYS.ODCIIndexCtx, 
                                          scanctx IN OUT jc_idxtype_im,
                                          scanflg IN NUMBER)
      RETURN NUMBER AUTHID CURRENT_USER PARALLEL_ENABLE AS
BEGIN
  raise_application_error(-20102,
        'options are not currently supported for jc_eval in functional mode');
--  return null;
END;
/
show errors;

CREATE OR REPLACE FUNCTION Evaluate3_FuncB(target BLOB, ct VARCHAR2,
                                          options VARCHAR2,
                                          indexctx IN SYS.ODCIIndexCtx, 
                                          scanctx IN OUT jc_idxtype_im,
                                          scanflg IN NUMBER)
      RETURN NUMBER AUTHID CURRENT_USER PARALLEL_ENABLE AS
BEGIN
  raise_application_error(-20102,
        'options are not currently supported for jc_eval in functional mode');
--  return null;
END;
/
show errors;

CREATE OR REPLACE FUNCTION EvaluateX_Func(target VARCHAR2, options VARCHAR2,
                                         indexctx IN SYS.ODCIIndexCtx, 
                                         scanctx IN OUT jc_idxtype_im,
                                         scanflg IN NUMBER)
      RETURN VARCHAR2 AUTHID CURRENT_USER PARALLEL_ENABLE AS
BEGIN
  return Exec_FuncV('evaluate_x', target, null, options, indexctx, scanctx, scanflg, 0);
END;
/
show errors;

CREATE OR REPLACE FUNCTION EvaluateX_FuncC(target CLOB, options VARCHAR2,
                           indexctx IN SYS.ODCIIndexCtx, 
                           scanctx IN OUT jc_idxtype_im,
                           scanflg IN NUMBER)
      RETURN CLOB AUTHID CURRENT_USER PARALLEL_ENABLE AS
BEGIN
  return Exec_FuncCC('evaluate_x', target, null, options, indexctx, scanctx, scanflg, 0);
END;
/
show errors;

CREATE OR REPLACE FUNCTION EvaluateX_FuncB(target BLOB, options VARCHAR2,
                           indexctx IN SYS.ODCIIndexCtx, 
                           scanctx IN OUT jc_idxtype_im,
                           scanflg IN NUMBER)
      RETURN BLOB AUTHID CURRENT_USER PARALLEL_ENABLE AS
BEGIN
  return Exec_FuncBB('evaluate_x', target, null, options, indexctx, scanctx, scanflg, 0);
END;
/
show errors;

CREATE OR REPLACE FUNCTION Compare_Func(target VARCHAR2, query VARCHAR2,
                             options VARCHAR2, indexctx IN SYS.ODCIIndexCtx, 
                             scanctx IN OUT jc_idxtype_im,
                             scanflg IN NUMBER)
      RETURN NUMBER AUTHID CURRENT_USER PARALLEL_ENABLE AS
BEGIN
  return Exec_Func('compare', target, query, options, indexctx, scanctx, scanflg);
END;
/
show errors;

CREATE OR REPLACE FUNCTION Compare_FuncC(target CLOB, query CLOB,
                             options VARCHAR2, indexctx IN SYS.ODCIIndexCtx, 
                             scanctx IN OUT jc_idxtype_im,
                             scanflg IN NUMBER)
      RETURN NUMBER AUTHID CURRENT_USER PARALLEL_ENABLE AS
BEGIN
  return Exec_FuncC('compare', target, query, options, indexctx, scanctx, scanflg);
END;
/
show errors;

CREATE OR REPLACE FUNCTION Compare_FuncCV(target CLOB, query VARCHAR2,
                             options VARCHAR2, indexctx IN SYS.ODCIIndexCtx, 
                             scanctx IN OUT jc_idxtype_im,
                             scanflg IN NUMBER)
RETURN NUMBER AUTHID CURRENT_USER PARALLEL_ENABLE AS
  error varchar2(32767);
  result varchar2(32767);
  BEGIN
    jchem_core_pkg.checkTableVersionEx('jc_compare', indexctx);

    IF query is null THEN 
      return null; 
    END IF;
    -- TODO: Should not we check 'indexctx IS NULL'?
    -- TODO: Should not we check 'scanflg = SYS.CleanUpCall'?
    IF target is null THEN
	  return NULL;
    ELSE
      IF indexctx.IndexInfo IS NOT NULL THEN
        error := jchem_clob_pkg.exec_function_cv('compare',
				target, query, options,
                                indexctx.Rid,
				indexctx.IndexInfo.IndexSchema,
				indexctx.IndexInfo.IndexName,
				indexctx.IndexInfo.IndexPartition,
				indexctx.IndexInfo.IndexCols(1).TableSchema, 
				indexctx.IndexInfo.IndexCols(1).TableName,
                    indexctx.IndexInfo.IndexCols(1).ColName,
                    result);
      ELSE
        error := jchem_clob_pkg.exec_function_cv('compare',
                    target, query, options,
                    null, null, null, null, null, null, null,
                    result);
      END IF;
    END IF;

  if error is null then
    return result;
  else
    jchem_core_pkg.handle_java_error(error);
  end if;
  END;
/
show errors;

CREATE OR REPLACE FUNCTION Compare_FuncCB(target CLOB, query BLOB,
                             options VARCHAR2, indexctx IN SYS.ODCIIndexCtx, 
                             scanctx IN OUT jc_idxtype_im,
                             scanflg IN NUMBER)
RETURN NUMBER AUTHID CURRENT_USER PARALLEL_ENABLE AS
  error varchar2(32767);
  result varchar2(32767);
  BEGIN
    jchem_core_pkg.checkTableVersionEx('jc_compare', indexctx);

    IF query is null THEN 
      return null; 
    END IF;
    -- TODO: Should not we check 'indexctx IS NULL'?
    -- TODO: Should not we check 'scanflg = SYS.CleanUpCall'?
    IF target is null THEN
	  return NULL;
    ELSE
      IF indexctx.IndexInfo IS NOT NULL THEN
        error := jchem_clob_pkg.exec_function_cb('compare',
				target, query, options,
                                indexctx.Rid,
				indexctx.IndexInfo.IndexSchema,
				indexctx.IndexInfo.IndexName,
				indexctx.IndexInfo.IndexPartition,
				indexctx.IndexInfo.IndexCols(1).TableSchema, 
				indexctx.IndexInfo.IndexCols(1).TableName,
                    indexctx.IndexInfo.IndexCols(1).ColName,
                    result);
      ELSE
        error := jchem_clob_pkg.exec_function_cb('compare',
                    target, query, options,
                    null, null, null, null, null, null, null,
                    result);
      END IF;
    END IF;

  if error is null then
    return result;
  else
    jchem_core_pkg.handle_java_error(error);
  end if;
  END;
/
show errors;

CREATE OR REPLACE FUNCTION Compare_FuncB(target BLOB, query BLOB,
                             options VARCHAR2, indexctx IN SYS.ODCIIndexCtx, 
                             scanctx IN OUT jc_idxtype_im,
                             scanflg IN NUMBER)
      RETURN NUMBER AUTHID CURRENT_USER PARALLEL_ENABLE AS
BEGIN
  return Exec_FuncB('compare', target, query, options, indexctx, scanctx, scanflg);
END;
/
show errors;

CREATE OR REPLACE FUNCTION Compare_FuncBV(target BLOB, query VARCHAR2,
                             options VARCHAR2, indexctx IN SYS.ODCIIndexCtx, 
                             scanctx IN OUT jc_idxtype_im,
                             scanflg IN NUMBER)
RETURN NUMBER AUTHID CURRENT_USER PARALLEL_ENABLE AS
  error varchar2(32767);
  result varchar2(32767);
  BEGIN
    jchem_core_pkg.checkTableVersionEx('jc_compare', indexctx);

    IF query is null THEN 
      return null; 
    END IF;
    -- TODO: Should not we check 'indexctx IS NULL'?
    -- TODO: Should not we check 'scanflg = SYS.CleanUpCall'?
    IF target is null THEN
	  return NULL;
    ELSE
      IF indexctx.IndexInfo IS NOT NULL THEN
       error := jchem_blob_pkg.exec_function_bv('compare',
				target, query, options,
                                indexctx.Rid,
				indexctx.IndexInfo.IndexSchema,
				indexctx.IndexInfo.IndexName,
				indexctx.IndexInfo.IndexPartition,
				indexctx.IndexInfo.IndexCols(1).TableSchema, 
				indexctx.IndexInfo.IndexCols(1).TableName,
                    indexctx.IndexInfo.IndexCols(1).ColName,
                    result);
      ELSE
        error := jchem_blob_pkg.exec_function_bv('compare', target, query, options,
                                           null, null, null, null, null, null, null,
                                           result);
      END IF;
    END IF;

  if error is null then
    return result;
  else
    jchem_core_pkg.handle_java_error(error);
  end if;
  END;
/
show errors;

CREATE OR REPLACE FUNCTION compare_func_bquery(target VARCHAR2, query BLOB,
                             options VARCHAR2, indexctx IN SYS.ODCIIndexCtx, 
                             scanctx IN OUT jc_idxtype_im,
                             scanflg IN NUMBER)
      RETURN NUMBER AUTHID CURRENT_USER PARALLEL_ENABLE AS
  error varchar2(32767);
  result varchar2(32767);
BEGIN
    jchem_core_pkg.checkTableVersionEx('jc_compare', indexctx);

    IF query is null THEN 
      return null; 
    END IF;
    -- TODO: Should not we check 'indexctx IS NULL'?
    -- TODO: Should not we check 'scanflg = SYS.CleanUpCall'?
    IF target is null THEN
	  return NULL;
    ELSE
      IF indexctx.IndexInfo IS NOT NULL THEN
       error := jchem_blob_pkg.exec_function_vb('compare',
				target, query, options,
                                indexctx.Rid,
				indexctx.IndexInfo.IndexSchema,
				indexctx.IndexInfo.IndexName,
				indexctx.IndexInfo.IndexPartition,
				indexctx.IndexInfo.IndexCols(1).TableSchema, 
				indexctx.IndexInfo.IndexCols(1).TableName,
                    indexctx.IndexInfo.IndexCols(1).ColName,
                    result);
      ELSE
        error := jchem_blob_pkg.exec_function_vb('compare', target, query, options,
                                               null, null, null, null, null, null, null,
                                               result);
      END IF;
    END IF;
  if error is null then
    return result;
  else
    jchem_core_pkg.handle_java_error(error);
  end if;
END;
/
show errors;

CREATE OR REPLACE FUNCTION MatchCount_Func(target VARCHAR2, query VARCHAR2,
                                indexctx IN SYS.ODCIIndexCtx,
                                scanctx IN OUT jc_idxtype_im,
                                scanflg IN NUMBER)
      RETURN NUMBER AUTHID CURRENT_USER PARALLEL_ENABLE AS
BEGIN
  return Exec_Func('matchcount', target, query, null, indexctx, scanctx, scanflg);
END;
/
show errors;

CREATE OR REPLACE FUNCTION MatchCount_FuncC(target CLOB, query CLOB,
				indexctx IN SYS.ODCIIndexCtx, 
                                scanctx IN OUT jc_idxtype_im,
                                scanflg IN NUMBER)
      RETURN NUMBER AUTHID CURRENT_USER PARALLEL_ENABLE AS
BEGIN
  return Exec_FuncC('matchcount', target, query, null, indexctx, scanctx, scanflg);
END;
/
show errors;

CREATE OR REPLACE FUNCTION MatchCount_FuncB(target BLOB, query BLOB,
                                      indexctx IN SYS.ODCIIndexCtx, 
                                      scanctx IN OUT jc_idxtype_im,
                                      scanflg IN NUMBER)
      RETURN NUMBER AUTHID CURRENT_USER PARALLEL_ENABLE AS
BEGIN
  return Exec_FuncB('matchcount', target, query, null, indexctx, scanctx, scanflg);
END;
/
show errors;

CREATE OR REPLACE FUNCTION Tanimoto_Func(target VARCHAR2, query VARCHAR2, 
          indexctx IN SYS.ODCIIndexCtx, scanctx IN OUT jc_idxtype_im,
          scanflg IN NUMBER) RETURN NUMBER AUTHID CURRENT_USER PARALLEL_ENABLE AS
  res VARCHAR2(32767);
BEGIN
  return Exec_Func('similarity', target, query, 'dissimilarityMetric:tanimoto',
                   indexctx, scanctx, scanflg);
END;
/
show errors;

CREATE OR REPLACE FUNCTION Tanimoto_FuncC(target CLOB, query CLOB, 
          indexctx IN SYS.ODCIIndexCtx, scanctx IN OUT jc_idxtype_im,
          scanflg IN NUMBER)
RETURN NUMBER AUTHID CURRENT_USER PARALLEL_ENABLE AS
  res VARCHAR2(32767);
BEGIN
  return Exec_FuncC('similarity', target, query, 'dissimilarityMetric:tanimoto',
                   indexctx, scanctx, scanflg);
END;
/
show errors;

CREATE OR REPLACE FUNCTION Tanimoto_FuncB(target BLOB, query BLOB, 
          indexctx IN SYS.ODCIIndexCtx, scanctx IN OUT jc_idxtype_im,
          scanflg IN NUMBER)
RETURN NUMBER AUTHID CURRENT_USER PARALLEL_ENABLE AS
  res VARCHAR2(32767);
BEGIN
  return Exec_FuncB('similarity', target, query, 'dissimilarityMetric:tanimoto',
                   indexctx, scanctx, scanflg);
END;
/
show errors;

CREATE OR REPLACE FUNCTION Tversky_Func(target in VARCHAR2, query in VARCHAR2, 
          targetWeight in number, queryWeight in number,
          indexctx IN SYS.ODCIIndexCtx, scanctx IN OUT jc_idxtype_im,
          scanflg IN NUMBER) RETURN NUMBER AUTHID CURRENT_USER PARALLEL_ENABLE AS
    res VARCHAR2(32767);
BEGIN
  return Exec_Func('similarity', target, query, 'dissimilarityMetric:tversky'
                    || jchem_core_pkg.simCalcSeparator 
                    || queryWeight || jchem_core_pkg.simCalcSeparator || targetWeight,
                   indexctx, scanctx, scanflg);
END;
/
show errors;

CREATE OR REPLACE FUNCTION Tversky_FuncC(target CLOB, query CLOB, 
          targetWeight in number, queryWeight in number,
          indexctx IN SYS.ODCIIndexCtx, 
          scanctx IN OUT jc_idxtype_im,
          scanflg IN NUMBER)
RETURN NUMBER AUTHID CURRENT_USER PARALLEL_ENABLE AS
    res VARCHAR2(32767);
BEGIN
  return Exec_FuncC('similarity', target, query, 'dissimilarityMetric:tversky'
                    || jchem_core_pkg.simCalcSeparator 
                    || queryWeight || jchem_core_pkg.simCalcSeparator || targetWeight,
                   indexctx, scanctx, scanflg);
END;
/
show errors;

CREATE OR REPLACE FUNCTION Tversky_FuncB(target BLOB, query BLOB, 
                  targetWeight in number, queryWeight in number,
                  indexctx IN SYS.ODCIIndexCtx, 
                  scanctx IN OUT jc_idxtype_im,
                  scanflg IN NUMBER)
RETURN NUMBER AUTHID CURRENT_USER PARALLEL_ENABLE AS
    res VARCHAR2(32767);
BEGIN
  return Exec_FuncB('similarity', target, query, 'dissimilarityMetric:tversky'
                    || jchem_core_pkg.simCalcSeparator 
                    || queryWeight || jchem_core_pkg.simCalcSeparator || targetWeight,
                   indexctx, scanctx, scanflg);
END;
/
show errors;

CREATE OR REPLACE FUNCTION Dissimilarity_Func(target VARCHAR2, query VARCHAR2, 
          indexctx IN SYS.ODCIIndexCtx, scanctx IN OUT jc_idxtype_im,
          scanflg IN NUMBER)
RETURN NUMBER AUTHID CURRENT_USER PARALLEL_ENABLE AS 
    res VARCHAR2(32767);
BEGIN
  return Exec_Func('dissimilarity', target, query, 'dissimilarityMetric:tanimoto',
                   indexctx, scanctx, scanflg);
END;
/
show errors;

CREATE OR REPLACE FUNCTION Dissimilarity_FuncC(target CLOB, query CLOB, 
          indexctx IN SYS.ODCIIndexCtx, scanctx IN OUT jc_idxtype_im,
          scanflg IN NUMBER)
RETURN NUMBER AUTHID CURRENT_USER PARALLEL_ENABLE AS 
  res VARCHAR2(32767);
BEGIN
  return Exec_FuncC('dissimilarity', target, query, 'dissimilarityMetric:tanimoto',
                   indexctx, scanctx, scanflg);
END;
/
show errors;

CREATE OR REPLACE FUNCTION Dissimilarity_FuncB(target BLOB, query BLOB, 
          indexctx IN SYS.ODCIIndexCtx, scanctx IN OUT jc_idxtype_im,
          scanflg IN NUMBER)
RETURN NUMBER AUTHID CURRENT_USER PARALLEL_ENABLE AS 
    res VARCHAR2(32767);
BEGIN
  return Exec_FuncB('dissimilarity', target, query, 'dissimilarityMetric:tanimoto',
                   indexctx, scanctx, scanflg);
END;
/
show errors;

CREATE OR REPLACE FUNCTION DissimilarityX_Func(target VARCHAR2, query VARCHAR2, 
          options VARCHAR2,
          indexctx IN SYS.ODCIIndexCtx, scanctx IN OUT jc_idxtype_im,
          scanflg IN NUMBER)
RETURN NUMBER AUTHID CURRENT_USER PARALLEL_ENABLE AS 
    res VARCHAR2(32767);
BEGIN
  return Exec_Func('dissimilarity', target, query, options,
                   indexctx, scanctx, scanflg);
END;
/
show errors;

CREATE OR REPLACE FUNCTION DissimilarityX_FuncC(target CLOB, query CLOB, 
          options VARCHAR2,
          indexctx IN SYS.ODCIIndexCtx, scanctx IN OUT jc_idxtype_im,
          scanflg IN NUMBER)
RETURN NUMBER AUTHID CURRENT_USER PARALLEL_ENABLE AS 
  res VARCHAR2(32767);
BEGIN
  return Exec_FuncC('dissimilarity', target, query, options,
                   indexctx, scanctx, scanflg);
END;
/
show errors;

CREATE OR REPLACE FUNCTION DissimilarityX_FuncB(target BLOB, query BLOB, 
          options VARCHAR2,
          indexctx IN SYS.ODCIIndexCtx, scanctx IN OUT jc_idxtype_im,
          scanflg IN NUMBER)
RETURN NUMBER AUTHID CURRENT_USER PARALLEL_ENABLE AS 
    res VARCHAR2(32767);
BEGIN
  return Exec_FuncB('dissimilarity', target, query, options,
                   indexctx, scanctx, scanflg);
END;
/
show errors;

CREATE OR REPLACE FUNCTION Molweight_Func(
          query VARCHAR2, indexctx IN SYS.ODCIIndexCtx, 
          scanctx IN OUT jc_idxtype_im,
          scanflg IN NUMBER) RETURN NUMBER AUTHID CURRENT_USER PARALLEL_ENABLE AS
  BEGIN
    jchem_core_pkg.checkTableVersionEx('jc_molweight', indexctx);

    IF query is null THEN
      IF indexctx.IndexInfo IS NOT NULL THEN
	return jchem_core_pkg.calc_molProp_from_idx(indexctx.Rid, 'molweight',
				indexctx.IndexInfo.IndexSchema,
				indexctx.IndexInfo.IndexName,
				indexctx.IndexInfo.IndexPartition,
				indexctx.IndexInfo.IndexCols(1).TableSchema,
			     	indexctx.IndexInfo.IndexCols(1).TableName);
      ELSE 
	return NULL;
      END IF;
    ELSE
      IF indexctx.IndexInfo IS NOT NULL THEN
        return jchem_core_pkg.calc_molProp( query, 'molweight', indexctx.Rid, 
				indexctx.IndexInfo.IndexSchema, indexctx.IndexInfo.IndexName,
				indexctx.IndexInfo.IndexPartition,
				indexctx.IndexInfo.IndexCols(1).TableSchema,
			     	indexctx.IndexInfo.IndexCols(1).TableName);
      ELSE
        return jchem_core_pkg.calc_molProp(query, 'molweight', null, 
					   null, null, null, null, null);
      END IF;
    END IF;
  END;
/
show errors;

CREATE OR REPLACE FUNCTION Molweight_FuncC(query CLOB, indexctx IN SYS.ODCIIndexCtx, 
                                scanctx IN OUT jc_idxtype_im,
                                scanflg IN NUMBER)
RETURN NUMBER AUTHID CURRENT_USER PARALLEL_ENABLE AS
  BEGIN
    jchem_core_pkg.checkTableVersionEx('jc_molweight', indexctx);

    IF query is null THEN
      IF indexctx.IndexInfo IS NOT NULL THEN
	    return jchem_core_pkg.calc_molProp_from_idx(indexctx.Rid,
                    'molweight',
                    indexctx.IndexInfo.IndexSchema,
                    indexctx.IndexInfo.IndexName,
				    indexctx.IndexInfo.IndexPartition,
                    indexctx.IndexInfo.IndexCols(1).TableSchema,
			     	indexctx.IndexInfo.IndexCols(1).TableName);
      ELSE 
        return NULL;
      END IF;
    ELSE
      IF indexctx.IndexInfo IS NOT NULL THEN
        return jchem_clob_pkg.get_molweight(
                    query, indexctx.Rid, 
                    indexctx.IndexInfo.IndexSchema,
                    indexctx.IndexInfo.IndexName,
				    indexctx.IndexInfo.IndexPartition,
                    indexctx.IndexInfo.IndexCols(1).TableSchema,
                    indexctx.IndexInfo.IndexCols(1).TableName);
      ELSE
        return jchem_clob_pkg.get_molweight(
                     query, null, null, null, null, null, null);
      END IF;
    END IF;
  END;
/
show errors;

CREATE OR REPLACE FUNCTION Molweight_FuncB(query BLOB, indexctx IN SYS.ODCIIndexCtx, 
                                scanctx IN OUT jc_idxtype_im,
                                scanflg IN NUMBER)
RETURN NUMBER AUTHID CURRENT_USER PARALLEL_ENABLE AS
  BEGIN
    jchem_core_pkg.checkTableVersionEx('jc_molweight', indexctx);

    IF query is null THEN
      IF indexctx.IndexInfo IS NOT NULL THEN
	    return jchem_core_pkg.calc_molProp_from_idx(indexctx.Rid,
                    'molweight',
                    indexctx.IndexInfo.IndexSchema,
                    indexctx.IndexInfo.IndexName,
				    indexctx.IndexInfo.IndexPartition,
                    indexctx.IndexInfo.IndexCols(1).TableSchema,
			     	indexctx.IndexInfo.IndexCols(1).TableName);
      ELSE 
        return NULL;
      END IF;
    ELSE
      IF indexctx.IndexInfo IS NOT NULL THEN
        return jchem_blob_pkg.get_molweight(
                    query, indexctx.Rid, 
                    indexctx.IndexInfo.IndexSchema,
                    indexctx.IndexInfo.IndexName,
				    indexctx.IndexInfo.IndexPartition,
                    indexctx.IndexInfo.IndexCols(1).TableSchema,
                    indexctx.IndexInfo.IndexCols(1).TableName);
      ELSE
        return jchem_blob_pkg.get_molweight(
                     query, null, null, null, null, null, null);
      END IF;
    END IF;
  END;
/
show errors;

CREATE OR REPLACE FUNCTION Formula_Func(query VARCHAR2, indexctx IN SYS.ODCIIndexCtx, 
                                scanctx IN OUT jc_idxtype_im,
                                scanflg IN NUMBER)
RETURN VARCHAR2 AUTHID CURRENT_USER PARALLEL_ENABLE AS
  BEGIN
    jchem_core_pkg.checkTableVersionEx('jc_formula', indexctx);
    
    IF query is null THEN
      IF indexctx.IndexInfo IS NOT NULL THEN
	return jchem_core_pkg.calc_molProp_from_idx(indexctx.Rid, 'molformula', 
				indexctx.IndexInfo.IndexSchema,
				indexctx.IndexInfo.IndexName,
				indexctx.IndexInfo.IndexPartition,
				indexctx.IndexInfo.IndexCols(1).TableSchema,
				indexctx.IndexInfo.IndexCols(1).TableName);
      ELSE 
	return NULL;
      END IF;
    ELSE
      IF indexctx.IndexInfo IS NOT NULL THEN
        return jchem_core_pkg.calc_molProp(
                                query, 'molformula', indexctx.Rid,
				indexctx.IndexInfo.IndexSchema,
				indexctx.IndexInfo.IndexName,
				indexctx.IndexInfo.IndexPartition,
				indexctx.IndexInfo.IndexCols(1).TableSchema,
				indexctx.IndexInfo.IndexCols(1).TableName);
      ELSE
        return jchem_core_pkg.calc_molProp(
                       query, 'molformula', null, 
					   null, null, null, null, null);
      END IF;
    END IF;
  END;
/
show errors;

CREATE OR REPLACE FUNCTION Formula_FuncC(query CLOB, indexctx IN SYS.ODCIIndexCtx, 
                                scanctx IN OUT jc_idxtype_im,
                                scanflg IN NUMBER)
RETURN VARCHAR2 AUTHID CURRENT_USER PARALLEL_ENABLE AS
  BEGIN
    jchem_core_pkg.checkTableVersionEx('jc_formulab', indexctx);
    
    IF query is null THEN
      IF indexctx.IndexInfo IS NOT NULL THEN
	return jchem_core_pkg.calc_molProp_from_idx(indexctx.Rid,
                'molformula', 
				indexctx.IndexInfo.IndexSchema,
				indexctx.IndexInfo.IndexName,
				indexctx.IndexInfo.IndexPartition,
				indexctx.IndexInfo.IndexCols(1).TableSchema,
				indexctx.IndexInfo.IndexCols(1).TableName);
      ELSE 
	return NULL;
      END IF;
    ELSE
      IF indexctx.IndexInfo IS NOT NULL THEN
        return jchem_clob_pkg.get_molformula(
                    query, indexctx.Rid, 
                    indexctx.IndexInfo.IndexSchema,
                    indexctx.IndexInfo.IndexName,
				    indexctx.IndexInfo.IndexPartition,
                    indexctx.IndexInfo.IndexCols(1).TableSchema,
                    indexctx.IndexInfo.IndexCols(1).TableName);
      ELSE
        return jchem_clob_pkg.get_molformula(
                     query, null, null, null, null, null, null);
      END IF;
    END IF;
  END;
/
show errors;

CREATE OR REPLACE FUNCTION Formula_FuncB(query BLOB, indexctx IN SYS.ODCIIndexCtx, 
                                scanctx IN OUT jc_idxtype_im,
                                scanflg IN NUMBER)
RETURN VARCHAR2 AUTHID CURRENT_USER PARALLEL_ENABLE AS
  BEGIN
    jchem_core_pkg.checkTableVersionEx('jc_formulab', indexctx);
    
    IF query is null THEN
      IF indexctx.IndexInfo IS NOT NULL THEN
	return jchem_core_pkg.calc_molProp_from_idx(indexctx.Rid,
                'molformula', 
				indexctx.IndexInfo.IndexSchema,
				indexctx.IndexInfo.IndexName,
				indexctx.IndexInfo.IndexPartition,
				indexctx.IndexInfo.IndexCols(1).TableSchema,
				indexctx.IndexInfo.IndexCols(1).TableName);
      ELSE 
	return NULL;
      END IF;
    ELSE
      IF indexctx.IndexInfo IS NOT NULL THEN
        return jchem_blob_pkg.get_molformula(
                    query, indexctx.Rid, 
                    indexctx.IndexInfo.IndexSchema,
                    indexctx.IndexInfo.IndexName,
				    indexctx.IndexInfo.IndexPartition,
                    indexctx.IndexInfo.IndexCols(1).TableSchema,
                    indexctx.IndexInfo.IndexCols(1).TableName);
      ELSE
        return jchem_blob_pkg.get_molformula(
                     query, null, null, null, null, null, null);
      END IF;
    END IF;
  END;
/
show errors;

CREATE OR REPLACE FUNCTION Molconvert_Func(query VARCHAR2, type VARCHAR2,
                                indexctx IN SYS.ODCIIndexCtx,
                                scanctx IN OUT jc_idxtype_im,
                                scanflg IN NUMBER)
RETURN VARCHAR2 AUTHID CURRENT_USER PARALLEL_ENABLE AS
  BEGIN
    jchem_core_pkg.checkTableVersionEx('jc_molconvert', indexctx);

    IF query is null THEN
      IF indexctx.IndexInfo IS NOT NULL THEN
    return jchem_core_pkg.molconvert_from_idx(
                indexctx.Rid, type,
                indexctx.IndexInfo.IndexSchema,
                indexctx.IndexInfo.IndexName,
				indexctx.IndexInfo.IndexPartition,
                indexctx.IndexInfo.IndexCols(1).TableSchema,
                    indexctx.IndexInfo.IndexCols(1).TableName);
      ELSE
    return NULL;
      END IF;
    ELSE
      IF indexctx.IndexInfo IS NOT NULL THEN
        return jchem_core_pkg.molconvert(
                query, null, type, indexctx.Rid,
                indexctx.IndexInfo.IndexSchema,
                indexctx.IndexInfo.IndexName,
				indexctx.IndexInfo.IndexPartition,
                indexctx.IndexInfo.IndexCols(1).TableSchema,
                    indexctx.IndexInfo.IndexCols(1).TableName);
      ELSE
        return jchem_core_pkg.molconvert(
                    query, null, type, null, null, null, null, null, null);
      END IF;
    END IF;
  END;
/
show errors;

CREATE OR REPLACE FUNCTION MolconvertB_Func(query VARCHAR2, type VARCHAR2,
                                indexctx IN SYS.ODCIIndexCtx,
                                scanctx IN OUT jc_idxtype_im,
                                scanflg IN NUMBER)
RETURN BLOB AUTHID CURRENT_USER PARALLEL_ENABLE AS
  BEGIN
    jchem_core_pkg.checkTableVersionEx('jc_molconvertb', indexctx);

    IF query is null THEN
      IF indexctx.IndexInfo IS NOT NULL THEN
    return jchem_core_pkg.molconvertb_from_idx(
                indexctx.Rid, type,
                indexctx.IndexInfo.IndexSchema,
                indexctx.IndexInfo.IndexName,
				indexctx.IndexInfo.IndexPartition,
                indexctx.IndexInfo.IndexCols(1).TableSchema,
                    indexctx.IndexInfo.IndexCols(1).TableName, null);
      ELSE
    return NULL;
      END IF;
    ELSE
      IF indexctx.IndexInfo IS NOT NULL THEN
        return jchem_core_pkg.molconvertb(
                query, null, type, indexctx.Rid,
                indexctx.IndexInfo.IndexSchema,
                indexctx.IndexInfo.IndexName,
				indexctx.IndexInfo.IndexPartition,
                indexctx.IndexInfo.IndexCols(1).TableSchema,
                    indexctx.IndexInfo.IndexCols(1).TableName, null);
      ELSE
        return jchem_core_pkg.molconvertb(
                    query, null, type, null, null, null, null, null, null, null);
      END IF;
    END IF;
  END;
/
show errors;

CREATE OR REPLACE FUNCTION MolconvertC_FuncC(query CLOB, type VARCHAR2,
                                indexctx IN SYS.ODCIIndexCtx,
                                scanctx IN OUT jc_idxtype_im,
                                scanflg IN NUMBER)
RETURN CLOB AUTHID CURRENT_USER PARALLEL_ENABLE AS
  BEGIN
    jchem_core_pkg.checkTableVersionEx('jc_molconvertbb', indexctx);

    IF query is null THEN
      IF indexctx.IndexInfo IS NOT NULL THEN
        return jchem_clob_pkg.molconvertc_from_idx(
                indexctx.Rid, type,
                indexctx.IndexInfo.IndexSchema,
                indexctx.IndexInfo.IndexName,
				indexctx.IndexInfo.IndexPartition,
                indexctx.IndexInfo.IndexCols(1).TableSchema,
                indexctx.IndexInfo.IndexCols(1).TableName, null);
      ELSE
        return NULL;
      END IF;
    ELSE
      IF indexctx.IndexInfo IS NOT NULL THEN
        return jchem_clob_pkg.molconvertc(
                query, null, type, indexctx.Rid,
                indexctx.IndexInfo.IndexSchema,
                indexctx.IndexInfo.IndexName,
				indexctx.IndexInfo.IndexPartition,
                indexctx.IndexInfo.IndexCols(1).TableSchema,
                    indexctx.IndexInfo.IndexCols(1).TableName, null);
      ELSE
        return jchem_clob_pkg.molconvertc(
                    query, null, type, null, null, null, null, null, null, null);
      END IF;
    END IF;
  END;
/
show errors;

CREATE OR REPLACE FUNCTION MolconvertB_FuncC(query CLOB, type VARCHAR2,
                                indexctx IN SYS.ODCIIndexCtx,
                                scanctx IN OUT jc_idxtype_im,
                                scanflg IN NUMBER)
RETURN BLOB AUTHID CURRENT_USER PARALLEL_ENABLE AS
  BEGIN
    jchem_core_pkg.checkTableVersionEx('jc_molconvertbb', indexctx);

    IF query is null THEN
      IF indexctx.IndexInfo IS NOT NULL THEN
        return jchem_core_pkg.molconvertb_from_idx(
                indexctx.Rid, type,
                indexctx.IndexInfo.IndexSchema,
                indexctx.IndexInfo.IndexName,
				indexctx.IndexInfo.IndexPartition,
                indexctx.IndexInfo.IndexCols(1).TableSchema,
                indexctx.IndexInfo.IndexCols(1).TableName, null);
      ELSE
        return NULL;
      END IF;
    ELSE
      IF indexctx.IndexInfo IS NOT NULL THEN
        return jchem_clob_pkg.molconvertb(
                query, null, type, indexctx.Rid,
                indexctx.IndexInfo.IndexSchema,
                indexctx.IndexInfo.IndexName,
				indexctx.IndexInfo.IndexPartition,
                indexctx.IndexInfo.IndexCols(1).TableSchema,
                    indexctx.IndexInfo.IndexCols(1).TableName, null);
      ELSE
        return jchem_clob_pkg.molconvertb(
                    query, null, type, null, null, null, null, null, null, null);
      END IF;
    END IF;
  END;
/
show errors;

CREATE OR REPLACE FUNCTION MolconvertB_FuncB(query BLOB, type VARCHAR2,
                                indexctx IN SYS.ODCIIndexCtx,
                                scanctx IN OUT jc_idxtype_im,
                                scanflg IN NUMBER)
RETURN BLOB AUTHID CURRENT_USER PARALLEL_ENABLE AS
  BEGIN
    jchem_core_pkg.checkTableVersionEx('jc_molconvertbb', indexctx);

    IF query is null THEN
      IF indexctx.IndexInfo IS NOT NULL THEN
        return jchem_core_pkg.molconvertb_from_idx(
                indexctx.Rid, type,
                indexctx.IndexInfo.IndexSchema,
                indexctx.IndexInfo.IndexName,
				indexctx.IndexInfo.IndexPartition,
                indexctx.IndexInfo.IndexCols(1).TableSchema,
                indexctx.IndexInfo.IndexCols(1).TableName, null);
      ELSE
        return NULL;
      END IF;
    ELSE
      IF indexctx.IndexInfo IS NOT NULL THEN
        return jchem_blob_pkg.molconvertb(
                query, null, type, indexctx.Rid,
                indexctx.IndexInfo.IndexSchema,
                indexctx.IndexInfo.IndexName,
				indexctx.IndexInfo.IndexPartition,
                indexctx.IndexInfo.IndexCols(1).TableSchema,
                    indexctx.IndexInfo.IndexCols(1).TableName, null);
      ELSE
        return jchem_blob_pkg.molconvertb(
                    query, null, type, null, null, null, null, null, null, null);
      END IF;
    END IF;
  END;
/
show errors;

CREATE OR REPLACE FUNCTION Transform_Func(reaction VARCHAR2, reactants VARCHAR2,
                                indexctx IN SYS.ODCIIndexCtx,
                                scanctx IN OUT jc_idxtype_im,
                                scanflg IN NUMBER)
RETURN VARCHAR2 AUTHID CURRENT_USER PARALLEL_ENABLE AS
  BEGIN
    IF reaction IS NULL OR reactants IS NULL THEN
	  return NULL;
    ELSE
        return jchem_core_pkg.react(reaction, reactants, null, null, null,
                      'method:n mappingstyle:d permuteReactants:y', 't');
    END IF;
  END;
/
show errors;

CREATE OR REPLACE FUNCTION React_Func(reaction VARCHAR2, reactants VARCHAR2,
                           options VARCHAR2,
                           indexctx IN SYS.ODCIIndexCtx,
                           scanctx IN OUT jc_idxtype_im,
                           scanflg IN NUMBER)
RETURN VARCHAR2 AUTHID CURRENT_USER PARALLEL_ENABLE AS
  BEGIN
    IF reaction IS NULL OR reactants IS NULL THEN
	  return NULL;
    ELSE
        return jchem_core_pkg.react(reaction, reactants, null, null, null,
                                    options, 't');
    END IF;
  END;
/
show errors;

CREATE OR REPLACE FUNCTION React_FuncB(reaction BLOB, reactants BLOB,
                           options VARCHAR2, indexctx IN SYS.ODCIIndexCtx,
                           scanctx IN OUT jc_idxtype_im, scanflg IN NUMBER)
RETURN BLOB AUTHID CURRENT_USER AS
BEGIN
  IF reaction IS NULL OR reactants IS NULL THEN
    return NULL;
  ELSE
      return jchem_blob_pkg.react(reaction, reactants, null, null, null,
              options, null, null);
  END IF;
END;
/
show errors;

CREATE OR REPLACE FUNCTION React4_Func(reaction VARCHAR2, reactant1 VARCHAR2,
                           reactant2 VARCHAR2, reactant3 VARCHAR2,reactant4
                           VARCHAR2, options VARCHAR2, indexctx IN
                           SYS.ODCIIndexCtx, scanctx IN OUT jc_idxtype_im,
                           scanflg IN NUMBER)
RETURN VARCHAR2 AUTHID CURRENT_USER PARALLEL_ENABLE AS
  BEGIN
    IF reaction IS NULL OR reactant1 IS NULL THEN
	  return NULL;
    ELSE
        return jchem_core_pkg.react(reaction, reactant1, reactant2, reactant3,
                                    reactant4, options, null);
    END IF;
  END;
/
show errors;

CREATE OR REPLACE FUNCTION React4_FuncC(reaction CLOB, reactant1 CLOB,
                           reactant2 CLOB, reactant3 CLOB, reactant4 CLOB,
                           options VARCHAR2, indexctx IN SYS.ODCIIndexCtx,
                           scanctx IN OUT jc_idxtype_im, scanflg IN NUMBER)
RETURN CLOB AUTHID CURRENT_USER AS
BEGIN
  IF reaction IS NULL OR reactant1 IS NULL THEN
    return NULL;
  ELSE
      return jchem_clob_pkg.react(reaction, reactant1, reactant2, reactant3,
              reactant4, options, null,  null);
  END IF;
END;
/
show errors;

CREATE OR REPLACE FUNCTION React4_FuncB(reaction BLOB, reactant1 BLOB,
                           reactant2 BLOB, reactant3 BLOB, reactant4 BLOB,
                           options VARCHAR2, indexctx IN SYS.ODCIIndexCtx,
                           scanctx IN OUT jc_idxtype_im, scanflg IN NUMBER)
RETURN BLOB AUTHID CURRENT_USER AS
BEGIN
  IF reaction IS NULL OR reactant1 IS NULL THEN
    return NULL;
  ELSE
      return jchem_blob_pkg.react(reaction, reactant1, reactant2, reactant3,
              reactant4, options, null,  null);
  END IF;
END;
/
show errors;

CREATE OR REPLACE FUNCTION Standardize_Func(structure VARCHAR2, param VARCHAR2,
                           indexctx IN SYS.ODCIIndexCtx,
                           scanctx IN OUT jc_idxtype_im,
                           scanflg IN NUMBER)
RETURN VARCHAR2 AUTHID CURRENT_USER PARALLEL_ENABLE AS
  BEGIN
    jchem_core_pkg.checkTableVersionEx('jc_standardize', indexctx);

    IF structure IS NULL THEN
        return NULL;
    ELSE
        return jchem_core_pkg.standardize(structure, param);
    END IF;
  END;
/
show errors;

CREATE OR REPLACE FUNCTION Standardize_FuncC(structure CLOB, param VARCHAR2,
                           indexctx IN SYS.ODCIIndexCtx,
                           scanctx IN OUT jc_idxtype_im,
                           scanflg IN NUMBER) RETURN CLOB AUTHID CURRENT_USER AS
  BEGIN
    jchem_core_pkg.checkTableVersionEx('jc_standardizeb', indexctx);

    IF structure IS NULL THEN
        return NULL;
    ELSE
        return jchem_clob_pkg.standardize(structure, param, null);
    END IF;
  END;
/
show errors;

CREATE OR REPLACE FUNCTION Standardize_FuncB(structure BLOB, param VARCHAR2,
                           indexctx IN SYS.ODCIIndexCtx,
                           scanctx IN OUT jc_idxtype_im,
                           scanflg IN NUMBER) RETURN BLOB AUTHID CURRENT_USER AS
  BEGIN
    jchem_core_pkg.checkTableVersionEx('jc_standardizeb', indexctx);

    IF structure IS NULL THEN
        return NULL;
    ELSE
        return jchem_blob_pkg.standardize(structure, param, null);
    END IF;
  END;
/
show errors;

CREATE OR REPLACE FUNCTION Formula_Func_eq(mol VARCHAR2, query VARCHAR2) RETURN NUMBER
    AUTHID CURRENT_USER PARALLEL_ENABLE AS
  BEGIN
    IF mol is null THEN return null; END IF;
    IF query is null THEN return null; END IF;
    IF mol = query THEN 
      RETURN 1;
    ELSE
      RETURN 0;
    END IF;
  END;
/
show errors;

CREATE OR REPLACE FUNCTION Formula_Func_eqC(mol CLOB, query CLOB) RETURN NUMBER
    AUTHID CURRENT_USER PARALLEL_ENABLE AS
  BEGIN
    IF mol is null THEN return null; END IF;
    IF query is null THEN return null; END IF;
    return jchem_clob_pkg.equals(mol, query);
  END;
/
show errors;

CREATE OR REPLACE FUNCTION Formula_Func_eqB(mol BLOB, query BLOB) RETURN NUMBER
    AUTHID CURRENT_USER PARALLEL_ENABLE AS
  BEGIN
    IF mol is null THEN return null; END IF;
    IF query is null THEN return null; END IF;
    return jchem_blob_pkg.equals(mol, query);
  END;
/
show errors;

CREATE OR REPLACE FUNCTION User_Def_Func(name VARCHAR2, delim VARCHAR2, 
				params VARCHAR2) RETURN VARCHAR2 authid current_user AS
  BEGIN
    return jchem_core_pkg.send_user_func(name, delim, params);
  END;
/
show errors;

------------------------
-- CREATE OR REPLACE OPERATORS
------------------------

CREATE OR REPLACE OPERATOR jc_contains BINDING
    (VARCHAR2, VARCHAR2) RETURN NUMBER
      WITH INDEX CONTEXT, SCAN CONTEXT jc_idxtype_im
      USING Contains_Func,
    (CLOB, CLOB) RETURN NUMBER
      WITH INDEX CONTEXT, SCAN CONTEXT jc_idxtype_im
      USING Contains_FuncC,
    (BLOB, BLOB) RETURN NUMBER
      WITH INDEX CONTEXT, SCAN CONTEXT jc_idxtype_im
      USING Contains_FuncB;

CREATE OR REPLACE OPERATOR jc_equals BINDING
    (VARCHAR2, VARCHAR2) RETURN NUMBER 
      WITH INDEX CONTEXT, SCAN CONTEXT jc_idxtype_im
      USING Equals_Func,
    (CLOB, CLOB) RETURN NUMBER 
      WITH INDEX CONTEXT, SCAN CONTEXT jc_idxtype_im
      USING Equals_FuncC,
    (BLOB, BLOB) RETURN NUMBER 
      WITH INDEX CONTEXT, SCAN CONTEXT jc_idxtype_im
      USING Equals_FuncB;

CREATE OR REPLACE OPERATOR jc_compare BINDING
    (VARCHAR2, VARCHAR2, VARCHAR2) RETURN NUMBER 
      WITH INDEX CONTEXT, SCAN CONTEXT jc_idxtype_im
      USING Compare_Func,
    (CLOB, CLOB, VARCHAR2) RETURN NUMBER 
      WITH INDEX CONTEXT, SCAN CONTEXT jc_idxtype_im
      USING Compare_FuncC,
    (CLOB, VARCHAR2, VARCHAR2) RETURN NUMBER 
      WITH INDEX CONTEXT, SCAN CONTEXT jc_idxtype_im
      USING Compare_FuncCV,
    (CLOB, BLOB, VARCHAR2) RETURN NUMBER 
      WITH INDEX CONTEXT, SCAN CONTEXT jc_idxtype_im
      USING Compare_FuncCB,
    (BLOB, BLOB, VARCHAR2) RETURN NUMBER 
      WITH INDEX CONTEXT, SCAN CONTEXT jc_idxtype_im
      USING Compare_FuncB,
    (BLOB, VARCHAR2, VARCHAR2) RETURN NUMBER 
      WITH INDEX CONTEXT, SCAN CONTEXT jc_idxtype_im
      USING Compare_FuncBV;

CREATE OR REPLACE OPERATOR jc_compare_vb BINDING(VARCHAR2, BLOB, VARCHAR2) RETURN NUMBER 
  WITH INDEX CONTEXT, SCAN CONTEXT jc_idxtype_im
  USING compare_func_bquery;

CREATE OR REPLACE OPERATOR jc_evaluate BINDING
    (VARCHAR2, VARCHAR2) RETURN NUMBER 
      WITH INDEX CONTEXT, SCAN CONTEXT jc_idxtype_im
      USING Evaluate_Func,
    (CLOB, VARCHAR2) RETURN NUMBER 
      WITH INDEX CONTEXT, SCAN CONTEXT jc_idxtype_im
      USING Evaluate_FuncC,
    (BLOB, VARCHAR2) RETURN NUMBER 
      WITH INDEX CONTEXT, SCAN CONTEXT jc_idxtype_im
      USING Evaluate_FuncB,
    (VARCHAR2, VARCHAR2, VARCHAR2) RETURN NUMBER 
      WITH INDEX CONTEXT, SCAN CONTEXT jc_idxtype_im
      USING Evaluate3_Func,
    (CLOB, VARCHAR2, VARCHAR2) RETURN NUMBER 
      WITH INDEX CONTEXT, SCAN CONTEXT jc_idxtype_im
      USING Evaluate3_FuncC,
    (BLOB, VARCHAR2, VARCHAR2) RETURN NUMBER 
      WITH INDEX CONTEXT, SCAN CONTEXT jc_idxtype_im
      USING Evaluate3_FuncB;

CREATE OR REPLACE OPERATOR jc_evaluate_x BINDING
    (VARCHAR2, VARCHAR2) RETURN VARCHAR2
      WITH INDEX CONTEXT, SCAN CONTEXT jc_idxtype_im
      USING EvaluateX_Func,
    (CLOB, VARCHAR2) RETURN CLOB
      WITH INDEX CONTEXT, SCAN CONTEXT jc_idxtype_im
      USING EvaluateX_FuncC,
    (BLOB, VARCHAR2) RETURN BLOB
      WITH INDEX CONTEXT, SCAN CONTEXT jc_idxtype_im
      USING EvaluateX_FuncB;

CREATE OR REPLACE OPERATOR jc_matchcount BINDING
    (VARCHAR2, VARCHAR2) RETURN NUMBER 
      WITH INDEX CONTEXT, SCAN CONTEXT jc_idxtype_im
      USING MatchCount_Func,
    (CLOB, CLOB) RETURN NUMBER 
      WITH INDEX CONTEXT, SCAN CONTEXT jc_idxtype_im
      USING MatchCount_FuncC,
    (BLOB, BLOB) RETURN NUMBER 
      WITH INDEX CONTEXT, SCAN CONTEXT jc_idxtype_im
      USING MatchCount_FuncB;

CREATE OR REPLACE OPERATOR jc_tanimoto BINDING
    (VARCHAR2, VARCHAR2)
      RETURN NUMBER WITH INDEX CONTEXT, SCAN CONTEXT jc_idxtype_im 
      USING Tanimoto_Func,
    (CLOB, CLOB)
      RETURN NUMBER WITH INDEX CONTEXT, SCAN CONTEXT jc_idxtype_im 
      USING Tanimoto_FuncC,
    (BLOB, BLOB)
      RETURN NUMBER WITH INDEX CONTEXT, SCAN CONTEXT jc_idxtype_im 
      USING Tanimoto_FuncB;

CREATE OR REPLACE OPERATOR jc_tversky BINDING
    (VARCHAR2, VARCHAR2, NUMBER, NUMBER)
      RETURN NUMBER WITH INDEX CONTEXT, SCAN CONTEXT jc_idxtype_im 
      USING Tversky_Func,
    (CLOB, CLOB, NUMBER, NUMBER)
      RETURN NUMBER WITH INDEX CONTEXT, SCAN CONTEXT jc_idxtype_im 
      USING Tversky_FuncC,
    (BLOB, BLOB, NUMBER, NUMBER)
      RETURN NUMBER WITH INDEX CONTEXT, SCAN CONTEXT jc_idxtype_im 
      USING Tversky_FuncB;

CREATE OR REPLACE OPERATOR jc_dissimilarity BINDING
    (VARCHAR2, VARCHAR2)
      RETURN NUMBER WITH INDEX CONTEXT, SCAN CONTEXT jc_idxtype_im 
      USING Dissimilarity_Func,
    (CLOB, CLOB)
      RETURN NUMBER WITH INDEX CONTEXT, SCAN CONTEXT jc_idxtype_im 
      USING Dissimilarity_FuncC,
    (BLOB, BLOB)
      RETURN NUMBER WITH INDEX CONTEXT, SCAN CONTEXT jc_idxtype_im 
      USING Dissimilarity_FuncB,
    (VARCHAR2, VARCHAR2, VARCHAR2)
      RETURN NUMBER WITH INDEX CONTEXT, SCAN CONTEXT jc_idxtype_im 
      USING DissimilarityX_Func,
    (CLOB, CLOB, VARCHAR2)
      RETURN NUMBER WITH INDEX CONTEXT, SCAN CONTEXT jc_idxtype_im 
      USING DissimilarityX_FuncC,
    (BLOB, BLOB, VARCHAR2)
      RETURN NUMBER WITH INDEX CONTEXT, SCAN CONTEXT jc_idxtype_im 
      USING DissimilarityX_FuncB;


CREATE OR REPLACE OPERATOR jc_molweight BINDING
    (VARCHAR2) RETURN NUMBER
      WITH INDEX CONTEXT, SCAN CONTEXT jc_idxtype_im
      USING Molweight_Func,
    (CLOB) RETURN NUMBER
      WITH INDEX CONTEXT, SCAN CONTEXT jc_idxtype_im
      USING Molweight_FuncC,
    (BLOB) RETURN NUMBER
      WITH INDEX CONTEXT, SCAN CONTEXT jc_idxtype_im
      USING Molweight_FuncB;

CREATE OR REPLACE OPERATOR jc_formula BINDING
    (VARCHAR2) RETURN VARCHAR2
      WITH INDEX CONTEXT, SCAN CONTEXT jc_idxtype_im
      USING Formula_Func,
    (CLOB) RETURN VARCHAR2
      WITH INDEX CONTEXT, SCAN CONTEXT jc_idxtype_im
      USING Formula_FuncC,
    (BLOB) RETURN VARCHAR2
      WITH INDEX CONTEXT, SCAN CONTEXT jc_idxtype_im
      USING Formula_FuncB;

CREATE OR REPLACE OPERATOR jc_molconvert BINDING
    (VARCHAR2, VARCHAR2) RETURN VARCHAR2
  WITH INDEX CONTEXT, SCAN CONTEXT jc_idxtype_im
  USING Molconvert_Func,
    (CLOB, VARCHAR2) RETURN CLOB
  WITH INDEX CONTEXT, SCAN CONTEXT jc_idxtype_im
  USING MolconvertC_FuncC;

CREATE OR REPLACE OPERATOR jc_molconvertb BINDING
    (VARCHAR2, VARCHAR2) RETURN BLOB
      WITH INDEX CONTEXT, SCAN CONTEXT jc_idxtype_im
      USING MolconvertB_Func,
    (CLOB, VARCHAR2) RETURN BLOB
      WITH INDEX CONTEXT, SCAN CONTEXT jc_idxtype_im
      USING MolconvertB_FuncC,
    (BLOB, VARCHAR2) RETURN BLOB
      WITH INDEX CONTEXT, SCAN CONTEXT jc_idxtype_im
      USING MolconvertB_FuncB;

CREATE OR REPLACE OPERATOR jc_formula_eq BINDING
    (VARCHAR2, VARCHAR2) RETURN NUMBER 
        USING Formula_Func_eq,
    (CLOB, CLOB) RETURN NUMBER 
        USING Formula_Func_eqC,
    (BLOB, BLOB) RETURN NUMBER 
        USING Formula_Func_eqb;

CREATE OR REPLACE OPERATOR jc_react BINDING(VARCHAR2, VARCHAR2, VARCHAR2) RETURN VARCHAR2
  WITH INDEX CONTEXT, SCAN CONTEXT jc_idxtype_im
  USING React_Func;

CREATE OR REPLACE OPERATOR jc_react4 BINDING
    (VARCHAR2, VARCHAR2, VARCHAR2, VARCHAR2, VARCHAR2, VARCHAR2) RETURN VARCHAR2
      WITH INDEX CONTEXT, SCAN CONTEXT jc_idxtype_im
      USING React4_Func,
    (CLOB, CLOB, CLOB, CLOB, CLOB, VARCHAR2) RETURN CLOB
      WITH INDEX CONTEXT, SCAN CONTEXT jc_idxtype_im
      USING React4_FuncC,
    (BLOB, BLOB, BLOB, BLOB, BLOB, VARCHAR2) RETURN BLOB
      WITH INDEX CONTEXT, SCAN CONTEXT jc_idxtype_im
      USING React4_FuncB;

CREATE OR REPLACE OPERATOR jc_transform BINDING(VARCHAR2, VARCHAR2) RETURN VARCHAR2
  WITH INDEX CONTEXT, SCAN CONTEXT jc_idxtype_im
  USING Transform_Func;

CREATE OR REPLACE OPERATOR jc_standardize BINDING
    (VARCHAR2, VARCHAR2) RETURN VARCHAR2
      WITH INDEX CONTEXT, SCAN CONTEXT jc_idxtype_im
      USING Standardize_Func,
    (CLOB, VARCHAR2) RETURN CLOB
      WITH INDEX CONTEXT, SCAN CONTEXT jc_idxtype_im
      USING Standardize_FuncC,
    (BLOB, VARCHAR2) RETURN BLOB
      WITH INDEX CONTEXT, SCAN CONTEXT jc_idxtype_im
      USING Standardize_FuncB;

CREATE OR REPLACE FUNCTION User_Def_FuncB(name VARCHAR2, delim VARCHAR2, 
				params BLOB) RETURN BLOB AUTHID CURRENT_USER AS
  BEGIN
    return jchem_blob_pkg.send_user_func(name, delim, params);
  END;
/
show errors;

------------------------
-- CREATE OR REPLACE OPERATORS
------------------------

CREATE OR REPLACE OPERATOR jc_containsb BINDING(BLOB, BLOB) RETURN NUMBER
  WITH INDEX CONTEXT, SCAN CONTEXT jc_idxtype_im
  USING Contains_FuncB;

CREATE OR REPLACE OPERATOR jc_equalsb BINDING(BLOB, BLOB) RETURN NUMBER 
  WITH INDEX CONTEXT, SCAN CONTEXT jc_idxtype_im
  USING Equals_FuncB;

CREATE OR REPLACE OPERATOR jc_compareb BINDING(BLOB, BLOB, VARCHAR2) RETURN NUMBER 
  WITH INDEX CONTEXT, SCAN CONTEXT jc_idxtype_im
  USING Compare_FuncB;

CREATE OR REPLACE OPERATOR jc_evaluateb BINDING(BLOB, VARCHAR2) RETURN NUMBER 
  WITH INDEX CONTEXT, SCAN CONTEXT jc_idxtype_im
  USING Evaluate_FuncB;

CREATE OR REPLACE OPERATOR jc_evaluateb_x BINDING(BLOB, VARCHAR2) RETURN BLOB
  WITH INDEX CONTEXT, SCAN CONTEXT jc_idxtype_im
  USING EvaluateX_FuncB;

CREATE OR REPLACE OPERATOR jc_matchcountb BINDING(BLOB, BLOB) RETURN NUMBER 
  WITH INDEX CONTEXT, SCAN CONTEXT jc_idxtype_im
  USING MatchCount_Funcb;

CREATE OR REPLACE OPERATOR jc_tanimotob BINDING(BLOB, BLOB)
  RETURN NUMBER WITH INDEX CONTEXT, SCAN CONTEXT jc_idxtype_im 
  USING Tanimoto_Funcb;

CREATE OR REPLACE OPERATOR jc_dissimilarityb BINDING(BLOB, BLOB)
  RETURN NUMBER WITH INDEX CONTEXT, SCAN CONTEXT jc_idxtype_im 
  USING Dissimilarity_Funcb;

CREATE OR REPLACE OPERATOR jc_molweightb BINDING(BLOB) RETURN NUMBER
  WITH INDEX CONTEXT, SCAN CONTEXT jc_idxtype_im
  USING Molweight_Funcb;

CREATE OR REPLACE OPERATOR jc_formulab BINDING(BLOB) RETURN VARCHAR2
  WITH INDEX CONTEXT, SCAN CONTEXT jc_idxtype_im
  USING Formula_Funcb;

CREATE OR REPLACE OPERATOR jc_molconvertbb BINDING(BLOB, VARCHAR2) RETURN BLOB
  WITH INDEX CONTEXT, SCAN CONTEXT jc_idxtype_im
  USING MolconvertB_Funcb;

CREATE OR REPLACE OPERATOR jc_formula_eqb BINDING(BLOB, BLOB) RETURN NUMBER 
  USING Formula_Func_eqb;

CREATE OR REPLACE OPERATOR jc_reactb BINDING(BLOB, BLOB, VARCHAR2) RETURN BLOB
  WITH INDEX CONTEXT, SCAN CONTEXT jc_idxtype_im
  USING React_FuncB;

CREATE OR REPLACE OPERATOR jc_reactb4 BINDING(BLOB, BLOB, BLOB, BLOB, BLOB, VARCHAR2) RETURN BLOB
  WITH INDEX CONTEXT, SCAN CONTEXT jc_idxtype_im
  USING React4_FuncB;

CREATE OR REPLACE OPERATOR jc_standardizeb BINDING(BLOB, VARCHAR2) RETURN BLOB
  WITH INDEX CONTEXT, SCAN CONTEXT jc_idxtype_im
  USING Standardize_FuncB;

-------------------------------------------------------------------
-- CREATE INDEXTYPE
-------------------------------------------------------------------

set serveroutput on;
CALL dbms_java.set_output(2000);

CREATE OR REPLACE INDEXTYPE jc_idxtype
FOR
   jc_contains(VARCHAR2, VARCHAR2),
   jc_contains(CLOB, CLOB),
   jc_contains(BLOB, BLOB),
   jc_equals(VARCHAR2, VARCHAR2),
   jc_equals(CLOB, CLOB),
   jc_equals(BLOB, BLOB),
   jc_matchcount(VARCHAR2, VARCHAR2),
   jc_matchcount(CLOB, CLOB),
   jc_matchcount(BLOB, BLOB),
   jc_dissimilarity(VARCHAR2, VARCHAR2),
   jc_dissimilarity(CLOB, CLOB),
   jc_dissimilarity(BLOB, BLOB),
   jc_dissimilarity(VARCHAR2, VARCHAR2, VARCHAR2),
   jc_dissimilarity(CLOB, CLOB, VARCHAR2),
   jc_dissimilarity(BLOB, BLOB, VARCHAR2),
   jc_tanimoto(VARCHAR2, VARCHAR2),
   jc_tanimoto(CLOB, CLOB),
   jc_tanimoto(BLOB, BLOB),
   jc_tversky(VARCHAR2, VARCHAR2, NUMBER, NUMBER),
   jc_tversky(CLOB, CLOB, NUMBER, NUMBER),
   jc_tversky(BLOB, BLOB, NUMBER, NUMBER),
   jc_compare(VARCHAR2, VARCHAR2, VARCHAR2),
   jc_compare(CLOB, VARCHAR2, VARCHAR2),
   jc_compare(CLOB, CLOB, VARCHAR2),
   jc_compare(CLOB, BLOB, VARCHAR2),
   jc_compare(BLOB, BLOB, VARCHAR2),
   jc_compare(BLOB, VARCHAR2, VARCHAR2),
   jc_compare_vb(VARCHAR2, BLOB, VARCHAR2),
   jc_evaluate(VARCHAR2, VARCHAR2),
   jc_evaluate(CLOB, VARCHAR2),
   jc_evaluate(BLOB, VARCHAR2),
   jc_evaluate(VARCHAR2, VARCHAR2, VARCHAR2),
   jc_evaluate(CLOB, VARCHAR2, VARCHAR2),
   jc_evaluate(BLOB, VARCHAR2, VARCHAR2),
   jc_evaluate_x(VARCHAR2, VARCHAR2),
   jc_evaluate_x(CLOB, VARCHAR2),
   jc_evaluate_x(BLOB, VARCHAR2),
   jc_molweight(VARCHAR2),
   jc_molweight(CLOB),
   jc_molweight(BLOB),
   jc_formula(VARCHAR2),
   jc_formula(CLOB),
   jc_formula(BLOB),
   jc_formula_eq(VARCHAR2, VARCHAR2),
   jc_formula_eq(CLOB, CLOB),
   jc_formula_eq(BLOB, BLOB),
   jc_molconvert(VARCHAR2, VARCHAR2),
   jc_molconvert(CLOB, VARCHAR2),
   jc_molconvertb(VARCHAR2, VARCHAR2),
   jc_molconvertb(CLOB, VARCHAR2),
   jc_molconvertb(BLOB, VARCHAR2),
   jc_react(VARCHAR2, VARCHAR2, VARCHAR2),
   jc_react4 (VARCHAR2, VARCHAR2, VARCHAR2, VARCHAR2, VARCHAR2, VARCHAR2),
   jc_react4 (CLOB, CLOB, CLOB, CLOB, CLOB, VARCHAR2),
   jc_react4 (BLOB, BLOB, BLOB, BLOB, BLOB, VARCHAR2),
   jc_standardize(VARCHAR2, VARCHAR2),
   jc_standardize(CLOB, VARCHAR2),
   jc_standardize(BLOB, VARCHAR2),
   jc_transform(VARCHAR2, VARCHAR2),
   jc_containsb(BLOB, BLOB),
   jc_equalsb(BLOB, BLOB),
   jc_matchcountb(BLOB, BLOB),
   jc_dissimilarityb(BLOB, BLOB),
   jc_tanimotob(BLOB, BLOB),
   jc_compareb(BLOB, BLOB, VARCHAR2),
   jc_evaluateb(BLOB, VARCHAR2),
   jc_evaluateb_x(BLOB, VARCHAR2),
   jc_molweightb(BLOB),
   jc_formulab(BLOB),
   jc_formula_eqb(BLOB, BLOB),
   jc_molconvertbb(BLOB, VARCHAR2),
   jc_reactb (BLOB, BLOB, VARCHAR2),
   jc_reactb4 (BLOB, BLOB, BLOB, BLOB, BLOB, VARCHAR2),
   jc_standardizeb(BLOB, VARCHAR2)
USING jc_idxtype_im
WITH LOCAL RANGE PARTITION;


CREATE OR REPLACE FUNCTION jc_insert(str VARCHAR2, table_name VARCHAR2, 
                          jcprop_name VARCHAR2 := '',
                          duplicate_check VARCHAR2 := '',
                          halt_on_error VARCHAR2 := '',
                          options VARCHAR2 := '') RETURN CD_ID_ARRAY
        AUTHID CURRENT_USER AS
  BEGIN
    begin
      return jchem_table_pkg.insert_structure(str, table_name,
          jcprop_name, duplicate_check, halt_on_error, options);
    exception
    when others then
      if sqlcode = -29532 then
        jchem_core_pkg.handle_java_error(sqlerrm);
      else
        raise;
      end if;
    end;
  END;
/
show errors;

CREATE OR REPLACE PROCEDURE jc_update(str VARCHAR2, table_name VARCHAR2,
                           id NUMBER, jcprop_name VARCHAR2 := null,
                           options VARCHAR2 := null)
        AUTHID CURRENT_USER AS
  BEGIN
    jchem_table_pkg.update_structure(str, table_name, id, jcprop_name, options);
  END;
/
show errors;

--
-- Condition is a WHERE clause in the form of "WHERE ..."
--
CREATE OR REPLACE PROCEDURE jc_delete(table_name VARCHAR2, condition VARCHAR2,
                           jcprop_name VARCHAR2 := null) AUTHID CURRENT_USER AS
  BEGIN
    jchem_table_pkg.delete_structure(table_name, condition, jcprop_name);
  END;
/
show errors;

CREATE OR REPLACE FUNCTION jc_insertb(str BLOB, table_name VARCHAR2, 
                          jcprop_name VARCHAR2 := '', duplicate_check VARCHAR2 := '',
                          halt_on_error VARCHAR2 := '', options VARCHAR2 := '')
        RETURN CD_ID_ARRAY AUTHID CURRENT_USER AS
  BEGIN
    begin
      return jchem_table_pkg.insert_structure(str, table_name,
          jcprop_name, duplicate_check, halt_on_error, options);
    exception
    when others then
      if sqlcode = -29532 then
        jchem_core_pkg.handle_java_error(sqlerrm);
      else
        raise;
      end if;
    end;
  END;
/
show errors;

CREATE OR REPLACE PROCEDURE jc_updateB(str BLOB, table_name VARCHAR2,
                           id NUMBER, jcprop_name VARCHAR2 := null,
                           options VARCHAR2 := null) AUTHID CURRENT_USER AS
  BEGIN
    jchem_table_pkg.update_structure(str, table_name, id, jcprop_name, options);
  END;
/
show errors;


create sequence jchem_idxscan_no_sq
/

create sequence jchem_sessionid_sq
/

create or replace procedure testFS2621(dbhost VARCHAR2, dbport NUMBER,
                        dbname VARCHAR2, password VARCHAR2, webappUrl VARCHAR2)
        authid current_user AS
begin
    jchem_core_pkg.set_master_property(null, 'jchem.service.endPoint.url.1', webappUrl);
    jchem_misc_pkg.setDbCallback(dbhost, dbport, dbname);
    jchem_core_pkg.use_password(password);
    
    execute immediate 'create table nci_10k (id number, structure varchar2(4000))';
end;
/
show errors;

create or replace package jcf authid current_user as
    FUNCTION contains(target VARCHAR2, query VARCHAR2)
        RETURN NUMBER PARALLEL_ENABLE;
    FUNCTION contains(target CLOB, query CLOB)
        RETURN NUMBER PARALLEL_ENABLE;
    FUNCTION contains(target BLOB, query BLOB)
        RETURN NUMBER PARALLEL_ENABLE;

    FUNCTION equals(target VARCHAR2, query VARCHAR2)
        RETURN NUMBER PARALLEL_ENABLE;
    FUNCTION equals(target CLOB, query CLOB)
        RETURN NUMBER PARALLEL_ENABLE;
    FUNCTION equals(target BLOB, query BLOB)
        RETURN NUMBER PARALLEL_ENABLE;

    FUNCTION evaluate(target VARCHAR2, filter VARCHAR2)
                            RETURN NUMBER PARALLEL_ENABLE;
    FUNCTION evaluate(target CLOB, filter VARCHAR2)
                            RETURN NUMBER PARALLEL_ENABLE;
    FUNCTION evaluate(target BLOB, filter VARCHAR2)
                            RETURN NUMBER PARALLEL_ENABLE;

    FUNCTION evaluate_x(target VARCHAR2, filter VARCHAR2)
          RETURN VARCHAR2 PARALLEL_ENABLE;
    FUNCTION evaluate_x(target CLOB, filter VARCHAR2, tempClob CLOB := null)
          RETURN CLOB PARALLEL_ENABLE;
    FUNCTION evaluate_x(target BLOB, filter VARCHAR2, tempBlob BLOB := null)
          RETURN BLOB PARALLEL_ENABLE;

    FUNCTION t_evaluate(target VARCHAR2, filter VARCHAR2)
        RETURN COMP_CHAR_ARRAY PARALLEL_ENABLE PIPELINED;
    FUNCTION t_evaluate(target CLOB, filter VARCHAR2)
        RETURN COMP_CLOB_ARRAY PARALLEL_ENABLE PIPELINED;
    FUNCTION t_evaluate(target BLOB, filter VARCHAR2)
        RETURN COMP_BLOB_ARRAY PARALLEL_ENABLE PIPELINED;

    FUNCTION compare(target VARCHAR2, query VARCHAR2, options VARCHAR2)
                RETURN NUMBER PARALLEL_ENABLE;
    FUNCTION compare(target CLOB, query CLOB, options VARCHAR2)
                RETURN NUMBER PARALLEL_ENABLE;
    FUNCTION compare(target CLOB, query VARCHAR2, options VARCHAR2)
                RETURN NUMBER PARALLEL_ENABLE;
    FUNCTION compare(target BLOB, query BLOB, options VARCHAR2)
                RETURN NUMBER PARALLEL_ENABLE;

    FUNCTION compare(target VARCHAR2, query BLOB, options VARCHAR2)
                RETURN NUMBER PARALLEL_ENABLE;

    FUNCTION hitColorAndAlign(tblSchema VARCHAR2, tblName VARCHAR2,
                colName VARCHAR2, query CLOB, rowids VARCHAR2,
                options VARCHAR2, hitColorAndAlignOptions VARCHAR2)
                RETURN COMP_CLOB_ARRAY PARALLEL_ENABLE PIPELINED;
    FUNCTION hitColorAndAlign(tblSchema VARCHAR2, tblName VARCHAR2,
                colName VARCHAR2, query BLOB, rowids VARCHAR2,
                options VARCHAR2, hitColorAndAlignOptions VARCHAR2)
                RETURN COMP_BLOB_ARRAY PARALLEL_ENABLE PIPELINED;

    FUNCTION matchcount(target VARCHAR2, query VARCHAR2)
              RETURN NUMBER PARALLEL_ENABLE;
    FUNCTION matchcount(target CLOB, query CLOB)
              RETURN NUMBER PARALLEL_ENABLE;
    FUNCTION matchcount(target BLOB, query BLOB)
              RETURN NUMBER PARALLEL_ENABLE;

    FUNCTION tanimoto(target VARCHAR2, query VARCHAR2)
              RETURN NUMBER PARALLEL_ENABLE;
    FUNCTION tanimoto(target CLOB, query CLOB)
              RETURN NUMBER PARALLEL_ENABLE;
    FUNCTION tanimoto(target BLOB, query BLOB)
              RETURN NUMBER PARALLEL_ENABLE;

    FUNCTION tversky(target VARCHAR2, query VARCHAR2,
                     targetWeight number, queryWeight number)
              RETURN NUMBER PARALLEL_ENABLE;
    FUNCTION tversky(target CLOB, query CLOB,
                     targetWeight number, queryWeight number)
              RETURN NUMBER PARALLEL_ENABLE;
    FUNCTION tversky(target BLOB, query BLOB,
                     targetWeight number, queryWeight number)
              RETURN NUMBER PARALLEL_ENABLE;

    FUNCTION dissimilarity(target VARCHAR2, query VARCHAR2)
                          RETURN NUMBER PARALLEL_ENABLE;
    FUNCTION dissimilarity(target CLOB, query CLOB)
                          RETURN NUMBER PARALLEL_ENABLE;
    FUNCTION dissimilarity(target BLOB, query BLOB)
                          RETURN NUMBER PARALLEL_ENABLE;

    FUNCTION molweight(query VARCHAR2)
                        RETURN NUMBER PARALLEL_ENABLE;
    FUNCTION molweight(query CLOB)
                        RETURN NUMBER PARALLEL_ENABLE;
    FUNCTION molweight(query BLOB)
                        RETURN NUMBER PARALLEL_ENABLE;

    FUNCTION formula(query VARCHAR2)
                RETURN VARCHAR2 PARALLEL_ENABLE;
    FUNCTION formula(query CLOB)
                RETURN VARCHAR2 PARALLEL_ENABLE;
    FUNCTION formula(query BLOB)
                RETURN VARCHAR2 PARALLEL_ENABLE;

    FUNCTION molconvert(query VARCHAR2, type VARCHAR2)
                RETURN VARCHAR2 PARALLEL_ENABLE;
    FUNCTION molconvert(query CLOB, type VARCHAR2)
                RETURN CLOB PARALLEL_ENABLE;

    FUNCTION molconvert(query VARCHAR2, inputFormat VARCHAR2, type VARCHAR2)
                RETURN VARCHAR2 PARALLEL_ENABLE;
    FUNCTION molconvert(query CLOB, inputFormat VARCHAR2, type VARCHAR2)
                RETURN CLOB PARALLEL_ENABLE;

    FUNCTION molconvertb(query VARCHAR2, type VARCHAR2, tmpBlob BLOB := null)
                RETURN BLOB PARALLEL_ENABLE;
    FUNCTION molconvertb(query CLOB, type VARCHAR2, tmpBlob BLOB := null)
                RETURN BLOB PARALLEL_ENABLE;
    FUNCTION molconvertb(query BLOB, type VARCHAR2, tmpBlob BLOB := null)
                RETURN BLOB PARALLEL_ENABLE;

    FUNCTION molconvertb(query VARCHAR2, inputFormat VARCHAR2, type VARCHAR2,
                         tmpBlob BLOB := null) RETURN BLOB PARALLEL_ENABLE;
    FUNCTION molconvertb(query CLOB, inputFormat VARCHAR2, type VARCHAR2,
                          tmpBlob BLOB := null) RETURN BLOB PARALLEL_ENABLE;
    FUNCTION molconvertb(query BLOB, inputFormat VARCHAR2, type VARCHAR2,
                          tmpBlob BLOB := null) RETURN BLOB PARALLEL_ENABLE;

    FUNCTION transform(reaction VARCHAR2, reactants VARCHAR2)
              RETURN VARCHAR2 PARALLEL_ENABLE;

    FUNCTION react(reaction VARCHAR2, reactants VARCHAR2,
                             options VARCHAR2)
           RETURN VARCHAR2 PARALLEL_ENABLE;

    FUNCTION react4(reaction VARCHAR2, reactant1 VARCHAR2,
                reactant2 VARCHAR2, reactant3 VARCHAR2, reactant4 VARCHAR2,
                options VARCHAR2)
        RETURN VARCHAR2 PARALLEL_ENABLE;
    FUNCTION react4(reaction CLOB, reactant1 CLOB, reactant2 CLOB,
                    reactant3 CLOB, reactant4 CLOB, options VARCHAR2,
                    tempClob CLOB := null)
        RETURN CLOB PARALLEL_ENABLE;
    FUNCTION react4(reaction BLOB, reactant1 BLOB, reactant2 BLOB,
                    reactant3 BLOB, reactant4 BLOB, options VARCHAR2,
                    tempBlob BLOB := null)
        RETURN BLOB PARALLEL_ENABLE;

    FUNCTION t_react4(reaction VARCHAR2, reactant1 VARCHAR2, reactant2
                      VARCHAR2, reactant3 VARCHAR2, reactant4 VARCHAR2,
                      options VARCHAR2)
        RETURN CHAR_PRODUCT_ARRAY PARALLEL_ENABLE PIPELINED;
    FUNCTION t_react4(reaction CLOB, reactant1 CLOB, reactant2 CLOB, reactant3
                      CLOB, reactant4 CLOB, options VARCHAR2)
        RETURN CLOB_PRODUCT_ARRAY PARALLEL_ENABLE PIPELINED;
    FUNCTION t_react4(reaction BLOB, reactant1 BLOB, reactant2 BLOB, reactant3
                      BLOB, reactant4 BLOB, options VARCHAR2)
        RETURN BLOB_PRODUCT_ARRAY PARALLEL_ENABLE PIPELINED;

    FUNCTION standardize(structure VARCHAR2, param VARCHAR2)
           RETURN VARCHAR2 PARALLEL_ENABLE;
    FUNCTION standardize(structure CLOB, param VARCHAR2, tempClob CLOB := null)
           RETURN CLOB PARALLEL_ENABLE;
    FUNCTION standardize(structure BLOB, param VARCHAR2, tempBlob BLOB := null)
           RETURN BLOB PARALLEL_ENABLE;

    FUNCTION formula_eq(mol VARCHAR2, query VARCHAR2) RETURN NUMBER
      PARALLEL_ENABLE;
    FUNCTION formula_eq(mol CLOB, query CLOB) RETURN NUMBER
      PARALLEL_ENABLE;
    FUNCTION formula_eq(mol BLOB, query BLOB) RETURN NUMBER
      PARALLEL_ENABLE;

    function exec_v(options in varchar2, execPath in varchar2, param1 in
                    varchar2, param2 in varchar2) return varchar2
      as language java name
        'chemaxon.jchem.cartridge.JFunctions.exec(java.lang.String,
        java.lang.String, java.lang.String, java.lang.String)
        return java.lang.String';

  function t_get_gmem_util return gmem_util_array pipelined;

  function t_get_taskinfo return taskinfo_array pipelined;

end jcf;
/
show errors

create or replace package body jcf as 
  FUNCTION contains(target VARCHAR2, query VARCHAR2)
      RETURN NUMBER AS
    error varchar2(32767);
    result varchar2(32767);
  BEGIN
    IF query is null or target is null THEN 
      return null; 
    END IF;
      error := jchem_core_pkg.exec_function('contains', target, query,
                           null, null, null, null, null, null, null, null,
                           result);
    if error is null then
      return result;
    else
      jchem_core_pkg.handle_java_error(error);
    end if;
  END;

  FUNCTION contains(target CLOB, query CLOB)
      RETURN NUMBER PARALLEL_ENABLE AS
    error varchar2(32767);
    result varchar2(32767);
  BEGIN
    IF query is null or target is null THEN 
      return null; 
    END IF;
      error := jchem_clob_pkg.exec_function('contains', target, query,
                           null, null, null, null, null, null, null, null,
                           result);
    if error is null then
      return result;
    else
      jchem_core_pkg.handle_java_error(error);
    end if;
  END;

  FUNCTION contains(target BLOB, query BLOB)
      RETURN NUMBER PARALLEL_ENABLE AS
    error varchar2(32767);
    result varchar2(32767);
  BEGIN
    IF query is null or target is null THEN 
      return null; 
    END IF;
      error := jchem_blob_pkg.exec_function('contains', target, query,
                       null, null, null, null, null, null, null, null,
                       result);
    if error is null then
      return result;
    else
      jchem_core_pkg.handle_java_error(error);
    end if;
  END;

  FUNCTION equals(target VARCHAR2, query VARCHAR2)
      RETURN NUMBER PARALLEL_ENABLE AS
    error varchar2(32767);
    result varchar2(32767);
  BEGIN
    IF query is null or target is null THEN 
      return null; 
    END IF;
      error := jchem_core_pkg.exec_function('equals', target, query,
                       null, null, null, null, null, null, null, null,
                       result);
    if error is null then
      return result;
    else
      jchem_core_pkg.handle_java_error(error);
    end if;
  END;

  FUNCTION equals(target CLOB, query CLOB)
      RETURN NUMBER PARALLEL_ENABLE AS
    error varchar2(32767);
    result varchar2(32767);
  BEGIN
    IF query is null or target is null THEN 
      return null; 
    END IF;
      error := jchem_clob_pkg.exec_function('equals', target, query,
                       null, null, null, null, null, null, null, null,
                       result);
    if error is null then
      return result;
    else
      jchem_core_pkg.handle_java_error(error);
    end if;
  END;

  FUNCTION equals(target BLOB, query BLOB)
      RETURN NUMBER PARALLEL_ENABLE AS
    error varchar2(32767);
    result varchar2(32767);
  BEGIN
    IF query is null or target is null THEN 
      return null; 
    END IF;
      error := jchem_blob_pkg.exec_function('equals', target, query,
                       null, null, null, null, null, null, null, null,
                       result);
    if error is null then
      return result;
    else
      jchem_core_pkg.handle_java_error(error);
    end if;
  END;

  FUNCTION evaluate(target VARCHAR2, filter VARCHAR2)
                          RETURN NUMBER PARALLEL_ENABLE AS
    error varchar2(32767);
    result varchar2(32767);
  BEGIN
    IF target is null THEN 
      return null; 
    END IF;
    error := jchem_core_pkg.exec_function('evaluate', target, null,
                       filter, null, null, null, null, null, null, null,
                       result);
    if error is null then
      return result;
    else
      jchem_core_pkg.handle_java_error(error);
    end if;
  END;

  FUNCTION evaluate(target CLOB, filter VARCHAR2)
        RETURN NUMBER PARALLEL_ENABLE AS
    error varchar2(32767);
    result varchar2(32767);
  BEGIN
    IF target is null THEN 
      return null; 
    END IF;
      error := jchem_clob_pkg.exec_function('evaluate', target, null,
                       filter, null, null, null, null, null, null, null,
                       result);
    if error is null then
      return result;
    else
      jchem_core_pkg.handle_java_error(error);
    end if;
  END;

  FUNCTION evaluate(target BLOB, filter VARCHAR2)
        RETURN NUMBER PARALLEL_ENABLE AS
    error varchar2(32767);
    result varchar2(32767);
  BEGIN
    IF target is null THEN 
      return null; 
    END IF;
      error := jchem_blob_pkg.exec_function('evaluate', target, null,
                      filter, null, null, null, null, null, null, null,
                      result);
    if error is null then
      return result;
    else
      jchem_core_pkg.handle_java_error(error);
    end if;
  END;

  FUNCTION evaluate_x(target VARCHAR2, filter VARCHAR2)
        RETURN VARCHAR2 PARALLEL_ENABLE AS
    error varchar2(32767);
    result varchar2(32767);
  BEGIN
    IF target is null THEN 
      return null; 
    END IF;
    error := jchem_core_pkg.exec_function('evaluate_x', target, null,
                      filter, null, null, null, null, null, null, null,
                      result);
    if error is null then
      return result;
    else
      jchem_core_pkg.handle_java_error(error);
    end if;
  END;

  FUNCTION evaluate_x(target CLOB, filter VARCHAR2,
        tempClob CLOB) RETURN CLOB PARALLEL_ENABLE AS
    error varchar2(32767);
    result CLOB;
  BEGIN
    IF target is null THEN 
      return null; 
    END IF;
      error := jchem_clob_pkg.exec_function__c('evaluate_x', target, null,
                      filter, null, null, null, null, null, null, null,
                      result);
    if error is null then
      return result;
    else
      jchem_core_pkg.handle_java_error(error);
    end if;
  END;

  FUNCTION evaluate_x(target BLOB, filter VARCHAR2, tempBlob BLOB)
          RETURN BLOB PARALLEL_ENABLE AS
    error varchar2(32767);
    result BLOB;
  BEGIN
    IF target is null THEN 
      return null; 
    END IF;
      error := jchem_blob_pkg.exec_function__b('evaluate_x', target, null,
                      filter, null, null, null, null, null, null, null,
                      result);
    if error is null then
      return result;
    else
      jchem_core_pkg.handle_java_error(error);
    end if;
  END;

  FUNCTION t_evaluate(target VARCHAR2, filter VARCHAR2)
      RETURN COMP_CHAR_ARRAY PARALLEL_ENABLE PIPELINED AS
        chararr CHAR_ARRAY;
  BEGIN
    IF target is null or filter is null THEN 
      return; 
    END IF;

    chararr := jchem_core_pkg.evaluate_arr(target, filter, null,
                              null, null, null, null, null);
    for i in 1..chararr.count loop
      pipe row(COMPOSITE_CHAR(chararr(i)));
    end loop;

    return;
  END;

  FUNCTION t_evaluate(target CLOB, filter VARCHAR2)
          RETURN COMP_CLOB_ARRAY PARALLEL_ENABLE PIPELINED AS
      clobarr CLOB_ARRAY;
  BEGIN
      IF target is null or filter is null THEN 
        return;
      END IF;

      clobarr := jchem_clob_pkg.evaluate_arr(target, filter,
                      null, null, null, null, null, null);
      for i in 1..clobarr.count loop
        pipe row(COMPOSITE_CLOB(clobarr(i)));
      end loop;
    
      return;
  END;

  FUNCTION t_evaluate(target BLOB, filter VARCHAR2)
          RETURN COMP_BLOB_ARRAY PARALLEL_ENABLE PIPELINED AS
      blobarr BLOB_ARRAY;
  BEGIN
      IF target is null or filter is null THEN 
        return;
      END IF;

      blobarr := jchem_blob_pkg.evaluate_arr(target, filter,
                      null, null, null, null, null, null);
      for i in 1..blobarr.count loop
        pipe row(COMPOSITE_BLOB(blobarr(i)));
      end loop;
    
      return;
  END;

  FUNCTION compare(target VARCHAR2, query VARCHAR2, options VARCHAR2)
              RETURN NUMBER PARALLEL_ENABLE AS
    error varchar2(32767);
    result varchar2(32767);
  BEGIN
    IF query is null or target is null THEN 
      return null; 
    END IF;
    error := jchem_core_pkg.exec_function('compare', target, query, options,
                                    null, null, null, null, null, null, null,
                                    result);
    if error is null then
      return result;
    else
      jchem_core_pkg.handle_java_error(error);
    end if;
  END;

  FUNCTION compare(target CLOB, query CLOB, options VARCHAR2)
      RETURN NUMBER PARALLEL_ENABLE AS
    error varchar2(32767);
    result varchar2(32767);
  BEGIN
    IF query is null or target is null THEN 
      return null; 
    END IF;
    error := jchem_clob_pkg.exec_function('compare', target, query, options,
                                    null, null, null, null, null, null, null,
                                    result);
    if error is null then
      return result;
    else
      jchem_core_pkg.handle_java_error(error);
    end if;
  END;

  FUNCTION compare(target CLOB, query VARCHAR2, options VARCHAR2)
      RETURN NUMBER PARALLEL_ENABLE AS
    error varchar2(32767);
    result varchar2(32767);
  BEGIN
    IF query is null or target is null THEN 
      return null; 
    END IF;
    error := jchem_clob_pkg.exec_function_cv('compare', target, query, options,
                                    null, null, null, null, null, null, null,
                                    result);
    if error is null then
      return result;
    else
      jchem_core_pkg.handle_java_error(error);
    end if;
  END;

  FUNCTION compare(target CLOB, query BLOB, options VARCHAR2)
      RETURN NUMBER PARALLEL_ENABLE AS
    error varchar2(32767);
    result varchar2(32767);
  BEGIN
    IF query is null or target is null THEN 
      return null; 
    END IF;
    error := jchem_clob_pkg.exec_function_cb('compare', target, query, options,
                                    null, null, null, null, null, null, null,
                                    result);
    if error is null then
      return result;
    else
      jchem_core_pkg.handle_java_error(error);
    end if;
  END;

  FUNCTION compare(target BLOB, query BLOB, options VARCHAR2)
      RETURN NUMBER PARALLEL_ENABLE AS
    error varchar2(32767);
    result varchar2(32767);
  BEGIN
    IF query is null or target is null THEN 
      return null; 
    END IF;
    error := jchem_blob_pkg.exec_function('compare', target, query, options,
                                    null, null, null, null, null, null, null,
                                    result);
    if error is null then
      return result;
    else
      jchem_core_pkg.handle_java_error(error);
    end if;
  END;

  FUNCTION compare(target VARCHAR2, query BLOB, options VARCHAR2)
              RETURN NUMBER PARALLEL_ENABLE AS
    error varchar2(32767);
    result varchar2(32767);
  BEGIN
    IF query is null or target is null THEN 
        return null; 
    END IF;
    error := jchem_blob_pkg.exec_function_vb('compare', target, query, options,
                                    null, null, null, null, null, null, null,
                                    result);
    if error is null then
      return result;
    else
      jchem_core_pkg.handle_java_error(error);
    end if;
  END;

  FUNCTION hitColorAndAlign(tblSchema VARCHAR2, tblName VARCHAR2,
              colName VARCHAR2, query CLOB, rowids VARCHAR2,
              options VARCHAR2, hitColorAndAlignOptions VARCHAR2)
              RETURN COMP_CLOB_ARRAY PARALLEL_ENABLE PIPELINED AS
    clobarr CLOB_ARRAY;
  BEGIN
    IF query is null THEN 
      return; 
    END IF;

    clobarr := jchem_clob_pkg.hitColorAndAlign(tblSchema, tblName,
                  colName, query, rowids, options, hitColorAndAlignOptions);

    for i in 1..clobarr.count loop
      pipe row(COMPOSITE_CLOB(clobarr(i)));
    end loop;

    return;
  END;

  FUNCTION hitColorAndAlign(tblSchema VARCHAR2, tblName VARCHAR2,
              colName VARCHAR2, query BLOB, rowids VARCHAR2,
              options VARCHAR2, hitColorAndAlignOptions VARCHAR2)
              RETURN COMP_BLOB_ARRAY PARALLEL_ENABLE PIPELINED AS
    blobarr BLOB_ARRAY;
  BEGIN
    IF query is null THEN 
      return; 
    END IF;

    blobarr := jchem_blob_pkg.hitColorAndAlign(tblSchema, tblName,
                  colName, query, rowids, options, hitColorAndAlignOptions);

    for i in 1..blobarr.count loop
      pipe row(COMPOSITE_BLOB(blobarr(i)));
    end loop;

    return;
  END;


  FUNCTION matchcount(target VARCHAR2, query VARCHAR2)
            RETURN NUMBER PARALLEL_ENABLE AS
    error varchar2(32767);
    result varchar2(32767);
  BEGIN
    IF query is null or target is null THEN 
      return null; 
    END IF;
    error := jchem_core_pkg.exec_function('matchcount', target, query, null,
                                    null, null, null, null, null, null, null,
                                    result);
    if error is null then
      return result;
    else
      jchem_core_pkg.handle_java_error(error);
    end if;
  END;

  FUNCTION matchcount(target CLOB, query CLOB) RETURN NUMBER PARALLEL_ENABLE AS
    error varchar2(32767);
    result varchar2(32767);
  BEGIN
    IF query is null or target is null THEN 
      return null; 
    END IF;
    error := jchem_clob_pkg.exec_function('matchcount', target, query, null,
                                    null, null, null, null, null, null, null,
                                    result);
    if error is null then
      return result;
    else
      jchem_core_pkg.handle_java_error(error);
    end if;
  END;

  FUNCTION matchcount(target BLOB, query BLOB) RETURN NUMBER PARALLEL_ENABLE AS
    error varchar2(32767);
    result varchar2(32767);
  BEGIN
    IF query is null or target is null THEN 
      return null; 
    END IF;
    error := jchem_blob_pkg.exec_function('matchcount', target, query, null,
                                    null, null, null, null, null, null, null,
                                    result);
    if error is null then
      return result;
    else
      jchem_core_pkg.handle_java_error(error);
    end if;
  END;

  FUNCTION tanimoto(target VARCHAR2, query VARCHAR2)
            RETURN NUMBER PARALLEL_ENABLE AS
    error varchar2(32767);
    result varchar2(32767);
  BEGIN
    IF query is null or target is null THEN 
      return null; 
    END IF;
    error := jchem_core_pkg.exec_function('similarity', target, query,
                                    'dissimilarityMetric:tanimoto',
                                    null, null, null, null, null, null, null,
                                    result);
    if error is null then
      return result;
    else
      jchem_core_pkg.handle_java_error(error);
    end if;
  END;

  FUNCTION tanimoto(target CLOB, query CLOB) RETURN NUMBER PARALLEL_ENABLE AS
    error varchar2(32767);
    result varchar2(32767);
  BEGIN
    IF query is null or target is null THEN 
      return null; 
    END IF;
    error := jchem_clob_pkg.exec_function('similarity', target, query,
                                    null, 'dissimilarityMetric:tanimoto',
                                    null, null, null, null, null, null,
                                    result);
    if error is null then
      return result;
    else
      jchem_core_pkg.handle_java_error(error);
    end if;
  END;

  FUNCTION tanimoto(target BLOB, query BLOB) RETURN NUMBER PARALLEL_ENABLE AS
    error varchar2(32767);
    result varchar2(32767);
  BEGIN
    IF query is null or target is null THEN 
      return null; 
    END IF;
    error := jchem_blob_pkg.exec_function('similarity', target, query,
                                    'dissimilarityMetric:tanimoto',
                                    null, null, null, null, null, null, null,
                                    result);
    if error is null then
      return result;
    else
      jchem_core_pkg.handle_java_error(error);
    end if;
  END;

  FUNCTION tversky(target VARCHAR2, query VARCHAR2, targetWeight number, queryWeight number)
            RETURN NUMBER PARALLEL_ENABLE AS
    error varchar2(32767);
    result varchar2(32767);
  BEGIN
    IF query is null or target is null THEN 
      return null; 
    END IF;
    error := jchem_core_pkg.exec_function('similarity', target, query,
                              'tversky'
                              || jchem_core_pkg.simCalcSeparator 
                              || targetWeight || jchem_core_pkg.simCalcSeparator || queryWeight,
                              null, null, null, null, null, null, null,
                              result);
    if error is null then
      return result;
    else
      jchem_core_pkg.handle_java_error(error);
    end if;
  END;

  FUNCTION tversky(target CLOB, query CLOB, targetWeight number, queryWeight number)
            RETURN NUMBER PARALLEL_ENABLE AS
    error varchar2(32767);
    result varchar2(32767);
  BEGIN
    IF query is null or target is null THEN 
      return null; 
    END IF;
    error := jchem_clob_pkg.exec_function('similarity', target, query,
                              'tversky'
                              || jchem_core_pkg.simCalcSeparator 
                              || targetWeight || jchem_core_pkg.simCalcSeparator || queryWeight,
                              null, null, null, null, null, null, null,
                              result);
    if error is null then
      return result;
    else
      jchem_core_pkg.handle_java_error(error);
    end if;
  END;

  FUNCTION tversky(target BLOB, query BLOB, targetWeight number, queryWeight number)
            RETURN NUMBER PARALLEL_ENABLE AS
    error varchar2(32767);
    result varchar2(32767);
  BEGIN
    IF query is null or target is null THEN 
      return null; 
    END IF;
    error := jchem_blob_pkg.exec_function('similarity', target, query,
                              'tversky'
                              || jchem_core_pkg.simCalcSeparator 
                              || targetWeight || jchem_core_pkg.simCalcSeparator || queryWeight,
                              null, null, null, null, null, null, null,
                              result);
    if error is null then
      return result;
    else
      jchem_core_pkg.handle_java_error(error);
    end if;
  END;

  FUNCTION dissimilarity(target VARCHAR2, query VARCHAR2)
                        RETURN NUMBER PARALLEL_ENABLE AS 
    error varchar2(32767);
    result varchar2(32767);
  BEGIN
    IF query is null or target is null THEN 
      return null; 
    END IF;
    error := jchem_core_pkg.exec_function('dissimilarity', target, query,
                              null, null, null, null, null, null, null, null,
                              result);
    if error is null then
      return result;
    else
      jchem_core_pkg.handle_java_error(error);
    end if;
  END;

  FUNCTION dissimilarity(target CLOB, query CLOB) RETURN NUMBER PARALLEL_ENABLE AS 
    error varchar2(32767);
    result varchar2(32767);
  BEGIN
    IF query is null or target is null THEN 
      return null; 
    END IF;
    error := jchem_clob_pkg.exec_function('dissimilarity', target, query,
                              null, null, null, null, null, null, null, null,
                              result);
    if error is null then
      return result;
    else
      jchem_core_pkg.handle_java_error(error);
    end if;
  END;

  FUNCTION dissimilarity(target BLOB, query BLOB) RETURN NUMBER PARALLEL_ENABLE AS 
      res VARCHAR2(32767);
    error varchar2(32767);
    result varchar2(32767);
  BEGIN
    IF query is null or target is null THEN 
      return null; 
    END IF;
    error := jchem_blob_pkg.exec_function('dissimilarity', target, query,
                              null, null, null, null, null, null, null, null,
                              result);
    if error is null then
      return result;
    else
      jchem_core_pkg.handle_java_error(error);
    end if;
  END;

  FUNCTION molweight(query VARCHAR2) RETURN NUMBER PARALLEL_ENABLE AS
  BEGIN
    IF query is null THEN 
      return null; 
    END IF;
    return jchem_core_pkg.calc_molProp(query, 'molweight', null, null,
                                              null, null, null, null);
  END;

  FUNCTION molweight(query CLOB) RETURN NUMBER PARALLEL_ENABLE AS
  BEGIN
    IF query is null THEN 
      return null; 
    END IF;
    return jchem_clob_pkg.get_molweight(
        query, null, null, null, null, null, null);
  END;

  FUNCTION molweight(query BLOB) RETURN NUMBER PARALLEL_ENABLE AS
  BEGIN
    IF query is null THEN 
      return null; 
    END IF;
    return jchem_blob_pkg.get_molweight(
        query, null, null, null, null, null, null);
  END;

  FUNCTION formula(query VARCHAR2)
              RETURN VARCHAR2 PARALLEL_ENABLE AS
  BEGIN
    IF query is null THEN 
      return null; 
    END IF;
    return jchem_core_pkg.calc_molProp(query, 'molformula', null, 
                                       null, null, null, null, null);
  END;

  FUNCTION formula(query CLOB) RETURN VARCHAR2 PARALLEL_ENABLE AS
  BEGIN
      IF query is null THEN 
        return null; 
      END IF;
      return jchem_clob_pkg.get_molformula(query,
              null, null, null, null, null, null);
  END;

  FUNCTION formula(query BLOB) RETURN VARCHAR2 PARALLEL_ENABLE AS
  BEGIN
      IF query is null THEN 
        return null; 
      END IF;
      return jchem_blob_pkg.get_molformula(query,
              null, null, null, null, null, null);
  END;

  FUNCTION molconvert(query VARCHAR2, type VARCHAR2)
              RETURN VARCHAR2 PARALLEL_ENABLE AS
  BEGIN
      return molconvert(query, null, type);
  END;

  FUNCTION molconvert(query CLOB, type VARCHAR2)
          RETURN CLOB PARALLEL_ENABLE AS
  BEGIN
      return molconvert(query, null, type);
  END;

  FUNCTION molconvert(query VARCHAR2, inputFormat VARCHAR2, type VARCHAR2)
              RETURN VARCHAR2 PARALLEL_ENABLE AS
  BEGIN
      IF query is null THEN
          return null; 
      END IF;
      return jchem_core_pkg.molconvert(query, inputFormat, type, null,
                          null, null, null, null, null);
  END;

  FUNCTION molconvert(query CLOB, inputFormat VARCHAR2, type VARCHAR2)
          RETURN CLOB PARALLEL_ENABLE AS
  BEGIN
      IF query is null THEN
          return null; 
      END IF;
      return jchem_clob_pkg.molconvertc(query, inputFormat, type, null,
                          null, null, null, null, null, null);
  END;

  FUNCTION molconvertb(query VARCHAR2, type VARCHAR2, tmpBlob BLOB := null)
              RETURN BLOB PARALLEL_ENABLE AS
  BEGIN
    return molconvertb(query, null, type, tmpBlob);
  END;

  FUNCTION molconvertb(query CLOB, type VARCHAR2, tmpBlob BLOB := null)
        RETURN BLOB PARALLEL_ENABLE AS
  BEGIN
    return molconvertb(query, null, type, tmpBlob);
  END;

  FUNCTION molconvertb(query BLOB, type VARCHAR2, tmpBlob BLOB := null)
        RETURN BLOB PARALLEL_ENABLE AS
  BEGIN
    return molconvertb(query, null, type, tmpBlob);
  END;

  FUNCTION molconvertb(query VARCHAR2, inputFormat VARCHAR2, type VARCHAR2, tmpBlob BLOB := null)
              RETURN BLOB PARALLEL_ENABLE AS
  BEGIN
    IF query is null THEN
        return NULL;
    END IF;
    return jchem_core_pkg.molconvertb(
          query, inputFormat, type, null, null, null, null, null, null, tmpBlob);
  END;

  FUNCTION molconvertb(query CLOB, inputFormat VARCHAR2, type VARCHAR2, tmpBlob BLOB := null)
        RETURN BLOB PARALLEL_ENABLE AS
  BEGIN
      IF query is null THEN
          return NULL;
      END IF;
      return jchem_clob_pkg.molconvertb(
          query, inputFormat, type, null, null, null, null, null, null, tmpBlob);
  END;


  FUNCTION molconvertb(query BLOB, inputFormat VARCHAR2, type VARCHAR2, tmpBlob BLOB := null)
        RETURN BLOB PARALLEL_ENABLE AS
  BEGIN
      IF query is null THEN
          return NULL;
      END IF;
      return jchem_blob_pkg.molconvertb(
          query, inputFormat, type, null, null, null, null, null, null, tmpBlob);
  END;

  FUNCTION transform(reaction VARCHAR2, reactants VARCHAR2)
            RETURN VARCHAR2 PARALLEL_ENABLE AS
  BEGIN
      IF reaction IS NULL OR reactants IS NULL THEN
          return NULL;
      ELSE
          return jchem_core_pkg.react(reaction, reactants, null, null, null,
                              'method:n mappingstyle:d permuteReactants:y', 't');
      END IF;
  END;

  FUNCTION react(reaction VARCHAR2, reactants VARCHAR2,
                           options VARCHAR2)
         RETURN VARCHAR2 PARALLEL_ENABLE AS
  BEGIN
    IF reaction IS NULL OR reactants IS NULL THEN
      return NULL;
    ELSE
        return jchem_core_pkg.react(reaction, reactants, null, null, null,
                                    options, 't');
    END IF;
  END;

  FUNCTION react4(reaction VARCHAR2, reactant1 VARCHAR2,
              reactant2 VARCHAR2, reactant3 VARCHAR2, reactant4 VARCHAR2,
              options VARCHAR2)
      RETURN VARCHAR2 PARALLEL_ENABLE AS
  BEGIN
      IF reaction IS NULL OR reactant1 IS NULL THEN
            return NULL;
      ELSE
          return jchem_core_pkg.react(reaction, reactant1, reactant2, reactant3,
                reactant4, options, null);
      END IF;
  END;

  FUNCTION react4(reaction CLOB, reactant1 CLOB, reactant2 CLOB,
                  reactant3 CLOB, reactant4 CLOB, options VARCHAR2,
                  tempClob CLOB)
      RETURN CLOB PARALLEL_ENABLE AS
  BEGIN
      IF reaction IS NULL OR reactant1 IS NULL THEN
            return NULL;
      ELSE
          return jchem_clob_pkg.react(reaction, reactant1, reactant2,
                          reactant3, reactant4, options, tempClob, null);
      END IF;
  END;

  FUNCTION react4(reaction BLOB, reactant1 BLOB, reactant2 BLOB, reactant3
              BLOB, reactant4 BLOB, options VARCHAR2, tempBlob BLOB)
      RETURN BLOB PARALLEL_ENABLE AS
  BEGIN
      IF reaction IS NULL OR reactant1 IS NULL THEN
            return NULL;
      ELSE
          return jchem_blob_pkg.react(reaction, reactant1, reactant2,
                          reactant3, reactant4, options, tempBlob, null);
      END IF;
  END;

  FUNCTION t_react4(reaction VARCHAR2, reactant1 VARCHAR2, reactant2
          VARCHAR2, reactant3 VARCHAR2, reactant4 VARCHAR2, options VARCHAR2)
  RETURN CHAR_PRODUCT_ARRAY PARALLEL_ENABLE PIPELINED AS
    cp_arr CHAR_PRODUCT_ARRAY;
  BEGIN
    IF reaction is null or reactant1 is null THEN
      return;
    END IF;

    cp_arr := jchem_core_pkg.react_arr(reaction, reactant1, reactant2,
                                        reactant3, reactant4, options, null);
    for i in 1..cp_arr.count loop
      pipe row(cp_arr(i));
    end loop;
    return;
  END;

  FUNCTION t_react4(reaction CLOB, reactant1 CLOB, reactant2 CLOB, reactant3
                     CLOB, reactant4 CLOB, options VARCHAR2)
  RETURN CLOB_PRODUCT_ARRAY PARALLEL_ENABLE PIPELINED AS
    cp_arr CLOB_PRODUCT_ARRAY;
  BEGIN
    IF reaction is null or reactant1 is null THEN 
      return; 
    END IF;

    cp_arr := jchem_clob_pkg.react_arr(reaction, reactant1, reactant2,
                reactant3, reactant4, options, null);

    for i in 1..cp_arr.count loop
      pipe row(cp_arr(i));
    end loop;

    return;
  END;

  FUNCTION t_react4(reaction BLOB, reactant1 BLOB, reactant2 BLOB, reactant3
                     BLOB, reactant4 BLOB, options VARCHAR2)
  RETURN BLOB_PRODUCT_ARRAY PARALLEL_ENABLE PIPELINED AS
    bp_arr BLOB_PRODUCT_ARRAY;
  BEGIN
    IF reaction is null or reactant1 is null THEN 
      return; 
    END IF;

    bp_arr := jchem_blob_pkg.react_arr(reaction, reactant1, reactant2,
                reactant3, reactant4, options, null);

    for i in 1..bp_arr.count loop
      pipe row(bp_arr(i));
    end loop;

    return;
  END;

  FUNCTION standardize(structure VARCHAR2, param VARCHAR2)
         RETURN VARCHAR2 PARALLEL_ENABLE AS
  BEGIN
    IF structure IS NULL THEN
        return NULL;
    ELSE
        return jchem_core_pkg.standardize(structure, param);
    END IF;
  END;

  FUNCTION standardize(structure CLOB, param VARCHAR2, tempClob CLOB)
      RETURN CLOB PARALLEL_ENABLE AS
  BEGIN
      IF structure IS NULL THEN
          return NULL;
      ELSE
          return jchem_clob_pkg.standardize(structure, param, tempClob);
      END IF;
  END;

  FUNCTION standardize(structure BLOB, param VARCHAR2, tempBlob BLOB)
      RETURN BLOB PARALLEL_ENABLE AS
  BEGIN
      IF structure IS NULL THEN
          return NULL;
      ELSE
          return jchem_blob_pkg.standardize(structure, param, tempBlob);
      END IF;
  END;

  FUNCTION formula_eq(mol VARCHAR2, query VARCHAR2) RETURN NUMBER
    PARALLEL_ENABLE AS
  BEGIN
      IF mol is null THEN return null; END IF;
      IF query is null THEN return null; END IF;
      IF mol = query THEN 
          RETURN 1;
      ELSE
          RETURN 0;
      END IF;
  END;

  FUNCTION formula_eq(mol clob, query clob) RETURN NUMBER PARALLEL_ENABLE AS
  BEGIN
      IF mol is null THEN return null; END IF;
      IF query is null THEN return null; END IF;
      return jchem_clob_pkg.equals(mol, query);
  END;

  FUNCTION formula_eq(mol blob, query blob) RETURN NUMBER PARALLEL_ENABLE AS
  BEGIN
      IF mol is null THEN return null; END IF;
      IF query is null THEN return null; END IF;
      return jchem_blob_pkg.equals(mol, query);
  END;

  function t_get_gmem_util return gmem_util_array pipelined as
    gmemutil_arr gmem_util_array;
  begin
    gmemutil_arr := jchem_core_pkg.get_gmemutil_arr();
    for i in 1..gmemutil_arr.count loop
      pipe row(gmemutil_arr(i));
    end loop;
  end;

  function t_get_taskinfo return taskinfo_array pipelined as
    taskinfo_arr taskinfo_array;
  begin
    taskinfo_arr := jchem_core_pkg.get_taskinfo_arr();
    for i in 1..taskinfo_arr.count loop
      pipe row(taskinfo_arr(i));
    end loop;
  end;

end jcf;
/
show errors;

-- Should we rather declare this procedure to have definer privileges?
create or replace procedure jc_set_default_property(prop_name VARCHAR2,
                                                prop_value VARCHAR2)
   authid current_user as language java name
    'chemaxon.jchem.cartridge.JFunctions.setDefaultProperty(java.lang.String, java.lang.String)';
/
show errors;

create or replace package rmi as
    procedure clear_directory_cache as language java name
	    'chemaxon.jchem.cartridge.rmi.client.RmiDirectory.clearRemoteRefCache()';
    procedure clear_locale as language java name
            'chemaxon.jchem.cartridge.rmi.client.RmiDirectory.clearLocale()';
end rmi;
/
show errors;

-- Calls to this package incur a significant overhead -- always!!!
-- Use these procedures only where the call overhead is not relevant.
-- Turning log levels off will not reduce call overhead (unlike wth the logger
-- in Java code), it will reduce only the amount of logging.
create or replace package jcart_logger authid current_user as
    procedure set_log_level(logger_name varchar2, level number)
          parallel_enable as language java name
      'chemaxon.jchem.cartridge.util.JCartPlsqlLogger.setLogLevel(java.lang.String, int)';

    procedure error(logger_name varchar2, message varchar2)
          parallel_enable as language java name
      'chemaxon.jchem.cartridge.util.JCartPlsqlLogger.error(java.lang.String,
                                                            java.lang.String)';

    procedure warning(logger_name varchar2, message varchar2)
          parallel_enable as language java name
      'chemaxon.jchem.cartridge.util.JCartPlsqlLogger.warning(java.lang.String,
                                                              java.lang.String)';
    procedure info(logger_name varchar2, message varchar2)
          parallel_enable as language java name
      'chemaxon.jchem.cartridge.util.JCartPlsqlLogger.info(java.lang.String,
                                                           java.lang.String)';
    procedure debug(logger_name varchar2, message varchar2)
          parallel_enable as language java name
      'chemaxon.jchem.cartridge.util.JCartPlsqlLogger.debug(java.lang.String,
                                                           java.lang.String)';
end jcart_logger;
/
show errors;

declare
  cursor get_prop_name_length is
    select * from user_tab_cols
    where table_name = 'JC_IDX_PROPERTY' and column_name = 'PROP_NAME';
begin
  for uu_rec in get_prop_name_length
  loop
    if uu_rec.data_length < 200 then
      execute immediate 'alter table jc_idx_property modify (prop_name varchar2(4000))';
    end if;
  end loop;
end;
/
show errors;

exit;
