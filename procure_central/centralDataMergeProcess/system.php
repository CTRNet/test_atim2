<?php

set_time_limit('3600');

//-- Initiate config file variables ------------------------------------------------------------------------------------------------------------------------------------------------

global $merge_process_version;
$merge_process_version = 'v0.1';

//-- DB PARAMETERS -----------------------------------------------------------------------------------------------------------------------------------------------------------------

global $db_ip;
global $db_port;
global $db_user;
global $db_pwd;
global $db_charset;
$db_ip		= 	"localhost";
$db_port	= 	"";
$db_user	= 	"root";
$db_pwd		= 	"";
$db_charset	= "utf8";

global $db_central_schemas;
$db_central_schemas	= "";

$db_chum_schemas = "";
$db_chuq_schemas = "";
$db_chus_schemas = "";
$db_cusm_schemas = "";
$db_processing_schemas = "";

global $db_connection;
$db_connection = null;

//-- Migration id and date ---------------------------------------------------------------------------------------------------------------------------------------------------------

global $merge_user_id;
$merge_user_id = 1;

global $import_date;
$import_date = null;

global $imported_by;
$imported_by = null;

//-- Other Varaiables --------------------------------------------------------------------------------------------------------------------------------------------------------------

global $import_summary;
$import_summary = array();

global $executed_queries;
$executed_queries = array();

global $track_queries;
$track_queries = false;

global $populated_tables_information;
$populated_tables_information = array();

//-- Views --------------------------------------------------------------------------------------------------------------------------------------------------------------

$collection_table_query = '
		SELECT
		Collection.id AS collection_id,
		Collection.bank_id AS bank_id,
		Collection.sop_master_id AS sop_master_id,
		Collection.participant_id AS participant_id,
		Collection.diagnosis_master_id AS diagnosis_master_id,
		Collection.consent_master_id AS consent_master_id,
		Collection.treatment_master_id AS treatment_master_id,
		Collection.event_master_id AS event_master_id,
Collection.procure_visit AS procure_visit,
Collection.procure_collected_by_bank AS procure_collected_by_bank,
		Participant.participant_identifier AS participant_identifier,
Participant.procure_participant_attribution_number,
		Collection.acquisition_label AS acquisition_label,
		Collection.collection_site AS collection_site,
		Collection.collection_datetime AS collection_datetime,
		Collection.collection_datetime_accuracy AS collection_datetime_accuracy,
		Collection.collection_property AS collection_property,
		Collection.collection_notes AS collection_notes,
		Collection.created AS created
		FROM collections AS Collection
		LEFT JOIN participants AS Participant ON Collection.participant_id = Participant.id AND Participant.deleted <> 1
		WHERE Collection.deleted <> 1 %%WHERE%%';

$sample_table_query = '
		SELECT SampleMaster.id AS sample_master_id,
		SampleMaster.parent_id AS parent_id,
		SampleMaster.initial_specimen_sample_id,
		SampleMaster.collection_id AS collection_id,
	
		Collection.bank_id,
		Collection.sop_master_id,
		Collection.participant_id,
	
		Participant.participant_identifier,
Participant.procure_participant_attribution_number,
	
		Collection.acquisition_label,
Collection.procure_visit AS procure_visit,
	
		SpecimenSampleControl.sample_type AS initial_specimen_sample_type,
		SpecimenSampleMaster.sample_control_id AS initial_specimen_sample_control_id,
		ParentSampleControl.sample_type AS parent_sample_type,
		ParentSampleMaster.sample_control_id AS parent_sample_control_id,
		SampleControl.sample_type,
		SampleMaster.sample_control_id,
		SampleMaster.sample_code,
		SampleControl.sample_category,
SampleMaster.procure_created_by_bank,
	
		IF(SpecimenDetail.reception_datetime IS NULL, NULL,
		 IF(Collection.collection_datetime IS NULL, -1,
		 IF(Collection.collection_datetime_accuracy != "c" OR SpecimenDetail.reception_datetime_accuracy != "c", -2,
		 IF(Collection.collection_datetime > SpecimenDetail.reception_datetime, -3,
		 TIMESTAMPDIFF(MINUTE, Collection.collection_datetime, SpecimenDetail.reception_datetime))))) AS coll_to_rec_spent_time_msg,
		
		IF(DerivativeDetail.creation_datetime IS NULL, NULL,
		 IF(Collection.collection_datetime IS NULL, -1,
		 IF(Collection.collection_datetime_accuracy != "c" OR DerivativeDetail.creation_datetime_accuracy != "c", -2,
		 IF(Collection.collection_datetime > DerivativeDetail.creation_datetime, -3,
		 TIMESTAMPDIFF(MINUTE, Collection.collection_datetime, DerivativeDetail.creation_datetime))))) AS coll_to_creation_spent_time_msg
	
		FROM sample_masters AS SampleMaster
		INNER JOIN sample_controls as SampleControl ON SampleMaster.sample_control_id=SampleControl.id
		INNER JOIN collections AS Collection ON Collection.id = SampleMaster.collection_id AND Collection.deleted != 1
		LEFT JOIN specimen_details AS SpecimenDetail ON SpecimenDetail.sample_master_id=SampleMaster.id
		LEFT JOIN derivative_details AS DerivativeDetail ON DerivativeDetail.sample_master_id=SampleMaster.id
		LEFT JOIN sample_masters AS SpecimenSampleMaster ON SampleMaster.initial_specimen_sample_id = SpecimenSampleMaster.id AND SpecimenSampleMaster.deleted != 1
		LEFT JOIN sample_controls AS SpecimenSampleControl ON SpecimenSampleMaster.sample_control_id = SpecimenSampleControl.id
		LEFT JOIN sample_masters AS ParentSampleMaster ON SampleMaster.parent_id = ParentSampleMaster.id AND ParentSampleMaster.deleted != 1
		LEFT JOIN sample_controls AS ParentSampleControl ON ParentSampleMaster.sample_control_id = ParentSampleControl.id
		LEFT JOIN participants AS Participant ON Collection.participant_id = Participant.id AND Participant.deleted != 1
		WHERE SampleMaster.deleted != 1 %%WHERE%%';	

