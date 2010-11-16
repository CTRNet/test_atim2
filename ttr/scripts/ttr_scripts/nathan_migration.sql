-- Atim_datatest

truncate participants;

SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO';
insert into participants (id, participant_identifier, title, first_name, usual_name, last_name, date_of_birth, sex, race, notes, has_more_than_one_consent, created, created_by, modified, modified_by)
select id, phn, salutation, first_name, usual_name, last_name, date_of_birth, sex, race, memo, has_more_than_one_consent, created, created_by, modified, modified_by from ttrdb.participants;
SET SQL_MODE=@OLD_SQL_MODE;

insert into participant_contacts (contact_name, contact_type, street, phone, participant_id)
select concat (id, 'contact_name'), concat (id, 'contact_type'), concat (id,  'street'), concat (id,  'phone'), id from ttrdb.participants

SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO';
insert into consent_masters (id, date_of_referral, route_of_referral,
consent_status, consent_signed_date, process_status, operation_date, acquisition_id, participant_id, consent_control_id)
select id, referral_datetime,referral_method,
consent_status, date_consent_signed, consent_closed, or_datetime, acquisition_id, participant_id, 1
from ttrdb.consents;
SET SQL_MODE=@OLD_SQL_MODE;

-- collections
truncate collections;
-- need redefine collection_property to ëparticipant collectioní or ëindependent collectioní based on consent or withdrawn or denied.
Alter table add column collected_by varchar(20) null,
add column collection_type varchar(20) null,
add column tb_received_by varchar(20) null,
add column tb_received_datetime varchar(20) null,
add column time_anaesthesia_ready time null,
add column time_incision time null,
add column pathologist varchar(50) null,
add column tissue_collection_status varchar(30) null,
add column after_hour_collection char(3) null,
add column tb_received_by varchar(20) null)




insert into collections (id, acquisition_label, collection_site,collection_datetime, collection_notes, collection_property, collection_type, tb_received_by, tb_received_datetime, time_anaesthesia_ready, time_incision, pathologist, tissue_collection_status, after_hour_collection, tb_received_by, created, created_by, modified, modified_by)   -- participant collection, independent collection
select id, acquisition_label, collection_site,collection_datetime, concat(id, ' notes'), 'participant collection', collection_type, tb_received_by, tb_received_datetime, time_anaesthesia_ready, time_incision, pathologist, tissue_collection_status, after_hour_collection, tb_received_by, created, created_by, modified, modified_by from ttrdb.collections

-- sample_masters
truncate sd_spe_tissues;
truncate sd_spe_bloods;
truncate sd_der_plasmas;
truncate sd_der_pbmcs;
truncate sd_der_dnas;
truncate sd_der_rnas;
truncate sample_masters;  -- can not truncate because recurrence key ñ parent_id

-- use collection_id other than acquisition_id to form sample_code to avoid duplicate
-- unique sample_code error for consents with more than one blood collection because we use acquisition_label, collection_id will be OK, not acquisition_id

insert into sample_masters (sample_code, sample_category,
sample_control_id, sample_type, initial_specimen_sample_type, collection_id, created, created_by, modified, modified_by)
select distinct concat(col.id,'T'), 'specimen',3, 'tissue', 'tissue', col.id, col.created, col.created_by, col.modified, col.modified_by
from ttrdb.sample_masters sm, collections col
where col.id=sm.collection_id
and sample_type like '%block%';

insert into sd_spe_tissues (sample_master_id, tissue_source, pathology_reception_datetime, created, created_by, modified, modified_by)
select sm.id, c.cancer_type, col.collection_datetime, col.created, col.created_by, col.modified, col.modified_by
from sample_masters sm, ttrdb.consents c, ttrdb.collections col
where col.id=sm.collection_id
and c.acquisition_id=col.acquisition_label
and sm.sample_type='tissue';

insert into sample_masters (sample_code, sample_category,
sample_control_id, sample_type, initial_specimen_sample_type, collection_id, created, created_by, modified, modified_by)
select distinct concat(col.id,'B'), 'specimen',2, 'blood', 'blood',col.id, col.created, col.created_by, col.modified, col.modified_by
from ttrdb.sample_masters sm, collections col
where col.id=sm.collection_id
and sample_type='tube';

insert into sd_spe_bloods (sample_master_id, collected_tube_nbr, created, created_by, modified, modified_by)
select sm.id, col.number_of_blood_tubes, col.created, col.created_by, col.modified, col.modified_by
from sample_masters sm, ttrdb.collections col
where col.id=sm.collection_id
and sm.sample_control_id=2
and col.collection_type='blood';

insert into sample_masters (sample_code, sample_category,
sample_control_id, sample_type, initial_specimen_sample_type, collection_id, created, created_by, modified, modified_by)
select distinct concat(col.id,'PLS'), 'derivative',9, 'plasma', 'blood',col.id, col.created, col.created_by, col.modified, col.modified_by
from ttrdb.sample_masters sm, collections col
where col.id=sm.collection_id
and sample_type ='plasma';

