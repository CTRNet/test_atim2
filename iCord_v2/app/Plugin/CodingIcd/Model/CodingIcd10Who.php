<?php

/**
 * Class CodingIcd10Who
 */
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

    /**
     * CodingIcd10Who constructor.
     */
    public function __construct()
    {
        parent::__construct();
        self::$singleton = $this;
    }

    /**
     *
     * @param $id
     * @return bool
     */
    public static function validateId($id)
    {
        return self::$singleton->globalValidateId($id);
    }

    /**
     *
     * @return CodingIcd10Who|null
     */
    public static function getSingleton()
    {
        return self::$singleton;
    }

    /**
     *
     * @return array
     */
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

    /**
     *
     * @param array $terms
     * @param $exactSearch
     * @param $searchOnId
     * @param $limit
     * @return array|bool|null|The
     */
    public function globalSearch(array $terms, $exactSearch, $searchOnId, $limit)
    {
        if (isset($terms[0])) {
            $terms[0] = preg_replace('/([cC][0-9]{2})\.([0-9]){0,1}/', '$1$2', $terms[0]);
        }
        return parent::globalSearch($terms, $exactSearch, $searchOnId, $limit);
    }
}