$aliquot_table_query = '
		SELECT
		AliquotMaster.id AS aliquot_master_id,
		AliquotMaster.sample_master_id AS sample_master_id,
		AliquotMaster.collection_id AS collection_id,
		Collection.bank_id,
		AliquotMaster.storage_master_id AS storage_master_id,
		Collection.participant_id,
	
		Participant.participant_identifier,
Participant.procure_participant_attribution_number,
		
		Collection.acquisition_label,
Collection.procure_visit AS procure_visit,
		
		SpecimenSampleControl.sample_type AS initial_specimen_sample_type,
		SpecimenSampleMaster.sample_control_id AS initial_specimen_sample_control_id,
		ParentSampleControl.sample_type AS parent_sample_type,
		ParentSampleMaster.sample_control_id AS parent_sample_control_id,
		SampleControl.sample_type,
		SampleMaster.sample_control_id,
	
		AliquotMaster.barcode,
		AliquotMaster.aliquot_label,
		AliquotControl.aliquot_type,
		AliquotMaster.aliquot_control_id,
		AliquotMaster.in_stock,
		AliquotMaster.in_stock_detail,
		StudySummary.title AS study_summary_title,
		StudySummary.id AS study_summary_id,
AliquotMaster.procure_created_by_bank,
		
		StorageMaster.code,
		StorageMaster.selection_label,
		AliquotMaster.storage_coord_x,
		AliquotMaster.storage_coord_y,
	
		StorageMaster.temperature,
		StorageMaster.temp_unit,
	
		AliquotMaster.created,
	
		IF(AliquotMaster.storage_datetime IS NULL, NULL,
		 IF(Collection.collection_datetime IS NULL, -1,
		 IF(Collection.collection_datetime_accuracy != "c" OR AliquotMaster.storage_datetime_accuracy != "c", -2,
		 IF(Collection.collection_datetime > AliquotMaster.storage_datetime, -3,
		 TIMESTAMPDIFF(MINUTE, Collection.collection_datetime, AliquotMaster.storage_datetime))))) AS coll_to_stor_spent_time_msg,
		IF(AliquotMaster.storage_datetime IS NULL, NULL,
		 IF(SpecimenDetail.reception_datetime IS NULL, -1,
		 IF(SpecimenDetail.reception_datetime_accuracy != "c" OR AliquotMaster.storage_datetime_accuracy != "c", -2,
		 IF(SpecimenDetail.reception_datetime > AliquotMaster.storage_datetime, -3,
		 TIMESTAMPDIFF(MINUTE, SpecimenDetail.reception_datetime, AliquotMaster.storage_datetime))))) AS rec_to_stor_spent_time_msg,
		IF(AliquotMaster.storage_datetime IS NULL, NULL,
		 IF(DerivativeDetail.creation_datetime IS NULL, -1,
		 IF(DerivativeDetail.creation_datetime_accuracy != "c" OR AliquotMaster.storage_datetime_accuracy != "c", -2,
		 IF(DerivativeDetail.creation_datetime > AliquotMaster.storage_datetime, -3,
		 TIMESTAMPDIFF(MINUTE, DerivativeDetail.creation_datetime, AliquotMaster.storage_datetime))))) AS creat_to_stor_spent_time_msg,

		IF(LENGTH(AliquotMaster.notes) > 0, "y", "n") AS has_notes
	
		FROM aliquot_masters AS AliquotMaster
		INNER JOIN aliquot_controls AS AliquotControl ON AliquotMaster.aliquot_control_id = AliquotControl.id
		INNER JOIN sample_masters AS SampleMaster ON SampleMaster.id = AliquotMaster.sample_master_id AND SampleMaster.deleted != 1
		INNER JOIN sample_controls AS SampleControl ON SampleMaster.sample_control_id = SampleControl.id
		INNER JOIN collections AS Collection ON Collection.id = SampleMaster.collection_id AND Collection.deleted != 1
		LEFT JOIN sample_masters AS SpecimenSampleMaster ON SampleMaster.initial_specimen_sample_id = SpecimenSampleMaster.id AND SpecimenSampleMaster.deleted != 1
		LEFT JOIN sample_controls AS SpecimenSampleControl ON SpecimenSampleMaster.sample_control_id = SpecimenSampleControl.id
		LEFT JOIN sample_masters AS ParentSampleMaster ON SampleMaster.parent_id = ParentSampleMaster.id AND ParentSampleMaster.deleted != 1
		LEFT JOIN sample_controls AS ParentSampleControl ON ParentSampleMaster.sample_control_id=ParentSampleControl.id
		LEFT JOIN participants AS Participant ON Collection.participant_id = Participant.id AND Participant.deleted != 1
		LEFT JOIN storage_masters AS StorageMaster ON StorageMaster.id = AliquotMaster.storage_master_id AND StorageMaster.deleted != 1
		LEFT JOIN specimen_details AS SpecimenDetail ON AliquotMaster.sample_master_id=SpecimenDetail.sample_master_id
		LEFT JOIN derivative_details AS DerivativeDetail ON AliquotMaster.sample_master_id=DerivativeDetail.sample_master_id
		LEFT JOIN study_summaries AS StudySummary ON StudySummary.id = AliquotMaster.study_summary_id AND StudySummary.deleted != 1
		WHERE AliquotMaster.deleted != 1 %%WHERE%%';

