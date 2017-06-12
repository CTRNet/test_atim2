<?php

class CodingIcd10Who extends CodingIcdAppModel
{

    // ---------------------------------------------------------------------------------------------------------------
    // Coding System: ICD-10 (International)
    // From: Stats Canada (WHO_ICD10_Ever_Created_Codes_2009WC)
    // ---------------------------------------------------------------------------------------------------------------
    protected static $singleton = null;

    public $name = 'CodingIcd10Who';

    public $useTable = 'coding_icd10_who';

    public $icdDescriptionTableFields = array(
        'search_format' => array(
            'title',
            'sub_title',
            'description'
        ),
        'detail_format' => array(
            'description'
        )
    );

    public $validate = array();

    public function __construct()
    {
        parent::__construct();
        self::$singleton = $this;
    }

    public static function validateId($id)
    {
        return self::$singleton->globalValidateId($id);
    }

    public static function getSingleton()
    {
        return self::$singleton;
    }

    public static function getSecondaryDiagnosisList()
    {
        $data = array();
        foreach (self::$singleton->find('all', array(
            'conditions' => array(
                "en_description LIKE 'Secondary malignant neoplasm%'"
            ),
            'fields' => array(
                'id'
            )
        )) as $newId) {
            $data[$newId['CodingIcd10Who']['id']] = $newId['CodingIcd10Who']['id'] . ' - ' . self::$singleton->getDescription($newId['CodingIcd10Who']['id']);
        }
        return $data;
    }
}
