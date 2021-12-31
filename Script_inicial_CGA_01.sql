create database CGA;

use cga;

create table Forma_pagamento (
cd_forma_pagamento int auto_increment primary key,
ds_forma_pagamento varchar(15) not null
);

create table salario (
cd_salario int auto_increment primary key,
vl_salario decimal (10,2)  not null,
dt_salario timestamp not null
);

create table gasto_fixo (
cd_gasto_fixo int auto_increment primary key,
ds_gasto_fixo varchar(50) not null,
vl_gasto_fixo decimal(10,2) not null,
dt_quitacao timestamp,
dt_registro timestamp not null default current_timestamp(),
cd_forma_pagamento int,
dt_referencia timestamp,
tp_ref enum ('1','2'),
constraint Gasfix_paga_fk foreign key (cd_forma_pagamento) references forma_pagamento (cd_forma_pagamento)
);

create table gasto_adicional (
cd_gasto_adicional int auto_increment primary key,
ds_gasto_adicional varchar(50) not null,
vl_gasto_adicional decimal (10,2) not null,
dt_quitacao timestamp,
dt_registro timestamp not null default current_timestamp(),
dt_salario timestamp,
cd_forma_pagamento int,
dt_referencia timestamp,
tp_ref enum ('1','2'),
constraint Gasadi_paga_fk foreign key (cd_forma_pagamento) references forma_pagamento (cd_forma_pagamento)
);

create table ganho_adicional (
cd_ganho_adicional int auto_increment primary key,
ds_ganho_adicional varchar(50) not null,
vl_ganho_adicional decimal (10,2) not null,
dt_quitacao timestamp,
dt_registro timestamp not null default current_timestamp(),
dt_salario timestamp,
cd_forma_pagamento int,
dt_referencia timestamp,
tp_ref enum ('1','2'),
constraint Ganadi_pag_fk foreign key (cd_forma_pagamento) references forma_pagamento (cd_forma_pagamento)
);

create table observacao_mensal (
cd_observacao_mensal int auto_increment primary key,
ds_observacao_mensal varchar (75) not null,
dt_registro_mensal timestamp not null default current_timestamp(),
dt_salario timestamp
);

##view de gastos fixos##
create view v_gasto_fixo
as 
select 	fp.ds_forma_pagamento Pagamento
	   ,gf.ds_gasto_fixo Descrição_fixo
       ,gf.vl_gasto_fixo valor_fixo
       ,date_format(gf.dt_referencia,'%m-%Y') data_referencia
       ,case	tp_ref
		  when  '1' then 'Parcela 1'
          when  '2' then 'Parcela 2'
          end tp_ref
from forma_pagamento fp
	,gasto_fixo gf
    
where fp.cd_forma_pagamento = gf.cd_forma_pagamento;

##viwe de gastos adicionais##
create view v_gasto_adicional
as 
select 	fp.ds_forma_pagamento Pagamento
	   ,gad.ds_gasto_adicional Descrição_fixo
       ,gad.vl_gasto_adicional valor_fixo
       ,date_format(gad.dt_referencia,'%m-%Y') data_referencia
       ,case	gad.tp_ref
		  when  '1' then 'Parcela 1'
          when  '2' then 'Parcela 2'
          end tp_ref
from forma_pagamento fp
	,gasto_adicional gad
    
where fp.cd_forma_pagamento = gad.cd_forma_pagamento;

##View de ganho adicional##
create view v_ganho_adicional
as
select 	fp.ds_forma_pagamento Pagamento
	   ,gand.ds_ganho_adicional Descrição_fixo
       ,gand.vl_ganho_adicional valor_fixo
       ,date_format(gand.dt_referencia,'%m-%Y') data_referencia
       ,case	gand.tp_ref
		  when  '1' then 'Parcela 1'
          when  '2' then 'Parcela 2'
          end tp_ref
from forma_pagamento fp
	,ganho_adicional gand
where fp.cd_forma_pagamento = gand.cd_forma_pagamento;

##Dados para testes##

insert into forma_pagamento (ds_forma_pagamento)
values ('Virtual'),('Fisica'),('Boleto');

insert into salario (vl_salario,dt_salario)
values (1700,'2021-12-28');

insert into gasto_fixo (ds_gasto_fixo,vl_gasto_fixo,cd_forma_pagamento)
values ('Moto 21/60',314.98,1);

insert into gasto_fixo (ds_gasto_fixo,vl_gasto_fixo,cd_forma_pagamento)
values ('Energia',151.84,1),
	   ('Internet',80,1),
       ('Agua e esgoto',50,1),
       ('Emprestimo',417,1);