$use_table_query = "
		SELECT CONCAT(AliquotInternalUse.id,6) AS id,
		AliquotMaster.id AS aliquot_master_id,
		AliquotInternalUse.type AS use_definition,
		AliquotInternalUse.use_code AS use_code,
		AliquotInternalUse.use_details AS use_details,
		AliquotInternalUse.used_volume AS used_volume,
		AliquotControl.volume_unit AS aliquot_volume_unit,
		AliquotInternalUse.use_datetime AS use_datetime,
		AliquotInternalUse.use_datetime_accuracy AS use_datetime_accuracy,
		AliquotInternalUse.duration AS duration,
		AliquotInternalUse.duration_unit AS duration_unit,
		AliquotInternalUse.used_by AS used_by,
		AliquotInternalUse.created AS created,
		CONCAT('/InventoryManagement/AliquotMasters/detailAliquotInternalUse/',AliquotMaster.id,'/',AliquotInternalUse.id) AS detail_url,
		SampleMaster.id AS sample_master_id,
		SampleMaster.collection_id AS collection_id,
		StudySummary.id AS study_summary_id,
		StudySummary.title AS study_title,
AliquotInternalUse.procure_created_by_bank AS procure_created_by_bank
		FROM aliquot_internal_uses AS AliquotInternalUse
		JOIN aliquot_masters AS AliquotMaster ON AliquotMaster.id = AliquotInternalUse.aliquot_master_id
		JOIN aliquot_controls AS AliquotControl ON AliquotMaster.aliquot_control_id = AliquotControl.id
		JOIN sample_masters AS SampleMaster ON SampleMaster.id = AliquotMaster.sample_master_id
		LEFT JOIN study_summaries AS StudySummary ON StudySummary.id = AliquotInternalUse.study_summary_id AND StudySummary.deleted != 1
		WHERE AliquotInternalUse.deleted <> 1 %%WHERE%%
	
		UNION ALL
	
		SELECT CONCAT(SourceAliquot.id,1) AS `id`,
		AliquotMaster.id AS aliquot_master_id,
		CONCAT('sample derivative creation#', SampleMaster.sample_control_id) AS use_definition,
		SampleMaster.sample_code AS use_code,
		'' AS `use_details`,
		SourceAliquot.used_volume AS used_volume,
		AliquotControl.volume_unit AS aliquot_volume_unit,
		DerivativeDetail.creation_datetime AS use_datetime,
		DerivativeDetail.creation_datetime_accuracy AS use_datetime_accuracy,
		NULL AS `duration`,
		'' AS `duration_unit`,
		DerivativeDetail.creation_by AS used_by,
		SourceAliquot.created AS created,
		CONCAT('/InventoryManagement/SampleMasters/detail/',SampleMaster.collection_id,'/',SampleMaster.id) AS detail_url,
		SampleMaster2.id AS sample_master_id,
		SampleMaster2.collection_id AS collection_id,
		NULL AS study_summary_id,
		'' AS study_title,
SampleMaster.procure_created_by_bank AS procure_created_by_bank
		FROM source_aliquots AS SourceAliquot
		JOIN sample_masters AS SampleMaster ON SampleMaster.id = SourceAliquot.sample_master_id
		JOIN derivative_details AS DerivativeDetail ON SampleMaster.id = DerivativeDetail.sample_master_id
		JOIN aliquot_masters AS AliquotMaster ON AliquotMaster.id = SourceAliquot.aliquot_master_id
		JOIN aliquot_controls AS AliquotControl ON AliquotMaster.aliquot_control_id = AliquotControl.id
		JOIN sample_masters SampleMaster2 ON SampleMaster2.id = AliquotMaster.sample_master_id
		WHERE SourceAliquot.deleted <> 1 %%WHERE%%
	
		UNION ALL
	
		SELECT CONCAT(Realiquoting.id ,2) AS id,
		AliquotMaster.id AS aliquot_master_id,
IF(Realiquoting.procure_central_is_transfer = '1', '###system_transfer_flag###', 'realiquoted to') AS use_definition,
		AliquotMasterChild.barcode AS use_code,
		'' AS use_details,
		Realiquoting.parent_used_volume AS used_volume,
		AliquotControl.volume_unit AS aliquot_volume_unit,
		Realiquoting.realiquoting_datetime AS use_datetime,
		Realiquoting.realiquoting_datetime_accuracy AS use_datetime_accuracy,
		NULL AS duration,
		'' AS duration_unit,
		Realiquoting.realiquoted_by AS used_by,
		Realiquoting.created AS created,
		CONCAT('/InventoryManagement/AliquotMasters/detail/',AliquotMasterChild.collection_id,'/',AliquotMasterChild.sample_master_id,'/',AliquotMasterChild.id) AS detail_url,
		SampleMaster.id AS sample_master_id,
		SampleMaster.collection_id AS collection_id,
		NULL AS study_summary_id,
		'' AS study_title,
AliquotMasterChild.procure_created_by_bank AS procure_created_by_bank
		FROM realiquotings AS Realiquoting
		JOIN aliquot_masters AS AliquotMaster ON AliquotMaster.id = Realiquoting.parent_aliquot_master_id
		JOIN aliquot_controls AS AliquotControl ON AliquotMaster.aliquot_control_id = AliquotControl.id
		JOIN aliquot_masters AS AliquotMasterChild ON AliquotMasterChild.id = Realiquoting.child_aliquot_master_id
		JOIN sample_masters AS SampleMaster ON SampleMaster.id = AliquotMaster.sample_master_id
		WHERE Realiquoting.deleted <> 1 %%WHERE%%
	
		UNION ALL
	
		SELECT CONCAT(QualityCtrl.id,3) AS id,
		AliquotMaster.id AS aliquot_master_id,
		'quality control' AS use_definition,
		QualityCtrl.qc_code AS use_code,
		'' AS use_details,
		QualityCtrl.used_volume AS used_volume,
		AliquotControl.volume_unit AS aliquot_volume_unit,
		QualityCtrl.date AS use_datetime,
		QualityCtrl.date_accuracy AS use_datetime_accuracy,
		NULL AS duration,
		'' AS duration_unit,
		QualityCtrl.run_by AS used_by,
		QualityCtrl.created AS created,
		CONCAT('/InventoryManagement/QualityCtrls/detail/',AliquotMaster.collection_id,'/',AliquotMaster.sample_master_id,'/',QualityCtrl.id) AS detail_url,
		SampleMaster.id AS sample_master_id,
		SampleMaster.collection_id AS collection_id,
		NULL AS study_summary_id,
		'' AS study_title,
