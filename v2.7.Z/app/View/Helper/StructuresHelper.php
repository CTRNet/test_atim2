<?php
App::uses('Helper', 'View');

/**
 * Class StructuresHelper
 */
class StructuresHelper extends AppHelper
{

    public $structureAliasFinal = array();
    private $structureAliasFinaltable = null;
    
    public $helpers = array(
        'Csv',
        'Html',
        'Form',
        'Javascript',
        'Ajax',
        'Paginator',
        'Session'
    );
    
    // an hidden field will be printed for the following field types if they are in readonly mode
    public $structureAlias = '';

    private static $hiddenOnDisabled = array(
        "input",
        "date",
        "datetime",
        "time",
        "integer",
        "integer_positive",
        "float",
        "float_positive",
        "tetarea",
        "autocomplete"
    );

    private static $treeNodeId = 0;

    private static $lastTabindex = 1;

    private $myValidationErrors = null;

    private static $writeModes = array(
        'add',
        'edit',
        'search',
        'addgrid',
        'editgrid',
        'batchedit'
    );
    
    // default options
    private static $defaults = array(
        'chartSettings' => array(),
        'chartsType' => array(),
        'number' => 0,
        'titles' => '',
        'type' => null,
        'data' => false, // override $this->request->data values, will not work properly for EDIT forms
        'settings' => array(
            'return' => false, // FALSE echos structure, TRUE returns it as string
                               // show/hide various structure elements, useful for STACKING multiple structures (for example, to make one BIG form out of multiple smaller forms)
            'actions' => true,
            'header' => '',
            'language_heading' => null,
            'form_top' => true, // will print the opening form tag
            'tabindex' => 0, // when setting TAB indexes, add this value to the number, useful for stacked forms
            'form_inputs' => true, // if TRUE, use inputs when supposed to, if FALSE use static display values regardless
            'form_bottom' => true,
            'name_prefix' => null,
            'pagination' => true,
            'sorting' => false, // if pagination is false, sorting can still be turned on (if pagination is on, sorting is ignored). Consists of an array with sorting URL parameters
            'columns_names' => array(), // columns names - usefull for reports. only works in detail views
            'stretch' => true, // the structure will take full page width
            'all_fields' => false, // FALSE acts on structures datatable settings, TRUE ignores them and displays ALL FIELDS in a form regardless
            'add_fields' => false, // if TRUE, adds an "add another" link after form to allow another row to be appended
            'del_fields' => false, // if TRUE, add a "remove" link after each row, to allow it to be removed from the form
            'tree' => array(), // indicates MULTIPLE atim_structures passed to this class, and which ones to use for which MODEL in each tree ROW
            'data_miss_warn' => true, // in debug mode, prints a warning if data is not found for a field
            'paste_disabled_fields' => array(), // pasting on those fields will be disabled
            'csv_header' => true, // in a csv file, if true, will print the header line
            'no_sanitization' => array(), // model => fields to avoid sanitizing
            'section_start' => false,
            'section_end' => false,
            'confirmation_msg' => null,
            'batchset' => null
        ),
        'links' => array(
            'top' => false, // if present, will turn structure into a FORM and this url is used as the FORM action attribute
            'index' => array(),
            'bottom' => array(),
            'tree' => array(),
            'tree_expand' => array(),
            'checklist' => array(), // keys are checkbox NAMES (model.field) and values are checkbox VALUES
            'radiolist' => array(), // keys are radio button NAMES (model.field) and values are radio button VALUES
            'ajax' => array( // change any of the above LINKS into AJAX calls instead
                'top' => false,
                'index' => array(),
                'bottom' => array()
            )
        ),
        'override' => array(),
        'dropdown_options' => array(),
        'extras' => array()
    );
    
    // HTML added to structure blindly, each in own COLUMN
    private static $defaultSettingsArr = array(
        "label" => false,
        "div" => false,
        "class" => "%c ",
        "id" => false,
        "legend" => false
    );

    private static $displayClassMapping = array(
        'index' => 'list',
        'table' => 'list',
        'listall' => 'list',
        'search' => 'search',
        'add' => 'add',
        'new' => 'add',
        'create' => 'add',
        'edit' => 'edit',
        'detail' => 'detail',
        'profile' => 'detail', // remove profile?
        'view' => 'detail',
        'datagrid' => 'grid',
        'editgrid' => 'grid',
        'addgrid' => 'grid',
        'delete' => 'delete',
        'remove' => 'delete',
        'cancel' => 'cancel',
        'back' => 'cancel',
        'return' => 'cancel',
        'duplicate' => 'duplicate',
        'copy' => 'duplicate',
        'return' => 'duplicate', // return = duplicate?
        'undo' => 'redo',
        'redo' => 'redo',
        'switch' => 'redo',
        'order' => 'order',
        'shop' => 'order',
        'ship' => 'order',
        'buy' => 'order',
        'cart' => 'order',
        'favourite' => 'thumbsup',
        'mark' => 'thumbsup',
        'label' => 'thumbsup',
        'thumbsup' => 'thumbsup',
        'thumbup' => 'thumbsup',
        'approve' => 'thumbsup',
        'unfavourite' => 'thumbsdown',
        'unmark' => 'thumbsdown',
        'unlabel' => 'thumbsdown',
        'thumbsdown' => 'thumbsdown',
        'thumbdown' => 'thumbsdown',
        'unapprove' => 'thumbsdown',
        'disapprove' => 'thumbsdown',
        'tree' => 'reveal',
        'reveal' => 'reveal',
        'menu' => 'menu',
        'summary' => 'summary',
        'filter' => 'filter',
        'user' => 'users',
        'users' => 'users',
        'group' => 'users',
        'groups' => 'users',
        'news' => 'news',
        'annoucement' => 'news',
        'annouvements' => 'news',
        'message' => 'news',
        'messages' => 'news'
    );

    private static $displayClassMappingPlugin = array(
        'menus' => null,
        'customize' => null,
        'clinicalannotation' => null,
        'inventorymanagement' => null,
        'datamart' => null,
        'administrate' => null,
        'drug' => null,
        'rtbform' => null,
        'order' => null,
        'protocol' => null,
        'material' => null,
        'sop' => null,
        'storagelayout' => null,
        'study' => null,
        'tools' => null,
        'pricing' => null,
        'provider' => null,
        'underdevelopment' => null,
        'labbook' => null
    );

    /**
     * StructuresHelper constructor.
     *
     * @param View $view
     * @param array $settings
     */
    public function __construct(View $view, $settings = array())
    {
        parent::__construct($view, $settings);
        
        App::uses('StructureValueDomain', 'Model');
        $this->StructureValueDomain = new StructureValueDomain();
    }

    /**
     *
     * @param string $hookExtension
     * @return bool|string
     */
    public function hook($hookExtension = '')
    {
        if ($hookExtension) {
            $hookExtension = '_' . $hookExtension;
        }
        
        $hookFile = APP . ($this->request->params['plugin'] ? 'Plugin' . DS . $this->request->params['plugin'] . DS : '') . 'View' . DS . $this->request->params['controller'] . DS . 'Hook' . DS . $this->request->params['action'] . $hookExtension . '.php';
        if (! file_exists($hookFile)) {
            $hookFile = false;
        }
        
        return $hookFile;
    }

    /**
     *
     * @param array $data
     * @param array $structure
     */
    private function updateDataWithAccuracy(array &$data, array &$structure)
    {
        if (! empty($structure['Accuracy']) && ! empty($data)) {
            $singleNode = false;
            $gotoEnd = false;
            foreach ($data as $dataL1) {
                foreach ($dataL1 as $dataL2) {
                    if (! is_array($dataL2)) {
                        $singleNode = true;
                        $data = array(
                            $data
                        );
                    }
                    $gotoEnd = true;
                    break;
                }
                if ($gotoEnd) {
                    break;
                }
            }
            
            // Fix for issue #2622 : Date accuracy won't be considered for display of Databrowser Nodes merge
            // Note: Don't have to add a fix too for csv export on 'same line' because we work on db date format for csv export
            $modelSynonyms = array();
            foreach ($structure['Sfs'] as $newField) {
                if (preg_match('/^([0-9]+\-)(.+)$/', $newField['model'], $matches)) {
                    $mainModel = $matches[2];
                    $modelSynonymous = $matches[0];
                    if (! isset($structure['Accuracy'][$modelSynonymous]) && isset($structure['Accuracy'][$mainModel]))
                        $structure['Accuracy'][$modelSynonymous] = $structure['Accuracy'][$mainModel];
                }
            }
            
            foreach ($data as &$dataLine) {
                foreach ($structure['Accuracy'] as $model => $fields) {
                    foreach ($fields as $dateField => $accuracyField) {
                        if (is_array($accuracyField)) {
                            // Fixe issue #2517: Duplicated date field in same structure: accuracy issue
                            $accuracyField = array_shift($accuracyField);
                        }
                        if (isset($dataLine[$model][$accuracyField])) {
                            $accuracy = $dataLine[$model][$accuracyField];
                            if ($accuracy != 'c') {
                                if ($accuracy == 'd') {
                                    $dataLine[$model][$dateField] = substr($dataLine[$model][$dateField], 0, 7);
                                } elseif ($accuracy == 'm') {
                                    $dataLine[$model][$dateField] = substr($dataLine[$model][$dateField], 0, 4);
                                } elseif ($accuracy == 'y') {
                                    $dataLine[$model][$dateField] = '±' . substr($dataLine[$model][$dateField], 0, 4);
                                } elseif ($accuracy == 'h') {
                                    $dataLine[$model][$dateField] = substr($dataLine[$model][$dateField], 0, 10);
                                } elseif ($accuracy == 'i') {
                                    $dataLine[$model][$dateField] = substr($dataLine[$model][$dateField], 0, 13);
                                }
                            }
                        }
                    }
                }
            }
            
            if ($singleNode) {
                $data = $data[0];
            }
        }
    }

    /**
     *
     * @param $options
     * @param $atimStructure
     */
    private function updateUnsanitizeList(&$options, $atimStructure)
    {
        if (isset($atimStructure['Sfs'])) {
            // no sanitization on select
            $flag = 'flag_' . $options['type'];
            foreach ($atimStructure['Sfs'] as $sfs) {
                if ($sfs[$flag] && $sfs['type'] == 'select') {
                    $options['settings']['no_sanitization'][$sfs['model']][] = $sfs['field'];
                }
            }
        } elseif ($options['type'] == "tree") {
            foreach ($atimStructure as $structure) {
                // no sanitization on select
                foreach ($structure['Sfs'] as $sfs) {
                    if ($sfs['flag_index'] && $sfs['type'] == 'select') {
                        $options['settings']['no_sanitization'][$sfs['model']][] = $sfs['field'];
                    }
                }
            }
        }
    }

    /**
     *
     * @return string
     */
    public function getStructureAlias()
    {
        return $this->structureAliasFinaltable;
    }

    /**
     *
     * @param $sfs
     * @param $unimportantFields
     */
    private function remove(&$sfs, $unimportantFields, $alias)
    {
        foreach ($sfs as $k => &$sf) {
            if ($alias == $sf["structure_alias"]){
                foreach ($unimportantFields as $field) {
                    unset($sf[$field]);
                }
            }else{
                unset($sfs[$k]);
            }
        }
        $sfs = array_values($sfs);
    }

    /**
     *
     * @param $structureAlias
     * @return string
     */
    private function putInTable($structureAlias)
    {
        $htmlResult = "";
        $temp = array();
        foreach ($structureAlias as $key => &$values) {
            if ($values) {
                foreach ($values as $alias => $structures) {
                    $temp[$alias] = $structures;
                }
            }
        }
        $structureAlias = $temp;
        unset($temp);
        
        $uniqueStructureAlias = array();
        foreach ($structureAlias as $alias => $structures) {
            $uniqueStructureAlias[] = $alias;
            $htmlResult .= "<h3 class='expandable'>" . $alias . "</h3>\n";
            $htmlResult .= "<table class='debugkit_structure_table'>\n";
            foreach ($structures as $index => $structure) {
                if ($index == 0) {
                    $htmlResult .= "<tr>";
                    foreach ($structure as $field => $value) {
                        $htmlResult .= "<th>" . $field . "</th>\n";
                    }
                    $htmlResult .= "</tr>\n";
                }
                $htmlResult .= "<tr>";
                foreach ($structure as $field => $value) {
                    $htmlResult .= "<td>" . $value . "</td>\n";
                }
                $htmlResult .= "</tr>\n";
            }
            $htmlResult .= "</table>\n";
        }
        
        return $htmlResult;
    }

    /**
     *
     * @param $atimStructure
     * @return array
     */
    private function simplifyStructureTable($atimStructure)
    {
        $unimportantFields = array(
            'id',
            'structure_format_id',
            'structure_field_id',
            'structure_id',
            'sortable',
            'StructureValueDomain',
            'StructureValidation'
        );
        if (Configure::read('debug')) {
            $samplifiedAliasStructure = array();
            if (isset($atimStructure['Structure'][0])) {
                foreach ($atimStructure['Structure'] as $struct) {
                    if (isset($struct['alias'])) {
                        $samplifiedAliasStructure[$struct['alias']] = $atimStructure['Sfs'];
                        $this->remove($samplifiedAliasStructure[$struct['alias']], $unimportantFields, $struct['alias']);
                    }
                }
            } elseif (isset($atimStructure['Structure']) && isset($atimStructure['Structure']['alias']) && isset($atimStructure['Sfs'])) {
                $samplifiedAliasStructure[$atimStructure['Structure']['alias']] = $atimStructure['Sfs'];
                $this->remove($samplifiedAliasStructure[$atimStructure['Structure']['alias']], $unimportantFields, $atimStructure['Structure']['alias']);
            }
        }
        return $samplifiedAliasStructure;
    }

