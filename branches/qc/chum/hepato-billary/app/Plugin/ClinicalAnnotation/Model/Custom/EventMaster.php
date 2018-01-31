<?php

class EventMasterCustom extends EventMaster
{

    var $useTable = 'event_masters';

    var $name = 'EventMaster';

    public function addBmiValue($eventData)
    {
        if ((isset($eventData['EventDetail']['weight'])) && (isset($eventData['EventDetail']['height']))) {
            $eventData['EventDetail']['bmi'] = '';
            // Format 'numeric' value
            $eventData['EventDetail']['weight'] = str_replace(',', '.', $eventData['EventDetail']['weight']);
            $eventData['EventDetail']['height'] = str_replace(',', '.', $eventData['EventDetail']['height']);
            $weight = $eventData['EventDetail']['weight'];
            $height = $eventData['EventDetail']['height'];
            if (is_numeric($weight) && is_numeric($height) && (! empty($height))) {
                $eventData['EventDetail']['bmi'] = ($weight / ($height * $height)) * 10000;
            }
        }
        return $eventData;
    }

    public function setHospitalizationDuration($eventData)
    {
        if (isset($eventData['EventDetail']['hospitalization_end_date']) && isset($eventData['EventMaster']['event_date'])) {
            $startDate = $eventData['EventMaster']['event_date'];
            $startDateAccuracy = isset($eventData['EventMaster']['event_date_accuracy']) ? $eventData['EventMaster']['event_date_accuracy'] : null;
            $endDate = $eventData['EventDetail']['hospitalization_end_date'];
            $endDateAccuracy = isset($eventData['EventDetail']['hospitalization_end_date_accuracy']) ? $eventData['EventDetail']['hospitalization_end_date_accuracy'] : null;
            $eventData['EventDetail']['hospitalization_duration_in_days'] = $this->getDuration($startDate, $endDate, 'hospitalization duration in days', $startDateAccuracy, $endDateAccuracy);
        }
        return $eventData;
    }

    public function setIntensiveCareDuration($eventData)
    {
        if (isset($eventData['EventDetail']['intensive_care_end_date']) && isset($eventData['EventMaster']['event_date'])) {
            $startDate = $eventData['EventMaster']['event_date'];
            $startDateAccuracy = isset($eventData['EventMaster']['event_date_accuracy']) ? $eventData['EventMaster']['event_date_accuracy'] : null;
            $endDate = $eventData['EventDetail']['intensive_care_end_date'];
            $endDateAccuracy = isset($eventData['EventDetail']['intensive_care_end_date_accuracy']) ? $eventData['EventDetail']['intensive_care_end_date_accuracy'] : null;
            $eventData['EventDetail']['intensive_care_duration_in_days'] = $this->getDuration($startDate, $endDate, 'intensive care duration in days', $startDateAccuracy, $endDateAccuracy);
        }
        return $eventData;
    }

