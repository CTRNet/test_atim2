<?php
class ViewCollectionCustom extends ViewCollection{
	
	var $name = 'ViewCollection';
	static $table_query = 
		'SELECT 
			Collection.id AS collection_id,
			Collection.bank_id AS bank_id,
			Collection.sop_master_id AS sop_master_id,
			Collection.participant_id AS participant_id,
			Collection.diagnosis_master_id AS diagnosis_master_id,
			Collection.consent_master_id AS consent_master_id,
			Collection.treatment_master_id AS treatment_master_id,
			Collection.event_master_id AS event_master_id,
			Participant.participant_identifier AS participant_identifier,
			Collection.acquisition_label AS acquisition_label,
			Collection.collection_site AS collection_site,
			Collection.collection_datetime AS collection_datetime,
			Collection.collection_datetime_accuracy AS collection_datetime_accuracy,
			Collection.collection_property AS collection_property,
			Collection.collection_notes AS collection_notes,
Collection.chus_chemo_naive,
Collection.chus_radio_naive,
Collection.chus_study_summary_id,
			Collection.created AS created 
			FROM collections AS Collection 
			LEFT JOIN participants AS Participant ON Collection.participant_id = Participant.id AND Participant.deleted <> 1 
			WHERE Collection.deleted <> 1 %%WHERE%%';
	
}