<?php

/**
 * Class CodingIcdo3Topo
 */
class CodingIcdo3Topo extends CodingIcdAppModel
{
    
    // ---------------------------------------------------------------------------------------------------------------
    // Coding System: ICD-O-3
    // From: Stats Canada through the Manitoba Cancer Registry (CCR_Reference_Tables_2009_FinalDraft_21122009)
    // Notes: An effort is underway to verify the file authenticity.
    // ---------------------------------------------------------------------------------------------------------------
    protected static $singleton = null;

    public $name = 'CodingIcdo3Topo';

    public $useTable = 'coding_icd_o_3_topography';

    public $icdDescriptionTableFields = array(
        'search_format' => array(/*'title': All values are equal to 'Malignant neoplasms' */ 'sub_title',
            'description'
        ),
        'detail_format' => array(
            'description'
        )
    );

    public $validate = array();

    /**
     * CodingIcdo3Topo constructor.
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
     * @return CodingIcdo3Topo|null
     */
    public static function getSingleton()
    {
        return self::$singleton;
    }

    /**
     *
     * @return array
     */
    public static function getTopoCategoriesCodes()
    {
        $data = array();
        $lang = Configure::read('Config.language') == "eng" ? "en" : "fr";
        foreach (self::$singleton->find('all', array(
            'fields' => array(
                'DISTINCT SUBSTRING(id, 1, 3) AS id, ' . $lang . '_sub_title'
            )
        )) as $newId) {
            $data[$newId['0']['id']] = $newId['0']['id'] . ' - ' . $newId['CodingIcdo3Topo'][$lang . '_sub_title'];
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