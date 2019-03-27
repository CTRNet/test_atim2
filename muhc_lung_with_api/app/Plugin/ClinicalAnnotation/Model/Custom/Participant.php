<?php
/**
 * **********************************************************************
 * CUSM
 * ***********************************************************************
 *
 * Clinical Annotation plugin custom code
 *
 * @author N. Luc - CTRNet (nicol.luc@gmail.com)
 * @since 2018-10-15
 */
 
class ParticipantCustom extends Participant
{

    var $useTable = 'participants';

    var $name = "Participant";

    public function summary($variables = array())
    {
        $return = false;
        
        if (isset($variables['Participant.id'])) {
            $result = $this->find('first', array(
                'conditions' => array(
                    'Participant.id' => $variables['Participant.id']
                )
            ));
            
            // Add bank participant numbers to title
            $identifierModel = AppModel::getInstance('ClinicalAnnotation', 'MiscIdentifier', true);
            $identifierResults = $identifierModel->find('all', array(
                'conditions' => array(
                    'MiscIdentifier.participant_id' => $variables['Participant.id'],
                    'MiscIdentifierControl.misc_identifier_name LIKE' => '%bank participant number'
                )
            ));
            $title = 'p#' . $result['Participant']['participant_identifier'];
            if (! empty($identifierResults)) {
                $identifierTitle = array();
                foreach ($identifierResults as $newIdentifier) {
                    $identifierTitle[] = $newIdentifier['MiscIdentifier']['identifier_value'];
                }
                $identifierTitle = implode(' & ', $identifierTitle);
                $title .= " ($identifierTitle)";
            }
            
            $return = array(
                'menu' => array(
                    null,
                    $title
                ),
                'title' => array(
                    null,
                    $title
                ),
                'structure alias' => 'participants',
                'data' => $result
            );
        }
        
        return $return;
    }
}