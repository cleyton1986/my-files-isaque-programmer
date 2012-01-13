CREATE DOMAIN DMN_MONEY AS NUMERIC(15,2);

ALTER TABLE TBCOMPRASITENS DROP CONSTRAINT FK_TBCOMPRASITENS_1;

ALTER TABLE TBCOMPRASITENS DROP CONSTRAINT FK_TBCOMPRASITENS_2;

ALTER TABLE TBCOMPRASITENS DROP CONSTRAINT FK_TBCOMPRASITENS_3;

ALTER TABLE TBCOMPRAS DROP CONSTRAINT PK_TBCOMPRAS;

ALTER TABLE TBCOMPRAS ADD ANO SMALLINT NOT NULL;

ALTER TABLE TBCOMPRASITENS ADD ANO SMALLINT NOT NULL;

alter table TBCOMPRAS
add constraint PK_TBCOMPRAS
primary key (ANO,CODCONTROL,CODEMP)
using index PK_TBCOMPRAS;

ALTER TABLE TBCOMPRASITENS ADD SEQ SMALLINT NOT NULL;

update RDB$RELATION_FIELDS set
RDB$NULL_FLAG = 1
where (RDB$FIELD_NAME = 'CODCONTROL') and
(RDB$RELATION_NAME = 'TBCOMPRASITENS');

update RDB$RELATION_FIELDS set
RDB$NULL_FLAG = 1
where (RDB$FIELD_NAME = 'CODEMP') and
(RDB$RELATION_NAME = 'TBCOMPRASITENS');

alter table TBCOMPRASITENS
add constraint PK_TBCOMPRASITENS
primary key (ANO,CODCONTROL,CODEMP,SEQ);

alter table TBCOMPRASITENS
add constraint FK_TBCOMPRASITENS_COMPRA
foreign key (ANO,CODCONTROL,CODEMP)
references TBCOMPRAS(ANO,CODCONTROL,CODEMP)
on delete CASCADE
on update CASCADE;

alter table TBCOMPRAS
add constraint FK_TBCOMPRAS_EMPRESA
foreign key (CODEMP)
references TBEMPRESA(CNPJ)
on update CASCADE;

alter table TBCOMPRAS
add constraint FK_TBCOMPRAS_FORNECEDOR
foreign key (CODFORN)
references TBFORNECEDOR(CODFORN)
on update CASCADE;

alter table TBCOMPRASITENS
add constraint FK_TBCOMPRASITENS_EMPRESA
foreign key (CODEMP)
references TBEMPRESA(CNPJ)
on update CASCADE;

alter table TBCOMPRASITENS
add constraint FK_TBCOMPRASITENS_FORNECEDOR
foreign key (CODFORN)
references TBFORNECEDOR(CODFORN)
on update CASCADE;

alter table TBCOMPRASITENS
add constraint FK_TBCOMPRASITENS_PRODUTO
foreign key (CODPROD)
references TBPRODUTO(COD);

ALTER TABLE TBCOMPRAS ADD DTLANCAMENTO TIMESTAMP;

ALTER TABLE TBCOMPRAS ADD NFCFOP INTEGER;

ALTER TABLE TBCOMPRAS DROP STATUS;

ALTER TABLE TBCOMPRAS ADD STATUS DMN_STATUS;

ALTER TABLE TBCOMPRAS
    ADD USUARIO VARCHAR(50) DEFAULT user,
    ADD FORMAPAGTO_COD SMALLINT,
    ADD CONDICAOPAGTO_COD SMALLINT,
    ADD COMPRA_PRAZO DMN_LOGICO,
    ADD PRAZO_01 SMALLINT,
    ADD PRAZO_02 SMALLINT,
    ADD PRAZO_03 SMALLINT,
    ADD PRAZO_04 SMALLINT,
    ADD PRAZO_05 SMALLINT,
    ADD PRAZO_06 SMALLINT,
    ADD PRAZO_07 SMALLINT,
    ADD PRAZO_08 SMALLINT,
    ADD PRAZO_09 SMALLINT,
    ADD PRAZO_10 SMALLINT,
    ADD PRAZO_11 SMALLINT,
    ADD PRAZO_12 SMALLINT;

