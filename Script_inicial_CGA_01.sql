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
       
       
##Procedure para inserir observação##
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
