<?php

class EventMasterCustom extends EventMaster
{

    var $useTable = 'event_masters';

    var $name = "EventMaster";

    public function beforeSave($options = array())
    {
        if (isset($this->data['EventMaster']['diagnosis_master_id']) && $this->data['EventMaster']['diagnosis_master_id']) {
            unset($this->data['EventMaster']['diagnosis_master_id']);
            AppController::addWarningMsg('no event can be linked to a diagnosis because diagnosis data comes from SARDO');
        }
        if (isset($this->data['EventMaster']['event_control_id'])) {
            $event_control = AppModel::getInstance('ClinicalAnnotation', 'EventControl', true);
            $event_control_data = $event_control->find('first', array(
                'conditions' => array(
                    'id' => $this->data['EventMaster']['event_control_id']
                )
            ));
            if (! in_array($event_control_data['EventControl']['event_type'], $event_control->modifiable_event_types)) {
                // Generate an error in merge process
                // AppController::getInstance()->redirect('/Pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);
            }
        } elseif ($this->id) {
            $event_data = $this->find('first', array(
                'conditions' => array(
                    'EventMaster.id' => $this->id
                )
            ));
            $event_control = AppModel::getInstance('ClinicalAnnotation', 'EventControl', true);
            if (! in_array($event_data['EventControl']['event_type'], $event_control->modifiable_event_types)) {
                // Generate an error in merge process
                // AppController::getInstance()->redirect('/Pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);
            }
        } else {
            // Generate an error in merge process
            // AppController::getInstance()->redirect('/Pages/err_plugin_system_error?method='.__METHOD__.',line='.__LINE__, null, true);
        }
        return parent::beforeSave($options);
    }

    public function validates($options = array())
    {
        $result = parent::validates($options);
        
        if (isset($this->data['EventDetail'])) {
            foreach (array(
                'slides',
                'blocks'
            ) as $item) {
                if (array_key_exists('number_of_' . $item, $this->data['EventDetail'])) {
                    if (preg_match('/^[0-9]+$/', $this->data['EventDetail']['number_of_' . $item]) && preg_match('/^[0-9]+$/', $this->data['EventDetail']['number_of_missing_' . $item])) {
                        if ($this->data['EventDetail']['number_of_' . $item] == '0' || $this->data['EventDetail']['number_of_' . $item] < $this->data['EventDetail']['number_of_missing_' . $item]) {
                            $this->validationErrors['number_of_' . $item][] = __("the system is unable to calculate the precentage of missing $item");
                            $this->validationErrors['number_of_missing_' . $item][] = __("the system is unable to calculate the precentage of missing $item");
                            $result = false;
                        } else {
                            $this->data['EventDetail']['pct_of_missing_' . $item] = ($this->data['EventDetail']['number_of_missing_' . $item] / $this->data['EventDetail']['number_of_' . $item]) * 100;
                        }
                    }
                }
            }
            if (array_key_exists('pt_subclass', $this->data['EventDetail']) && ! empty($this->data['EventDetail']['pt_subclass'])) {
                if ($this->data['EventDetail']['pt'] != '3') {
                    $this->validationErrors['pt_subclass'][] = __("no pt subclass has to be recorded");
                    $result = false;
                }
            }
            if (array_key_exists('idc_p_1_intraductal', $this->data['EventDetail'])) {
                if ($this->data['EventDetail']['idc_p_1_intraductal'] != 'y') {
                    $idc_fields = array(
                        'idc_p_2_density_1',
                        'idc_p_2_density_1_precision',
                        'idc_p_3_density_2',
                        'idc_p_3_density_2_precision',
                        'idc_p_4_atypical_cells',
                        'idc_p_5_vs_adjacent_tumor',
                        'idc_p_6_comedonecrosis',
                        'idc_p_7_duct_2x',
                        'idc_p_8_branching',
                        'idc_p_9_streaming'
                    );
                    $icd_field_completed = false;
                    foreach ($idc_fields as $new_field)
                        if (strlen(trim($this->data['EventDetail'][$new_field])))
                            $icd_field_completed = true;
                    if ($icd_field_completed) {
                        $this->validationErrors['idc_p_1_intraductal'][] = __("idc-p 1 different than yes : no value has to be enterred for fields icd-p 2 to 9");
                        $result = false;
                    }
                }
                foreach (array(
                    'idc_p_2_density_1' => 'idc_p_2_density_1_precision',
                    'idc_p_3_density_2' => 'idc_p_3_density_2_precision'
                ) as $new_field => $new_field_precision) {
                    if (preg_match('/specify/', $this->data['EventDetail'][$new_field]) && ! strlen(trim($this->data['EventDetail'][$new_field_precision]))) {
                        $this->validationErrors[$new_field_precision][] = __("precision is requested");
                        $result = false;
                    }
                }
            }
        }
        
        return $result;
    }
}