    /**
     * Builds a structure
     *
     * @param array $atimStructure The structure to build
     * @param array $options The various options indicating how to build the structures. refer to self::$default for all options
     * @return depending on the return option, echoes the structure and returns true or returns the string
     */
    public function build(array $atimStructure = array(), array $options = array())
    {
        if (Configure::read('debug') && count($atimStructure) != 0) {
            $this->structureAliasFinal[] = $this->simplifyStructureTable($atimStructure);
            $this->structureAliasFinaltable = $this->putInTable($this->structureAliasFinal);
        }
        
        // DEFAULT set of options, overridden by PASSED options
        $options = $this->arrayMergeRecursiveDistinct(self::$defaults, $options);
        if (! isset($options['type'])) {
            $options['type'] = $this->request->params['action']; // no type, default to action
        }
        
        $data = $this->request->data;
        if (is_array($options['data'])) {
            $data = $options['data'];
        }
        if ($data == null) {
            $data = array();
        }
        
        $args = AppController::getInstance()->passedArgs;
        if (isset($args['noHeader'])) {
            $options['settings']['header'] = '';
        }
        if (isset($args['noActions'])) {
            $options['settings']['actions'] = false;
        }
        if (isset($args['type'])) {
            if ($args['type'] == 'index' && $options['type'] == 'detail') {
                $options['type'] = 'index';
                $options['settings']['pagination'] = false;
                $data = array(
                    $data
                );
            }
        }
        if (isset($args['forSelection'])) {
            $options['links']['index'] = array(
                'detail' => $options['links']['index']['detail']
            );
        }
        
        // print warning when unknown stuff and debug is on
        if (Configure::read('debug') > 0) {
            if (is_array($options)) {
                foreach ($options as $k => $foo) {
                    if (! array_key_exists($k, self::$defaults)) {
                        AppController::addWarningMsg(__("unknown function [%s] in structure build", $k));
                    }
                }
                
                if (is_array($options['settings'])) {
                    foreach ($options['settings'] as $k => $foo) {
                        if (! array_key_exists($k, self::$defaults['settings'])) {
                            AppController::addWarningMsg(__("unknown setting [%s] in structure build", $k));
                        }
                    }
                } else {
                    AppController::addWarningMsg(__("settings should be an array"));
                }
                
                if (is_array($options['links'])) {
                    foreach ($options['links'] as $k => $foo) {
                        if (! array_key_exists($k, self::$defaults['links'])) {
                            AppController::addWarningMsg(__("unknown link [%s] in structure build", $k));
                        }
                    }
                } else {
                    AppController::addWarningMsg(__("links should be an array"));
                }
            } else {
                AppController::addWarningMsg(__("settings must be an array"));
            }
        }
        
        if (! is_array($options['extras'])) {
            $options['extras'] = array(
                'end' => $options['extras']
            );
        }
        
        if (isset($atimStructure['Structure'])) {
            reset($atimStructure['Structure']);
            if (is_array(current($atimStructure['Structure']))) {
                // iterate over sub structures
                foreach ($atimStructure['Structure'] as $subStructure) {
                    if (isset($subStructure['CodingIcdCheck']) && $subStructure['CodingIcdCheck']) {
                        $options['CodingIcdCheck'] = true;
                        break;
                    }
                }
                if (! isset($options['CodingIcdCheck'])) {
                    $options['CodingIcdCheck'] = false;
                }
            } else {
                $options['CodingIcdCheck'] = isset($atimStructure['Structure']['CodingIcdCheck']) && $atimStructure['Structure']['CodingIcdCheck'];
            }
        }
        
        if ($options['settings']['return']) {
            // the result needs to be returned as a string, turn output buffering on
            ob_start();
        }
        
        if ($options['links']['top'] && $options['settings']['form_top']) {
            if (isset($options['links']['ajax']['top']) && $options['links']['ajax']['top']) {
                echo ($this->Ajax->form(array(
                    'type' => 'post',
                    'options' => array(
                        'update' => $options['links']['ajax']['top'],
                        'url' => $options['links']['top']
                    )
                )));
            } else {
                echo ('
					<form action="' . $this->generateLinksList($this->request->data, $options['links'], 'top') . '" method="post" enctype="multipart/form-data">
				');
            }
        }
        
        // display grey-box HEADING with descriptive form info
        if ($options['settings']['header']) {
            if (! is_array($options['settings']['header'])) {
                $options['settings']['header'] = array(
                    'title' => $options['settings']['header'],
                    'description' => ''
                );
            }
            
            echo '<div class="descriptive_heading">
					<h4>', $options['settings']['header']['title'], ($options['settings']['section_start'] ? "<a class='icon16 delete noPrompt sectionCtrl' href='#'></a>" : ""), '</h4>
					<p>', $options['settings']['header']['description'], '</p>
				</div>
			';
        }
        
        if ($options['settings']['section_start']) {
            echo '<div class="section">';
        }
        
        if ($options['settings']['language_heading']) {
            echo '<div class="heading_mimic"><h4>' . $options['settings']['language_heading'] . '</h4></div>';
        }
        
        if (isset($options['extras']['start'])) {
            echo ('
				<div class="extra">' . $options['extras']['start'] . '</div>
			');
        }
        
        if ($options['type'] != 'csv') {
            $this->updateUnsanitizeList($options, $atimStructure);
            $sanitizedData = stringCorrection(Sanitize::clean($data));
            if ($options['settings']['no_sanitization']) {
                $this->unsanitize($sanitizedData, $data, $options['settings']['no_sanitization']);
            }
            $data = $sanitizedData;
            unset($sanitizedData);
        }
        
        $this->updateDataWithAccuracy($data, $atimStructure); // will not update tree view data
                                                              // run specific TYPE function to build structure (ordered by frequence for performance)
        $type = $options['type'];
        if (in_array($type, self::$writeModes)) {
            // editable types, convert validation errors
            $this->myValidationErrors = array();
            foreach ($this->Form->validationErrors as $validationErrorArr) {
                $this->myValidationErrors = array_merge($validationErrorArr, $this->myValidationErrors);
            }
        }
        
        if ($type == 'summary') {
            $this->buildSummary($atimStructure, $options, $data);
        } elseif (in_array($type, array(
            'index',
            'addgrid',
            'editgrid'
        ))) {
            if ($type == 'addgrid' || $type == 'editgrid') {
                $options['settings']['pagination'] = false;
            }
            $this->buildTable($atimStructure, $options, $data, $type);
        } elseif (in_array($type, array(
            'detail',
            'add',
            'edit',
            'search',
            'batchedit'
        ))) {
            $this->buildDetail($atimStructure, $options, $data);
        } elseif ($type == 'tree') {
            $options['type'] = 'index';
            $this->buildTree($atimStructure, $options, $data);
        } elseif ($type == 'csv') {
            $this->buildCsv($atimStructure, $options, $data);
            $options['settings']['actions'] = false;
        } elseif ($type == 'chart') {
            for ($i = 0; $i < $options['number']; $i ++) {
                if (! isset($options['chartSettings']['popup']) || ! $options['chartSettings']['popup']) {
                    $options['titles'][$i] = isset($options['titles'][$i]) ? $options['titles'][$i] : "";
                    echo '<div class="heading_mimic"><h4>' . $options['titles'][$i] . '</h4></div>';
                    echo '<div class="chartDivHTML" style="height: 300px"><svg></svg></div>';
                    echo '<div class="actions" style ="background: white">
                            <div class="bottom_button">
                                <a href="javascript:void(0)" title="' . __('detach the chart') . '" class="search pop-up-chart-a" onclick = "createGraph(' . $i . ', true)">
                                <span class="icon16 charts" style="margin-right: 0px;"></span>' . '</a>
                            </div>
                        </div>';
                } else {
                    echo '<div class="heading_mimic"><h4>' . $options['titles'][$i] . '</h4></div>';
                    echo '<div class="actions" style ="background: white">
                            <div class="bottom_button">
                                <a href="javascript:void(0)" class= "show-chart-popup" title="' . __('detach the chart') . '" class="search">
                                <span class="icon16 charts"></span>' . __('detach the chart') . '</a>
                            </div>
                        </div>';
                }
            }
            return;
        } else {
            if (Configure::read('debug') > 0) {
                AppController::addWarningMsg(__("warning: unknown build type [%s]", $type));
            }
            // build detail anyway
            $options['type'] = 'detail';
            $this->buildDetail($atimStructure, $options, $data);
        }
        
        if (isset($options['extras']['end'])) {
            echo '
				<div class="extra">' . $options['extras']['end'] . '</div>
			';
        }
        
        if ($options['settings']['section_end']) {
            echo '</div>';
        }
        
        if ($options['links']['top'] && $options['settings']['form_bottom']) {
            if ($options['type'] == 'search') { // search mode
                $linkClass = "search";
                $linkLabel = __("search", null);
                $exactSearch = __("exact search") . '<input type="checkbox" name="data[exact_search]"/>';
                $exactSearch .= "\r\n<p class='bottom_button_load' data-bottom_button_load = '1'>\r\n\t<a href='javascript:void(0)' tabindex='10' class=''>\r\n\t\t<span class='icon16 load-search'></span>" . "<span class='button_load_text'>" . __("previous search") . "</span>\r\n\t</a>\r\n</p>\r\n";
            } else { // other mode
                $linkClass = "submit";
                $linkLabel = __("submit", null);
                $exactSearch = "";
            }
            $linkParams = array(
                'tabindex' => StructuresHelper::$lastTabindex + 1,
                'escape' => false,
                'class' => 'submit'
            );
            $confirmationMsg = '';
            if ($options['settings']['confirmation_msg']) {
                $linkParams['data-confirmation-msg'] = 1;
                $confirmationMsg = '<span class="confirmationMsg hidden">' . $options['settings']['confirmation_msg'] . '</span>';
            }
            echo ('
				<div class="submitBar">
					<div class="flyOverSubmit">
						' . $exactSearch . '
						<div class="bottom_button">
							<input class="submit" type="submit" value="Submit" style="display: none;"/>' . $confirmationMsg . $this->Html->link('<span class="icon16 ' . $linkClass . '"></span>' . $linkLabel, "", $linkParams) . '</div>
					</div>
				</div>
			');
        }
        
        if ($options['links']['top'] && $options['settings']['form_bottom']) {
            echo ('
				</form>
			');
        }
        
        if ($options['settings']['actions']) {
            echo $this->generateLinksList($this->request->data, $options['links'], 'bottom');
        }
        
        $result = null;
        if ($options['settings']['return']) {
            // the result needs to be returned as a string, take the output buffer
            $result = ob_get_contents();
            ob_end_clean();
        } else {
            $result = true;
        }
        return $result;
    }
    
    // end FUNCTION build()
    
    /**
     * Reorganizes a structure in a single column
     *
     * @param array $structure
     */
    private function flattenStructure(array &$structure)
    {
        $firstColumn = null;
        foreach ($structure as $tableColumnKey => $tableColumn) {
            if (is_array($tableColumn)) {
                if ($firstColumn === null) {
                    $firstColumn = $tableColumnKey;
                    continue;
                }
                $structure[$firstColumn] = array_merge($structure[$firstColumn], $tableColumn);
                unset($structure[$tableColumnKey]);
            }
        }
    }

    /**
     * Build a structure in a detail format
     *
     * @param array $atimStructure
     * @param array $options
     * @param array $dataUnit
     */
    private function buildDetail(array $atimStructure, array $options, $dataUnit)
    {
        $tableIndex = $this->buildStack($atimStructure, $options);
        // display table...
        $stretch = $options['settings']['stretch'] ? '' : ' style="width: auto;" ';
        echo '
			<table class="structure" cellspacing="0"' . $stretch . '>
			<tbody>
				<tr>
		';
        
        // each column in table
        $countColumns = 0;
        if ($options['type'] == 'search') {
            // put every structure fields in the same column
            self::flattenStructure($tableIndex);
        }
        
        $manyColumns = ! empty($options['settings']['columns_names']) && $options['type'] == 'detail';
        
        foreach ($tableIndex as $tableColumnKey => $tableColumn) {
            $countColumns ++;
            
            // for each FORM/DETAIL element...
            if (is_array($tableColumn)) {
                echo ('<td class="this_column_' . $countColumns . ' total_columns_' . count($tableIndex) . '"> 
						<table class="columns detail" cellspacing="0">
							<tbody>
								<tr>');
                
                if ($manyColumns) {
                    echo '<td></td><td class="label">', implode('</td><td class="label">', $options['settings']['columns_names']), '</td></tr><tr>';
                }
                // each row in column
                $tableRowCount = 0;
                $newLine = true;
                $endOfLine = "";
                $display = array();
                $help = null; // keeps the help if hidden fields are in the way
                foreach ($tableColumn as $tableRow) {
                    foreach ($tableRow as $tableRowPart) {
                        if (trim($tableRowPart['heading'])) {
                            if (! $newLine) {
                                echo '<td class="content">' . implode('</td><td class="content">', $display) . "</td>" . $endOfLine . "</tr><tr>";
                                $display = array();
                                $endOfLine = "";
                            }
                            echo '<td class="heading no_border" colspan="' . (SHOW_HELP ? '3' : '2') . '">
										<h4>' . $tableRowPart['heading'] . '</h4>
									</td>
								</tr><tr>
							';
                            $newLine = true;
                        }
                        
                        if ($tableRowPart['label']) {
                            if (! $newLine) {
                                echo '<td class="content">' . implode('</td><td class="content">', $display) . "</td>" . $endOfLine . "</tr><tr>";
                                $display = array();
                                $endOfLine = "";
                            }
                            $help = null;
                            $margin = '';
                            
                            if (in_array($options["type"], array("add", "edit"))!==false && isset($tableRowPart["settings"]["required"])&& $tableRowPart["settings"]["required"]=="required"){
                            $tableRowPart['label'].=" *";
                            }
                            
                            if ($tableRowPart['margin'] > 0) {
                                $margin = 'style="padding-left: ' . ($tableRowPart['margin'] * 10 + 10) . 'px"';
                            }
                            echo '<td class="label" ' . $margin . '>
										' . $tableRowPart['label'] . '
								</td>
							';
                        }
                        
                        // value
                        $currentValue = null;
                        $suffixes = $options['type'] == "search" && in_array($tableRowPart['type'], StructuresComponent::$dateRange) ? array(
                            "_start",
                            "_end"
                        ) : array(
                            ""
                        );
                        foreach ($suffixes as $suffix) {
                            $currentValue = self::getCurrentValue($dataUnit, $tableRowPart, $suffix, $options);
                            if ($manyColumns) {
                                if (is_array($currentValue)) {
                                    foreach ($options['settings']['columns_names'] as $colName) {
                                        if (! isset($display[$colName])) {
                                            $display[$colName] = "";
                                        }
                                        $display[$colName] .= isset($currentValue[$colName]) ? $currentValue[$colName] . " " : "";
                                    }
                                } else {
                                    $display = array_fill(0, count($options['settings']['columns_names']), '');
                                }
                            } else {
                                if (! isset($display[0])) {
                                    $display[0] = "";
                                }
                                if ($suffix == "_end") {
                                    $display[0] .= '<span class="tag"> To </span>';
                                }
                                if (strlen($suffix) > 0 && ($tableRowPart['type'] == 'input' || $tableRowPart['type'] == 'integer' || $tableRowPart['type'] == 'integer_positive' || $tableRowPart['type'] == 'float' || $tableRowPart['type'] == 'float_positive')) {
                                    // input type, add the sufix to the name
                                    $tableRowPart['format_back'] = $tableRowPart['format'];
                                    $tableRowPart['format'] = preg_replace('/name="data\[((.)*)\]"/', 'name="data[$1' . $suffix . ']"', $tableRowPart['format']);
                                }
                                
                                if ($tableRowPart['type'] == 'textarea') {
                                    $display[0] .= '<span>' . $this->getPrintableField($tableRowPart, $options, $currentValue, null, $suffix);
                                } else {

                                    if (($tableRowPart["type"] != "yes_no" && $tableRowPart["type"] != "y_n_u") || !isset($tableRowPart["settings"]["class"]) || strpos($tableRowPart["settings"]["class"], "required")===false){
                                        $display[0] .= '<span><span class="nowrap">' . $this->getPrintableField($tableRowPart, $options, $currentValue, null, $suffix) . '</span>';
                                    }else {
                                        $display[0] .= '<span><span class="nowrap required">' . $this->getPrintableField($tableRowPart, $options, $currentValue, null, $suffix) . '</span>';
                                    }
                                }
                                
                                if (strlen($suffix) > 0 && ($tableRowPart['type'] == 'input' || $tableRowPart['type'] == 'integer' || $tableRowPart['type'] == 'integer_positive' || $tableRowPart['type'] == 'float' || $tableRowPart['type'] == 'float_positive')) {
                                    $tableRowPart['format'] = $tableRowPart['format_back'];
                                }
                                if ($options['type'] == "search" && ! in_array($tableRowPart['type'], StructuresComponent::$rangeTypes) && ! isset($tableRowPart['settings']['noCtrl'])) {
                                    $display[0] .= '<a class="adv_ctrl btn_add_or icon16 add_mini" href="#" onclick="return false;"></a>';
                                }
                                $display[0] .= '</span>';
                            }
                            
                            if ($tableRowPart['type'] == 'hidden') {
                                $tableRowPart['help'] = $help;
                            } else {
                                $help = $tableRowPart['help'];
                            }
                        }
                        
                        if (SHOW_HELP) {
                            
                            $endOfLine = '
									<td class="help">
										' . $tableRowPart['help'] . '
									</td>';
                        }
                        
                        $newLine = false;
                    }
                    $tableRowCount ++;
                } // end ROW
                echo '<td class="content">' . implode('</td><td class="content">', $display) . '</td>' . $endOfLine . '</tr>
						</tbody>
						</table>
						
					</td>
				';
            } else {
                $this->printExtras($countColumns, count($tableIndex), $tableColumn);
            }
        } // end COLUMN
        
        echo ('
				</tr>
			</tbody>
			</table>
		');
    }

    /**
     * Echoes a structure in a summary format
     *
     * @param array $atimStructure
     * @param array $options
     * @param array $dataUnit
     */
    private function buildSummary(array $atimStructure, array $options, array $dataUnit)
    {
        $tableIndex = $this->buildStack($atimStructure, $options);
        self::flattenStructure($tableIndex);
        echo ("<dl>");
        foreach ($tableIndex as $tableColumnKey => $tableColumn) {
            $firstLine = true;
            foreach ($tableColumn as $tableRow) {
                foreach ($tableRow as $tableRowPart) {
                    if (strlen($tableRowPart['label']) > 0 || $firstLine) {
                        if (! $firstLine) {
                            echo "</dd>";
                        }
                        echo "<dt>", $tableRowPart['label'], "</dt><dd>";
                        $firstLine = false;
                    }
                    if (array_key_exists($tableRowPart['model'], $dataUnit) && array_key_exists($tableRowPart['field'], $dataUnit[$tableRowPart['model']])) {
                        $value = $dataUnit[$tableRowPart['model']][$tableRowPart['field']];
                        if ($tableRowPart['type'] == 'textarea') {
                            $value = str_replace('\n', '<br/>', $value);
                        }
                        echo $this->getPrintableField($tableRowPart, $options, $value, null, null), " ";
                    } elseif (Configure::read('debug') > 0 && $options['settings']['data_miss_warn']) {
                        AppController::addWarningMsg(__("no data for [%s.%s]", $tableRowPart['model'], $tableRowPart['field']));
                    }
                }
            }
            if (! $firstLine) {
                echo "</dd>";
            }
        }
        echo ("</dl>");
    }

    /**
     *
     * @param $currentValue
     * @return string
     */
    private function getOpenFileLink($currentValue)
    {
        $fileArray = explode(".", $currentValue);
        $extention = $fileArray[count($fileArray) - 1];
        $name = "";
        for ($i = 3; $i < count($fileArray) - 1; $i ++) {
            $name .= $fileArray[$i] . ".";
        }
        $shortName = $name;
        if (strlen($name) > 30) {
            $shortName = substr($name, 0, 30) . '...';
        }
        return '<a title = "' . __("download %s", $name . $extention) . '" href="?file=' . $currentValue . '">' . $shortName . $extention . '</a>';
    }

    /**
     * Echoes a structure field
     *
     * @param array $tableRowPart The field settings
     * @param array $options The structure settings
     * @param string $currentValue The value to use/lookup for the field
     * @param int $key A numeric key used when there is multiple instances of the same field (like grids)
     * @param string $fieldNameSuffix A name suffix to use on active non input fields
     * @return string The built field
     */
    private function getPrintableField(array $tableRowPart, array $options, $currentValue, $key, $fieldNameSuffix)
    {
        $display = null;
        $fieldName = $tableRowPart['name'] . $fieldNameSuffix;
        if ($tableRowPart['flag_confidential'] && ! $this->Session->read('flag_show_confidential')) {
            $display = CONFIDENTIAL_MARKER;
            if ($options['links']['top'] && $options['settings']['form_inputs'] && $options['type'] != "search") {
                AppController::getInstance()->redirect("/Pages/err_confidential");
            }
        } elseif ($options['links']['top'] && $options['settings']['form_inputs'] && ! $tableRowPart['readonly']) {
            if ($tableRowPart['type'] == "date") {
                $display = "";
                if ($options['type'] != "search" && isset(AppModel::$accuracyConfig[$tableRowPart['tablename']][$tableRowPart['field']])) {
                    $display = "<div class='accuracy_target_blue'></div>";
                }
                $display .= self::getDateInputs($fieldName, $currentValue, $tableRowPart['settings']);
            } elseif ($tableRowPart['type'] == "datetime") {
                $date = $time = null;
                if (is_array($currentValue)) {
                    $date = $currentValue;
                    $time = $currentValue;
                } elseif (strlen($currentValue) > 0 && $currentValue != "NULL") {
                    if (strpos($currentValue, " ") === false) {
                        $date = $currentValue;
                    } else {
                        list ($date, $time) = explode(" ", $currentValue);
                    }
                }
                
                if ($options['type'] != "search" && isset(AppModel::$accuracyConfig[$tableRowPart['tablename']][$tableRowPart['field']])) {
                    $display = "<div class='accuracy_target_blue'></div>";
                }
                
                $display .= self::getDateInputs($fieldName, $date, $tableRowPart['settings']);
                unset($tableRowPart['settings']['required']);
                $display .= self::getTimeInputs($fieldName, $time, $tableRowPart['settings']);
            } elseif ($tableRowPart['type'] == "time") {
                $display = self::getTimeInputs($fieldName, $currentValue, $tableRowPart['settings']);
            } elseif ($tableRowPart['type'] == "select" || (($options['type'] == "search" || $options['type'] == "batchedit") && ($tableRowPart['type'] == "radio" || $tableRowPart['type'] == "checkbox" || $tableRowPart['type'] == "yes_no" || $tableRowPart['type'] == "y_n_u"))) {
                if (array_key_exists($currentValue, $tableRowPart['settings']['options']['previously_defined'])) {
                    $tableRowPart['settings']['options']['previously_defined'] = array(
                        $currentValue => $tableRowPart['settings']['options']['previously_defined'][$currentValue]
                    );
                } elseif (! array_key_exists($currentValue, $tableRowPart['settings']['options']['defined']) && ! array_key_exists($currentValue, $tableRowPart['settings']['options']['previously_defined']) && count($tableRowPart['settings']['options']) > 1) {
                    // add the unmatched value if there is more than a value
                    if (($options['type'] == "search" || $options['type'] == "batchedit") && $currentValue == "") {
                        // this is a search or batchedit and the value is the empty one, not really an "unmatched" one
                        $tableRowPart['settings']['options'] = array_merge(array(
                            "" => ""
                        ), $tableRowPart['settings']['options']);
                        if (empty($tableRowPart['settings']['options']['previously_defined'])) {
                            $defined = $tableRowPart['settings']['options']['defined'];
                            unset($tableRowPart['settings']['options']['defined']);
                            unset($tableRowPart['settings']['options']['previously_defined']);
                            $tableRowPart['settings']['options'] = array_merge($tableRowPart['settings']['options'], $defined);
                        }
                    } else {
                        $tableRowPart['settings']['options'] = array(
                            __('unmatched value') => array(
                                $currentValue => $currentValue
                            ),
                            __('supported value') => $tableRowPart['settings']['options']['defined']
                        );
                    }
                } elseif ($options['type'] == "search" && ! empty($tableRowPart['settings']['options']['previously_defined'])) {
                    $tmp = $tableRowPart['settings']['options']['defined'];
                    unset($tableRowPart['settings']['options']['defined']);
                    $tableRowPart['settings']['options'][__('defined')] = $tmp;
                    $tmp = $tableRowPart['settings']['options']['previously_defined'];
                    unset($tableRowPart['settings']['options']['previously_defined']);
                    $tableRowPart['settings']['options'][__('previously defined')] = $tmp;
                } else {
                    $tableRowPart['settings']['options'] = $tableRowPart['settings']['options']['defined'];
                }
                
                $tableRowPart['settings']['class'] = str_replace("%c ", isset($this->myValidationErrors[$tableRowPart['field']]) ? "error " : "", $tableRowPart['settings']['class']);
                $display = $this->Form->input($fieldName, array_merge($tableRowPart['settings'], array(
                    'type' => 'select',
                    'value' => $currentValue
                )));
            } elseif ($tableRowPart['type'] == "radio") {
                if (! array_key_exists($currentValue, $tableRowPart['settings']['options'])) {
                    $tableRowPart['settings']['options'][$currentValue] = "(" . __('unmatched value') . ") " . $currentValue;
                }
                $display = $this->Form->input($fieldName, array_merge($tableRowPart['settings'], array(
                    'type' => $tableRowPart['type'],
                    'value' => $currentValue,
                    'checked' => $currentValue ? true : false
                )));
            } elseif ($tableRowPart['type'] == "checkbox") {
                unset($tableRowPart['settings']['options']);
                $display = $this->Form->input($fieldName, array_merge($tableRowPart['settings'], array(
                    'type' => 'checkbox',
                    'value' => 1,
                    'checked' => $currentValue ? true : false
                )));
            } elseif ($tableRowPart['type'] == "yes_no" || $tableRowPart['type'] == "y_n_u") {
                unset($tableRowPart['settings']['options']);
                $display = $this->Form->input($fieldName, array_merge($tableRowPart['settings'], array(
                    'type' => 'hidden',
                    'value' => ""
                ))) . __('yes') . $this->Form->input($fieldName, array_merge($tableRowPart['settings'], array(
                    'type' => 'checkbox',
                    'value' => "y",
                    'hiddenField' => false,
                    'checked' => $currentValue == "y" ? true : false
                ))) . __('no') . $this->Form->input($fieldName, array_merge($tableRowPart['settings'], array(
                    'type' => 'checkbox',
                    'value' => "n",
                    'hiddenField' => false,
                    'checked' => $currentValue == "n" ? true : false
                )));
                if ($tableRowPart['type'] == "y_n_u") {
                    $display .= __('unknown') . $this->Form->input($fieldName, array_merge($tableRowPart['settings'], array(
                        'type' => 'checkbox',
                        'value' => "u",
                        'hiddenField' => false,
                        'checked' => $currentValue == "u" ? true : false
                    )));
                }
            } elseif (($tableRowPart['type'] == "float" || $tableRowPart['type'] == "float_positive") && DECIMAL_SEPARATOR == ',') {
                $currentValue = str_replace('.', ',', $currentValue);
            } elseif ($tableRowPart['type'] == "textarea") {
                $currentValue = str_replace('\n', "\n", $currentValue);
            } elseif ($tableRowPart['type'] == 'file') {
                if ($currentValue) {
                    if (! is_array($currentValue)) {
                        $display = $this->getOpenFileLink($currentValue);
                        $display .= '<input type="radio" class="fileOption" name="data[' . $fieldName . '][option]" value="" checked="checked"><span>' . _('keep') . '</span>';
                        $display .= '<input type="radio" class="fileOption" name="data[' . $fieldName . '][option]" value="delete"><span>' . _('delete') . '</span>';
                        $display .= '<input type="radio" class="fileOption" name="data[' . $fieldName . '][option]" value="replace"><span>' . _('replace') . '</span>';
                        $display .= ' ';
                    }
                }
            }
            $display .= $tableRowPart['format']; // might contain hidden field if the current one is disabled
            
            $this->fieldDisplayFormat($display, $tableRowPart, $key, $currentValue);
            
            if (($options['type'] == "addgrid" || $options['type'] == "editgrid") && strpos($tableRowPart['settings']['class'], "pasteDisabled") !== false && $tableRowPart['type'] != "hidden") {
                // displays the "no copy" icon on the left of the fields with disabled copy option
                $display .= '<div class="pasteDisabled"></div>';
            }
        } elseif (strlen($currentValue) > 0) {
            $elligibleAsDate = strlen($currentValue) > 1;
            if ($tableRowPart['type'] == "date" && $elligibleAsDate) {
                $date = explode("-", $currentValue);
                $year = $date[0];
                $month = null;
                $day = null;
                switch (count($date)) {
                    case 3:
                        $day = $date[2];
                    case 2:
                        $month = $date[1];
                        break;
                }
                list ($day) = explode(" ", $day); // in case the current date is a datetime
                $display = AppController::getFormatedDateString($year, $month, $day, $options['type'] != 'csv');
            } elseif ($tableRowPart['type'] == "datetime" && $elligibleAsDate) {
                $display = AppController::getFormatedDatetimeString($currentValue, $options['type'] != 'csv');
            } elseif ($tableRowPart['type'] == "time" && $elligibleAsDate) {
                list ($hour, $minutes) = explode(":", $currentValue);
                $display = AppController::getFormatedTimeString($hour, $minutes);
            } elseif (in_array($tableRowPart['type'], array(
                "select",
                "radio",
                "checkbox",
                "yes_no",
                "y_n_u"
            ))) {
                if (isset($tableRowPart['settings']['options']['defined'][$currentValue])) {
                    $display = $tableRowPart['settings']['options']['defined'][$currentValue];
                } elseif (isset($tableRowPart['settings']['options']['previously_defined'][$currentValue])) {
                    $display = $tableRowPart['settings']['options']['previously_defined'][$currentValue];
                } else {
                    $display = $currentValue;
                    if (Configure::read('debug') > 0 && ($currentValue != "-" || $options['settings']['data_miss_warn'])) {
                        AppController::addWarningMsg(__("missing reference key [%s] for field [%s]", $currentValue, $tableRowPart['field']));
                    }
                }
            } elseif (($tableRowPart['type'] == "float" || $tableRowPart['type'] == "float_positive") && DECIMAL_SEPARATOR == ',') {
                $display = str_replace('.', ',', $currentValue);
            } elseif ($tableRowPart['type'] == 'textarea') {
                $currentValue = htmlspecialchars($currentValue);
                $currentValue = str_replace('\\\\', '&dbs;', $currentValue);
                $currentValue = str_replace('\n', in_array($options['type'], self::$writeModes) ? "\n" : '<br/>', $currentValue);
                $currentValue = str_replace('&dbs;', '\\', $currentValue);
                $display = html_entity_decode($currentValue);
            } elseif ($tableRowPart['type'] == 'file') {
                $display = $this->getOpenFileLink($currentValue);
            } else {
                $display = $currentValue;
            }
        }
        
        if ($tableRowPart['readonly']) {
            $tmp = $tableRowPart['format'];
            
            if (isset($tableRowPart['settings']['options'])) {
                // merging with numerical keys
                $tableRowPart['settings']['options'] = $tableRowPart['settings']['options']['defined'] + $tableRowPart['settings']['options']['previously_defined'];
            }
            
            if ($tableRowPart['type'] == 'select' && ! array_key_exists($currentValue, $tableRowPart['settings']['options'])) {
                // disabled dropdown with unmatched value, pick the first one
                $arrKeys = array_keys($tableRowPart['settings']['options']);
                $currentValue = $arrKeys[0];
                $display = $tableRowPart['settings']['options'][$currentValue];
            }
            $this->fieldDisplayFormat($tmp, $tableRowPart, $key, $currentValue);
            $display .= $tmp;
        }
        
        $tag = "";
        if (strlen($tableRowPart['tag']) > 0) {
            if ($options['type'] == 'csv') {
                $tag = $tableRowPart['tag'] == '-' ? '' : $tableRowPart['tag'] . ' ';
            } else {
                $tag = '<span class="tag">' . $tableRowPart['tag'] . '</span> ';
            }
        }
        return $tag . (strlen($display) > 0 ? $display : "-") . " ";
    }

    /**
     * Update the field display to insert in it its values and classes
     *
     * @param string &$display Pointer to the display string, which will be updated
     * @param array $tableRowPart The current field data/settings
     * @param string $key The key, if any to use in the name
     * @param string $currentValue The current field value
     */
    private function fieldDisplayFormat(&$display, array $tableRowPart, $key, $currentValue)
    {
        $display = str_replace("%c ", isset($this->myValidationErrors[$tableRowPart['field']]) ? "error " : "", $display);
        
        if (strlen($key)) {
            $display = str_replace("[%d]", "[" . $key . "]", $display);
        }
        if (! is_array($currentValue)) {
            $display = str_replace("%s", $currentValue, $display);
        }
        
        if (isset($tableRowPart['tool'])) {
            $display .= $tableRowPart['tool'];
        }
    }

    /**
     * Echoes a structure in a table format
     *
     * @param array $atimStructure
     * @param array $options
     * @param array $data
     * @param $type
     */
    private function buildTable(array $atimStructure, array $options, array $data, $type)
    {
        // attach PER PAGE pagination param to PASSED params array...
        if (isset($this->request->params['named']) && isset($this->request->params['named']['per'])) {
            $this->request->params['pass']['per'] = $this->request->params['named']['per'];
        }
        
        $tableStructure = $this->buildStack($atimStructure, $options);
        
        $structureCount = 0;
        $structureIndex = array(
            1 => $tableStructure
        );
        
        $stretch = $options['settings']['stretch'] ? '' : ' style="width: auto;" ';
        $class = 'structure ' . $options['type'];
        if ($options['type'] == 'index') {
            $class .= ' lineHighlight';
        }
        echo '
			<table class="' . $class . '" cellspacing="0"' . $stretch . '>
				<tbody>
					<tr>
		';
        foreach ($structureIndex as $tableKey => $tableIndex) {
            $structureCount ++;
            if (is_array($tableIndex)) {
                // start table...
                echo '
					<td class="this_column_', $structureCount, ' total_columns_', count($structureIndex), '">
						<table class="columns index" cellspacing="0">
				';
                $removeLineCtrl = ($options['type'] == 'addgrid' || $options['type'] == 'editgrid') && $options['settings']['del_fields'];
                $addLineCtrl = ($options['type'] == 'addgrid' || $options['type'] == 'editgrid') && $options['settings']['add_fields'];
                $options['remove_line_ctrl'] = $removeLineCtrl;
                $headerData = $this->buildDisplayHeader($tableIndex, $options);
                echo '<thead>', $headerData['header'], '</thead>';
                
                if ($options['type'] == "addgrid" && count($data) == 0) {
                    // display at least one line
                    $data[0] = array();
                }
                
                if (count($data)) {
                    $data = array_merge(array(), $data); // make sure keys are starting from 0 and that none is being skipped
                    echo "<tbody>";
                    
                    if ($addLineCtrl) {
                        // blank hidden line
                        $data["%d"] = array();
                    }
                    $rowNum = 1;
                    $defaultSettingsWoClass = self::$defaultSettingsArr;
                    unset($defaultSettingsWoClass['class']);
                    foreach ($data as $key => $dataUnit) {
                        if ($addLineCtrl && $rowNum == count($data)) {
                            echo "<tr class='hidden'>";
                        } else {
                            echo "<tr>";
                        }
                        
                        // checklist
                        if (count($options['links']['checklist'])) {
                            echo '
								<td class="checkbox">', $this->getChecklist($options['links']['checklist'], $dataUnit), '</td>
							';
                        }
                        
                        // radiolist
                        if (count($options['links']['radiolist'])) {
                            echo '
								<td class="radiobutton">', $this->getRadiolist($options['links']['radiolist'], $dataUnit), '</td>
							';
                        }
                        
                        // index
                        if (count($options['links']['index'])) {
                            $currentLinks = array();
                            if (is_array($options['links']['index'])) {
                                foreach ($options['links']['index'] as $name => &$link) {
                                    $currentLinks[$name] = $this->strReplaceLink($link, $dataUnit);
                                }
                            } else {
                                $currentLinks[] = $this->strReplaceLink($options['links']['index'], $dataUnit);
                            }
                            $currentLinks = array(
                                'index' => $currentLinks
                            );
                            if (isset($options['links']['ajax']['index'])) {
                                $currentLinks['ajax']['index'] = $options['links']['ajax']['index'];
                            }
                            echo '
								<td class="id">', $this->generateLinksList(null, $currentLinks, 'index'), '</td>
							';
                        }
                        
                        $structureCount = 0;
                        $structureIndex = array(
                            1 => $tableStructure
                        );
                        
                        // add EXTRAS, if any
                        $structureIndex = $this->displayExtras($structureIndex, $options);
                        
                        // data
                        $firstCell = true;
                        $suffix = null; // used by the require inline
                        foreach ($tableIndex as $tableColumn) {
                            foreach ($tableColumn as $tableRow) {
                                foreach ($tableRow as $tableRowPart) {
                                    $currentValue = self::getCurrentValue($dataUnit, $tableRowPart, "", $options);
                                    $getPrintableField = $this->getPrintableField($tableRowPart, $options, $currentValue, $key, null);
                                    $hint = strlen($getPrintableField) > 100 ? $getPrintableField : " ";
                                    if (strlen($tableRowPart['label']) || $firstCell) {
                                        if ($type === 'index') {
                                            if ($firstCell) {
                                                echo "<td><p class = 'wraped-text'>";
                                                $firstCell = false;
                                            } else {
                                                echo "</p></td><td><p class = 'wraped-text' title='" . $hint . "'>";
                                            }
                                        } else {
                                            if ($firstCell) {
                                                echo "<td>";
                                                $firstCell = false;
                                            } else {
                                                echo "</td><td>";
                                            }
                                        }
                                    }
                                    echo $getPrintableField;
                                }
                            }
                        }
                        if ($type === 'index') {
                            echo "</p></td>\n";
                        } else {
                            echo "</td>\n";
                        }
                        
                        // remove line ctrl
                        if ($removeLineCtrl) {
                            echo '
									<td class="right">
										<a href="#" class="removeLineLink icon16 delete_mini" title="', __('click to remove these elements'), '"></a>
									</td>
							';
                        }
                        
                        echo "</td></tr>";
                        $rowNum ++;
                    }
                    echo "</tbody><tfoot>";
                    if ($options['settings']['pagination']) {
                        echo '<pre>';
                        echo '</pre>';
                        echo '<tr class="pagination">
                                <th colspan="', $headerData['count'], '">
                                    <span class="results">', $this->Paginator->counter(array(
                            'format' => '%start%-%end%' . __(' of ') . '%count%'
                        )), '</span>
                                    <span class="links">
                                            ', $this->Paginator->prev(__('prev'), null, __('prev')), '
                                            ', $this->Paginator->numbers(), '
                                            ', $this->Paginator->next(__('next'), null, __('next')), '
                                    </span>';
                        $limits = array(
                            5,
                            10,
                            20,
                            50
                        );
                        $currentLimit = $this->Paginator->params['paging'];
                        $currentLimit = current($currentLimit);
                        $currentLimit = $currentLimit['limit'];
                        while ($limit = array_shift($limits)) {
                            echo ($currentLimit == $limit ? '<span class="current">' : ''), $this->Paginator->link($limit, array(
                                'page' => 1,
                                'limit' => $limit
                            )), ($currentLimit == $limit ? '</span>' : ''), (count($limits) ? ' | ' : '');
                        }
                        echo '			</th>
								</tr>
						';
                    }
                    
                    if (count($options['links']['checklist'])) {
                        echo "<tr><td colspan='3'><a href='#' class='checkAll'>", __('check all'), "</a> | <a href='#' class='uncheckAll'>", __('uncheck all'), "</a></td></tr>";
                    }
                    
                    if ($addLineCtrl) {
                        echo '<tr>
								<td class="right" colspan="', $headerData['count'], '">
									<a class="addLineLink icon16 add_mini" href="#" title="', __('click to add a line'), '"></a>
									<input class="addLineCount" type="text" size="1" value="1" maxlength="2"/> line(s)
								</td>
							</tr>
						';
                    }
                    echo "</tfoot>";
                } else {
                    echo '<tfoot>
							<tr>
									<td class="no_data_available" colspan="', $headerData['count'], '">', __('core_no_data_available'), '</td>
							</tr></tfoot>
					';
                }
                echo "</table></td>";
            } else {
                $this->printExtras($structureCount, count($structureIndex), $tableIndex);
            }
        }
        echo "</tr></tbody></table>";
    }

    /**
     * Builds a structure in a csv format
     *
     * @param unknown_type $atimStructure
     * @param unknown_type $options
     * @param $data
     */
    private function buildCsv($atimStructure, $options, $data)
    {
        $csv = $this->Csv;
        if (isset(AppController::getInstance()->csvConfig)) {
            $this->Csv->csvSeparator = AppController::getInstance()->csvConfig['define_csv_separator'];
        }
        
        if (isset($csv::$nodesInfo)) {
            // same line mode
            $this->Csv->current = array();
            $tmpCodingIcdCheck = false; // $options['CodingIcdCheck'] has not been set by previous functions
            if ($options['settings']['csv_header']) {
                // first call, build all structures
                $options['type'] = 'index';
                $nodeNameLine = array();
                $headingLine = array();
                $displayHeading = false;
                $lines = array();
                foreach ($csv::$nodesInfo as $nodeId => $nodeInfo) {
                    $headingSubLine = array();
                    $subLine = array();
                    $csv::$structures[$nodeId] = $structure = $this->buildStack($csv::$structures[$nodeId], $options);
                    $csv::$structures[$nodeId] = $this->titleHtmlSpecialCharsDecode($csv::$structures[$nodeId], isset(AppController::getInstance()->csvConfig) ? AppController::getInstance()->csvConfig['define_csv_encoding'] : CSV_ENCODING);
                    foreach ($csv::$structures[$nodeId] as $tableColumn) {
                        $lastHeading = '';
                        foreach ($tableColumn as $fm => $tableRow) {
                            foreach ($tableRow as $tableRowPart) {
                                if (strlen($tableRowPart['heading'])) {
                                    $displayHeading = true;
                                    $lastHeading = $tableRowPart['heading'];
                                }
                                $headingSubLine[] = $lastHeading;
                                $subLine[] = $tableRowPart['label'];
                                if (in_array($tableRowPart['type'], array(
                                    'date',
                                    'datetime'
                                ))) {
                                    $subLine[] = __('accuracy');
                                    $headingSubLine[] = $lastHeading;
                                }
                                if (! isset($options['CodingIcdCheck'])) {
                                    foreach (AppModel::getMagicCodingIcdTriggerArray() as $key => $trigger) {
                                        if (strpos($tableRowPart['setting'], $trigger) !== false) {
                                            $tmpCodingIcdCheck = true;
                                        }
                                    }
                                }
                            }
                        }
                    }
                    $csv::$nodesInfo[$nodeId]['cols_count'] = count($subLine);
                    for ($i = 1; $i <= $nodeInfo['max_length']; ++ $i) {
                        foreach ($subLine as $subLineKey => $subLinePart) {
                            $nodeNameLine[] = $nodeInfo['display_name'] . " $i";
                            $headingLine[] = $headingSubLine[$subLineKey];
                            $line[] = $subLinePart;
                        }
                    }
                }
                $options['type'] = 'csv'; // go back to csv
                $this->Csv->addRow($nodeNameLine);
                if ($displayHeading)
                    $this->Csv->addRow($headingLine);
                $this->Csv->addRow($line);
            }
            
            $lines = array();
            // data = array(node => pkey => data rows => data line
            
            if (! isset($options['CodingIcdCheck'])) {
                $options['CodingIcdCheck'] = $tmpCodingIcdCheck;
            }
            
            foreach ($csv::$nodesInfo as $nodeId => $nodeInfo) {
                // fill the node section of the lines array. the index is the pkey of the line
                foreach ($data[$nodeId] as $pkey => $dataRow) {
                    if (! isset($lines[$pkey])) {
                        $lines[$pkey] = array();
                    }
                    $instances = 0;
                    foreach ($dataRow as $modelData) {
                        // node_data is all data of a node linked to a pkey
                        foreach ($csv::$structures[$nodeId] as $tableColumn) {
                            foreach ($tableColumn as $tableRow) {
                                foreach ($tableRow as $tableRowPart) {
                                    if (isset($modelData[$tableRowPart['model']][$tableRowPart['field']])) {
                                        if (in_array($tableRowPart['type'], array(
                                            'date',
                                            'datetime'
                                        ))) {
                                            $lines[$pkey] = array_merge($lines[$pkey], $this->getDateValuesFormattedForExcel($modelData[$tableRowPart['model']], $tableRowPart['field'], $tableRowPart['type']));
                                        } else {
                                            $currentValue = self::getCurrentValue($modelData, $tableRowPart, "", $options);
                                            $lines[$pkey][] = trim($this->getPrintableField($tableRowPart, $options, $currentValue, null, null));
                                        }
                                    } else {
                                        $lines[$pkey][] = '';
                                        if (in_array($tableRowPart['type'], array(
                                            'date',
                                            'datetime'
                                        )))
                                            $lines[$pkey][] = "";
                                    }
                                }
                            }
                        }
                        ++ $instances;
                    }
                    if ($instances < $csv::$nodesInfo[$nodeId]['max_length']) {
                        // padding
                        $lines[$pkey] = array_merge($lines[$pkey], array_fill(0, $csv::$nodesInfo[$nodeId]['cols_count'], ""));
                    }
                }
            }
            
            foreach ($lines as &$line) {
                $this->Csv->addRow($line);
            }
            echo $this->Csv->render($options['settings']['csv_header'], isset(AppController::getInstance()->csvConfig) ? AppController::getInstance()->csvConfig['define_csv_encoding'] : CSV_ENCODING);
        } else {
            // default mode, multi lines
            $options['type'] = 'index';
            $tableStructure = $this->buildStack($atimStructure, $options);
            $tableStructure = $this->titleHtmlSpecialCharsDecode($tableStructure, isset(AppController::getInstance()->csvConfig) ? AppController::getInstance()->csvConfig['define_csv_encoding'] : CSV_ENCODING);
            $options['type'] = 'csv'; // go back to csv
            
            if (is_array($tableStructure) && count($data)) {
                // header line
                if ($options['settings']['csv_header']) {
                    $nodeNameLine = array();
                    $languageNodeList = array();
                    $headingLine = array();
                    $displayHeading = false;
                    $line = array();
                    if (empty($options['settings']['columns_names'])) {
                        foreach ($tableStructure as $tableColumn) {
                            $lastHeading = '';
                            foreach ($tableColumn as $fm => $tableRow) {
                                foreach ($tableRow as $tableRowPart) {
                                    $structureGroupName = isset($tableRowPart['structure_group_name']) ? $tableRowPart['structure_group_name'] : '';
                                    $nodeNameLine[] = $structureGroupName;
                                    $languageNodeList[$structureGroupName] = '-1';
                                    if (strlen($tableRowPart['heading'])) {
                                        $lastHeading = $tableRowPart['heading'];
                                        $displayHeading = true;
                                    }
                                    $headingLine[] = $lastHeading;
                                    $line[] = $tableRowPart['label'];
                                    if (in_array($tableRowPart['type'], array(
                                        'date',
                                        'datetime'
                                    ))) {
                                        $nodeNameLine[] = $structureGroupName;
                                        $headingLine[] = $lastHeading;
                                        $line[] = __('accuracy');
                                    }
                                }
                            }
                        }
                    } else {
                        // Multi-Lines and Multi Column Report Display: Date format for excel not supported
                        // No heading to manage
                        $line = array_merge(array(
                            ''
                        ), $options['settings']['columns_names']);
                    }
                    if (! empty($nodeNameLine) && sizeof($languageNodeList) > 1)
                        $this->Csv->addRow($nodeNameLine);
                    if ($displayHeading)
                        $this->Csv->addRow($headingLine);
                    $this->Csv->addRow($line);
                }
                
                // content
                if (empty($options['settings']['columns_names'])) {
                    foreach ($data as $dataUnit) {
                        $line = array();
                        foreach ($tableStructure as $tableColumn) {
                            foreach ($tableColumn as $fm => $tableRow) {
                                foreach ($tableRow as $tableRowPart) {
                                    if (isset($dataUnit[$tableRowPart['model']][$tableRowPart['field']])) {
                                        if (in_array($tableRowPart['type'], array(
                                            'date',
                                            'datetime'
                                        ))) {
                                            $line = array_merge($line, $this->getDateValuesFormattedForExcel($dataUnit[$tableRowPart['model']], $tableRowPart['field'], $tableRowPart['type']));
                                        } else {
                                            $currentValue = self::getCurrentValue($dataUnit, $tableRowPart, "", $options);
                                            $line[] = trim($this->getPrintableField($tableRowPart, $options, $currentValue, null, null));
                                        }
                                    } else {
                                        $line[] = "";
                                        if (in_array($tableRowPart['type'], array(
                                            'date',
                                            'datetime'
                                        )))
                                            $line[] = "";
                                    }
                                }
                            }
                        }
                        $this->Csv->addRow($line);
                    }
                } else {
                    // Multi-Lines and Multi Column Report Display: Date format for excel not supported + no ICD description generated
                    foreach ($tableStructure as $tableColumn) {
                        foreach ($tableColumn as $fm => $tableRow) {
                            foreach ($tableRow as $tableRowPart) {
                                $line = array(
                                    $tableRowPart['label']
                                );
                                $currentData = $data[0][0][$tableRowPart['field']];
                                foreach ($options['settings']['columns_names'] as $columnName) {
                                    if (array_key_exists($columnName, $currentData)) {
                                        $line[] = trim($this->getPrintableField($tableRowPart, $options, $currentData[$columnName], null, null));
                                    } else {
                                        $line[] = '';
                                    }
                                }
                                $this->Csv->addRow($line);
                            }
                        }
                    }
                }
            }
            
            echo $this->Csv->render($options['settings']['csv_header'], isset(AppController::getInstance()->csvConfig) ? AppController::getInstance()->csvConfig['define_csv_encoding'] : CSV_ENCODING);
        }
    }

    /**
     * Convert all HTML entities to their applicable characters for all headings, labels and tags of the structure
     *
     * @param array $tableStructure Structure to work on
     * @param string $encoding Enconding
     * @return array $tableStructure Processed structrue
     */
    public function titleHtmlSpecialCharsDecode($tableStructure, $encoding)
    {
        foreach ($tableStructure as &$tableColumn) {
            foreach ($tableColumn as &$tableRow) {
                foreach ($tableRow as &$tableRowPart) {
                    $tableRowPart['heading'] = html_entity_decode($tableRowPart['heading'], ENT_NOQUOTES, $encoding);
                    $tableRowPart['label'] = html_entity_decode($tableRowPart['label'], ENT_NOQUOTES, $encoding);
                    $tableRowPart['tag'] = html_entity_decode($tableRowPart['tag'], ENT_NOQUOTES, $encoding);
                }
            }
        }
        return $tableStructure;
    }

    /**
     * Rebuild date that has been formated by function updateDataWithAccuracy() to be formated for CSV export
     *
     * @param array $modelData
     * @param array $field
     * @param array $fieldType date or datetime
     * @return array
     */
    public function getDateValuesFormattedForExcel($modelData, $field, $fieldType)
    {
        $reformattedDate = array();
        if (isset($modelData[$field])) {
            if (! empty($modelData[$field])) {
                $accuracy = isset($modelData[$field . '_accuracy']) ? ($modelData[$field . '_accuracy'] ? $modelData[$field . '_accuracy'] : 'c') : 'c';
                $reformattedDate = $modelData[$field];
                if (($fieldType == 'date' && ! preg_match('/^[0-9]{4}\-[0-9]{2}\-[0-9]{2}$/', $reformattedDate)) || ($fieldType == 'datetime' && ! preg_match('/^[0-9]{4}\-[0-9]{2}\-[0-9]{2}\ [0-9]{2}\:[0-9]{2}(\:[0-9][0-9]){0,1}$/', $reformattedDate))) {
                    // Add regular expression on date to be sure date has been first formated by updateDataWithAccuracy() (not done when exproting data on same line from databrowser)
                    switch ($accuracy) {
                        case 'y':
                            $reformattedDate = str_replace('±', '', $reformattedDate);
                        case 'm':
                            $reformattedDate = str_replace('%s', $reformattedDate, '%s-01-01' . ($fieldType == 'date' ? '' : ' 00:00'));
                            break;
                        case 'd':
                            $reformattedDate = str_replace('%s', $reformattedDate, '%s-01' . ($fieldType == 'date' ? '' : ' 00:00'));
                            break;
                        case 'h':
                            $reformattedDate = str_replace('%s', $reformattedDate, '%s 00:00');
                            break;
                        case 'i':
                            $reformattedDate = str_replace('%s', $reformattedDate, '%s:00');
                            break;
                        default:
                    }
                }
                $dateValues[] = $reformattedDate;
                $dateValues[] = __('date_accuracy_value_' . $accuracy);
            } else {
                $dateValues = array(
                    '-',
                    '-'
                );
            }
        }
        return $dateValues;
    }

    /**
     * Echoes a structure in a tree format
     *
     * @param array $atimStructures Contains atim_strucures (yes, plural), one for each data model to display
     * @param array $options
     * @param array $data
     */
    private function buildTree(array $atimStructures, array $options, array $data)
    {
        // prebuild links
        if (count($data)) {
            foreach ($options['links']['tree'] as $modelName => $links) {
                $tmp = $options['links']['tree'][$modelName];
                unset($options['links']['tree'][$modelName]);
                $options['links']['tree'][$modelName]['index'] = $tmp;
                unset($tmp);
                foreach (array(
                    'radiolist',
                    'checklist'
                ) as $type) {
                    if (isset($options['links']['tree'][$modelName]['index'][$type])) {
                        $options['links']['tree'][$modelName][$type] = $options['links']['tree'][$modelName]['index'][$type];
                        unset($options['links']['tree'][$modelName]['index'][$type]);
                    }
                }
                
                // index links
                $treeLinks = $options['links'];
                $treeLinks['index'] = $options['links']['tree'][$modelName]['index'];
                $options['links']['tree'][$modelName]['index'] = $this->generateLinksList(null, $treeLinks, 'index');
            }
        }
        
        $stretch = $options['settings']['stretch'] ? '' : ' style="width: auto;" ';
        echo '
			<table class="structure" cellspacing="0"' . $stretch . '>
			<tbody>
				<tr>
		';
        
        $structureCount = 0;
        $structureIndex = array(
            1 => array()
        );
        
        // add EXTRAS, if any
        $structureIndex = $this->displayExtras($structureIndex, $options);
        
        foreach ($structureIndex as $columnKey => $tableIndex) {
            
            $structureCount ++;
            
            // for each FORM/DETAIL element...
            
            if (is_array($tableIndex)) {
                
                echo ('
					<td class="this_column_' . $structureCount . ' total_columns_' . count($structureIndex) . '" style="width: 30%;">
						<table class="columns tree" cellspacing="0">
							<tbody>
				');
                
                if (count($data)) {
                    // start root level of UL tree, and call NODE function
                    echo ('
						<tr><td>
							<ul class="tree_root">
					');
                    $this->buildTreeNode($atimStructures, $options, $data);
                    
                    echo ('
							</ul>
						</td></tr>
					');
                } else {
                    // display something nice for NO ROWS msg...
                    echo ('
							<tr>
									<td class="no_data_available" colspan="1">' . __('core_no_data_available') . '</td>
							</tr>
					');
                }
                
                echo ('
							</tbody>
						</table>
					</td>
				');
            } else {
                $this->printExtras($structureCount, count($structureIndex), $tableIndex);
            }
        }
        
        echo '
				</tr>
			</tbody>
			</table>
			';
    }

    /**
     * Echoes a tree node for the tree structure
     *
     * @param array $atimStructures
     * @param array $options
     * @param array $data
     */
    private function buildTreeNode(array &$atimStructures, array $options, array $data)
    {
        $accuracyUpdated = array();
        foreach ($data as $dataKey => &$dataVal) {
            // unset CHILDREN from data, to not confuse STACK function
            $children = array();
            if (isset($dataVal['children'])) {
                $children = $dataVal['children'];
                unset($dataVal['children']);
            }
            echo '
				<li>
			';
            
            // collect LINKS and STACK to be added to LI, must do out of order, as need ID field to use as unique CSS ID in UL/A toggle
            // reveal sub ULs if sub ULs exist
            $links = "";
            $expandKey = "";
            echo '<div class="nodeBlock"><div class="leftPart">- ';
            if (count($options['links']['tree'])) {
                $i = 0;
                foreach ($dataVal as $modelName => $modelArray) {
                    if (isset($options['links']['tree'][$modelName])) {
                        // apply prebuilt links
                        if (isset($options['links']['tree'][$modelName]['radiolist'])) {
                            $links .= $this->getRadiolist($options['links']['tree'][$modelName]['radiolist'], $dataVal);
                        }
                        
                        if (isset($options['links']['tree'][$modelName]['checklist'])) {
                            $links .= $this->getCheckist($options['links']['tree'][$modelName]['check'], $dataVal);
                        }
                        
                        $links .= $this->strReplaceLink($options['links']['tree'][$modelName]['index'], $dataVal);
                        
                        if (isset($modelArray['id'])) {
                            $expandKey = $modelName;
                            break;
                        }
                    }
                }
            } elseif (count($options['links']['index'])) {
                // apply prebuilt links
                $links = $this->strReplaceLink($options['links']['tree'][$expandKey], $dataVal);
            }
            if (is_array($children)) {
                if (empty($children)) {
                    echo '<a class="icon16 reveal not_allowed href="#" onclick="return false;">+</a> | ';
                } else {
                    echo '<a class="icon16 reveal activate" href="#" onclick="return false;">+</a> | ';
                }
            } elseif ($children) {
                $dataJson = array(
                    'url' => isset($options['links']['tree_expand'][$expandKey]) ? $this->strReplaceLink($options['links']['tree_expand'][$expandKey], $dataVal) : ""
                );
                if (isset($dataJson['url'][0]) && $dataJson['url'][0] == '/') {
                    $dataJson['url'] = substr($dataJson['url'], 1);
                }
                $dataJson = htmlentities(json_encode($dataJson));
                echo '<a class="icon16 reveal notFetched" data-json="' . $dataJson . '" href="#" onclick="return false;">+</a> | ';
            } else {
                echo '<a class="icon16 reveal not_allowed" href="#" onclick="return false;">+</a> | ';
            }
            
            $dataVal['css'][] = 'rightPart';
            echo '</div><div class="' . implode(' ', $dataVal['css']) . '"><span class="nowrap">', $links, '</span>';
            
            if (count($options['settings']['tree'])) {
                foreach ($dataVal as $modelName => $modelArray) {
                    if (isset($options['settings']['tree'][$modelName])) {
                        
                        if (! isset($atimStructures[$options['settings']['tree'][$modelName]]['app_stack'])) {
                            $atimStructures[$options['settings']['tree'][$modelName]]['app_stack'] = $this->buildStack($atimStructures[$options['settings']['tree'][$modelName]], $options);
                        }
                        
                        $tableIndex = $atimStructures[$options['settings']['tree'][$modelName]]['app_stack'];
                        
                        if (! array_key_exists($options['settings']['tree'][$modelName], $accuracyUpdated)) {
                            // update accuracy, only once per structure binding per level.
                            $this->updateDataWithAccuracy($data, $atimStructures[$options['settings']['tree'][$modelName]]);
                            $accuracyUpdated[$options['settings']['tree'][$modelName]] = true;
                        }
                        
                        break;
                    }
                }
            }
            
            $options['type'] = 'index';
            unset($options['stack']);
            $first = true;
            foreach ($tableIndex as $tableColumnKey => $tableColumn) {
                foreach ($tableColumn as $tableRowKey => $tableRow) {
                    foreach ($tableRow as $tableRowPart) {
                        // carefull with the white spaces as removing them the can break the display in IE
                        echo '<span class="nowrap">';
                        if (($tableRowPart['type'] != 'hidden' && strlen($tableRowPart['label'])) || $first) {
                            echo '<span class="divider">|</span> ';
                            $first = false;
                        }
                        
                        if (isset($dataVal[$tableRowPart['model']]['id'])) {
                            // prepends model.pkey to the beginning of the name (used by permission tree)
                            $toPrefix = $dataVal[$tableRowPart['model']]['id'] . "][";
                            if (isset($tableRowPart['format']) && strlen($tableRowPart['format']) > 0) {
                                $tableRowPart['format'] = preg_replace('/name="data\[/', 'name="data[' . $toPrefix, $tableRowPart['format']);
                            } else {
                                $tableRowPart['name'] = $toPrefix . $tableRowPart['name'];
                            }
                        }
                        echo $this->getPrintableField($tableRowPart, $options, isset($dataVal[$tableRowPart['model']][$tableRowPart['field']]) ? $dataVal[$tableRowPart['model']][$tableRowPart['field']] : "", null, null), '</span>
						';
                    }
                }
            }
            
            echo '</div>
				<div class="treeArrow">
				</div>
			</div>';
            
            // create sub-UL, calling this NODE function again, if model has any CHILDREN
            if (is_array($children) && ! empty($children)) {
                echo '
					<ul style="display:none;">
				';
                
                $this->buildTreeNode($atimStructures, $options, $children);
                echo '
					</ul>
				';
            }
            
            echo '
				</li>
			';
        }
    }

    /**
     * Builds the display header
     *
     * @param array $tableStructure
     * @param array $options The options
     * @return array
     * @internal param array $tableIndex The structural information* The structural information
     */
    private function buildDisplayHeader(array $tableStructure, array $options)
    {
        $columnCount = 0;
        $returnString = '<tr>';
        $languageNode = '';
        $languageNodeString = "";
        $languageNodeCount = 0;
        $languageNodeList = array();
        $languageHeader = '';
        $languageHeaderString = "";
        $languageHeaderCount = 0;
        $colspan = 0;
        
        foreach (array(
            'checklist',
            'radiolist',
            'index'
        ) as $key) {
            if (count($options['links'][$key])) {
                ++ $colspan;
                $columnCount ++;
                $languageNodeCount ++;
                $languageHeaderCount ++;
            }
        }
        
        $batchset = '';
        if ($options['settings']['batchset'] && $options['settings']['batchset']['link'] && $options['settings']['batchset']['var'] && AppController::checkLinkPermission('/Datamart/BatchSets/add/')) {
            $link = preg_replace('#(/){2,}#', '/', $this->request->webroot . $options['settings']['batchset']['link'] . '/batchsetVar:' . $options['settings']['batchset']['var']);
            if (isset($options['settings']['batchset']['ctrl'])) {
                $link .= '/batchsetCtrl:' . $options['settings']['batchset']['ctrl'];
            }
            $batchset = '<a href="' . $link . '" title="' . __('add to temporary batchset') . '" class="icon16 batchset"></a>';
        }
        
        if ($colspan) {
            $returnString .= $colspan > 1 ? ('<th colspan="' . $colspan . '">' . $batchset . '</th>') : '<th>' . $batchset . '</th>';
            $batchset = '';
        }
        
        // each column/row in table
        if (count($tableStructure)) {
            $linkParts = explode('/', $_SERVER['REQUEST_URI']);
            $sortOn = "";
            $sortAsc = true;
            foreach ($linkParts as $linkPart) {
                if (strpos($linkPart, "sort:") === 0) {
                    $sortOn = substr($linkPart, 5);
                } elseif ($linkPart == "direction:desc") {
                    $sortAsc = false;
                }
            }
            
            $paging = $this->Paginator->params['paging'];
            if (strlen($sortOn) == 0 && isset($this->Paginator->params['paging']) && ($part = current($paging)) && isset($part['defaults']['order'])) {
                $sortOn = is_array($part['defaults']['order']) ? current($part['defaults']['order']) : $part['defaults']['order'];
                list ($sortOn) = explode(",", $sortOn); // discard any but the first order by clause
                $sortOn = explode(" ", $sortOn);
                $sortAsc = ! isset($sortOn[1]) || strtoupper($sortOn[1]) != "DESC";
                $sortOn = $sortOn[0];
            }
            
            $contentColumnsCount = 0;
            foreach ($tableStructure as $tableColumn) {
                foreach ($tableColumn as $tableRow) {
                    foreach ($tableRow as $tableRowPart) {
                        if ($tableRowPart['type'] != 'hidden' && strlen($tableRowPart['label']) > 0) {
                            ++ $contentColumnsCount;
                        }
                    }
                }
            }
            $columnCount += $contentColumnsCount;
            $contentColumnsCount /= 2;
            $currentColNumber = 0;
            $firstCell = true;
            $previousStructureGroup = null;
            $structureGroupChange = false;
            foreach ($tableStructure as $tableColumn) {
                $newColumn = true;
                foreach ($tableColumn as $tableRow) {
                    foreach ($tableRow as $tableRowPart) {
                        if (($tableRowPart['type'] != 'hidden' && strlen($tableRowPart['label']) > 0) || $firstCell) {
                            if (isset($tableRowPart['structure_group'])) {
                                if ($previousStructureGroup != $tableRowPart['structure_group']) {
                                    $structureGroupChange = true;
                                    $previousStructureGroup = $tableRowPart['structure_group'];
                                } else {
                                    $structureGroupChange = false;
                                }
                            } elseif ($previousStructureGroup) {
                                $structureGroupChange = true;
                                $previousStructureGroup = null;
                            } else {
                                $structureGroupChange = false;
                            }
                            $firstCell = false;
                            
                            // label and help/info marker, if available...
                            if ($tableRowPart['flag_float']) {
                                $returnString .= '
									<th class="floatingCell">
								' . $batchset;
                            } else {
                                $returnString .= '
									<th>
								' . $batchset;
                            }
                            $batchset = '';
                            
                            if ($structureGroupChange) {
                                if ($languageNodeCount > 0) {
                                    $languageNode .= '<th colspan="' . $languageNodeCount . '">' . (trim($languageNodeString) ? '<div class="indexLangHeader">' . $languageNodeString . '</div>' : '') . '</th>';
                                }
                                $languageNodeCount = 0;
                                $languageNodeString = isset($tableRowPart['structure_group_name']) ? $tableRowPart['structure_group_name'] : '';
                                $languageNodeList[$languageNodeString] = '-1';
                            }
                            ++ $languageNodeCount;
                            if ($tableRowPart['heading'] || $structureGroupChange || $newColumn) {
                                if ($languageHeaderCount > 0) {
                                    $languageHeader .= '<th colspan="' . $languageHeaderCount . '">' . (trim($languageHeaderString) ? '<div class="indexLangHeader">' . $languageHeaderString . '</div>' : '') . '</th>';
                                }
                                $languageHeaderCount = 0;
                                $languageHeaderString = $tableRowPart['heading'];
                            }
                            ++ $languageHeaderCount;
                            $newColumn = false;
                            
                            $defaultSortingDirection = isset($_REQUEST['direction']) ? $_REQUEST['direction'] : 'asc';
                            $defaultSortingDirection = strtolower($defaultSortingDirection);
                            
                            if ($tableRowPart['sortable'] && ($options['settings']['pagination'] || $options['settings']['sorting'])) {
                                $sortedOnCurrentColumn = $tableRowPart['model'] . '.' . $tableRowPart['field'] == $sortOn;
                                if ($sortedOnCurrentColumn) {
                                    $returnString .= '<div style="display: inline-block;" class="ui-icon ui-icon-triangle-1-' . ($sortAsc ? "s" : "n") . '"></div>';
                                }
                                if ($options['settings']['pagination']) {
                                    $paginatorString = $this->Paginator->sort($tableRowPart['model'] . '.' . $tableRowPart['field'], html_entity_decode($tableRowPart['label'], ENT_QUOTES, "UTF-8"));
                                    if ($sortedOnCurrentColumn && $sortAsc) {
                                        $paginatorString = str_replace('/direction:asc">', '/direction:desc">', $paginatorString);
                                    }
                                    $returnString .= $paginatorString;
                                } else {
                                    // sorting
                                    $url = array_merge($options['settings']['sorting'], array(
                                        'sort' => $tableRowPart['model'] . '.' . $tableRowPart['field'],
                                        'direction' => $sortedOnCurrentColumn && $sortAsc ? "desc" : "asc",
                                        'order' => null
                                    ));
                                    $returnString .= $this->Html->link(html_entity_decode($tableRowPart['label'], ENT_QUOTES, "UTF-8"), $url, array());
                                }
                            } else {
                                $returnString .= $tableRowPart['label'];

                                if (in_array($options["type"], array("addgrid", "editgrid"))!==false && isset($tableRowPart["settings"]["required"])&& $tableRowPart["settings"]["required"]=="required"){
                                    $returnString .= " *";
                                }
                            }
                            
                            if (SHOW_HELP) {
                                $returnString .= $currentColNumber < $contentColumnsCount ? str_replace('<span class="icon16 help">', '<span class="icon16 help right">', $tableRowPart['help']) : $tableRowPart['help'];
                            }
                            
                            ++ $currentColNumber;
                            $returnString .= '
								</th>
							';
                        }
                    }
                }
            }
        }
        
        if ($options['remove_line_ctrl']) {
            $returnString .= '
				<th>&nbsp;</th>
			';
            $columnCount ++;
            $languageNodeCount ++;
            $languageHeaderCount ++;
        }
        
        // end header row...
        $returnString .= '
				</tr>
		';
        
        if (sizeof($languageNodeList) > 1) {
            if ($languageNodeString) {
                $languageNode = '<tr>' . $languageNode . '<th colspan="' . $languageNodeCount . '">' . (trim($languageNodeString) ? '<div class="indexLangHeader">' . $languageNodeString . '</div>' : '') . '</th></tr>';
            }
            if ($languageNode)
                $languageNode .= '<th>&nbsp;</th>';
        } else {
            $languageNode = '';
        }
        if ($languageHeaderCount) {
            $languageHeader = '<tr>' . $languageHeader . '<th colspan="' . $languageHeaderCount . '">' . (trim($languageHeaderString) ? '<div class="indexLangHeader">' . $languageHeaderString . '</div>' : '') . '</th></tr>';
        }
        
        return array(
            "header" => $languageNode . $languageHeader . $returnString,
            "count" => $columnCount
        );
    }

    /**
     *
     * @param array $returnArray
     * @param $options
     * @return array
     */
    private function displayExtras($returnArray = array(), $options)
    {
        if (count($options['extras'])) {
            foreach ($options['extras'] as $key => $val) {
                if ($key == 'start' || $key == 'end') {
                    continue;
                }
                while (isset($returnArray[$key])) {
                    $key ++;
                }
                $returnArray[$key] = $val;
            }
        }
        ksort($returnArray);
        return $returnArray;
    }

    /**
     *
     * @param $thisColumn
     * @param $totalColumns
     * @param $content
     */
    private function printExtras($thisColumn, $totalColumns, $content)
    {
        echo ('
			<td class="this_column_' . $thisColumn . ' total_columns_' . $totalColumns . '"> 
			
				<table class="columns extra" cellspacing="0">
				<tbody>
					<tr>
						<td>
							' . $content . '
						</td>
					</tr>
				</tbody>
				</table>
				
			</td>
		');
    }

    /**
     * Builds the structure part that will contain data.
     * Input types (inputs and numbers) are prebuilt
     * whereas other types still need to be generated
     *
     * @param array $atimStructure
     * @param array $options
     * @return array The representation of the display where $result = arry(x => array(y => array(field data))
     */
    private function buildStack(array $atimStructure, array $options)
    {
        $stack = array(); // the stack array represents the display x => array(y => array(field data))
        $emptyHelpBullet = '<span class="icon16 help error">&nbsp;&nbsp;&nbsp;&nbsp;</span>';
        $helpBullet = '<span class="icon16 help">&nbsp;&nbsp;&nbsp;&nbsp;<div>%s</div></span> ';
        $independentTypes = array(
            "select" => null,
            "radio" => null,
            "checkbox" => null,
            "date" => null,
            "datetime" => null,
            "time" => null,
            "yes_no" => null,
            "y_n_u" => null
        );
        $myDefaultSettingsArr = self::$defaultSettingsArr;
        $myDefaultSettingsArr['value'] = "%s";
        self::$lastTabindex = max(self::$lastTabindex, $options['settings']['tabindex']);
        
        if (isset($atimStructure['Sfs'])) {
            // float fields must bear the column number of the first real field
            $column = null;
            foreach ($atimStructure['Sfs'] as $sfs) {
                if ($sfs['flag_float'] == 0) {
                    $column = $sfs['display_column'];
                    break;
                }
            }
            if ($column != null) {
                foreach ($atimStructure['Sfs'] as &$sfs) {
                    if ($sfs['flag_float']) {
                        $sfs['display_column'] = $column;
                    } else {
                        break;
                    }
                }
                unset($sfs);
            }
            
            $pasteDisabled = array();
            foreach ($atimStructure['Sfs'] as $sfs) {
                $modelDotField = $sfs['model'] . '.' . $sfs['field'];
                if ($sfs['flag_' . $options['type']] || ($options['settings']['all_fields'] && ($sfs['flag_detail'] || $sfs['flag_index']))) {
                    $current = array(
                        "name" => "",
                        "model" => $sfs['model'],
                        "tablename" => $sfs['tablename'],
                        "field" => $sfs['field'],
                        "heading" => trim($sfs['language_heading']) ? __($sfs['language_heading']) : $sfs['language_heading'],
                        "label" => __($sfs['language_label']),
                        "tag" => __($sfs['language_tag']),
                        "type" => $sfs['type'],
                        "help" => strlen($sfs['language_help']) > 0 ? sprintf($helpBullet, __($sfs['language_help'])) : $emptyHelpBullet,
                        "setting" => $sfs['setting'], // required for icd10 magic
                        "default" => $sfs['default'],
                        "sortable" => array_key_exists('sortable', $sfs)? $sfs['sortable'] : 0,
                        "flag_confidential" => $sfs['flag_confidential'],
                        "flag_float" => $sfs['flag_float'],
                        "readonly" => isset($sfs["flag_" . $options['type'] . "_readonly"]) && $sfs["flag_" . $options['type'] . "_readonly"],
                        "margin" => $sfs['margin'],
                        "structure_group" => isset($sfs['structure_group']) ? $sfs['structure_group'] : null,
                        "structure_group_name" => isset($sfs['structure_group_name']) ? $sfs['structure_group_name'] : null
                    );
                    $settings = $myDefaultSettingsArr;
                    $dateFormatArr = str_split(DATE_FORMAT);
                    if ($options['links']['top'] && $options['settings']['form_inputs']) {
                        $settings['tabindex'] = self::$lastTabindex ++;
                        
                        // building all text fields (dropdowns, radios and checkboxes cannot be built here)
                        $fieldName = "";
                        if (strlen($options['settings']['name_prefix'])) {
                            $fieldName .= $options['settings']['name_prefix'] . ".";
                        }
                        if ($options['type'] == 'addgrid' || $options['type'] == 'editgrid') {
                            $fieldName .= "%d.";
                            if (in_array($modelDotField, $options['settings']['paste_disabled_fields'])) {
                                $settings['class'] .= " pasteDisabled";
                                $pasteDisabled[] = $modelDotField;
                            }
                        }
                        $fieldName .= $modelDotField;
                        $fieldName = str_replace(".", "][", $fieldName); // manually replace . by ][ to counter cake bug
                        $current['name'] = $fieldName;
                        $rangeValueSearch = $options['type'] == "search" && in_array($current['type'], StructuresComponent::$rangeTypesNumber);
                        if (strlen($sfs['setting']) > 0 && ! $current['readonly'] || $rangeValueSearch) {
                            // parse through FORM_FIELDS setting value, and add to helper array
                            if (empty($sfs['setting'])) {
                                $sfs['setting'] = "calss=%c";
                            }
                            $tmpSetting = explode(',', $sfs['setting']);
                            foreach ($tmpSetting as $setting) {
                                $setting = explode('=', $setting);
                                if ($rangeValueSearch && strpos($settings['class'], 'range') === false) {
                                    $settings['class'] .= 'range ';
                                }
                                if ($setting[0] == 'tool') {
                                    if ($setting[1] == 'csv') {
                                        if ($options['type'] == 'search') {
                                            $current['tool'] = $this->Form->input($fieldName . "_with_file_upload", array_merge($settings, array(
                                                "type" => "file",
                                                "class" => null,
                                                "value" => null
                                            )));
                                        }
                                    } else {
                                        $href = preg_replace("#(\/){2,}#", "/", $this->request->webroot . str_replace(' ', '_', trim(str_replace('.', ' ', $setting[1])))); // webroot bug otherwise
                                        $current['tool'] = '<a href="' . $href . '" class="tool_popup"></a>';
                                    }
                                } else {
                                    if ($setting[0] == 'class' && isset($settings['class'])) {
                                        $settings['class'] .= ' ' . $setting[1];
                                    } else {
                                        if (! array_key_exists(1, $setting)) {
                                            $settings[$setting[0]] = '';
                                            if (Configure::read('debug') > 0) {
                                                AppController::addWarningMsg(__("missing value for the setting [%s] of the structure field [%s]", $setting[0], $fieldName));
                                            }
                                        } else {
                                            $settings[$setting[0]] = $setting[1];
                                        }
                                    }
                                }
                            }
                        }
                        
                        // validation CSS classes
                        if (isset($sfs['StructureValidation']) && count($sfs['StructureValidation']) > 0 && $options['type'] != "search") {
                            
                            foreach ($sfs['StructureValidation'] as $validation) {
                                if ($validation['rule'] == 'notBlank') {
                                    if ($options['type'] != 'batchedit') {
                                        $settings["class"] .= " required";
                                        $settings["required"] = "required";
                                    }
                                    break;
                                }
                            }
                            if ($settings["class"] == "%c ") {
                                $settings["class"] .= "validation";
                            }
                        }
                        if ($current['readonly']) {
                            unset($settings['disabled']);
                            $current["format"] = $this->Form->text($fieldName, array(
                                "type" => "hidden",
                                "id" => false,
                                "value" => "%s"
                            ), $settings);
                            $settings['disabled'] = "disabled";
                        } elseif ($sfs['type'] == "input") {
                            if ($options['type'] != "search") {
                                $settings['class'] = str_replace("range", "", $settings['class']);
                            }
                            $current["format"] = $this->Form->input($fieldName, array_merge(array(
                                "type" => "text"
                            ), $settings));
                        } elseif (array_key_exists($sfs['type'], $independentTypes)) {
                            // do nothing for independent types
                            $current["format"] = "";
                        } elseif ($sfs['type'] == "integer" || $sfs['type'] == "integer_positive") {
                            if (! isset($settings['size'])) {
                                $settings['size'] = 4;
                            }
                            $current["format"] = $this->Form->text($fieldName, array_merge(array(
                                "type" => "number"
                            ), $settings));
                        } elseif ($sfs['type'] == "float" || $sfs['type'] == "float_positive") {
                            if (! isset($settings['size'])) {
                                $settings['size'] = 4;
                            }
                            $current["format"] = $this->Form->text($fieldName, array_merge(array(
                                "type" => "text"
                            ), $settings));
                        } elseif ($sfs['type'] == "textarea") {
                            // notice this is Form->input and not Form->text
                            $tmpSettings = array();
                            if ($options['type'] == 'add' || $options['type'] == 'edit' || $options == 'search') {
                                // default textarea size in add/edit/search
                                if (! array_key_exists('rows', $settings)) {
                                    $settings['rows'] = 3;
                                }
                                if (! array_key_exists('cols', $settings)) {
                                    $settings['cols'] = 30;
                                }
                            } elseif ($options['type'] == 'addgrid' || $options['type'] == 'editgrid') {
                                // default textarea size in grids
                                if (! array_key_exists('rows', $settings)) {
                                    $settings['rows'] = 2;
                                }
                                if (! array_key_exists('cols', $settings)) {
                                    $settings['cols'] = 15;
                                }
                            }
                            $current["format"] = $this->Form->input($fieldName, array_merge(array(
                                "type" => "textarea"
                            ), array_merge($settings, $tmpSettings)));
                        } elseif ($sfs['type'] == "autocomplete" || $sfs['type'] == "hidden" || $sfs['type'] == "file" || $sfs['type'] == "password") {
                            if ($sfs['type'] == "autocomplete" && isset($settings['url'])) {
                                $settings['class'] .= " jqueryAutocomplete";
                            }
                            $current["format"] = $this->Form->text($fieldName, array_merge(array(
                                "type" => $sfs['type']
                            ), $settings));
                            if ($sfs['type'] == "hidden") {
                                if (strlen($current['label'])) {
                                    if (Configure::read('debug') > 0) {
                                        // AppController::addWarningMsg(__("the hidden field [%s] label has been removed", $modelDotField));
                                    }
                                    $current['label'] = "";
                                }
                                if (strlen($current['heading'])) {
                                    if (Configure::read('debug') > 0) {
                                        // AppController::addWarningMsg(__("the hidden field [%s] heading has been removed", $modelDotField));
                                    }
                                    $current['heading'] = "";
                                }
                            }
                        } elseif ($sfs['type'] == "display") {
                            $current["format"] = "%s";
                        } else {
                            if (Configure::read('debug') > 0) {
                                AppController::addWarningMsg(__("field type [%s] is unknown", $sfs['type']));
                            }
                            $current["format"] = $this->Form->input($fieldName, array_merge(array(
                                "type" => "text"
                            ), $settings));
                        }
                        
                        $current['default'] = $sfs['default'];
                        $current['settings'] = $settings;
                    } else {
                        $current["format"] = "";
                    }
                    
                    if (array_key_exists($sfs['type'], $independentTypes)) {
                        $dropdownResult = array(
                            "defined" => array(),
                            "previously_defined" => array()
                        );
                        if ($sfs['type'] == "select") {
                            $addBlank = true;
                            if (count($sfs['StructureValidation']) > 0 && (in_array($options['type'], array(
                                'edit',
                                'editgrid',
                                'add',
                                'addgrid'
                            )))) {
                                // check if the field can be empty or not
                                foreach ($sfs['StructureValidation'] as $validation) {
                                    if ($validation['rule'] == 'notBlank') {
                                        if (in_array($options['type'], array(
                                            'edit',
                                            'editgrid'
                                        )) || ! empty($sfs['default']) || (isset($options['override'][$modelDotField]) && ! empty($options['override'][$modelDotField]))) {
                                            $addBlank = false;
                                        }
                                        break;
                                    }
                                }
                            }
                            if ($addBlank) {
                                $dropdownResult["defined"][""] = "";
                            }
                        }
                        
                        if (isset($options['dropdown_options'][$modelDotField])) {
                            $dropdownResult['defined'] = $options['dropdown_options'][$modelDotField];
                        } elseif (count($sfs['StructureValueDomain']) > 0) {
                            $this->StructureValueDomain->updateDropdownResult($sfs['StructureValueDomain'], $dropdownResult);
                        } elseif ($sfs['type'] == "checkbox") {
                            // provide yes/no as default for checkboxes
                            $dropdownResult['defined'] = array(
                                0 => __("no"),
                                1 => __("yes")
                            );
                        } elseif ($sfs['type'] == "yes_no" || $sfs['type'] == "y_n_u") {
                            // provide yes/no/? as default for yes_no
                            $dropdownResult['defined'] = array(
                                "" => "",
                                "n" => __("no"),
                                "y" => __("yes")
                            );
                            if ($sfs['type'] == "y_n_u") {
                                $dropdownResult['defined']["u"] = __('unknown');
                            }
                        }
                        
                        if ($options['type'] == "search" && ($sfs['type'] == "checkbox" || $sfs['type'] == "radio")) {
                            // checkbox and radio buttons in search mode are dropdowns
                            $dropdownResult['defined'] = array_merge(array(
                                "" => ""
                            ), $dropdownResult['defined']);
                        }
                        
                        if (count($dropdownResult['defined']) == 2 && isset($sfs['flag_' . $options['type'] . '_readonly']) && $sfs['flag_' . $options['type'] . '_readonly'] && isset($addBlank) && $addBlank) {
                            // unset the blank value, the single value for a disabled field should be default
                            unset($dropdownResult['defined'][""]);
                        }
                        $current['settings']['options'] = $dropdownResult;
                    }
                    
                    if (! isset($stack[$sfs['display_column']][$sfs['display_order']])) {
                        $stack[$sfs['display_column']][$sfs['display_order']] = array();
                    }
                    $stack[$sfs['display_column']][$sfs['display_order']][] = $current;
                }
            }
            
            if (Configure::read('debug') > 0) {
                $pasteDisabled = array_diff($options['settings']['paste_disabled_fields'], $pasteDisabled);
                if (count($pasteDisabled) > 0) {
                    AppController::addWarningMsg("Paste disabled field(s) not found: " . implode(", ", $pasteDisabled), true);
                }
            }
        }
        
        if (Configure::read('debug') > 0 && count($options['override']) > 0) {
            $override = array_merge(array(), $options['override']);
            foreach ($stack as $cell) {
                foreach ($cell as $fields) {
                    foreach ($fields as $field) {
                        unset($override[$field['model'] . "." . $field['field']]);
                        if (in_array($field['type'], array(
                            'date',
                            'datetime'
                        )))
                            unset($override[$field['model'] . "." . $field['field'] . '_accuracy']);
                    }
                }
            }
            if (count($override) > 0) {
                if ($options['type'] == 'index' || $options['type'] == 'detail') {
                    AppController::addWarningMsg(__("you should not define overrides for index and detail views"));
                } else {
                    foreach ($override as $key => $foo) {
                        AppController::addWarningMsg(__("the override for [%s] couldn't be applied because the field was not found", $key));
                    }
                }
            }
        }
        return $stack;
    }

    /**
     *
     * @param array $atimContent
     * @param array $options
     * @return string
     */
    public function generateContentWrapper($atimContent = array(), $options = array())
    {
        $returnString = '';
        
        // display table...
        $returnString .= '
			<table class="structure" cellspacing="0">
			<tbody>
				<tr>
		';
        
        // each column in table
        $countColumns = 0;
        foreach ($atimContent as $content) {
            $countColumns ++;
            
            $returnString .= '
				<td class="this_column_' . $countColumns . ' total_columns_' . count($atimContent) . '"> 
					
					<table class="columns content" cellspacing="0">
					<tbody>
						<tr>
							<td>
								' . $content . '
							</td>
						</tr>
					</tbody>
					</table>
						
				</td>
			';
        } // end COLUMN
        
        $returnString .= '
				</tr>
			</tbody>
			</table>
		';
        
        return $returnString . $this->generateLinksList(null, isset($options['links']) ? $options['links'] : array(), 'bottom');
    }

    /**
     *
     * @param $data
     * @param array $optionLinks
     * @param string $state
     * @return mixed|string
     */
    private function generateLinksList($data, array $optionLinks, $state = 'index')
    {
        $returnString = '';
        
        $returnUrls = array();
        $returnLinks = array();
        
        $links = isset($optionLinks[$state]) ? $optionLinks[$state] : array();
        $links = is_array($links) ? $links : array(
            'detail' => $links
        );
        // parse through $LINKS array passed to function, make link for each
        foreach ($links as $linkName => $linkArray) {
            if (empty($linkArray)) {
                continue;
            }
            if (! is_array($linkArray)) {
                $linkArray = array(
                    $linkName => $linkArray
                );
            }
            
            $linkResults = array();
            
            $icon = "";
            $json = "";
            if (isset($linkArray['link'])) {
                if (isset($linkArray['icon'])) {
                    $icon = $linkArray['icon'];
                }
                if (isset($linkArray['json'])) {
                    $json = $linkArray['json'];
                }
                $linkArray = array(
                    $linkName => $linkArray['link']
                );
            }
            $prevIcon = $icon;
            foreach ($linkArray as $linkLabel => &$linkLocation) {
                $icon = $prevIcon;
                if (is_array($linkLocation)) {
                    if (isset($linkLocation['icon'])) {
                        // set requested custom icon
                        $icon = $linkLocation['icon'];
                    }
                    $linkLocation = &$linkLocation['link'];
                }
                
                // if ACO/ARO permissions check succeeds or if it's a js command, create link
                if (AppController::checkLinkPermission($linkLocation) || strpos($linkLocation, "javascript:") === 0) {
                    
                    $displayClassName = $this->generateLinkClass($linkName, $linkLocation);
                    $htmlAttributes = array(
                        'title' => strip_tags(html_entity_decode(__($linkName), ENT_QUOTES, "UTF-8"))
                    );
                    
                    $class = strlen($icon) > 0 ? $icon : $displayClassName;
                    
                    // set Javascript confirmation msg...
                    $confirmationMsg = null;
                    
                    if ($data != null) {
                        $linkLocation = $this->strReplaceLink($linkLocation, $data);
                    }
                    
                    $returnUrls[] = $this->Html->url($linkLocation);
                    
                    // check AJAX variable, and set link to be AJAX link if exists
                    $htmlAttributes['class'] = '';
                    if (isset($optionLinks['ajax'][$state][$linkName])) {
                        $htmlAttributes['class'] = 'ajax ';
                        // if ajax SETTING is an ARRAY, set helper's OPTIONS based on keys=>values
                        if (is_array($optionLinks['ajax'][$state][$linkName])) {
                            foreach ($optionLinks['ajax'][$state][$linkName] as $htmlAttributeKey => $htmlAttributeValue) {
                                $htmlAttributes[$htmlAttributeKey] = $htmlAttributeValue;
                            }
                            if (isset($htmlAttributes['json'])) {
                                $htmlAttributes['data-json'] = htmlentities((json_encode($htmlAttributes['json'])));
                                unset($htmlAttributes['json']);
                            }
                        } else {
                            // otherwise if STRING set UPDATE option only
                            $htmlAttributes['data-json'] = htmlentities(json_encode(array(
                                'update' => $optionLinks['ajax'][$state][$linkName]
                            )));
                        }
                    } elseif ($json) {
                        $htmlAttributes['data-json'] = $json;
                    }
                    
                    $htmlAttributes['escape'] = false; // inline option removed from LINK function and moved to Options array
                    $htmlAttributes['class'] .= $class;
                    if ($state == 'index') {
                        $htmlAttributes['class'] .= ' icon16';
                        $linkResults[$linkLabel] = $this->Html->link('&nbsp;', $linkLocation, // url
$htmlAttributes, // options
$confirmationMsg); // confirmation message
                    } else {
                        $linkResults[$linkLabel] = $this->Html->link('<span class="icon16 ' . $class . '"></span>' . __($linkLabel), // title
$linkLocation, // url
$htmlAttributes, // options
$confirmationMsg); // confirmation message
                    }
                } else {
                    // if ACO/ARO permission check fails, display NOt ALLOWED type link
                    $returnUrls[] = $this->Html->url('/menus');
                    if ($state == 'index') {
                        $linkResults[$linkLabel] = '<a class="icon16 not_allowed"></a>';
                    } else {
                        $linkResults[$linkLabel] = '<a class="not_allowed">' . __($linkLabel) . '</a>';
                    }
                } // end CHECKMENUPERMISSIONS
            }
            
            if (count($linkResults) == 1 && isset($linkResults[$linkName])) {
                $returnLinks[$linkName] = $linkResults[$linkName];
            } else {
                $linksAppend = '
							<a href="javascript:void(0)"><span class="icon16 popup"></span>' . __($linkName, true) . '</a>
							<!-- container DIV for JS functionality -->
							<div class="filter_menu' . (count($linkResults) > 7 ? ' scroll' : '') . '">
								
								<div class="menuContent">
									<ul>
				';
                
                $count = 0;
                $tmpSize = sizeof($linkResults) - 1;
                foreach ($linkResults as $linkLabel => $linkLocation) {
                    $classLastLine = "";
                    if ($count == $tmpSize) {
                        $classLastLine = " count_last_line";
                    }
                    $linksAppend .= '
										<li class="count_' . $count . $classLastLine . '">
											' . $linkLocation . '
										</li>
					';
                    
                    $count ++;
                }
                
                $linksAppend .= '
									</ul>
								</div>
				';
                
                if (count($linkResults) > 7) {
                    $linksAppend .= '
								<span class="up"></span>
								<span class="down"></span>
								
								<a href="#" class="up">&uarr;</a>
								<a href="#" class="down">&darr;</a>
					
					';
                }
                
                $linksAppend .= '
								<div class="arrow"><span></span></div>
							</div>
				';
                
                $returnLinks[$linkName] = $linksAppend;
            }
        } // end FOREACH
          // ADD title to links bar and wrap in H5
        if ($state == 'bottom') {
            
            $returnString = '
				<div class="actions">
			';
            
            if (count($returnLinks)) {
                $linksArray = array();
                foreach ($returnLinks as $returnLink) {
                    if (strpos($returnLink, ' class="not_allowed"')) {
                        $linksArray[] = '<div class="bottom_button not_allowed">' . $returnLink . '</div>';
                    } else {
                        $linksArray[] = '<div class="bottom_button">' . $returnLink . '</div>';
                    }
                }
                
                $returnString .= implode("", $linksArray);
            }
            
            $returnString .= '
				</div>
			';
        } elseif ($state == 'top') {
            $returnString = $returnUrls[0];
        } elseif ($state == 'index') {
            if (count($returnLinks)) {
                $returnString = implode(' ', $returnLinks);
            }
        }
        
        return $returnString;
    }

    /**
     *
     * @param null $linkName
     * @param null $linkLocation
     * @return mixed|null|string
     */
    public function generateLinkClass($linkName = null, $linkLocation = null)
    {
        $displayClassName = '';
        $displayClassArray = array();
        
        // CODE TO SET CLASS(ES) BASED ON URL GOES HERE!
        // determine TYPE of link, for styling and icon
        
        $useString = $linkName ? $linkName : $linkLocation;
        
        if ($linkName) {
            $useString = str_replace('core_', '', $useString);
        }
        
        $displayClassArray = str_replace('/', ' ', $useString);
        $displayClassArray = str_replace('_', ' ', $displayClassArray);
        $displayClassArray = str_replace('-', ' ', $displayClassArray);
        $displayClassArray = str_replace('  ', ' ', $displayClassArray);
        $displayClassArray = explode(' ', trim($displayClassArray));
        
        // if URL is passed but no NAME, reduce to words and get LAST word (which should be the action) and use that
        if (! $linkName && $linkLocation) {
            foreach ($displayClassArray as $key => $val) {
                if (strpos($val, '%') !== false || strpos($val, '@') !== false || is_numeric($val)) {
                    unset($displayClassArray[$key]);
                } else {
                    $displayClassArray[$key] = strtolower(trim($val));
                }
            }
            
            $displayClassArray = array_reverse($displayClassArray);
        }
        
        $displayClassArray[1] = isset($displayClassArray[1]) ? strtolower($displayClassArray[1]) : '';
        $displayClassArray[2] = isset($displayClassArray[2]) ? strtolower($displayClassArray[2]) : '';
        
        $displayClassName = null;
        if (isset(self::$displayClassMapping[$displayClassArray[0]])) {
            $displayClassName = self::$displayClassMapping[$displayClassArray[0]];
        } elseif ($displayClassArray[0] == "plugin") {
            if ($displayClassArray[1] == 'menus') {
                if ($displayClassArray[2] == 'tools') {
                    $displayClassName = 'tools';
                } elseif ($displayClassArray[2] == 'datamart') {
                    $displayClassName = 'datamart';
                } else {
                    $displayClassName = 'home';
                }
            } elseif ($displayClassArray[1] == 'users' && $displayClassArray[2] == 'logout') {
                $displayClassName = 'logout';
            } elseif (array_key_exists($displayClassArray[1], self::$displayClassMappingPlugin)) {
                array_shift($displayClassArray);
                $displayClassName = implode(' ', $displayClassArray);
            } else {
                $displayClassName = 'default';
            }
            
            $displayClassName = 'plugin ' . $displayClassName;
        } elseif ($linkName && $linkLocation) {
            $displayClassName = $this->generateLinkClass(null, $linkLocation);
        } else {
            $displayClassName = 'default';
        }
        
        // return
        return $displayClassName;
    }

    /**
     * FUNCTION to replace %%MODEL.FIELDNAME%% in link with MODEL.FIELDNAME value
     *
     * @param string $link
     * @param array $data
     * @return mixed|string
     */
    public function strReplaceLink($link = '', $data = array())
    {
        if (is_array($data)) {
            foreach ($data as $model => $fields) {
                if (is_array($fields)) {
                    foreach ($fields as $field => $value) {
                        // avoid ONETOMANY or HASANDBELONGSOTMANY relationahips
                        if (! is_array($value)) {
                            // find text in LINK href in format of %%MODEL.FIELD%% and replace with that MODEL.FIELD value...
                            $link = str_replace('%%' . $model . '.' . $field . '%%', $value, $link);
                        }
                    }
                }
            }
        }
        $toCheck = is_array($link) ? $link['link'] : $link;
        if (preg_match('/%%[\w.]+%%/', $toCheck) && Configure::read('debug')) {
            AppController::addWarningMsg('DEBUG: bad link detected [' . $toCheck . ']');
        }
        return $link;
    }

    /**
     *
     * @param $array1
     * @param null $array2
     * @return mixed
     */
    public function &arrayMergeRecursiveDistinct(&$array1, &$array2 = null)
    {
        $merged = $array1;
        if (is_array($array2)) {
            foreach ($array2 as $key => $val) {
                if (is_array($array2[$key])) {
                    if (! isset($merged[$key])) {
                        $merged[$key] = array();
                    }
                    $merged[$key] = is_array($merged[$key]) ? $this->arrayMergeRecursiveDistinct($merged[$key], $array2[$key]) : $array2[$key];
                } else {
                    $merged[$key] = $val;
                }
            }
        }
        return $merged;
    }

    /**
     * Returns the date inputs
     *
     * @param string $name
     * @param string $date YYYY-MM-DD
     * @param array $attributes
     * @return string
     */
    private function getDateInputs($name, $date, array $attributes)
    {
        $prefDate = str_split(DATE_FORMAT);
        $year = $month = $day = null;
        if (is_array($date)) {
            $year = $date['year'];
            $month = $date['month'];
            $day = $date['day'];
            if (isset($date['year_accuracy'])) {
                $year = '±' . $year;
            }
        } elseif (strlen($date) > 0 && $date != "NULL") {
            $date = explode("-", $date);
            $year = $date[0];
            switch (count($date)) {
                case 3:
                    $day = $date[2];
                case 2:
                    $month = $date[1];
                    break;
            }
        }
        $result = "";
        unset($attributes['options']); // fixes an IE js bug where $(select).val() returns an error if "options" is present as an attribute
        $yearAttributes = $attributes;
        if (strpos($year, "±") === 0) {
            $yearAttributes['class'] .= " year_accuracy ";
            $year = substr($year, 2);
        }
        if (isset($attributes['required'])) {
            $yearAttributes['required'] = $attributes['required'];
            unset($attributes['required']);
        }
        if (DATETIME_INPUT_TYPE == "dropdown") {
            foreach ($prefDate as $part) {
                if ($part == "Y") {
                    $result .= $this->Form->year($name, 1900, 2100, array_merge($yearAttributes, array(
                        'value' => $year
                    )));
                } elseif ($part == "M") {
                    $result .= $this->Form->month($name, array_merge($attributes, array(
                        'value' => $month
                    )));
                } else {
                    $result .= $this->Form->day($name, array_merge($attributes, array(
                        'value' => $day
                    )));
                }
            }
        } else {
            foreach ($prefDate as $part) {
                if ($part == "Y") {
                    $result .= '<span class="tooltip">' . $this->Form->text($name . ".year", array_merge($yearAttributes, array(
                        'type' => 'number',
                        'min' => 1900,
                        'max' => 2100,
                        'value' => $year,
                        'size' => 6,
                        'maxlength' => 4,
                        'class' => 'year'
                    ))) . "<div>" . __('year') . "</div></span>";
                } elseif ($part == "M") {
                    $result .= '<span class="tooltip">' . $this->Form->text($name . ".month", array_merge($attributes, array(
                        'type' => 'number',
                        'min' => 1,
                        'max' => 12,
                        'value' => $month,
                        'size' => 3,
                        'maxlength' => 2,
                        'class' => 'month'
                    ))) . "<div>" . __('month') . "</div></span>";
                } else {
                    $result .= '<span class="tooltip">' . $this->Form->text($name . ".day", array_merge($attributes, array(
                        'type' => 'number',
                        'min' => 1,
                        'max' => 31,
                        'value' => $day,
                        'size' => 3,
                        'maxlength' => 2,
                        'class' => 'month'
                    ))) . "<div>" . __('day') . "</div></span>";
                }
            }
        }
        if (! isset($attributes['disabled']) || (! $attributes['disabled'] && $attributes['disabled'] != "disabled")) {
            // add the calendar icon + extra span to manage calendar javascript
            $result = '<span>' . $result . '<span style="position: relative;">
						<input type="button" class="datepicker" value=""/>
						<!-- <img src="' . $this->Html->Url('/img/cal.gif') . '" alt="cal" class="fake_datepicker"/> -->
					</span>
				</span>';
        }
        return $result;
    }

    /**
     * Returns the time inputs
     *
     * @param string $name
     * @param string $time HH:mm (24h format)
     * @param array $attributes
     * @return string
     */
    private function getTimeInputs($name, $time, array $attributes)
    {
        $result = "";
        $hour = $minutes = $meridian = null;
        if (is_array($time)) {
            $hour = $time['hour'];
            $minutes = $time['min'];
            if (isset($time['meridian'])) {
                $meridian = $time['meridian'];
            }
        } elseif (strlen($time) > 0) {
            if (strpos($time, ":") === false) {
                $hour = $time;
            } else {
                list ($hour, $minutes) = explode(":", $time);
            }
            if (TIME_FORMAT == 12) {
                if ($hour >= 12) {
                    $meridian = 'pm';
                    if ($hour > 12) {
                        $hour %= 12;
                    }
                } else {
                    $meridian = 'am';
                    if ($hour == 0) {
                        $hour = 12;
                    }
                }
            }
        }
        if (DATETIME_INPUT_TYPE == "dropdown") {
            unset($attributes['options']); // Fixes an IE8 issue with $.serialize
            $result .= $this->Form->hour($name, TIME_FORMAT == 24, array_merge($attributes, array(
                'value' => $hour
            )));
            $result .= $this->Form->minute($name, array_merge($attributes, array(
                'value' => $minutes
            )));
        } else {
            unset($attributes['options']);
            $result .= '<span class="tooltip">' . $this->Form->text($name . ".hour", array_merge($attributes, array(
                'type' => 'number',
                'value' => $hour,
                'size' => 3,
                'min' => TIME_FORMAT == 12 ? 1 : 0,
                'max' => TIME_FORMAT == 12 ? 12 : 23
            ))) . "<div>" . __('hour') . "</div></span>";
            $result .= '<span class="tooltip">' . $this->Form->text($name . ".min", array_merge($attributes, array(
                'type' => 'number',
                'value' => $minutes,
                'size' => 3,
                'min' => 0,
                'max' => 59
            ))) . "<div>" . __('minutes') . "</div></span>";
        }
        if (TIME_FORMAT == 12) {
            $result .= $this->Form->meridian($name, array_merge($attributes, array(
                'value' => $meridian
            )));
        }
        return $result;
    }

    /**
     *
     * @param $dataUnit
     * @param array $tableRowPart
     * @param $suffix
     * @param $options
     * @return bool|string
     */
    private static function getCurrentValue($dataUnit, array $tableRowPart, $suffix, $options)
    {
        $warning = false;
        if (is_array($dataUnit) && array_key_exists($tableRowPart['model'], $dataUnit) && is_array($dataUnit[$tableRowPart['model']]) && array_key_exists($tableRowPart['field'] . $suffix, $dataUnit[$tableRowPart['model']])) {
            // priority 1, data
            $currentValue = $dataUnit[$tableRowPart['model']][$tableRowPart['field'] . $suffix];
        } elseif ($options['type'] != 'index' && $options['type'] != 'detail' && $options['type'] != 'csv') {
            if (isset($options['override'][$tableRowPart['model'] . "." . $tableRowPart['field']])) {
                // priority 2, override
                $overrideModeField = $tableRowPart['model'] . "." . $tableRowPart['field'] . $suffix;
                $currentValue = $options['override'][$overrideModeField];
                if (in_array($tableRowPart['type'], array(
                    'date',
                    'datetime'
                )) && isset($options['override'][$overrideModeField . '_accuracy'])) {
                    $overrideModeFieldAccuracy = $options['override'][$overrideModeField . '_accuracy'];
                    if ($overrideModeFieldAccuracy != 'c') {
                        if ($overrideModeFieldAccuracy == 'd') {
                            $currentValue = substr($currentValue, 0, 7);
                        } elseif ($overrideModeFieldAccuracy == 'm') {
                            $currentValue = substr($currentValue, 0, 4);
                        } elseif ($overrideModeFieldAccuracy == 'y') {
                            $currentValue = '±' . substr($currentValue, 0, 4);
                        } elseif ($overrideModeFieldAccuracy == 'h') {
                            $currentValue = substr($currentValue, 0, 10);
                        } elseif ($overrideModeFieldAccuracy == 'i') {
                            $currentValue = substr($currentValue, 0, 13);
                        }
                    }
                }
                if (is_array($currentValue)) {
                    if (Configure::read('debug') > 0) {
                        AppController::addWarningMsg(__("invalid override for model.field [%s.%s]", $tableRowPart['model'], $tableRowPart['field'] . $suffix));
                    }
                    $currentValue = "";
                } elseif (Configure::read('debug') > 0 && $tableRowPart['type'] == 'select' && ! array_key_exists($currentValue, $tableRowPart['settings']['options']['defined'])) {
                    AppController::addWarningMsg(__('unsupported override value for model.field [%s.%s]', $tableRowPart['model'], $tableRowPart['field'] . $suffix));
                }
            } elseif (! empty($tableRowPart['default'])) {
                // priority 3, default
                $currentValue = $tableRowPart['default'];
            } else {
                $currentValue = "";
                if ($tableRowPart['readonly'] && $tableRowPart['field'] != 'CopyCtrl') {
                    $warning = true;
                }
            }
        } else {
            $warning = true;
            $currentValue = "-";
        }
        
        if ($warning && Configure::read('debug') > 0 && $options['settings']['data_miss_warn']) {
            AppController::addWarningMsg(__("no data for [%s.%s]", $tableRowPart['model'], $tableRowPart['field']));
        }
        
        if ($options['CodingIcdCheck'] && ($options['type'] == 'index' || $options['type'] == 'detail' || $options['type'] == 'csv') && $currentValue) {
            foreach (AppModel::getMagicCodingIcdTriggerArray() as $key => $trigger) {
                if (strpos($tableRowPart['setting'], $trigger) !== false) {
                    eval('$instance = ' . $key . '::getSingleton();');
                    $currentValue .= " - " . $instance->getDescription($currentValue);
                }
            }
        }
        
        return $currentValue;
    }

    /**
     *
     * @param array $rawRadiolist
     * @param array $data
     * @return string
     */
    private function getRadiolist(array $rawRadiolist, array $data)
    {
        $result = '';
        $defaultSettingsWoClass = self::$defaultSettingsArr;
        unset($defaultSettingsWoClass['class']);
        foreach ($rawRadiolist as $radiobuttonName => $radiobuttonValue) {
            list ($tmpModel, $tmpField) = explode(".", $radiobuttonName);
            $radiobuttonValue = $this->strReplaceLink($radiobuttonValue, $data);
            $tmpAttributes = array(
                'legend' => false,
                'value' => false,
                'id' => $radiobuttonName
            );
            if (isset($data[$tmpModel][$tmpField]) && $data[$tmpModel][$tmpField] == $radiobuttonValue) {
                $tmpAttributes['checked'] = 'checked';
            }
            $result .= $this->Form->radio($radiobuttonName, array(
                $radiobuttonValue => ''
            ), array_merge($defaultSettingsWoClass, $tmpAttributes));
        }
        
        return $result;
    }

    /**
     *
     * @param array $rawChecklist
     * @param array $data
     * @return string
     */
    public function getChecklist(array $rawChecklist, array $data)
    {
        $result = '';
        $defaultSettingsWoClass = self::$defaultSettingsArr;
        unset($defaultSettingsWoClass['class']);
        foreach ($rawChecklist as $checkboxName => $checkboxValue) {
            $checkboxValue = $this->strReplaceLink($checkboxValue, $data);
            $result .= $this->Form->checkbox($checkboxName, array_merge($defaultSettingsWoClass, array(
                'value' => $checkboxValue
            )));
        }
        
        return $result;
    }

    /**
     *
     * @param array $sanitizedData
     * @param array $orgData
     * @param array $unsanitize
     */
    private function unsanitize(array &$sanitizedData, array $orgData, array $unsanitize)
    {
        foreach ($orgData as $index => $row) {
            foreach ($unsanitize as $model => $fields) {
                if ($index == $model) {
                    // flat
                    foreach ($fields as $field) {
                        if (isset($row[$field])) {
                            $sanitizedData[$model][$field] = $row[$field];
                        }
                    }
                }
                if (isset($row[$model])) {
                    // row
                    foreach ($fields as $field) {
                        if (isset($row[$model][$field])) {
                            $sanitizedData[$index][$model][$field] = $row[$model][$field];
                        }
                    }
                }
            }
        }
    }

    /**
     *
     * @param $searchUrl
     * @param $name
     * @return string
     */
    public function generateSelectItem($searchUrl, $name)
    {
        return '
		<div class="selectItemZone">
			<div class="selectedItem"></div>
			<span class="button" data-url="' . $searchUrl . '" data-name="' . $name . '"><a href="#">' . __('search') . '</a></span>
		</div>
		';
    }

    /**
     *
     * @param $indexUrl
     * @return string
     */
    public function ajaxIndex($indexUrl)
    {
        return AppController::checkLinkPermission($indexUrl) ? '
		<div class="indexZone" data-url="' . $indexUrl . '">
		</div>
		' : '<div>' . __('You are not authorized to access that location.') . '</div>';
    }
}