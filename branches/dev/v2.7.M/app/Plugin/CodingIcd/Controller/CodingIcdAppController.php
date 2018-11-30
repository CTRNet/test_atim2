<?php
 /**
 *
 * ATiM - Advanced Tissue Management Application
 * Copyright (c) Canadian Tissue Repository Network (http://www.ctrnet.ca)
 *
 * Licensed under GNU General Public License
 * For full copyright and license information, please see the LICENSE.txt
 * Redistributions of files must retain the above copyright notice.
 *
 * @author        Canadian Tissue Repository Network <info@ctrnet.ca>
 * @copyright     Copyright (c) Canadian Tissue Repository Network (http://www.ctrnet.ca)
 * @link          http://www.ctrnet.ca
 * @since         ATiM v 2
 * @license       http://www.gnu.org/licenses  GNU General Public License
 */

/**
 * Class CodingIcdAppController
 */
class CodingIcdAppController extends AppController
{

    /**
     *
     * @param $useIcdType
     */
    public function tool($useIcdType)
    {
        $this->layout = 'ajax';
        $this->Structures->set('simple_search');
        $this->Structures->set('empty', "empty");
    }

    /**
     * Search through an icd coding model
     *
     * @param boolean $isTool Is the search made from a popup tool
     * @param AppModel $modelToUse The model to base the search on
     * @return bool
     * @internal param array $searchFieldsPrefix The fields prefix to base the search on* The fields prefix to base the search on
     */
    public function globalSearch($isTool, $modelToUse)
    {
        if ($isTool) {
            $modelNameToUse = $modelToUse->name;
            $this->layout = 'ajax';
            $this->Structures->set("CodingIcd");
            $limit = 25;
            
            if (! $db = ConnectionManager::getDataSource($modelToUse->useDbConfig)) {
                return false;
            }
            
            $this->request->data = $modelToUse->globalSearch(array(
                $this->request->data[0]['term']
            ), isset($this->request->data['exact_search']) && $this->request->data['exact_search'], true, $limit + 1);
            
            if (count($this->request->data) > $limit) {
                unset($this->request->data[$limit]);
                $this->set("overflow", true);
            }
        } else {
            die("Not implemented");
        }
    }

    /**
     *
     * @param $modelToUse
     */
    public function globalAutocomplete($modelToUse)
    {
        // layout = ajax to avoid printing layout
        $this->layout = 'ajax';
        // debug = 0 to avoid printing debug queries that would break the javascript array
        Configure::write('debug', 0);
        
        // query the database
        $term = str_replace('_', '\_', str_replace('%', '\%', $_GET['term']));
        $data = $modelToUse->find('all', array(
            'conditions' => array(
                $modelToUse->name . '.id LIKE' => $term . '%'
            ),
            'fields' => array(
                $modelToUse->name . '.id'
            ),
            'limit' => 10,
            'recursive' => - 1
        ));
        
        // build javascript textual array
        $result = "";
        foreach ($data as $dataUnit) {
            $result .= '"' . $dataUnit[$modelToUse->name]['id'] . '", ';
        }
        if (sizeof($result) > 0) {
            $result = substr($result, 0, - 2);
        }
        $this->set('result', "[" . $result . "]");
    }
}