<?php

class ParticipantCustom extends Participant
{

    var $useTable = 'participants';

    var $name = "Participant";

    public function summary($variables = array())
    {
        $return = false;
        
        if (isset($variables['Participant.id'])) {
            
            // custom code to add no labo----
            $result = $this->find('first', array(
                'conditions' => array(
                    'Participant.id' => $variables['Participant.id']
                )
            ));
            
            $identifierModel = AppModel::getInstance('ClinicalAnnotation', 'MiscIdentifier', true);
            $identifierResults = $identifierModel->find('all', array(
                'conditions' => array(
                    'MiscIdentifier.participant_id' => $variables['Participant.id'],
                    'MiscIdentifierControl.misc_identifier_name LIKE' => '%no lab'
                )
            ));
            
            $title = null;
            if (! empty($identifierResults)) {
                $result['Participant'] = $identifierResults[0]['Participant'];
                $result[0]['identifiers'] = "";
                $tempArray = array();
                foreach ($identifierResults as $ir) {
                    $tempArray[__(str_replace(' bank no lab', '', $ir['MiscIdentifierControl']['misc_identifier_name']), true)] = $ir['MiscIdentifier']['identifier_value'];
                }
                asort($tempArray);
                foreach ($tempArray as $key => $value) {
                    $result[0]['identifiers'] .= $key . " - " . $value . "\n";
                }
                
                $title = 'NoLabo: ' . implode(" & ", $tempArray);
            } else {
                $result = $this->findById($variables['Participant.id']);
                $result[0]['identifiers'] = '';
                $title = __('n/a', true);
            }
            
            // ------------------------------
            
            $return = array(
                'menu' => array(
                    null,
                    $title
                ),
                'title' => array(
                    null,
                    $title
                ),
                'structure alias' => 'participants,qc_nd_part_id_summary',
                'data' => $result
            );
        }
        
        return $return;
    }

    public function getSardoValues($typeOfList)
    {
        $query = "SELECT value, fr FROM qc_nd_sardo_drop_down_lists WHERE type = '" . $typeOfList[0] . "' ORDER BY value ASC";
        try {
            $res = $this->query($query);
            $sardoValues = array();
            foreach ($res as $data) {
                $sardoValues[$data['qc_nd_sardo_drop_down_lists']['value']] = $data['qc_nd_sardo_drop_down_lists']['fr'];
            }
            return $sardoValues;
        } catch (Exception $e) {
            $bt = debug_backtrace();
            AppController::getInstance()->redirect('/Pages/err_plugin_system_error?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
        }
    }
}