    public function getDuration($startDate, $endDate, $fieldLabel, $startDateAccuracy = null, $endDateAccuracy = null)
    {
        if (! is_array($startDate)) {
            if ($startDateAccuracy != 'c') {
                $startDate = array(
                    'year' => null,
                    'month' => null,
                    'day' => null
                );
            } else {
                if (! preg_match('/^([0-9]{4})-([0-9]{2})\-([0-9]{2})$/', $startDate, $matches))
                    AppController::getInstance()->redirect('/Pages/err_plugin_system_error?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
                $startDate = array(
                    'year' => $matches[1],
                    'month' => $matches[2],
                    'day' => $matches[3]
                );
            }
        }
        if (! is_array($endDate)) {
            if ($endDateAccuracy != 'c') {
                $endDate = array(
                    'year' => null,
                    'month' => null,
                    'day' => null
                );
            } else {
                if (! preg_match('/^([0-9]{4})-([0-9]{2})\-([0-9]{2})$/', $endDate, $matches))
                    AppController::getInstance()->redirect('/Pages/err_plugin_system_error?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
                $endDate = array(
                    'year' => $matches[1],
                    'month' => $matches[2],
                    'day' => $matches[3]
                );
            }
        }
        if (empty($startDate['month']) || empty($startDate['day']) || empty($startDate['year']) || empty($endDate['month']) || empty($endDate['day']) || empty($endDate['year'])) {
            // At least one date is missing to continue
            AppController::addWarningMsg(str_replace('%field%', __($fieldLabel, true), __('the dates accuracy is not sufficient: the field [%%field%%] can not be generated', true)));
        } else {
            $start = $startDate['year'] . '-' . $startDate['month'] . '-' . $startDate['day'];
            $end = $endDate['year'] . '-' . $endDate['month'] . '-' . $endDate['day'];
            $StartDateObj = new DateTime($start);
            $EndDateObj = new DateTime($end);
            $interval = $StartDateObj->diff($EndDateObj);
            if ($interval->invert) {
                AppController::addWarningMsg(str_replace('%field%', __($fieldLabel, true), __('error in the dates definitions: the field [%%field%%] can not be generated', true)));
            } else {
                return $interval->format('%a');
            }
        }
        return '';
    }

    /**
     * Set participant surgeries list for hepatobiliary-lab-biology.
     *
     * @param $eventControl Event
     *            control of the created/studied event.
     * @param
     *            $particpantId
     */
    public function getParticipantSurgeriesList($eventControl, $participantId = null)
    {
        if ($eventControl['EventControl']['event_group'] . '-' . $eventControl['EventControl']['event_type'] == 'lab-biology') {
            $treatmentModel = AppModel::getInstance('ClinicalAnnotation', 'TreatmentMaster', true);
            $result = array(
                '' => ''
            );
            $criteria = array(
                "TreatmentControl.tx_method" => 'surgery'
            );
            if (! is_null($participantId))
                $criteria['TreatmentMaster.participant_id'] = $participantId;
            foreach ($treatmentModel->find('all', array(
                'conditions' => $criteria,
                'order' => 'TreatmentMaster.start_date DESC'
            )) as $newSurgery) {
                $result[$newSurgery['TreatmentMaster']['id']] = __($newSurgery['TreatmentControl']['disease_site'], true) . ' - ' . __($newSurgery['TreatmentControl']['tx_method'], true) . ' ' . $newSurgery['TreatmentMaster']['start_date'];
            }
            return $result;
        }
        return null;
    }

    public function completeVolumetry($eventData, &$submittedDataValidates)
    {
        if (isset($eventData['EventDetail']['is_volumetry_post_pve'])) {
            $remnantLiverVolume = '';
            $remnantLiverPercentage = '';
            if (isset($eventData['EventDetail']['total_liver_volume']) && is_numeric($eventData['EventDetail']['total_liver_volume']) && isset($eventData['EventDetail']['resected_liver_volume']) && is_numeric($eventData['EventDetail']['resected_liver_volume'])) {
                // Remanant liver volume (= total liver volume - resected liver volume)
                $remnantLiverVolume = $eventData['EventDetail']['total_liver_volume'] - $eventData['EventDetail']['resected_liver_volume'];
                if ($remnantLiverVolume < 0) {
                    $this->validationErrors['total_liver_volume'][] = __('resected volume bigger than liver volume');
                    $remnantLiverVolume = '';
                    $submittedDataValidates = false;
                }
            }
            if ($remnantLiverVolume != '' && isset($eventData['EventDetail']['total_liver_volume']) && is_numeric($eventData['EventDetail']['total_liver_volume']) && isset($eventData['EventDetail']['tumoral_volume']) && is_numeric($eventData['EventDetail']['tumoral_volume'])) {
                // Remanant liver percentage (= (remnant liver volume / (total_liver_volume - tumoral_volume)) * 100 ))
                $diff = $eventData['EventDetail']['total_liver_volume'] - $eventData['EventDetail']['tumoral_volume'];
                if ($diff < 0) {
                    $this->validationErrors['tumoral_volume'][] = __('tumoral volume bigger than liver volume');
                    $submittedDataValidates = false;
                } elseif (! empty($diff)) {
                    $remnantLiverPercentage = ($remnantLiverVolume / $diff) * 100;
                }
            }
            $eventData['EventDetail']['remnant_liver_volume'] = $remnantLiverVolume;
            $eventData['EventDetail']['remnant_liver_percentage'] = $remnantLiverPercentage;
        }
        return $eventData;
    }

    public function setScores($eventControlEventType, $eventData, &$submittedDataValidates)
    {
        if ($eventControlEventType == "child pugh score (classic)" || $eventControlEventType == "child pugh score (mod)") {
            return $this->setChildPughScore($eventData);
        } elseif ($eventControlEventType == "okuda score") {
            return $this->setOkudaScore($eventData);
        } elseif ($eventControlEventType == "barcelona score") {
            return $this->setBarcelonaScore($eventData);
        } elseif ($eventControlEventType == "clip score") {
            return $this->setClipScore($eventData);
        } elseif ($eventControlEventType == "fong score") {
            return $this->setFongScore($eventData);
        } elseif ($eventControlEventType == "gretch score") {
            return $this->setGretchScore($eventData);
        } elseif ($eventControlEventType == "meld score") {
            return $this->setMeldScore($eventData, $submittedDataValidates);
        } elseif ($eventControlEventType == "charlson score") {
            return $this->setCharlsonScore($eventData, $submittedDataValidates);
        }
        return $eventData;
    }

    public function setChildPughScore($eventData)
    {
        $score = 0;
        $setScore = true;
        
        if ($eventData['EventDetail']['bilirubin'] == "<34µmol/l" || $eventData['EventDetail']['bilirubin'] == "<68µmol/l") {
            ++ $score;
        } elseif ($eventData['EventDetail']['bilirubin'] == "34 - 50µmol/l" || $eventData['EventDetail']['bilirubin'] == "68 - 170µmol/l") {
            $score += 2;
        } elseif ($eventData['EventDetail']['bilirubin'] == ">50µmol/l" || $eventData['EventDetail']['bilirubin'] == ">170µmol/l") {
            $score += 3;
        } else {
            $setScore = false;
        }
        
        if ($eventData['EventDetail']['albumin'] == "<28g/l") {
            $score += 3;
            // ++ $score;
        } elseif ($eventData['EventDetail']['albumin'] == "28 - 35g/l") {
            $score += 2;
        } elseif ($eventData['EventDetail']['albumin'] == ">35g/l") {
            ++ $score;
            // $score += 3;
        } else {
            $setScore = false;
        }
        
        if ($eventData['EventDetail']['inr'] == "<1.7") {
            ++ $score;
        } elseif ($eventData['EventDetail']['inr'] == "1.7 - 2.2") {
            $score += 2;
        } elseif ($eventData['EventDetail']['inr'] == ">2.2") {
            $score += 3;
        } else {
            $setScore = false;
        }
        
        if ($eventData['EventDetail']['encephalopathy'] == "none") {
            ++ $score;
        } elseif ($eventData['EventDetail']['encephalopathy'] == "grade I-II") {
            $score += 2;
        } elseif ($eventData['EventDetail']['encephalopathy'] == "grade III-IV") {
            $score += 3;
        } else {
            $setScore = false;
        }
        
        if ($eventData['EventDetail']['ascite'] == "none") {
            ++ $score;
        } elseif ($eventData['EventDetail']['ascite'] == "mild") {
            $score += 2;
        } elseif ($eventData['EventDetail']['ascite'] == "severe") {
            $score += 3;
        } else {
            $setScore = false;
        }
        
        if ($setScore) {
            // no score if bellow 4
            if ($score < 7 && $score > 4) {
                $eventData['EventDetail']['result'] = "A";
            } elseif ($score < 10) {
                $eventData['EventDetail']['result'] = "B";
            } elseif ($score < 16) {
                $eventData['EventDetail']['result'] = "C";
            }
            $eventData['EventDetail']['result'] .= " (" . $score . ")";
        } else {
            $eventData['EventDetail']['result'] = '';
        }
        
        return $eventData;
    }

    public function setOkudaScore($eventData)
    {
        $score = 0;
        $setScore = true;
        
        if ($eventData['EventDetail']['bilirubin'] == ">=50µmol/l") {
            ++ $score;
        } elseif (empty($eventData['EventDetail']['bilirubin'])) {
            $setScore = false;
        }
        
        if ($eventData['EventDetail']['albumin'] == "<30g/l") {
            ++ $score;
        } elseif (empty($eventData['EventDetail']['albumin'])) {
            $setScore = false;
        }
        
        if ($eventData['EventDetail']['ascite'] == "y") {
            ++ $score;
        } elseif (empty($eventData['EventDetail']['ascite'])) {
            $setScore = false;
        }
        
        if ($eventData['EventDetail']['tumor_size_ratio'] == ">=50%") {
            ++ $score;
        } elseif (empty($eventData['EventDetail']['tumor_size_ratio'])) {
            $setScore = false;
        }
        
        if ($setScore) {
            // no score if bellow 4
            if ($score < 1) {
                $eventData['EventDetail']['result'] = "I";
            } elseif ($score < 3) {
                $eventData['EventDetail']['result'] = "II";
            } else {
                $eventData['EventDetail']['result'] = "III";
            }
            $eventData['EventDetail']['result'] .= " (" . $score . ")";
        } else {
            $eventData['EventDetail']['result'] = '';
        }
        
        return $eventData;
    }

    public function setBarcelonaScore($eventData)
    {
        if ($eventData['EventDetail']['who'] == "3 - 4" || $eventData['EventDetail']['tumor_morphology'] == "indifferent" || $eventData['EventDetail']['okuda_score'] == "III" || $eventData['EventDetail']['liver_function'] == "child-pugh C") {
            $eventData['EventDetail']['result'] = "D";
            return $eventData;
        }
        
        if ($eventData['EventDetail']['who'] == "1 - 2" || $eventData['EventDetail']['tumor_morphology'] == "metastasis" || $eventData['EventDetail']['tumor_morphology'] == "vascular invasion") {
            $eventData['EventDetail']['result'] = "C";
            return $eventData;
        }
        
        // Stade A, B: all fields should be completed
        if (($eventData['EventDetail']['who'] == '') || empty($eventData['EventDetail']['tumor_morphology']) || empty($eventData['EventDetail']['okuda_score']) || empty($eventData['EventDetail']['liver_function'])) {
            $eventData['EventDetail']['result'] = '';
            return $eventData;
        }
        
        // At this level:
        // - $eventData['EventDetail']['who'] equals 0 (automatically)
        
        if (($eventData['EventDetail']['tumor_morphology'] == "multinodular") && (($eventData['EventDetail']['okuda_score'] == "I") || ($eventData['EventDetail']['okuda_score'] == "II")) && (($eventData['EventDetail']['liver_function'] == "child-pugh A") || ($eventData['EventDetail']['liver_function'] == "child-pugh B"))) {
            $eventData['EventDetail']['result'] = 'B';
            return $eventData;
        }
        
        if (($eventData['EventDetail']['tumor_morphology'] == "3 tumors, < 3 cm") && (($eventData['EventDetail']['okuda_score'] == "I") || ($eventData['EventDetail']['okuda_score'] == "II")) && (($eventData['EventDetail']['liver_function'] == "child-pugh A") || ($eventData['EventDetail']['liver_function'] == "child-pugh B"))) {
            $eventData['EventDetail']['result'] = 'A4';
            return $eventData;
        }
        
        if (($eventData['EventDetail']['tumor_morphology'] == "unique, < 5cm") && ($eventData['EventDetail']['okuda_score'] == "I")) {
            if ($eventData['EventDetail']['liver_function'] == "HTP, hyperbilirubinemia") {
                $eventData['EventDetail']['result'] = "A3";
            } elseif ($eventData['EventDetail']['liver_function'] == "HTP, bilirubin N") {
                $eventData['EventDetail']['result'] = "A2";
            } else {
                $eventData['EventDetail']['result'] = "A1";
            }
            return $eventData;
        }
        
        $eventData['EventDetail']['result'] = "?";
        return $eventData;
    }

    public function setClipScore($eventData)
    {
        $setScore = true;
        
        $eventData['EventDetail']['result'] = 0;
        if ($eventData['EventDetail']['child_pugh_score'] == "B") {
            ++ $eventData['EventDetail']['result'];
        } elseif ($eventData['EventDetail']['child_pugh_score'] == "C") {
            $eventData['EventDetail']['result'] += 2;
        } elseif (empty($eventData['EventDetail']['child_pugh_score'])) {
            $setScore = false;
        }
        
        if ($eventData['EventDetail']['morphology_of_tumor'] == "multiple nodules & < 50%") {
            ++ $eventData['EventDetail']['result'];
        } elseif ($eventData['EventDetail']['morphology_of_tumor'] == "massive or >= 50%") {
            $eventData['EventDetail']['result'] += 2;
        } elseif (empty($eventData['EventDetail']['morphology_of_tumor'])) {
            $setScore = false;
        }
        
        if ($eventData['EventDetail']['alpha_foetoprotein'] == ">= 400 g/L") {
            ++ $eventData['EventDetail']['result'];
        } elseif (empty($eventData['EventDetail']['alpha_foetoprotein'])) {
            $setScore = false;
        }
        
        if ($eventData['EventDetail']['portal_thrombosis'] == "y") {
            ++ $eventData['EventDetail']['result'];
        } elseif (empty($eventData['EventDetail']['portal_thrombosis'])) {
            $setScore = false;
        }
        
        if (! $setScore) {
            $eventData['EventDetail']['result'] = '';
        }
        
        return $eventData;
    }

    public function setFongScore($eventData)
    {
        $eventData['EventDetail']['result'] = 0;
        foreach (array(
            'metastatic_lymph_nodes',
            'interval_under_year',
            'more_than_one_metastasis',
            'metastasis_greater_five_cm',
            'cea_greater_two_hundred'
        ) as $field) {
            if ($eventData['EventDetail'][$field] == "y") {
                ++ $eventData['EventDetail']['result'];
            } elseif (empty($eventData['EventDetail'][$field])) {
                $eventData['EventDetail']['result'] = '';
                return $eventData;
            }
        }
        return $eventData;
    }

    public function setGretchScore($eventData)
    {
        $score = 0;
        $setScore = true;
        
        if ($eventData['EventDetail']['karnofsky_index'] == "<= 80%") {
            $score += 3;
        } elseif (empty($eventData['EventDetail']['karnofsky_index'])) {
            $setScore = false;
        }
        if ($eventData['EventDetail']['bilirubin'] == ">=50µmol/l") {
            $score += 3;
        } elseif (empty($eventData['EventDetail']['bilirubin'])) {
            $setScore = false;
        }
        if ($eventData['EventDetail']['alkaline_phosphatase'] == ">= 2N") {
            $score += 2;
        } elseif (empty($eventData['EventDetail']['alkaline_phosphatase'])) {
            $setScore = false;
        }
        if ($eventData['EventDetail']['alpha_foetoprotein'] == ">= 35 µg/L") {
            $score += 2;
        } elseif (empty($eventData['EventDetail']['alpha_foetoprotein'])) {
            $setScore = false;
        }
        if ($eventData['EventDetail']['portal_thrombosis'] == "y") {
            $score += 2;
        } elseif (empty($eventData['EventDetail']['portal_thrombosis'])) {
            $setScore = false;
        }
        
        if (! $setScore) {
            $eventData['EventDetail']['result'] = '';
        } else {
            if ($score == 0) {
                $eventData['EventDetail']['result'] = "A (0)";
            } elseif ($score < 6) {
                $eventData['EventDetail']['result'] = "B (" . $score . ")";
            } else {
                $eventData['EventDetail']['result'] = "C (" . $score . ")";
            }
        }
        return $eventData;
    }

    public function setMeldScore($eventData, &$submittedDataValidates)
    {
        $eventData['EventDetail']['result'] = null;
        $eventData['EventDetail']['sodium_result'] = null;
        
        // Get data
        $creat = str_replace(",", ".", $eventData['EventDetail']['creatinine']);
        if (! is_numeric($creat))
            return $eventData;
        if (empty($eventData['EventDetail']['dialysis']))
            return $eventData;
        $creat = ($eventData['EventDetail']['dialysis'] == "y") ? 4 : ($creat / 88.4);
        
        $bilirubin = str_replace(",", ".", $eventData['EventDetail']['bilirubin']);
        if (! is_numeric($bilirubin))
            return $eventData;
        $bilirubin = (($bilirubin / 17.1) < 1) ? 1 : ($bilirubin / 17.1);
        
        $inr = str_replace(",", ".", $eventData['EventDetail']['inr']);
        if (! is_numeric($inr))
            return $eventData;
            // Calculate MELD
        $eventData['EventDetail']['result'] = ((0.957 * log($creat)) + (0.378 * log($bilirubin)) + (1.12 * log($inr)) + 0.643) * 10;
        if ($eventData['EventDetail']['result'] < 0) {
            $submittedDataValidates = false;
            $eventData['EventDetail']['result'] = '';
            $this->validationErrors['result'][] = str_replace('%field%', __('result'), __('calculated value for field [%field%] is negative'));
        }
        
        // Calculate MELD-Na
        $sodium = str_replace(",", ".", $eventData['EventDetail']['sodium']);
        if (! is_numeric($sodium))
            return $eventData;
        
        $tmp = (0.028 * ($eventData['EventDetail']['result'] - 17) * ($sodium - 135)) + 2.53;
        
        $eventData['EventDetail']['sodium_result'] = (0.855 * $eventData['EventDetail']['result']) + 0.705 * (140 - $sodium) + $tmp;
        if ($eventData['EventDetail']['sodium_result'] < 0) {
            $submittedDataValidates = false;
            $eventData['EventDetail']['sodium_result'] = '';
            $this->validationErrors['sodium_result'][] = str_replace('%field%', __('MELD-Na'), __('calculated value for field [%field%] is negative'));
        }
        
        return $eventData;
    }

    public function setCharlsonScore($eventData, &$submittedDataValidates)
    {
        $eventData['EventDetail']['result'] = 0;
        
        switch ($eventData['EventDetail']['scoring_age']) {
            case '<=40yrs':
                break;
            case '41-50':
                $eventData['EventDetail']['result'] += 1;
                break;
            case '51-60':
                $eventData['EventDetail']['result'] += 2;
                break;
            case '61-70':
                $eventData['EventDetail']['result'] += 3;
                break;
            case '71-80':
                $eventData['EventDetail']['result'] += 4;
                break;
        }
        
        $scoringData = array(
            '1' => array(
                'myocardial_infarction',
                'congestive_heart_failure',
                'peripheral_disease',
                'cerebrovascular_disease',
                'dementia',
                'chronic_pulmonary_disease',
                'connective_tissue_disease',
                'peptic_ulcer_disease',
                'mild_liver_disease',
                'diabetes_without_end-organ_damage'
            ),
            '2' => array(
                'hemiplegia',
                'moderate_or_severe_renal_disease',
                'diabetes_with_end-organ_damage',
                'tumor_without_metastasis',
                'leukemia',
                'lymphoma'
            ),
            '3' => array(
                'moderate_or_severe_liver_disease'
            ),
            '6' => array(
                'metastatic_solid_tumor',
                'aids'
            )
        );
        foreach ($scoringData as $value => $allFields) {
            foreach ($allFields as $specificField) {
                if (! array_key_exists($specificField, $eventData['EventDetail']))
                    die('ERR322323 ' . $specificField);
                if ($eventData['EventDetail'][$specificField]) {
                    $eventData['EventDetail']['result'] += $value;
                }
            }
        }
        
        return $eventData;
    }

    public function allowDeletion($eventMasterId)
    {
        $res = parent::allowDeletion($eventMasterId);
        if ($res['allow_deletion']) {
            if ($eventMasterId != $this->id) {
                // not the same, fetch
                $data = $this->findById($eventMasterId);
            } else {
                $data = $this->data;
            }
            $participantId = $data['EventMaster']['participant_id'];
            if (! $participantId)
                AppController::getInstance()->redirect('/Pages/err_plugin_system_error?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
            $TreatmentControl = AppModel::getInstance('ClinicalAnnotation', 'TreatmentControl', true);
            $studiedTreatmentControlIds = $TreatmentControl->find('list', array(
                'conditions' => array(
                    'TreatmentControl.detail_tablename' => array(
                        'qc_hb_txd_surgery_livers',
                        'qc_hb_txd_surgery_pancreas'
                    ),
                    'TreatmentControl.flag_active' => '1'
                ),
                'fields' => array(
                    'TreatmentControl.id'
                )
            ));
            $TreatmentMaster = AppModel::getInstance('ClinicalAnnotation', 'TreatmentMaster', true);
            $linkedSurgeries = $TreatmentMaster->find('all', array(
                'conditions' => array(
                    'TreatmentMaster.treatment_control_id' => $studiedTreatmentControlIds,
                    'TreatmentMaster.participant_id' => $participantId
                )
            ));
            $linkedToSurgery = false;
            foreach ($linkedSurgeries as $newOne) {
                if (($newOne['TreatmentDetail']['lab_report_id'] == $eventMasterId) || ($newOne['TreatmentDetail']['imagery_id'] == $eventMasterId) || ($newOne['TreatmentDetail']['fong_score_id'] == $eventMasterId) || ($newOne['TreatmentDetail']['meld_score_id'] == $eventMasterId) || ($newOne['TreatmentDetail']['gretch_score_id'] == $eventMasterId) || ($newOne['TreatmentDetail']['clip_score_id'] == $eventMasterId) || ($newOne['TreatmentDetail']['barcelona_score_id'] == $eventMasterId) || ($newOne['TreatmentDetail']['okuda_score_id'] == $eventMasterId))
                    $linkedToSurgery = true;
            }
            if ($linkedToSurgery)
                $res = array(
                    'allow_deletion' => false,
                    'msg' => 'at least one pre operative data is linked to this annotation'
                );
        }
        return $res;
    }
}