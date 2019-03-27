<?php

/**
 * Class CodingIcdo3Morpho
 */
class CodingIcdo3Morpho extends CodingIcdAppModel
{
    
    // ---------------------------------------------------------------------------------------------------------------
    // Coding System: ICD-O-3 (Morphology)
    // From: CIHI publications department (ICD10CA_Code_Eng_Desc2010_V2_0 & ICD10CA_Code_Fra_Desc2010_V2_0)
    // ---------------------------------------------------------------------------------------------------------------
    protected static $singleton = null;

    public $name = 'CodingIcdo3Morpho';

    public $useTable = 'coding_icd_o_3_morphology';

    public $icdDescriptionTableFields = array(
        'search_format' => array(
            'description'
        ),
        'detail_format' => array(
            'description'
        )
    );

    public $validate = array();

    /**
     * CodingIcdo3Morpho constructor.
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
        $tmpId = null;
        if (is_array($id)) {
            $tmpId = array_values($id);
            $tmpId = $tmpId[0];
        } else {
            $tmpId = $id;
        }
        // we need to check if this is an id here because sql will return true on '80000'='80000a'
        return (is_numeric($tmpId) || strlen($tmpId) == 0) ? self::$singleton->globalValidateId($id) : false;
    }

    /**
     *
     * @return CodingIcdo3Morpho|null
     */
    public static function getSingleton()
    {
        return self::$singleton;
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
            $terms[0] = preg_replace('/([0-9]{4})\/([0-9]){0,1}/', '$1$2', $terms[0]);
        }
        return parent::globalSearch($terms, $exactSearch, $searchOnId, $limit);
    }
}