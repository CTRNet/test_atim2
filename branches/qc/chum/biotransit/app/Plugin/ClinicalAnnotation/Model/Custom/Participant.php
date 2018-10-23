<?php

/**
 * **********************************************************************
 * CHUM-BioTransit Project
 * ***********************************************************************
 *
 * ClinicalAnnotation plugin custom code
 *
 * Class ParticipantCustom
 *
 * @author N. Luc - CTRNet (nicolas.luc@gmail.com)
 * @since 2018-10-22
 */
class ParticipantCustom extends Participant
{

    var $useTable = 'participants';

    var $name = "Participant";

    public $belongsTo = array(
        'StudySummary' => array(
            'className' => 'Study.StudySummary',
            'foreignKey' => 'chum_biotransit_study_summary_id'
        )
    );

    /**
     * Manage participant summary to display.
     *
     * @param array $variables
     * @return array|bool
     */
    public function summary($variables = array())
    {
        $return = false;
        
        if (isset($variables['Participant.id'])) {
            $result = $this->find('first', array(
                'conditions' => array(
                    'Participant.id' => $variables['Participant.id']
                )
            ));
            $title = $result['StudySummary']['title'] . ' p#' . $result['Participant']['chum_biotransit_participant_study_number'];
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

    /**
     * Participant data custom valdiation.
     *
     * @param array $options
     * @return bool
     */
    public function validates($options = array())
    {
        $validate = parent::validates($options);
        
        // Validate selected study then set chum_biotransit_study_summary_id
        if (isset($this->data['FunctionManagement']['chum_biotransit_autocomplete_participant_study_summary_id'])) {
            $this->data['Participant']['chum_biotransit_study_summary_id'] = null;
            $this->addWritableField(array(
                'chum_biotransit_study_summary_id'
            ));
            $this->data['FunctionManagement']['chum_biotransit_autocomplete_participant_study_summary_id'] = trim($this->data['FunctionManagement']['chum_biotransit_autocomplete_participant_study_summary_id']);
            $studyModel = AppModel::getInstance("Study", "StudySummary", true);
            $arrStudySelectionResults = $studyModel->getStudyIdFromStudyDataAndCode($this->data['FunctionManagement']['chum_biotransit_autocomplete_participant_study_summary_id']);
            if (isset($arrStudySelectionResults['StudySummary'])) {
                $this->data['Participant']['chum_biotransit_study_summary_id'] = $arrStudySelectionResults['StudySummary']['id'];
            } else {
                if (isset($arrStudySelectionResults['error'])) {
                    $this->validationErrors['chum_biotransit_autocomplete_participant_study_summary_id'][] = $arrStudySelectionResults['error'];
                    $validate = false;
                }
            }
        }
        
        // Validate the chum_biotransit_participant_study_number: Unique for one study
        if ($validate && isset($this->data['Participant']['chum_biotransit_participant_study_number'])) {
            if (! isset($this->data['Participant']['chum_biotransit_study_summary_id'])) {
                if (! isset($this->data['StudySummary']['title'])) {
                    AppController::getInstance()->redirect('/Pages/err_plugin_system_error?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
                } else {
                    $studyModel = AppModel::getInstance("Study", "StudySummary", true);
                    $studyData = $studyModel->find('all', array(
                        'conditions' => array(
                            'StudySummary.title' => $this->data['StudySummary']['title']
                        ),
                        'recursive' => - 1
                    ));
                    if (! $studyData || sizeof($studyData) > 2) {
                        AppController::getInstance()->redirect('/Pages/err_plugin_system_error?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
                    } else {
                        $this->data['Participant']['chum_biotransit_study_summary_id'] = $studyData[0]['StudySummary']['id'];
                    }
                }
            }
            $this->data['Participant']['chum_biotransit_participant_study_number'] = trim($this->data['Participant']['chum_biotransit_participant_study_number']);
            $participant_id = (isset($this->id) && ! empty($this->id)) ? $this->id : '-1';
            $isParticipantStudyNumberUse = $this->find('count', array(
                'conditions' => array(
                    'Participant.chum_biotransit_study_summary_id' => $this->data['Participant']['chum_biotransit_study_summary_id'],
                    'Participant.chum_biotransit_participant_study_number' => $this->data['Participant']['chum_biotransit_participant_study_number'],
                    "Participant.id != $participant_id"
                )
            ));
            if ($isParticipantStudyNumberUse) {
                $this->validationErrors['chum_biotransit_participant_study_number'][] = 'participant study number already assigned to a participant';
                $validate = false;
            }
        }
        
        return $validate;
    }
}