QualityCtrl.procure_created_by_bank AS procure_created_by_bank
		FROM quality_ctrls AS QualityCtrl
		JOIN aliquot_masters AS AliquotMaster ON AliquotMaster.id = QualityCtrl.aliquot_master_id
		JOIN aliquot_controls AS AliquotControl ON AliquotMaster.aliquot_control_id = AliquotControl.id
		JOIN sample_masters AS SampleMaster ON SampleMaster.id = AliquotMaster.sample_master_id
		WHERE QualityCtrl.deleted <> 1 %%WHERE%%
	
		UNION ALL
	
		SELECT CONCAT(OrderItem.id, 4) AS id,
		AliquotMaster.id AS aliquot_master_id,
		IF(OrderItem.shipment_id, 'aliquot shipment', 'order preparation') AS use_definition,
		IF(OrderItem.shipment_id, Shipment.shipment_code, Order.order_number) AS use_code,
		'' AS use_details,
		NULL AS used_volume,
		'' AS aliquot_volume_unit,
		IF(OrderItem.shipment_id, Shipment.datetime_shipped, OrderItem.date_added) AS use_datetime,
		IF(OrderItem.shipment_id, Shipment.datetime_shipped_accuracy, IF(OrderItem.date_added_accuracy = 'c', 'h', OrderItem.date_added_accuracy)) AS use_datetime_accuracy,
		NULL AS duration,
		'' AS duration_unit,
		IF(OrderItem.shipment_id, Shipment.shipped_by, OrderItem.added_by) AS used_by,
		IF(OrderItem.shipment_id, Shipment.created, OrderItem.created) AS created,
		IF(OrderItem.shipment_id,
				CONCAT('/Order/Shipments/detail/',OrderItem.order_id,'/',OrderItem.shipment_id),
				IF(OrderItem.order_line_id,
						CONCAT('/Order/OrderLines/detail/',OrderItem.order_id,'/',OrderItem.order_line_id),
						CONCAT('/Order/Orders/detail/',OrderItem.order_id))
		) AS detail_url,
		SampleMaster.id AS sample_master_id,
		SampleMaster.collection_id AS collection_id,
		IF(OrderLine.study_summary_id, OrderLine.study_summary_id, Order.default_study_summary_id) AS study_summary_id,
		IF(OrderLine.study_summary_id, OrderLineStudySummary.title, OrderStudySummary.title) AS study_title,
OrderItem.procure_created_by_bank
		FROM order_items OrderItem
		JOIN aliquot_masters AS AliquotMaster ON AliquotMaster.id = OrderItem.aliquot_master_id
		LEFT JOIN shipments AS Shipment ON Shipment.id = OrderItem.shipment_id
		JOIN sample_masters SampleMaster ON SampleMaster.id = AliquotMaster.sample_master_id
		LEFT JOIN order_lines AS OrderLine ON  OrderLine.id = OrderItem.order_line_id
		LEFT JOIN study_summaries AS OrderLineStudySummary ON OrderLineStudySummary.id = OrderLine.study_summary_id AND OrderLineStudySummary.deleted != 1
		JOIN `orders` AS `Order` ON  Order.id = OrderItem.order_id
		LEFT JOIN study_summaries AS OrderStudySummary ON OrderStudySummary.id = Order.default_study_summary_id AND OrderStudySummary.deleted != 1
		WHERE OrderItem.deleted <> 1 %%WHERE%%
	
		UNION ALL
	
		SELECT CONCAT(OrderItem.id, 7) AS id,
		AliquotMaster.id AS aliquot_master_id,
		'shipped aliquot return' AS use_definition,
		Shipment.shipment_code AS use_code,
		'' AS use_details,
		NULL AS used_volume,
		'' AS aliquot_volume_unit,
		OrderItem.date_returned AS use_datetime,
		IF(OrderItem.date_returned_accuracy = 'c', 'h', OrderItem.date_returned_accuracy) AS use_datetime_accuracy,
		NULL AS duration,
		'' AS duration_unit,
		OrderItem.reception_by AS used_by,
		OrderItem.modified AS created,
		CONCAT('/Order/Shipments/detail/',OrderItem.order_id,'/',OrderItem.shipment_id) AS detail_url,
		SampleMaster.id AS sample_master_id,
		SampleMaster.collection_id AS collection_id,
		IF(OrderLine.study_summary_id, OrderLine.study_summary_id, Order.default_study_summary_id) AS study_summary_id,
		IF(OrderLine.study_summary_id, OrderLineStudySummary.title, OrderStudySummary.title) AS study_title,
OrderItem.procure_created_by_bank
		FROM order_items OrderItem
		JOIN aliquot_masters AS AliquotMaster ON AliquotMaster.id = OrderItem.aliquot_master_id
		JOIN shipments AS Shipment ON Shipment.id = OrderItem.shipment_id
		JOIN sample_masters SampleMaster ON SampleMaster.id = AliquotMaster.sample_master_id
		LEFT JOIN order_lines AS OrderLine ON  OrderLine.id = OrderItem.order_line_id
		LEFT JOIN study_summaries AS OrderLineStudySummary ON OrderLineStudySummary.id = OrderLine.study_summary_id AND OrderLineStudySummary.deleted != 1
		JOIN `orders` AS `Order` ON  Order.id = OrderItem.order_id
		LEFT JOIN study_summaries AS OrderStudySummary ON OrderStudySummary.id = Order.default_study_summary_id AND OrderStudySummary.deleted != 1
		WHERE OrderItem.deleted <> 1 AND OrderItem.status = 'shipped & returned' %%WHERE%%
	
		UNION ALL
	
		SELECT CONCAT(AliquotReviewMaster.id,5) AS id,
		AliquotMaster.id AS aliquot_master_id,
		'specimen review' AS use_definition,
		SpecimenReviewMaster.review_code AS use_code,
		'' AS use_details,
		NULL AS used_volume,
		'' AS aliquot_volume_unit,
		SpecimenReviewMaster.review_date AS use_datetime,
		SpecimenReviewMaster.review_date_accuracy AS use_datetime_accuracy,
		NULL AS duration,
		'' AS duration_unit,
		'' AS used_by,
		AliquotReviewMaster.created AS created,
		CONCAT('/InventoryManagement/SpecimenReviews/detail/',AliquotMaster.collection_id,'/',AliquotMaster.sample_master_id,'/',SpecimenReviewMaster.id) AS detail_url,
		SampleMaster.id AS sample_master_id,
		SampleMaster.collection_id AS collection_id,
		NULL AS study_summary_id,
		'' AS study_title,