CREATE SEQUENCE GEN_COMPRAS_CONTROLE_2011;
CREATE SEQUENCE GEN_COMPRAS_CONTROLE_2012;
CREATE SEQUENCE GEN_COMPRAS_CONTROLE_2013;
CREATE SEQUENCE GEN_COMPRAS_CONTROLE_2014;
CREATE SEQUENCE GEN_COMPRAS_CONTROLE_2015;
CREATE SEQUENCE GEN_COMPRAS_CONTROLE_2016;
CREATE SEQUENCE GEN_COMPRAS_CONTROLE_2017;
CREATE SEQUENCE GEN_COMPRAS_CONTROLE_2018;
CREATE SEQUENCE GEN_COMPRAS_CONTROLE_2019;
CREATE SEQUENCE GEN_COMPRAS_CONTROLE_2020;

SET TERM ^ ;

CREATE OR ALTER Trigger Tg_compras_controle For TBCOMPRAS
Active Before Insert Position 0
AS
BEGIN
  IF (NEW.CODCONTROL IS NULL) THEN
    if ( new.Ano = 2011 ) then
      NEW.CODCONTROL = GEN_ID(GEN_COMPRAS_CONTROLE_2011, 1);
    else
    if ( new.Ano = 2012 ) then
      NEW.CODCONTROL = GEN_ID(GEN_COMPRAS_CONTROLE_2012, 1);
    else
    if ( new.Ano = 2013 ) then
      NEW.CODCONTROL = GEN_ID(GEN_COMPRAS_CONTROLE_2013, 1);
    else
    if ( new.Ano = 2014 ) then
      NEW.CODCONTROL = GEN_ID(GEN_COMPRAS_CONTROLE_2014, 1);
    else
    if ( new.Ano = 2015 ) then
      NEW.CODCONTROL = GEN_ID(GEN_COMPRAS_CONTROLE_2015, 1);
    else
    if ( new.Ano = 2016 ) then
      NEW.CODCONTROL = GEN_ID(GEN_COMPRAS_CONTROLE_2016, 1);
    else
    if ( new.Ano = 2017 ) then
      NEW.CODCONTROL = GEN_ID(GEN_COMPRAS_CONTROLE_2017, 1);
    else
    if ( new.Ano = 2018 ) then
      NEW.CODCONTROL = GEN_ID(GEN_COMPRAS_CONTROLE_2018, 1);
    else
    if ( new.Ano = 2019 ) then
      NEW.CODCONTROL = GEN_ID(GEN_COMPRAS_CONTROLE_2019, 1);
    else
    if ( new.Ano = 2020 ) then
      NEW.CODCONTROL = GEN_ID(GEN_COMPRAS_CONTROLE_2020, 1);
END

SET TERM ; ^

ALTER TABLE TBCOMPRASITENS
    ADD PERC_PARTICIPACAO NUMERIC(10,2),
    ADD VALOR_FRETE DMN_MONEY,
    ADD VALOR_DESCONTO DMN_MONEY,
    ADD VALOR_OUTROS DMN_MONEY,
    ADD VALOR_IPI DMN_MONEY,
    ADD UNID_COD SMALLINT;
    
ALTER TABLE TBCOMPRASITENS
    ALTER PRECOUNIT TYPE DMN_MONEY,
    ALTER CUSTOMEDIO TYPE DMN_MONEY;
    
alter table TBCOMPRASITENS
add constraint FK_TBCOMPRASITENS_UNID
foreign key (UNID_COD)
references TBUNIDADEPROD(UNP_COD);

ALTER TABLE TBCOMPRAS
    ALTER IPI TYPE DMN_MONEY,
    ALTER ICMSBASE TYPE DMN_MONEY,
    ALTER ICMSVALOR TYPE DMN_MONEY,
    ALTER ICMSSUBSTBASE TYPE DMN_MONEY,
    ALTER ICMSSUBSTVALOR TYPE DMN_MONEY,
    ALTER FRETE TYPE DMN_MONEY,
    ALTER OUTROSCUSTOS TYPE DMN_MONEY,
    ALTER DESCONTO TYPE DMN_MONEY,
    ALTER TOTALNF TYPE DMN_MONEY,
    ALTER TOTALPROD TYPE DMN_MONEY;
    
ALTER TABLE TBCOMPRAS
    ADD DTFINALIZACAO_COMPRA TIMESTAMP;
    
            
    
        