insert into gasto_adicional (ds_gasto_adicional,vl_gasto_adicional,cd_forma_pagamento)
values ('Fatura Nubank',350,1);

insert into ganho_adicional (ds_ganho_adicional,vl_ganho_adicional,cd_forma_pagamento)
values ('Ferias 2/2',1183.09,1),
	   ('Guardado',400,1);
       
       
##Procedure de observação##
delimiter $$

create procedure sp_observacao (
pdsobservacao varchar (75)
)
begin
    
    start transaction;
    
    if not exists(select cd_observacao_mensal from observacao_mensal where ds_observacao_mensal = pdsobservacao) then
		insert into observacao_mensal values (null,pdsobservacao,current_timestamp(),null);
			select  'Dados Cadastrados com sucesso!' as resultado;
	commit;
	else
		select 'Usuario já cadastrado!' as resultado; 
        rollback;
        
    end if;
	
end $$

delimiter ;

##Procedure de ganho adicional##
delimiter $$
create procedure sp_ganho_adicional(
pds_ganho_adicional varchar(50),
pvl_ganho_adicional decimal(10,2),
pcd_forma_pagamento int,
ptp_ref enum('1','2'),
pdt_referencia timestamp
)
begin
	start transaction;
		if not exists(select cd_ganho_adicional 
					  from ganho_adicional  
                      where ds_ganho_adicional = pds_ganho_adicional
						and vl_ganho_adicional = pvl_ganho_adicional
                        and tp_ref = ptp_ref)
				then
                insert into ganho_adicional values (null,pds_ganho_adicional,pvl_ganho_adicional,null,current_timestamp(),null,pcd_forma_pagamento,ptp_ref,pdt_referencia);
                select 'Dados cadastrados com sucesso!' as Resultado;
                commit;
		else 
			rollback;
            select 'Dados Já cadastrados!' as Resultado;
         end if;
end$$

delimiter ; 

##Procedure de gasto adicional##
delimiter $$
create procedure sp_gasto_adicional(
pds_gasto_adicional varchar(50),
pvl_gasto_adicional decimal(10,2),
pcd_forma_pagamento int,
ptp_ref enum('1','2'),
pdt_referencia timestamp
)
begin
	start transaction;
		if not exists(select cd_gasto_adicional 
					  from gasto_adicional  
                      where ds_gasto_adicional = pds_gasto_adicional
						and vl_gasto_adicional = pvl_gasto_adicional
                        and tp_ref = ptp_ref)
				then
                insert into gasto_adicional values (null,pds_gasto_adicional,pvl_gasto_adicional,null,current_timestamp(),null,pcd_forma_pagamento,ptp_ref,pdt_referencia);
                select 'Dados cadastrados com sucesso!' as Resultado;
                commit;
		else 
			rollback;
            select 'Dados Já cadastrados!' as Resultado;
         end if;
end$$

delimiter ; 

##Procedure de gasto fixo##
delimiter $$
create procedure sp_gasto_fixo(
pds_gasto_fixo varchar(50),
pvl_gasto_fixo decimal(10,2),
pcd_forma_pagamento int,
pdt_referencia timestamp,
ptp_ref enum('1','2')
)
begin
	start transaction;
		if not exists(select cd_gasto_fixo 
					  from gasto_fixo  
                      where ds_gasto_fixo = pds_gasto_fixo
						and vl_gasto_fixo = pvl_gasto_fixo
                        and tp_ref = ptp_ref)
				then
                insert into gasto_fixo values (null,pds_gasto_fixo,pvl_gasto_fixo,null,current_timestamp(),pcd_forma_pagamento,pdt_referencia,ptp_ref);
                select 'Dados cadastrados com sucesso!' as Resultado;
                commit;
		else 
			rollback;
            select 'Dados Já cadastrados!' as Resultado;
         end if;
end$$

delimiter ; 

##Procedure de salario##
delimiter $$
create procedure sp_salario (
pvl_salario decimal(10,2),
pdt_salario timestamp
)
begin
	start transaction;
		if not exists
					 (select cd_salario 
					  from salario 
                      where vl_salario = pvl_salario
						and dt_salario = pdt_salario)
			then 
				insert into salario values (null,pvl_salario,pdt_salario);
            select 'Dados cadastros com sucesso!' as Resultado;
            Commit;
		else
			select 'Dados já cadastrados!' as Resultado;
            rollback;
		end if;
end $$

delimiter ;