AliquotReviewMaster.procure_created_by_bank
		FROM aliquot_review_masters AS AliquotReviewMaster
		JOIN aliquot_masters AS AliquotMaster ON AliquotMaster.id = AliquotReviewMaster.aliquot_master_id
		JOIN specimen_review_masters AS SpecimenReviewMaster ON SpecimenReviewMaster.id = AliquotReviewMaster.specimen_review_master_id
		JOIN sample_masters AS SampleMaster ON SampleMaster.id = AliquotMaster.sample_master_id
		WHERE AliquotReviewMaster.deleted <> 1 %%WHERE%%";

//==================================================================================================================================================================================
// DATABSE CONNECTION
//==================================================================================================================================================================================

function connectToCentralDatabase() {
	global $db_ip;
	global $db_port;
	global $db_user;
	global $db_pwd;
	global $db_charset;
	global $db_connection;
	global $db_central_schemas;
	
	$db_connection = @mysqli_connect(
			$db_ip.(!empty($db_port)? ":".$db_port : ''),
			$db_user,
			$db_pwd
	) or die("ERR_DATABASE_CONNECTION: Could not connect to MySQL");
	if(!mysqli_set_charset($db_connection, $db_charset)) die("ERR_DATABASE_CONNECTION: Invalid charset");
	@mysqli_select_db($db_connection, $db_central_schemas) or die("ERR_CENTRAL_SCHEMA: Unable to use central database : $db_central_schemas");
	$res_autocommit = mysqli_autocommit($db_connection , false);
	if(!$res_autocommit) die("ERR_DATABASE_CONNECTION: Could not set autocommit to false");
	//TODO autocommit seams to not work
	
	// Set merge date and user id
	
	global $merge_user_id;
	global $import_date;
	global $imported_by;
	
	$query_result = getSelectQueryResult("SELECT NOW() AS import_date, id FROM users WHERE id = '$merge_user_id';");
	if(empty($query_result)) {
		mergeDie("ERR_DATABASE_CONNECTION: merge user id '$merge_user_id' does not exist into $db_schema");
	}
	$import_date = $query_result[0]['import_date'];
	$imported_by = $query_result[0]['id'];
}

function testDbSchemas($db_schema, $site) {
	global $db_connection;
	global $db_sites_schemas;

	if($db_schema) {
		if(!mysqli_query($db_connection, "SELECT count(*) from $db_schema.aliquot_controls")) {
			pr("SELECT count(*) from $db_schema.aliquot_controls");exit;
			recordErrorAndMessage('ATiM Database Check', '@@ERROR@@', "Wrong DB schema and/or content", '', "Unable to connect to the schema $db_schema defined for site $site (or to the aliquot_controls table). No data will be imported from this site.");
			return false;
		} else {
			$query_result = mysqli_query($db_connection, "SELECT created FROM $db_schema.atim_procure_dump_information LIMIT 0 ,1");
			if($query_result) {
				$atim_dump_data = $query_result->fetch_assoc();
				$atim_dump_data['created'];
				recordErrorAndMessage('Merge Information', '@@MESSAGE@@', "Site Dump Information", '', "Dump of '$site' database created on '".$atim_dump_data['created'].".");
				return true;
			} else {
				recordErrorAndMessage('ATiM Database Check', '@@ERROR@@', "Missing atim_procure_dump_information Table Data", '', "See data of site '$site'. No data will be imported from this site.");
				return false;
			}
		}
	} else {
		recordErrorAndMessage('ATiM Database Check', '@@WARNING@@', "No DB schema defined", '', "No schema defined for site '$site'. No data will be imported from this site.");
		return false;
	}
	return false;
}

//==================================================================================================================================================================================
// FUNCTIONS ON MERGED DATA
//==================================================================================================================================================================================

// CONTROLS

