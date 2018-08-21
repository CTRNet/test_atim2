<?php

/**
 * Class CsvController
 */
class CsvController extends DatamartAppController
{

    public $uses = array();

    /**
     * Fetches data and returns it in a CSV
     * Too many params so they are received via the /key:value/ syntax
     * Either generates the CSV popup or the CSV file.
     */
    public function csv()
    {
        AppController::atimSetCookie(false);
        if (isset($this->passedArgs['popup'])) {
            // generates CSV popup
            $this->Structures->set('csv_popup');
            $this->render('popup');
        } else {
            if (array_key_exists('Config', $this->request->data)) {
                $config = array_merge($this->request->data['Config'], (array_key_exists(0, $this->request->data) ? $this->request->data[0] : array()));
                unset($this->request->data[0]);
                unset($this->request->data['Config']);
                $this->configureCsv($config);
            }
            $plugin = $this->passedArgs['plugin'];
            $modelName = $this->passedArgs['model']; // The model to use to fetch the data
            $modelPkey = $this->passedArgs['modelPkey']; // The key to use to fetch the data
            $structureAlias = $this->passedArgs['structure']; // The structure to render the data
            $dataPkey = isset($this->passedArgs['dataPkey']) ? $this->passedArgs['dataPkey'] : $modelPkey; // The model to look for in the data array
            $dataModel = isset($this->passedArgs['dataModel']) ? $this->passedArgs['dataModel'] : $modelName; // The pkey to look for in the data array
            
            $this->ModelToSearch = AppModel::getInstance($plugin, $modelName, true);
            
            if (! isset($this->request->data[$dataModel]) || ! isset($this->request->data[$dataModel][$dataPkey])) {
                $this->redirect('/Pages/err_internal?p[]=failed to find values', null, true);
                exit();
            }
            
            $ids[] = 0;
            if (! is_array($this->request->data[$dataModel][$dataPkey])) {
                $this->request->data[$dataModel][$dataPkey] = explode(",", $this->request->data[$dataModel][$dataPkey]);
            }
            foreach ($this->request->data[$dataModel][$dataPkey] as $id) {
                if ($id != 0) {
                    $ids[] = $id;
                }
            }
            
            $this->request->data = $this->ModelToSearch->find('all', array(
                'conditions' => $modelName . "." . $modelPkey . " IN ('" . implode("', '", $ids) . "')"
            ));
            
            $this->set('csvHeader', true);
            $this->Structures->set($structureAlias, 'result_structure');
            Configure::write('debug', 0);
            $this->layout = false;
            $_SESSION['query']['previous'][] = $this->getQueryLogs('default');
        }
    }
}