insert into sd_der_plasmas (sample_master_id, created, created_by, modified, modified_by)
select id, created, created_by, modified, modified_by
from sample_masters 
where sample_control_id=9;

insert into sample_masters (sample_code, sample_category,
sample_control_id, sample_type, initial_specimen_sample_type, collection_id, created, created_by, modified, modified_by)
select distinct concat(col.id,'BC'), 'derivative',8, 'buffy_coat','blood', col.id, col.created, col.created_by, col.modified, col.modified_by
from ttrdb.sample_masters sm, collections col
where col.id=sm.collection_id
and sample_type ='buffy_coat';

insert into sd_der_pbmcs (sample_master_id, created, created_by, modified, modified_by)
select id, created, created_by, modified, modified_by
from sample_masters 
where sample_control_id=8;

insert into sample_masters (sample_code, sample_category,
sample_control_id, sample_type, initial_specimen_sample_type, collection_id, created, created_by, modified, modified_by)
select distinct concat(col.id,'DNA'), 'derivative', 12, 'dna','blood', col.id, col.created, col.created_by, col.modified, col.modified_by
from ttrdb.sample_masters sm, collections col
where col.id=sm.collection_id
and sample_type ='dna_card';

insert into sd_der_dnas (sample_master_id, created, created_by, modified, modified_by)
select id, created, created_by, modified, modified_by
from sample_masters 
where sample_control_id=12;


insert into sample_masters (sample_code, sample_category,
sample_control_id, sample_type, initial_specimen_sample_type, collection_id, created, created_by, modified, modified_by)
select distinct concat(col.id,'RNA'), 'derivative', 13, 'rna', 'blood',col.id, col.created, col.created_by, col.modified, col.modified_by
from ttrdb.sample_masters sm, collections col
where col.id=sm.collection_id
and sample_type ='rna_fraction';

insert into sd_der_rnas (sample_master_id, created, created_by, modified, modified_by)
select id, created, created_by, modified, modified_by
from sample_masters 
where sample_control_id=13;

-- need update parent_id
update sample_masters sm inner join sample_masters sm1
set sm.parent_id=sm1.id
where sm1.sample_type='blood'
and sm.collection_id=sm1.collection_id
and sm.sample_type<>'blood'

-- need update initial_specimen_sample_id
update sample_masters sm inner join sample_masters sm1
set sm.initial_specimen_sample_id=sm1.id
where sm1.sample_type='blood'
and sm.collection_id=sm1.collection_id
and sm.sample_type<>'blood'

update sample_masters sm inner join sample_masters sm1
set sm.initial_specimen_sample_id=sm1.id
where sm1.sample_type='tissue'
and sm.collection_id=sm1.collection_id
and sm.sample_type<>'tissue';

truncate ad_blocks;
truncate ad_tubes;
truncate ad_tissue_slides;
truncate ad_whatman_papers;
truncate realiquotings;
truncate source_aliquots;
truncate aliquot_uses;
truncate ad_tissue_cores;
truncate aliquot_masters; 
-- add ttr_sample_master_id
alter table aliquot_masters add column ttr_sample_master_id int(11);

-- insert into aliquot_masters
-- tissue block

alter table aliquot_masters add column ttr_sample_master_id int(11);

insert into aliquot_masters(barcode, aliquot_type, aliquot_control_id, collection_id, sample_master_id,
in_stock, storage_datetime,storage_master_id, storage_coord_x,
storage_coord_y, ttr_sample_master_id)
select smt.sample_barcode, 'block', 4, smt.collection_id, sm.id,
smt.sample_status,stored_datetime, stm.id, smt.row_id, smt.col_id,
smt.id
from ttrdb.sample_masters smt, sample_masters sm, ttrdb.boxes b, storage_masters stm
where smt.collection_id=sm.collection_id
and sm.sample_type='tissue'
and smt.sample_type like '%block%'
and smt.box_id=b.id
and b.description=stm.code;

insert into ad_blocks (aliquot_master_id, block_type)
select am.id, sm.sample_type
from aliquot_masters am, ttrdb.sample_masters sm
where am.ttr_sample_master_id=sm.id
and am.aliquot_control_id=4;

-- tissue slide
insert into aliquot_masters(barcode, aliquot_type, aliquot_control_id, collection_id, sample_master_id,
in_stock, storage_datetime,ttr_sample_master_id)
select smt.sample_barcode, smt.sample_type, 5, smt.collection_id, sm.id,
smt.sample_status,smt.stored_datetime, smt.id
from ttrdb.sample_masters smt, sample_masters sm
where smt.collection_id=sm.collection_id
and sm.sample_type='tissue'
and smt.sample_type = 'tissue_slide';

