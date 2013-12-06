<?php
class ViewSampleCustom extends ViewSample{
	var $name = 'ViewSample';
	
	static $table_query = '	
		SELECT SampleMaster.id AS sample_master_id,
		SampleMaster.parent_id AS parent_id,
		SampleMaster.initial_specimen_sample_id,
		SampleMaster.collection_id AS collection_id,
		
		Collection.bank_id, 
		Collection.sop_master_id, 
		Collection.participant_id, 
		
		Participant.participant_identifier, 
		
		Collection.acquisition_label,
		
		SpecimenSampleControl.sample_type AS initial_specimen_sample_type,
		SpecimenSampleMaster.sample_control_id AS initial_specimen_sample_control_id,
		ParentSampleControl.sample_type AS parent_sample_type,
		ParentSampleMaster.sample_control_id AS parent_sample_control_id,
		SampleControl.sample_type,
		SampleMaster.sample_control_id,
		SampleMaster.sample_code,
		SampleControl.sample_category,
Collection.uhn_collection_year AS uhn_collection_year,
MiscIdentifier.identifier_value AS tgh_number,
Collection.uhn_pre_post_treatment AS uhn_pre_post_treatment,
EventDetail.report_number AS uhn_report_number,
			
NULL AS coll_to_rec_spent_time_msg,
NULL AS coll_to_creation_spent_time_msg 
		
		FROM sample_masters AS SampleMaster
		INNER JOIN sample_controls as SampleControl ON SampleMaster.sample_control_id=SampleControl.id
		INNER JOIN collections AS Collection ON Collection.id = SampleMaster.collection_id AND Collection.deleted != 1
		LEFT JOIN sample_masters AS SpecimenSampleMaster ON SampleMaster.initial_specimen_sample_id = SpecimenSampleMaster.id AND SpecimenSampleMaster.deleted != 1
		LEFT JOIN sample_controls AS SpecimenSampleControl ON SpecimenSampleMaster.sample_control_id = SpecimenSampleControl.id
		LEFT JOIN sample_masters AS ParentSampleMaster ON SampleMaster.parent_id = ParentSampleMaster.id AND ParentSampleMaster.deleted != 1
		LEFT JOIN sample_controls AS ParentSampleControl ON ParentSampleMaster.sample_control_id = ParentSampleControl.id
		LEFT JOIN participants AS Participant ON Collection.participant_id = Participant.id AND Participant.deleted != 1
LEFT JOIN misc_identifiers AS MiscIdentifier ON Collection.uhn_misc_identifier_id = MiscIdentifier.id AND MiscIdentifier.deleted <> 1
LEFT JOIN uhn_ed_ovary_lab_pathologies AS EventDetail ON EventDetail.event_master_id = Collection.event_master_id
		WHERE SampleMaster.deleted != 1 %%WHERE%%';
}