function getControls($db_schema) {
	$atim_controls = array();
	
	//*** Control : sample_controls ***
	$atim_controls['sample_controls'] = array();
	$query_result = getSelectQueryResult("SELECT parent_sample_control_id, derivative_sample_control_id FROM $db_schema.parent_to_derivative_sample_controls WHERE flag_active = 1");
	foreach($query_result as $unit){
		$key = $unit["parent_sample_control_id"];
		$value = $unit["derivative_sample_control_id"];
		if(!isset($relations[$key])){
			$relations[$key] = array();
		}
		$relations[$key][] = $value;
	}
	$active_sample_control_ids = getActiveSampleControlIds($relations, "");
	$ids_to_types = array();
	foreach(getSelectQueryResult("SELECT id, sample_type, sample_category, detail_tablename FROM $db_schema.sample_controls WHERE id IN (".implode(',', $active_sample_control_ids).")") as $new_sample_control) {
		$atim_controls['sample_controls'][$new_sample_control['sample_type']] = $new_sample_control;
		$ids_to_types[$new_sample_control['id']] = $new_sample_control['sample_type'];
	}
	$atim_controls['sample_controls']['***id_to_type***'] = $ids_to_types;
	
	//*** Control : aliquot_controls ***
	$atim_controls['aliquot_controls'] = array();
	$query = "SELECT ac.id, sample_type, aliquot_type, ac.detail_tablename, volume_unit 
		FROM $db_schema.aliquot_controls ac INNER JOIN $db_schema.sample_controls sc ON sc.id = ac.sample_control_id 
		WHERE ac.flag_active = '1' AND ac.sample_control_id IN (".implode(',', $active_sample_control_ids).")";
	foreach(getSelectQueryResult($query) as $new_aliquot_control) $atim_controls['aliquot_controls'][$new_aliquot_control['sample_type'].'-'.$new_aliquot_control['aliquot_type']] = $new_aliquot_control;
	//*** Control : consent_controls ***
	$atim_controls['consent_controls'] = array();
	foreach(getSelectQueryResult("SELECT id, controls_type, detail_tablename FROM $db_schema.consent_controls WHERE flag_active = 1") as $new_control) $atim_controls['consent_controls'][$new_control['controls_type']] = $new_control;
	//*** Control : event_controls ***
	$atim_controls['event_controls'] = array();
	foreach(getSelectQueryResult("SELECT id, disease_site, event_type, detail_tablename FROM $db_schema.event_controls WHERE flag_active = 1") as $new_control) $atim_controls['event_controls'][(strlen($new_control['disease_site'])? $new_control['disease_site'].'-': '').$new_control['event_type']] = $new_control;
	//*** Control : misc_identifier_controls ***
	$atim_controls['misc_identifier_controls'] = array();
	foreach(getSelectQueryResult("SELECT id, misc_identifier_name, flag_active, autoincrement_name, misc_identifier_format, flag_once_per_participant, flag_unique FROM $db_schema.misc_identifier_controls WHERE flag_active = 1") as $new_control) $atim_controls['misc_identifier_controls'][$new_control['misc_identifier_name']] = $new_control;
	//*** Control : storage_controls ***
	$atim_controls['storage_controls'] = array();
	foreach(getSelectQueryResult("SELECT id, storage_type, coord_x_title, coord_x_type, coord_x_size, coord_y_title, coord_y_type, coord_y_size, display_x_size, display_y_size , set_temperature, is_tma_block, detail_tablename FROM $db_schema.storage_controls WHERE flag_active = 1") as $new_control) $atim_controls['storage_controls'][$new_control['storage_type']] = $new_control;
	//*** Control : treatment_controls ***
	$atim_controls['treatment_controls'] = array();
	$query  = "SELECT tc.id, disease_site, tx_method, tc.detail_tablename, applied_protocol_control_id, tec.id AS treatment_extend_control_id, tec.detail_tablename AS treatment_extend_detail_tablename
		FROM $db_schema.treatment_controls tc LEFT JOIN $db_schema.treatment_extend_controls tec ON tc.treatment_extend_control_id = tec.id AND tec.flag_active = 1
		WHERE tc.flag_active = 1";
	foreach(getSelectQueryResult($query) as $new_control) $atim_controls['treatment_controls'][(strlen($new_control['disease_site'])?$new_control['disease_site'].'-':'').$new_control['tx_method']] = $new_control;
	//*** Control : specimen_review_controls ***
	$atim_controls['specimen_review_controls'] = array();
	$query  = "SELECT src.id, src.review_type, sample_control_id, src.detail_tablename, arc.id AS aliquot_review_control_id, arc.review_type AS aliquot_review_type, arc.detail_tablename AS aliquot_review_detail_tablename, aliquot_type_restriction
		FROM $db_schema.specimen_review_controls src LEFT JOIN $db_schema.aliquot_review_controls arc ON src.aliquot_review_control_id = arc.id AND arc.flag_active = 1
		WHERE src.flag_active = 1";
	foreach(getSelectQueryResult($query) as $new_control) $atim_controls['specimen_review_controls'][$new_control['review_type']] = $new_control;
	ksort($atim_controls);
	
	return $atim_controls;
}

function getActiveSampleControlIds($relations, $current_check){
	$active_ids = array('-1');	//If no sample
	if(array_key_exists($current_check, $relations)) {
		foreach($relations[$current_check] as $sample_id){
			if($current_check != $sample_id && $sample_id != 'already_parsed'){
				$active_ids[] = $sample_id;
				if(isset($relations[$sample_id]) && !in_array('already_parsed', $relations[$sample_id])){
					$relations[$sample_id][] = 'already_parsed';
					$active_ids = array_merge($active_ids, getActiveSampleControlIds($relations, $sample_id));
				}
			}
		}
	}
	return array_unique($active_ids);
}

// POPULATED TABLES

function getTablesInformation($table_name) {
	global $populated_tables_information;

	if(!isset($populated_tables_information[$table_name])) {
		//First bank downloaded: Get fields and set previous max id to 0
		$table_fields = array();
		$primary_key = null;
		foreach(getSelectQueryResult("SHOW columns FROM $table_name;") as $new_field_data) {
			$table_fields[] = $new_field_data['Field'];
			if($new_field_data['Key'] == 'PRI') $primary_key = $new_field_data['Field'];
		}
		$populated_tables_information[$table_name] = array(
				'fields' => $table_fields,
				'primary_key' => $primary_key,
				'last_downloaded_bank_max_pk_value' => strlen($primary_key)? 0 : null);
	}
	return $populated_tables_information[$table_name];
}

function regenerateTablesInformation() {
	global $populated_tables_information;

	foreach($populated_tables_information as $table_name => $table_information) {
		if($table_information['primary_key']) {
			//Get the last primarey key value (max()) recorded into this table
			$atim_table_data = getSelectQueryResult("SELECT MAX(".$table_information['primary_key'].") AS max_record_id FROM $table_name");
			$populated_tables_information[$table_name]['last_downloaded_bank_max_pk_value'] = ($atim_table_data && $atim_table_data['0']['max_record_id'])? $atim_table_data['0']['max_record_id'] : 0;
		}
	}
}

// STORAGE

function updateStorageLftRghtAndLabel() {
	$lft_rght_id = 0;
	foreach(getSelectQueryResult("SELECT id, short_label FROM storage_masters WHERE deleted <> 1 AND (parent_id IS NULL OR parent_id LIKE '')") as $new_storage) {
		$storage_master_id = $new_storage['id'];
		$short_label= $new_storage['short_label'];
		$lft_rght_id++;
		$lft = $lft_rght_id;
		updateChildrenStorageLftRghtAndLabel($storage_master_id, $lft_rght_id,$short_label);
		$lft_rght_id++;
		$rght = $lft_rght_id;
		customQuery("UPDATE storage_masters SET lft = '$lft', rght = '$rght', selection_label = '".str_replace("'","''",$short_label)."' WHERE id = $storage_master_id");
	}
}