insert into ad_tissue_slides (aliquot_master_id)
select id from aliquot_masters where aliquot_control_id=5

--  blood tube  -- there is system error when there is more than 1 blood collection
-- duplicate barcode in ttrdb.sample_masters
select sm1.id, sm1.sample_barcode, sm1.* from ttrdb.sample_masters sm1, ttrdb.sample_masters sm2
where sm1.sample_type = 'tube'
and sm2.sample_type = 'tube'
and sm1.sample_barcode=sm2.sample_barcode
and sm1.id<>sm2.id
order by sm1.sample_barcode

-- check more than one collection only 2, some may just wrong data entry
select * from ttrdb.collections where id in (
select sm1.collection_id from ttrdb.sample_masters sm1, ttrdb.sample_masters sm2
where sm1.sample_type = 'tube'
and sm2.sample_type = 'tube'
and sm1.sample_barcode=sm2.sample_barcode
and sm1.id<>sm2.id
order by sm1.sample_barcode
)
order by acquisition_label

-- tube -- do not use the query below, lose duplicate entry
insert into aliquot_masters(barcode, aliquot_type, aliquot_control_id, collection_id, sample_master_id,
in_stock, storage_datetime,ttr_sample_master_id)
select smt.sample_barcode, smt.sample_type, 1, smt.collection_id, sm.id,
'not available',smt.stored_datetime, smt.id
from ttrdb.sample_masters smt, sample_masters sm
where smt.collection_id=sm.collection_id
and sm.sample_type='blood'
and smt.sample_type = 'tube'a
and smt.id not in
(select sm1.id from ttrdb.sample_masters sm1, ttrdb.sample_masters sm2
where sm1.sample_type = 'tube'
and sm2.sample_type = 'tube'
and sm1.sample_barcode=sm2.sample_barcode
and sm1.id<>sm2.id
);

insert into ad_tubes (aliquot_master_id)
select id from aliquot_masters where aliquot_control_id=1

-- plasma and buffy_coat -- do not use the query below, lose duplicate entry
insert into aliquot_masters(barcode, aliquot_type, aliquot_control_id, collection_id, sample_master_id,
in_stock, storage_datetime,storage_master_id, storage_coord_x,
storage_coord_y, initial_volume, current_volume, aliquot_volume_unit,ttr_sample_master_id)
select smt.sample_barcode, smt.sample_type, 11, smt.collection_id, sm.id,
smt.sample_status,stored_datetime, stm.id, smt.row_id, smt.col_id,
bp.quantity, bp.available_quantity, 'ul',
smt.id
from ttrdb.sample_masters smt, sample_masters sm, 
ttrdb.boxes b, storage_masters stm, ttrdb.sd_bloodproducts bp
where smt.collection_id=sm.collection_id
and sm.sample_type= smt.sample_type 
and smt.box_id=b.id
and b.description=stm.code
and smt.id=bp.sample_master_id
and smt.id not in
(select sm1.id from ttrdb.sample_masters sm1, ttrdb.sample_masters sm2
where sm1.sample_type = sm2.sample_type and sm1.sample_barcode=sm2.sample_barcode
and sm1.id<>sm2.id
);

insert into ad_tubes (aliquot_master_id)
select id from aliquot_masters where aliquot_control_id=11;

-- rna
insert into aliquot_masters(barcode, aliquot_type, aliquot_control_id, collection_id, sample_master_id,
in_stock, storage_datetime,storage_master_id, storage_coord_x,
storage_coord_y, initial_volume, current_volume, aliquot_volume_unit,ttr_sample_master_id)
select smt.sample_barcode, 'rna', 11, smt.collection_id, sm.id,   -- aliquot_type is tube
smt.sample_status,stored_datetime, stm.id, smt.row_id, smt.col_id,
r.quantity, r.available_quantity, 'ul',
smt.id
from ttrdb.sample_masters smt, sample_masters sm, 
ttrdb.boxes b, storage_masters stm, ttrdb.sd_rnafractions r
where smt.collection_id=sm.collection_id
and sm.sample_type= 'rna'
and smt.sample_type = 'rna_fraction'
and smt.box_id=b.id
and b.description=stm.code
and smt.id=r.sample_master_id;

insert into ad_tubes (aliquot_master_id)
select id from aliquot_masters where aliquot_control_id=11 and aliquot_type='rna';


-- insert into derivative detail
insert into derivative_details (sample_master_id)
select id from sample_masters where sample_category='derivative'

-- check sample_type and aliquot_type
select count(am.id), sm.sample_type, am.aliquot_type
 from sample_masters sm, aliquot_masters am 
where sm.id=am.sample_master_id
group by sm.sample_type, am.aliquot_type

-- data for aliquot detail error
select am.*
from aliquot_masters am, ad_tubes at
where am.id=at.aliquot_master_id
and substr(barcode, 1, 4)='1000'
