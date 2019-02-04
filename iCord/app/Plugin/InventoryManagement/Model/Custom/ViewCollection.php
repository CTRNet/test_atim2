<?php
/** **********************************************************************
 * iCord
 * ***********************************************************************
 *
 * Iventory Management plugin custom code
 * 
 * @author N. Luc - CTRNet (nicol.luc@gmail.com)
 * @since 2019-01-31
 */
class ViewCollectionCustom extends ViewCollection {

    var $name = 'ViewCollection';
    
// Add collection supplier_dept and collection_timepoint fields to the view    
    static $table_query = '
		SELECT
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
Collection.supplier_dept,
Collection.collection_timepoint,
		Collection.created AS created
		FROM collections AS Collection
		LEFT JOIN participants AS Participant ON Collection.participant_id = Participant.id AND Participant.deleted <> 1
		WHERE Collection.deleted <> 1 %%WHERE%%';
}