<?php

/**
 * Class CodingIcdAppModel
 */
class CodingIcdAppModel extends AppModel
{

    public $icdDescriptionTableFields = array();

    /**
     *
     * @param unknown_type $id The id of the code to get the description of
     * @param boolean $isSearchForm Define if the data will be display in a search form or not
     * @param array $dataArray The CodingIcd* data array
     * @return the description of an icd code
     *         @note: This is CodingIcdAppModel, thus this function must work for all coding
     */
    public function getDescription($id, $isSearchForm = false, $dataArray = null)
    {
        $lang = Configure::read('Config.language') == "eng" ? "en" : "fr";
        if (isset(AppController::getInstance()->csvConfig) && isset(AppController::getInstance()->csvConfig['config_language'])) {
            $lang = AppController::getInstance()->csvConfig['config_language'] == "eng" ? "en" : "fr";
        }
        if (! $dataArray)
            $dataArray = $this->find('first', array(
                'conditions' => array(
                    'id' => $id
                )
            ));
        $description = array();
        if (is_array($dataArray) && ! empty($dataArray)) {
            $dataArray = array_shift($dataArray);
            foreach ($this->icdDescriptionTableFields[$isSearchForm ? 'search_format' : 'detail_format'] as $fieldToDisplay)
                if (isset($dataArray[$lang . "_" . $fieldToDisplay]))
                    $description[] = $dataArray[$lang . "_" . $fieldToDisplay];
        }
        return $description ? implode(' - ', $description) : '-';
    }

    /**
     *
     * @param $id
     * @return bool
     */
    public function globalValidateId($id)
    {
        if (is_array($id)) {
            $id = array_values($id);
            $id = $id[0];
        }
        return strlen($id) > 0 ? $this->find('count', array(
            'conditions' => array(
                'id' => $id
            )
        )) > 0 : true;
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
        if (! $db = ConnectionManager::getDataSource($this->useDbConfig)) {
            return false;
        }
        
        // Get fields to search on
        $lang = Configure::read('Config.language') == "eng" ? "en" : "fr";
        $searchFields = array_keys($this->schema());
        $filterKey = $lang . '_';
        $searchFields = array_filter($searchFields, function ($in) use($filterKey) {
            return strpos($in, $filterKey) === 0;
        });
        if ($searchOnId) {
            $searchFields[] = "id";
        }
        
        // Build conditions
        $conditions = array();
        $orderBy = array();
        foreach ($terms as $term) {
            if (strlen($term) > 3) {
                if ($exactSearch) {
                    $term = "+" . preg_replace("/(\s)([^ \t\r\n\v\f])/", "$1+$2", trim($term));
                } else {
                    $term = preg_replace("/([^ \t\r\n\v\f])(\s)/", "$1*$2", trim($term)) . "*";
                }
                $term = $db->value($term);
                $conditions[] = "MATCH(" . implode(", ", $searchFields) . ") AGAINST (" . $term . " IN BOOLEAN MODE)";
                $orderBy[] = "MATCH(" . implode(", ", $searchFields) . ") AGAINST (" . $term . " IN BOOLEAN MODE)";
            } else {
                // See issue#3019: Disease Code: Search on short string like 'C61' failed
                $smallTermConditions = '';
                foreach ($searchFields as $newField) {
                    if ($exactSearch) {
                        $conditions[] = "$newField LIKE '$term'";
                    } else {
                        $conditions[] = "$newField LIKE '%$term%'";
                    }
                }
            }
        }
        if ($orderBy)
            $orderBy = array(
                '((' . implode(') + (', $orderBy) . ')) DESC'
            );
        
        if ($limit != null) {
            $data = $this->find('all', array(
                'conditions' => array(
                    implode(" OR ", $conditions)
                ),
                'limit' => $limit,
                'order' => $orderBy
            ));
        } else {
            $data = $this->find('all', array(
                'conditions' => array(
                    implode(" OR ", $conditions)
                ),
                'order' => $orderBy
            ));
        }
        
        $data = self::convertDataToNeutralIcd($data);
        foreach ($data as &$newIcdData)
            $newIcdData['CodingIcd']['generated_detail'] = $this->getDescription($newIcdData['CodingIcd']['id'], 1, $newIcdData);
        return $data;
    }

    /**
     * Convert CodingIcd* data arrays to have them use the generic CodingIcd model so that we only have 2 CodingIcd structures
     *
     * @param array $dataArray The CodingIcd* data array to convert
     * @return The converted array
     */
    public static function convertDataToNeutralIcd(array $dataArray)
    {
        $result = array();
        if (count($dataArray) > 0) {
            $key = array_keys($dataArray[0]);
            $key = $key[0];
            foreach ($dataArray as $dataUnit) {
                $result[] = array(
                    "CodingIcd" => $dataUnit[$key]
                );
            }
        }
        return $result;
    }

    /**
     *
     * @param array $terms
     * @param $exactSearch
     * @return array
     */
    public function getCastedSearchParams(array $terms, $exactSearch)
    {
        $searchResult = $this->globalSearch($terms, $exactSearch, true, false);
        $data = array();
        if (count($searchResult) > 0) {
            foreach ($searchResult as $unit) {
                $data[] = $unit['CodingIcd']['id'];
            }
        } else {
            $data[] = "NO ID MATCHED";
        }
        return $data;
    }
}