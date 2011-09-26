<?php

class ViewAliquotUse extends InventorymanagementAppModel {

	private $view_sub_queries = array(
		"SELECT 
		CONCAT(source.id, 1) AS id,
		aliq.id AS aliquot_master_id,
		'sample derivative creation' AS use_definition, 
		samp.sample_code AS use_code,
		'' AS use_details,
		source.used_volume,
		aliq.aliquot_volume_unit,
		der.creation_datetime AS use_datetime,
		der.creation_by AS used_by,
		source.created,
		CONCAT('|inventorymanagement|aliquot_masters|listAllSourceAliquots|',samp.collection_id ,'|',samp.id) AS detail_url,
		samp2.id AS sample_master_id,
		samp2.collection_id AS collection_id
		FROM source_aliquots AS source
		INNER JOIN sample_masters AS samp ON samp.id = source.sample_master_id  AND samp.deleted != 1
		INNER JOIN derivative_details AS der ON samp.id = der.sample_master_id  AND der.deleted != 1
		INNER JOIN aliquot_masters AS aliq ON aliq.id = source.aliquot_master_id AND aliq.deleted != 1
		INNER JOIN sample_masters AS samp2 ON samp2.id = aliq.sample_master_id  AND samp.deleted != 1
		WHERE source.deleted != 1",
	
		"SELECT 
		CONCAT(realiq.id, 2) AS id,
		aliq.id AS aliquot_master_id,
		'realiquoted to' AS use_definition, 
		child.barcode AS use_code,
		'' AS use_details,
		realiq.parent_used_volume AS used_volume,
		aliq.aliquot_volume_unit,
		realiq.realiquoting_datetime AS use_datetime,
		realiq.realiquoted_by AS used_by,
		realiq.created,
		CONCAT('|inventorymanagement|aliquot_masters|listAllRealiquotedParents|',child.collection_id,'|',child.sample_master_id,'|',child.id) AS detail_url,
		samp.id AS sample_master_id,
		samp.collection_id AS collection_id
		FROM realiquotings AS realiq
		INNER JOIN aliquot_masters AS aliq ON aliq.id = realiq.parent_aliquot_master_id AND aliq.deleted != 1
		INNER JOIN aliquot_masters AS child ON child.id = realiq.child_aliquot_master_id AND child.deleted != 1
		INNER JOIN sample_masters AS samp ON samp.id = aliq.sample_master_id  AND samp.deleted != 1
		WHERE realiq.deleted != 1",
	
		"SELECT 
		CONCAT(qc.id, 3) AS id,
		aliq.id AS aliquot_master_id,
		'quality control' AS use_definition, 
		qc.qc_code AS use_code,
		'' AS use_details,
		qc.used_volume,
		aliq.aliquot_volume_unit,
		qc.date AS use_datetime,
		qc.run_by AS used_by,
		qc.created,
		CONCAT('|inventorymanagement|quality_ctrls|detail|',aliq.collection_id,'|',aliq.sample_master_id,'|',qc.id) AS detail_url,
		samp.id AS sample_master_id,
		samp.collection_id AS collection_id
		FROM quality_ctrls AS qc
		INNER JOIN aliquot_masters AS aliq ON aliq.id = qc.aliquot_master_id AND aliq.deleted != 1
		INNER JOIN sample_masters AS samp ON samp.id = aliq.sample_master_id  AND samp.deleted != 1
		WHERE qc.deleted != 1",
	
		"SELECT 
		CONCAT(item.id, 4) AS id,
		aliq.id AS aliquot_master_id,
		'aliquot shipment' AS use_definition, 
		sh.shipment_code AS use_code,
		'' AS use_details,
		'' AS used_volume,
		'' AS aliquot_volume_unit,
		sh.datetime_shipped AS use_datetime,
		sh.shipped_by AS used_by,
		sh.created,
		CONCAT('|order|shipments|detail|',sh.order_id,'|',sh.id) AS detail_url,
		samp.id AS sample_master_id,
		samp.collection_id AS collection_id
		FROM order_items AS item
		INNER JOIN aliquot_masters AS aliq ON aliq.id = item.aliquot_master_id AND aliq.deleted != 1
		INNER JOIN shipments AS sh ON sh.id = item.shipment_id AND sh.deleted != 1
		INNER JOIN sample_masters AS samp ON samp.id = aliq.sample_master_id  AND samp.deleted != 1
		WHERE item.deleted != 1",
	
		"SELECT 
		CONCAT(alr.id, 5) AS id,
		aliq.id AS aliquot_master_id,
		'specimen review' AS use_definition, 
		spr.review_code AS use_code,
		'' AS use_details,
		'' AS used_volume,
		'' AS aliquot_volume_unit,
		spr.review_date AS use_datetime,
		'' AS used_by,
		alr.created,
		CONCAT('|inventorymanagement|specimen_reviews|detail|',aliq.collection_id,'|',aliq.sample_master_id,'|',spr.id) AS detail_url,
		samp.id AS sample_master_id,
		samp.collection_id AS collection_id
		FROM aliquot_review_masters AS alr
		INNER JOIN aliquot_masters AS aliq ON aliq.id = alr.aliquot_master_id AND aliq.deleted != 1
		INNER JOIN specimen_review_masters AS spr ON spr.id = alr.specimen_review_master_id AND spr.deleted != 1
		INNER JOIN sample_masters AS samp ON samp.id = aliq.sample_master_id  AND samp.deleted != 1
		WHERE alr.deleted != 1",
	
		"SELECT 
		CONCAT(aluse.id, 6) AS id,
		aliq.id AS aliquot_master_id,
		'internal use' AS use_definition, 
		aluse.use_code,
		aluse.use_details,
		aluse.used_volume,
		aliq.aliquot_volume_unit,
		aluse.use_datetime,
		aluse.used_by,
		aluse.created,
		CONCAT('|inventorymanagement|aliquot_masters|detailAliquotInternalUse|',aliq.id,'|',aluse.id) AS detail_url,
		samp.id AS sample_master_id,
		samp.collection_id AS collection_id
		FROM aliquot_internal_uses AS aluse
		INNER JOIN aliquot_masters AS aliq ON aliq.id = aluse.aliquot_master_id AND aliq.deleted != 1
		INNER JOIN sample_masters AS samp ON samp.id = aliq.sample_master_id  AND samp.deleted != 1
		WHERE aluse.deleted != 1");
	
	function findFastFromAliquotMasterId($aliquot_master_id) {
		//TODO: REPLACE BY A BETTER SOLUTION IN v2.3 (View use is too time consuming see issue 1352)
		$tmp_uses_list = array();
		foreach($this->view_sub_queries as $sub_query) {
			$sub_query_results = $this->query($sub_query." AND aliq.id = $aliquot_master_id");
			foreach($sub_query_results as $new_record) {
				$view_aliquot_use = array();
				foreach($new_record as $model => $data) {
					$view_aliquot_use = array_merge($view_aliquot_use,$data);
				}
				if((strlen($view_aliquot_use['use_datetime']) > 1) && (strpos($view_aliquot_use['use_datetime'], ':') == false)) {
					$view_aliquot_use['use_datetime'] .= ' 00:00';
				}	
				$tmp_uses_list[$view_aliquot_use['use_datetime']][] = $view_aliquot_use;
			}
		}
		krsort($tmp_uses_list);
		
		$uses_list = array();
		foreach($tmp_uses_list as $tmp => $records_set) {
			foreach($records_set as $data) {
				$uses_list[]['ViewAliquotUse'] = $data;
			}
		}
						
		return $uses_list;
	}

}

?>