function updateChildrenStorageLftRghtAndLabel($parent_id, &$lft_rght_id, $parent_selection_label) {
	foreach(getSelectQueryResult("SELECT id, short_label FROM storage_masters WHERE deleted <> 1 AND parent_id = $parent_id") as $new_storage) {
		$storage_master_id = $new_storage['id'];
		$short_label= $new_storage['short_label'];
		$selection_label = $parent_selection_label.'-'.$short_label;
		$lft_rght_id++;
		$lft = $lft_rght_id;
		updateChildrenStorageLftRghtAndLabel($storage_master_id, $lft_rght_id, $selection_label);
		$lft_rght_id++;
		$rght = $lft_rght_id;
		customQuery("UPDATE storage_masters SET lft = '$lft', rght = '$rght', selection_label = '".str_replace("'","''",$selection_label)."' WHERE id = $storage_master_id");
	}
	return;
}

// BATCHSET

function createBatchSet($model, $title, $ids) {
	global $imported_by;
	global $import_date;

	if($ids) {
		$ids = is_array($ids)?  implode(',',$ids) : $ids ;
		if(!preg_match('/^[0-9,]+$/', $ids))  mergeDie("ERR_createBatchSet_#1 ('$title', '$model', '$ids')!");
		$datamart_structure_id = getSelectQueryResult("SELECT id FROM datamart_structures WHERE model = '$model';");
		if(!$datamart_structure_id || !isset($datamart_structure_id[0]['id'])) mergeDie("ERR_createBatchSet_#2 ('$title', '$model', '$ids')!");
		$datamart_structure_id = $datamart_structure_id[0]['id'];
		$query = "INSERT INTO `datamart_batch_sets` (user_id, group_id, sharing_status, title, description, `datamart_structure_id`, `created`, `created_by`, `modified`, `modified_by`)
		(SELECT id, group_id, 'all', '$title', '### Merge Process BatchSet ###', $datamart_structure_id, '$import_date', $imported_by, '$import_date', $imported_by FROM users WHERE id = $imported_by);";
		customQuery($query, true);
		$datamart_batch_set_id = getSelectQueryResult("SELECT id FROM datamart_batch_sets WHERE title = '$title'");
		if(!($datamart_batch_set_id && $datamart_batch_set_id['0']['id'])) mergeDie("ERR_createBatchSet_#3 ('$title', '$model', '$ids')!");
		$datamart_batch_set_id = $datamart_batch_set_id['0']['id'];
		$query = "INSERT INTO datamart_batch_ids (set_id, lookup_id) VALUES ($datamart_batch_set_id, ".str_replace(",", "), ($datamart_batch_set_id, ", $ids).");";
		customQuery($query, true);
	}
}

//==================================================================================================================================================================================
// MESSAGE DISPLAY
//==================================================================================================================================================================================

function mergeDie($error_messages) {
	global $db_connection;
	if(is_array($error_messages)) {
		foreach($error_messages as $msg) pr($msg);
	} else {
		pr($error_messages);
	}
	pr('-------------------------------------------------------------------------------------------------------------------------------------');
	$counter = 0;
	foreach(debug_backtrace() as $debug_data) {
		$counter++;
		pr("$counter- Function ".$debug_data['function']."() [File: ".$debug_data['file']." - Line: ".$debug_data['line']."]");
	}
	mysqli_rollback ($db_connection);
	die('Please contact your administrator');	
}

function pr($var) {
	echo '<pre>';
	print_r($var);
	echo '</pre>';
}

function displayMergeTitle($title) {
	global $import_date;
	global $merge_process_version;
	global $excel_files_paths;
	echo "<br><FONT COLOR=\"blue\">=====================================================================<br>
		<b><FONT COLOR=\"blue\">$title</b></FONT><br>
		<b><FONT COLOR=\"blue\">Version : </FONT>$merge_process_version</b><br>
		<b><FONT COLOR=\"blue\">Date : </FONT>$import_date</b><br>
		<FONT COLOR=\"blue\">=====================================================================</FONT><br>";
}

function recordErrorAndMessage($msg_data_type, $msg_level, $msg_title, $msg_description, $msg_detail, $msg_detail_key = null) {
	global $import_summary;
	if(is_null($msg_detail_key)) {
		$import_summary[$msg_data_type][$msg_level]["$msg_title#@#@#$msg_description"][] = $msg_detail;
	} else {
		$import_summary[$msg_data_type][$msg_level]["$msg_title#@#@#$msg_description"][$msg_detail_key] = $msg_detail;
	}
}

