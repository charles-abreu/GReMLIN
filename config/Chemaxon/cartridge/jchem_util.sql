create or replace package jchem_util authid current_user as
  function convertLongRawForJavaScript_1(cd_structure varchar2)
        RETURN VARCHAR2 AS LANGUAGE JAVA NAME
	    'chemaxon.util.HTMLTools.convertForJavaScript(java.lang.String) return java.lang.String';
  function convertLongRawForJavaScript(cd_structure varchar2) return varchar2;
  function convertBlobForJavaScript(cd_structure BLOB)
        RETURN BLOB AS LANGUAGE JAVA NAME
        'chemaxon.jchem.cartridge.JCFunctionsBlob.convertForJavaScript(oracle.sql.BLOB) return oracle.sql.BLOB';
  function convertBlobForJavaScript(cd_structure BLOB, temp_blob BLOB)
        RETURN BLOB AS LANGUAGE JAVA NAME
        'chemaxon.jchem.cartridge.JCFunctionsBlob.convertForJavaScript(
        oracle.sql.BLOB, oracle.sql.BLOB) return oracle.sql.BLOB';
  function convertBlobForJavaScriptToVc(cd_structure BLOB)
        RETURN VARCHAR2 AS LANGUAGE JAVA NAME
        'chemaxon.jchem.cartridge.JCFunctionsBlob.convertForJavaScriptToStr(oracle.sql.BLOB)
        return java.lang.String';
  function blobToChar(cd_structure BLOB) RETURN VARCHAR2 AS LANGUAGE JAVA NAME
        'chemaxon.jchem.cartridge.JCFunctionsBlob.blobToString(oracle.sql.BLOB)
        return java.lang.String';
  procedure recode(tmp_blobtbl_name varchar2, blob_id number) as language java name
        'chemaxon.jchem.cartridge.JcAspFunctions.recode(java.lang.String, long)';
  function encode(origBlob blob, encoding varchar2, tmp_blobtbl_name varchar2,
                  tmp_blobseq_name varchar2) return number as language java name
        'chemaxon.jchem.cartridge.JcAspFunctions.encode(
                oracle.sql.BLOB, java.lang.String, java.lang.String,
                java.lang.String) return long';
  procedure jc_encode_blob_into_tmp(sql_query_structure varchar2, encoding
                                    varchar2, tmp_blobtable_name in varchar2,
                                    tmp_blobseq_name in varchar2, blob_id out
                                    number);
end jchem_util;
/
show errors;

create or replace package body jchem_util as
  function convertLongRawForJavaScript(cd_structure varchar2) return varchar2 as
  begin
    return convertLongRawForJavaScript_1(jchem_misc_pkg.rawtochar(cd_structure));
  end;

  procedure jc_encode_blob_into_tmp(sql_query_structure varchar2, encoding
                                    varchar2, tmp_blobtable_name in varchar2,
                                    tmp_blobseq_name in varchar2, blob_id out
                                    number) as
      structure blob;
  begin
      execute immediate sql_query_structure into structure;
      blob_id := encode(structure, encoding, tmp_blobtable_name,
                        tmp_blobseq_name);
  end;
end jchem_util;
/
show errors;

-- select max(length(jchem_util.test(cd_id))) from jc_fmc_10k;
quit
