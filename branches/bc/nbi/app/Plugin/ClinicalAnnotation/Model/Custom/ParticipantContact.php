<?php
/**
 * **********************************************************************
 * NBI Project..
 * ***********************************************************************
 *
 * ClinicalAnnotation plugin custom code
 *
 * @author N. Luc - CTRNet (nicolas.luc@gmail.com)
 * @since 2019-02-21
 */
 
class ParticipantContactCustom extends ParticipantContact
{

    public $belongsTo = array(
        'Participant' => array(
            'className' => 'ClinicalAnnotation.Participant',
            'foreignKey' => 'participant_id',
            'type' => 'INNER'
        )
    );

    var $useTable = 'participant_contacts';

    var $name = 'ParticipantContact';
    
    public function beforeFind($queryData)
    {
        // Manage search on nominal information for participants of the retropsective bank
        if (($_SESSION['Auth']['User']['group_id'] != '1') && is_array($queryData['conditions'])) {
            // Non-administrator user
            // Limit access to prospecitve bank participant when confidential/critical information is part of the query conditions
            $queryData['recursive'] = 1;
            $queryData['conditions'][] = "Participant.bc_nbi_retrospective_bank != 'n'";
            $queryData['conditions'][] = "ParticipantContact.confidential != 1";

        }
        return $queryData;
    }
    
    public function afterFind($results, $primary = false)
    {
        // Manage display on nominal information for participants of the retropsective bank
        $results = parent::afterFind($results);
        if ($_SESSION['Auth']['User']['group_id'] != '1') {
            // Non-administrator user
            // Hide confidential/critical information of the participants of the retrospecive bank
            if (isset($results[0]['Participant'])) {
                foreach ($results as $keyResult => $result) {
                    if ((! isset($result['Participant']['bc_nbi_retrospective_bank'])) || $result['Participant']['bc_nbi_retrospective_bank'] == 'y') {
                        if ((! isset($result['ParticipantContact']['confidential'])) || $result['ParticipantContact']['confidential']) {
                            AppController::getInstance()->redirect('/Pages/err_plugin_system_error?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
                        }
                    }
                }
            } elseif (isset($results['Participant']) || isset($results['ParticipantContact'])) {
                // Should never happen
                AppController::getInstance()->redirect('/Pages/err_plugin_system_error?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
            }
        }
        return $results;
    }
}