function dislayErrorAndMessage($commit = false) {
	global $import_summary;
	global $db_connection;
	global $track_queries;
	global $import_date;
	global $imported_by;
	
	if($track_queries) addQueryToMessages();
	
	customQuery("TRUNCATE procure_banks_data_merge_messages");
	
	echo "<br><FONT COLOR=\"blue\">
		=====================================================================<br>
		<b>Merge Summary</b><br>
		=====================================================================</FONT><br>";
	$err_counter = 0;
	foreach($import_summary as $msg_data_type => $data1) {
		echo "<br><br><FONT COLOR=\"0066FF\" >
		=====================================================================<br>
		$msg_data_type<br>
		=====================================================================</FONT><br>";
		foreach($data1 as $msg_level => $data2) {
			$color = 'black';
			$code = 'ER';
			switch($msg_level) {
				case '@@ERROR@@':
					$color = 'red';
					$code = 'Err';
					break;
				case '@@WARNING@@':
					$color = 'orange';
					$code = 'War';
					break;
				case '@@MESSAGE@@':
					$color = 'green';
					$code = 'Msg';
					break;
				default:
					echo '<br><br><br>UNSUPORTED message_type : '.$msg_level.'<br><br><br>';
			}
			foreach($data2 as $msg_title_and_description => $details) {
				preg_match('/^(.+)(#@#@#)(.*)$/', $msg_title_and_description, $matches);
				$msg_title = str_replace("\n", ' ', $matches[1]);
				$msg_title_for_db = str_replace("'", "''", $msg_title);
				$msg_description = str_replace("\n", ' ', $matches[3]);
				$msg_description_for_db = str_replace("'", "''", $msg_description);
				$err_counter++;
				echo "<br><br><FONT COLOR='$color' ><b>".utf8_decode("[$code#$err_counter] $msg_title")."</b></FONT><br>";
				if($msg_description) echo "<i><FONT COLOR=\black\" >".utf8_decode($msg_description)."</FONT></i><br>";
				foreach($details as $detail) {
					$detail = str_replace("\n", ' ', $detail);
					echo ' - '.utf8_decode($detail)."<br>";
					//Record data in db
					$detail = str_replace("'", "''", $detail);
					$query = "INSERT INTO procure_banks_data_merge_messages (type, message_nbr, title, description, details, created, created_by, modified, modified_by)
						VALUES 
						('".str_replace('@','',$msg_level)."', $err_counter, '$msg_title_for_db', '$msg_description_for_db', '$detail', '$import_date', $imported_by, '$import_date', $imported_by);";
					customQuery($query, true);
				}
			}
		}
	}
	
	$query = "INSERT INTO procure_banks_data_merge_messages (type, details, created, created_by, modified, modified_by)
		VALUES
		('merge_date', DATE(NOW()), '$import_date', $imported_by, '$import_date', $imported_by);";
	customQuery($query, true);
	
	if($commit) {
		customQuery($query);
		mysqli_commit($db_connection);
		$ccl = '& Commited';
	} else {
		$ccl = 'But Not Commited';
	}
	echo "<br><FONT COLOR=\"blue\">
		=====================================================================<br>
		<b>Merge Done $ccl</b><br>
		=====================================================================</FONT><br>";

}

//==================================================================================================================================================================================
// QUERY FUNCTIONS
//==================================================================================================================================================================================

/**
 * Exeute an sql statement.
 * 
 * @param string $query SQL statement
 * @param boolean $insert True for any $query being an INSERT statement
 * 
 * @return multitype Id of the insert when $insert set to TRUE else the mysqli_result object
 */
function customQuery($query, $insert = false) {
	global $db_connection;
	global $executed_queries;
	global $track_queries;
	
	if($track_queries) $executed_queries[] = $query;
	$query_res = mysqli_query($db_connection, $query) or mergeDie(array("ERR_QUERY", mysqli_error($db_connection), $query));
	return ($insert)? mysqli_insert_id($db_connection) : $query_res;
}

function addQueryToMessages() {
	global $executed_queries;
	
	foreach($executed_queries as $query) {
		recordErrorAndMessage('Executed Queries', '@@MESSAGE@@', "List of queries", '', $query);
	}
}

/**
 * Execute an sql SELECT statement and return results into an array.
 *
 * @param string $query SQL statement
 *
 * @return array Query results in an array
 */
function getSelectQueryResult($query) {
	if(!preg_match('/^[\ ]*((SELECT)|(SHOW))/i', $query))  mergeDie(array("ERR_QUERY", "'SELECT' query expected", $query));
	$select_result = array();
	$query_result = customQuery($query);
	while($row = $query_result->fetch_assoc()) {
		$select_result[] = $row;
	}
	return $select_result;
}

function magicSelectInsert($bank_schema, $table_name, $table_foreign_keys = array(), $specific_select_field_rules = array(), $compare_table_fields = false) {
	$table_information = getTablesInformation($table_name);    

    if($compare_table_fields) {
        $bank_schema_table_fields = array();
        foreach(getSelectQueryResult("SHOW columns FROM $bank_schema.$table_name;") as $new_field_data) {
            $bank_schema_table_fields[] = $new_field_data['Field'];
        }
        foreach($table_information['fields'] as $field_key => $field) {
            if(!in_array($field, $bank_schema_table_fields)) {
                unset($table_information['fields'][$field_key]);
            }
        }
    }

	//Get fields of table
	$insert_table_fields = $select_table_fields = $table_information['fields'];

	//Check Primary Key exists and increment this one if required
	if($table_information['primary_key']) {
		$primary_key = $table_information['primary_key'];
		$key_id = array_search($primary_key, $select_table_fields);
		$select_table_fields[$key_id] = "($primary_key + ".$table_information['last_downloaded_bank_max_pk_value'].")";
	}

	//Increment foreign_key if required (or id in specific cases like revs table (table_revs.id ref table.id))
	foreach($table_foreign_keys as $field => $linked_table_name) {
		$key_id = array_search($field, $select_table_fields);
		if($key_id !== false) {
			$linked_table_information = getTablesInformation($linked_table_name);
			if(!$linked_table_information['primary_key']) mergeDie("ER_magicSelectInsert_001 (".$table_name.".".$field." to ".$linked_table_name.").");
			$select_table_fields[$key_id] = "(".$field." + ".$linked_table_information['last_downloaded_bank_max_pk_value'].")";
		} else {
			//TODO Should if be displayed? recordErrorAndMessage('Function magicSelectInsert() : Messages for administrator', '@@WARNING@@', 'Validate field of $table_foreign_keys does not exist into table', "Field $field is not a field of $table_name", $field.$table_name);
		}
	}

	//Add specific field import rule
	foreach($specific_select_field_rules as $field => $rule) {
		$key_id = array_search($field, $select_table_fields);
		if($key_id === false) mergeDie("ER_magicSelectInsert_002 (".$table_name.".".$field.").");
		$select_table_fields[$key_id] = "($rule)";
	}

	//Select & Insert
	$query = "INSERT INTO $table_name (".implode(',',$insert_table_fields).") (SELECT ".implode(',',$select_table_fields)." FROM ".$bank_schema.".$table_name)";
	customQuery($query);
}
	
?>
		