UPDATE sample_controls SET status='disabled' WHERE id IN(1, 4, 103, 104, 112, 113);
UPDATE parent_to_derivative_sample_controls SET status='disabled' WHERE id IN(23);
UPDATE sample_to_aliquot_controls SET status='disabled' WHERE id IN(23, 2, 3);

/*
select sac.id, sc.sample_type, ac.aliquot_type from sample_to_aliquot_controls sac
inner join sample_controls as sc ON sc.id=sac.sample_control_id
inner join aliquot_controls as ac ON ac.id=sac.aliquot_control_id
where sample_type like '%culture%';


select pdsc.id, sc.sample_type, dsc.sample_type, pdsc.status from parent_to_derivative_sample_controls pdsc
inner join sample_controls as sc on pdsc.parent_sample_control_id=sc.id
inner join sample_controls as dsc on pdsc.derivative_sample_control_id=dsc.id
group by parent_sample_control_id;
*/