<?php

class ReportsControllerCustom extends ReportsController
{
    public function sampleAndDerivativeCreationSummary($parameters)
    {
        if (! AppController::checkLinkPermission('/InventoryManagement/SampleMasters/detail')) {
            $this->atimFlashError(__('you need privileges to access this page'), Router::url(null, true));
        }
    
        // 1- Build Header
        $startDateForDisplay = AppController::getFormatedDateString($parameters[0]['report_datetime_range_start']['year'], $parameters[0]['report_datetime_range_start']['month'], $parameters[0]['report_datetime_range_start']['day']);
        $endDateForDisplay = AppController::getFormatedDateString($parameters[0]['report_datetime_range_end']['year'], $parameters[0]['report_datetime_range_end']['month'], $parameters[0]['report_datetime_range_end']['day']);
    
        $header = array(
            'title' => __('from') . ' ' . (empty($parameters[0]['report_datetime_range_start']['year']) ? '?' : $startDateForDisplay) . ' ' . __('to') . ' ' . (empty($parameters[0]['report_datetime_range_end']['year']) ? '?' : $endDateForDisplay),
            'description' => 'n/a'
        );
    
        $bankIds = array();
        if (isset($parameters[0]['bank_id'])) {
            foreach ($parameters[0]['bank_id'] as $bankId)
                if (! empty($bankId))
                    $bankIds[] = $bankId;
                if (! empty($bankIds)) {
                    $bank = AppModel::getInstance("Administrate", "Bank", true);
                    $bankList = $bank->find('all', array(
                        'conditions' => array(
                            'id' => $bankIds
                        )
                    ));
                    $bankNames = array();
                    foreach ($bankList as $newBank)
                        $bankNames[] = $newBank['Bank']['name'];
                    $header['description'] = __('bank') . ': ' . implode(',', $bankNames);
                }
        }
    
        // 2- Search data
    
        $bankConditions = empty($bankIds) ? 'TRUE' : 'col.bank_id IN (' . implode(',', $bankIds) . ')';
    
        $startDateForSql = AppController::getFormatedDatetimeSQL($parameters[0]['report_datetime_range_start'], 'start');
        $endDateForSql = AppController::getFormatedDatetimeSQL($parameters[0]['report_datetime_range_end'], 'end');
    
        $searchOnDateRange = true;
        if ((strpos($startDateForSql, '-9999') === 0) && (strpos($endDateForSql, '9999') === 0))
            $searchOnDateRange = false;
    
        $resFinal = array();
        $tmpResFinal = array();
    
        // Work on specimen
    
        $conditions = $searchOnDateRange ? "col.collection_datetime >= '$startDateForSql' AND col.collection_datetime <= '$endDateForSql'" : 'TRUE';
        $resSamples = $this->Report->tryCatchQuery("SELECT COUNT(*), sc.sample_type
            FROM sample_masters AS sm
            INNER JOIN sample_controls AS sc ON sm.sample_control_id=sc.id
			INNER JOIN collections AS col ON col.id = sm.collection_id
			INNER JOIN aliquot_masters AS alq ON alq.sample_master_id = sm.id
			WHERE col.mb_number IS NOT NULL
			AND col.mb_number != ''
            AND sc.sample_category = 'specimen'
            AND ($conditions)
            AND ($bankConditions)
			AND sm.deleted != '1'
			AND alq.in_stock LIKE '%yes%'
            GROUP BY sample_type;");
        $resParticipants = $this->Report->tryCatchQuery("SELECT COUNT(*), res.sample_type FROM (
            SELECT DISTINCT col.mb_number, sc.sample_type
            FROM sample_masters AS sm
            INNER JOIN sample_controls AS sc ON sm.sample_control_id=sc.id
            INNER JOIN collections AS col ON col.id = sm.collection_id
		    INNER JOIN aliquot_masters AS alq ON alq.sample_master_id = sm.id
			WHERE col.mb_number IS NOT NULL
			AND col.mb_number != ''
            AND sc.sample_category = 'specimen'
            AND ($conditions)
            AND ($bankConditions)
            AND sm.deleted != '1'
            AND alq.in_stock LIKE '%yes%'
        ) AS res GROUP BY res.sample_type;");
    
        foreach ($resSamples as $data) {
            $tmpResFinal['specimen-' . $data['sc']['sample_type']] = array(
                'SampleControl' => array(
                    'sample_category' => 'specimen',
                    'sample_type' => $data['sc']['sample_type']
                ),
                '0' => array(
                    'created_samples_nbr' => $data[0]['COUNT(*)'],
                    'matching_participant_number' => null
                )
            );
        }
        foreach ($resParticipants as $data) {
            $tmpResFinal['specimen-' . $data['res']['sample_type']]['0']['matching_participant_number'] = $data[0]['COUNT(*)'];
        }
    
        // Work on derivative
    
        $conditions = $search_on_date_range? "col.collection_datetime >= '$start_date_for_sql' AND col.collection_datetime <= '$end_date_for_sql'" : 'TRUE';
        $resSamples = $this->Report->tryCatchQuery("SELECT COUNT(*), sc.sample_type
            FROM sample_masters AS sm
            INNER JOIN sample_controls AS sc ON sm.sample_control_id=sc.id
            INNER JOIN collections AS col ON col.id = sm.collection_id
		    INNER JOIN aliquot_masters AS alq ON alq.sample_master_id = sm.id
			WHERE col.mb_number IS NOT NULL
			AND col.mb_number != ''
            AND sc.sample_category = 'derivative'
            AND ($conditions)
            AND ($bankConditions)
            AND sm.deleted != '1'
            AND alq.in_stock LIKE '%yes%'
            GROUP BY sample_type;");
        $resParticipants = $this->Report->tryCatchQuery("SELECT COUNT(*), res.sample_type FROM (
            SELECT DISTINCT col.mb_number, sc.sample_type
            FROM sample_masters AS sm
            INNER JOIN sample_controls AS sc ON sm.sample_control_id=sc.id
            INNER JOIN collections AS col ON col.id = sm.collection_id
            INNER JOIN aliquot_masters AS alq ON alq.sample_master_id = sm.id
			WHERE col.mb_number IS NOT NULL
			AND col.mb_number != ''
            AND sc.sample_category = 'derivative'
            AND ($conditions)
            AND ($bankConditions)
            AND sm.deleted != '1'
            AND alq.in_stock LIKE '%yes%'
        ) AS res GROUP BY res.sample_type;");
    
        foreach ($resSamples as $data) {
            $tmpResFinal['derivative-' . $data['sc']['sample_type']] = array(
                'SampleControl' => array(
                    'sample_category' => 'derivative',
                    'sample_type' => $data['sc']['sample_type']
                ),
                '0' => array(
                    'created_samples_nbr' => $data[0]['COUNT(*)'],
                    'matching_participant_number' => null
                )
            );
        }
        foreach ($resParticipants as $data) {
            $tmpResFinal['derivative-' . $data['res']['sample_type']]['0']['matching_participant_number'] = $data[0]['COUNT(*)'];
        }
    
        // Format data for report
        foreach ($tmpResFinal as $newSampleTypeData) {
            $resFinal[] = $newSampleTypeData;
        }
    
        $arrayToReturn = array(
            'header' => $header,
            'data' => $resFinal,
            'columns_names' => null,
            'error_msg' => null
        );
    
        return $arrayToReturn;
    }
    
}