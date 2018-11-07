<?php

/**
 * Class TmaSlideUse
 */
class TmaSlideUse extends StorageLayoutAppModel
{

    public $belongsTo = array(
        'TmaSlide' => array(
            'className' => 'StorageLayout.TmaSlide',
            'foreignKey' => 'tma_slide_id'
        ),
        'StudySummary' => array(
            'className' => 'Study.StudySummary',
            'foreignKey' => 'study_summary_id'
        )
    );

    public static $studyModel = null;

    /**
     *
     * @param array $options
     * @return bool
     */
    public function validates($options = array())
    {
        $this->validateAndUpdateTmaSlideUseStudyData();
        
        return parent::validates($options);
    }

    public function validateAndUpdateTmaSlideUseStudyData()
    {
        $tmaSlideUseData = & $this->data;
        
        // check data structure
        $tmpArrToCheck = array_values($tmaSlideUseData);
        if ((! is_array($tmaSlideUseData)) || (is_array($tmpArrToCheck) && isset($tmpArrToCheck[0]['TmaSlideUse']))) {
            AppController::getInstance()->redirect('/Pages/err_plugin_system_error?method=' . __METHOD__ . ',line=' . __LINE__, null, true);
        }
        
        // Launch validation
        if (array_key_exists('FunctionManagement', $tmaSlideUseData) && array_key_exists('autocomplete_tma_slide_use_study_summary_id', $tmaSlideUseData['FunctionManagement'])) {
            $tmaSlideUseData['TmaSlideUse']['study_summary_id'] = null;
            $tmaSlideUseData['FunctionManagement']['autocomplete_tma_slide_use_study_summary_id'] = trim($tmaSlideUseData['FunctionManagement']['autocomplete_tma_slide_use_study_summary_id']);
            $this->addWritableField(array(
                'study_summary_id'
            ));
            if (strlen($tmaSlideUseData['FunctionManagement']['autocomplete_tma_slide_use_study_summary_id'])) {
                // Load model
                if (self::$studyModel == null)
                    self::$studyModel = AppModel::getInstance("Study", "StudySummary", true);
                    
                    // Check the aliquot internal use study definition
                $arrStudySelectionResults = self::$studyModel->getStudyIdFromStudyDataAndCode($tmaSlideUseData['FunctionManagement']['autocomplete_tma_slide_use_study_summary_id']);
                
                // Set study summary id
                if (isset($arrStudySelectionResults['StudySummary'])) {
                    $tmaSlideUseData['TmaSlideUse']['study_summary_id'] = $arrStudySelectionResults['StudySummary']['id'];
                }
                
                // Set error
                if (isset($arrStudySelectionResults['error'])) {
                    $this->validationErrors['autocomplete_tma_slide_use_study_summary_id'][] = $arrStudySelectionResults['error'];
                }
            }
        }
    }
}