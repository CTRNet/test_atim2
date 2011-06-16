<?php
	
App::import('Component','SessionAcl');

class StructuresHelper extends Helper {
		
	var $helpers = array( 'Csv', 'Html', 'Form', 'Javascript', 'Ajax', 'Paginator','Session' );
	
	//an hidden field will be printed for the following field types if they are in readonly mode
	private static $hidden_on_disabled = array("input", "date", "datetime", "time", "integer", "interger_positive", "float", "float_positive", "tetarea", "autocomplete");
	
	private static $tree_node_id = 0;
	private static $last_tabindex = 1;
	
	private $my_validation_errors = null;
	
	//default options
	private static $defaults = array(
			'type'		=>	NULL, 
			
			'data'	=> false, // override $this->data values, will not work properly for EDIT forms
			
			'settings'	=> array(
				'return'			=> false, // FALSE echos structure, TRUE returns it as string
				
				// show/hide various structure elements, useful for STACKING multiple structures (for example, to make one BIG form out of multiple smaller forms)
				'actions'		=> true, 
				'header'		=> '',
				'form_top'		=> true, 
				'tabindex'		=> 0, // when setting TAB indexes, add this value to the number, useful for stacked forms
				'form_inputs'	=> true, // if TRUE, use inputs when supposed to, if FALSE use static display values regardless
				'form_bottom'	=> true,
				'name_prefix'	=> NULL,
				'pagination'	=> true,
				'sorting'		=> false, //if pagination is false, sorting can still be turned on (if pagination is on, sorting is ignored)
				'columns_names' => array(), // columns names - usefull for reports. only works in detail views
				'stretch'		=> true, //the structure will take full page width
				
				'all_fields'	=> false, // FALSE acts on structures datatable settings, TRUE ignores them and displays ALL FIELDS in a form regardless
				'add_fields'	=> false, // if TRUE, adds an "add another" link after form to allow another row to be appended
				'del_fields'	=> false, // if TRUE, add a "remove" link after each row, to allow it to be removed from the form
				
				'tree'			=> array(), // indicates MULTIPLE atim_structures passed to this class, and which ones to use for which MODEL in each tree ROW
				'data_miss_warn'=> true, //in debug mode, prints a warning if data is not found for a field
				
				'paste_disabled_fields' => array()//pasting on those fields will be disabled
			),
			
			'links'		=> array(
				'top'			=> false, // if present, will turn structure into a FORM and this url is used as the FORM action attribute
				'index'			=> array(),
				'bottom'		=> array(),
				
				'tree'			=> array(),
				'tree_expand'	=> array(),
				
				'checklist'		=> array(), // keys are checkbox NAMES (model.field) and values are checkbox VALUES
				'radiolist'		=> array(), // keys are radio button NAMES (model.field) and values are radio button VALUES
				
				'ajax'	=> array( // change any of the above LINKS into AJAX calls instead
					'top'		=> false,
					'index'		=> array(),
					'bottom'	=> array()
				)
			),
			
			'override'			=> array(),
			'dropdown_options' 	=> array(),
			'extras'			=> array() // HTML added to structure blindly, each in own COLUMN
		);

	private static $default_settings_arr = array(
			"label" => false, 
			"div" => false, 
			"class" => "%c ",
			"id" => false,
			"legend" => false,
		);
		
	private static $display_class_mapping = array(
		'index'		=>	'list',
		'table'		=>	'list',
		'listall'	=>	'list',
	
		'search'	=>	'search',
	
		'add'		=>	'add',
		'new'		=>	'add',
		'create'	=> 	'add',
		
		'edit'		=>	'edit',
		
		'detail'	=>	'detail',
		'profile'	=>	'detail', //remove profile?
		'view'		=>	'detail',
		
		'datagrid'	=>	'grid',
		'editgrid'	=>	'grid',
		'addgrid'	=>	'grid',
	
		'delete'	=>	'delete',
		'remove'	=>	'delete',
	
		'cancel'	=>	'cancel',
		'back'		=>	'cancel',
		'return'	=>	'cancel',
	
		'duplicate'	=>	'duplicate',
		'copy'		=>	'duplicate',
		'return'	=>	'duplicate', //return = duplicate?
		
		'undo'		=>	'redo',
		'redo'		=>	'redo',
		'switch'	=>	'redo',
		
		'order'		=>	'order',
		'shop'		=>	'order',
		'ship'		=>	'order',
		'buy'		=>	'order',
		'cart'		=>	'order',
		
		'favourite'	=>	'thumbsup',
		'mark'		=>	'thumbsup',
		'label'		=>	'thumbsup',
		'thumbsup'	=>	'thumbsup',
		'thumbup'	=>	'thumbsup',
		'approve'	=>	'thumbsup',
		
		'unfavourite' =>'thumbsdown',
		'unmark'	=>	'thumbsdown',
		'unlabel'	=>	'thumbsdown',
		'thumbsdown'=>	'thumbsdown',
		'thumbdown'	=>	'thumbsdown',
		'unapprove'	=>	'thumbsdown',
		'disapprove'=>	'thumbsdown',
	
		'tree'		=>	'reveal',
		'reveal'	=>	'reveal',
		'menu'		=>	'menu',
	
		'summary'	=>	'summary',

		'filter'	=>	'filter',
	
		'user'		=>	'users',
		'users'		=>	'users',
		'group'		=>	'users',
		'groups'	=>	'users',
	
		'news'		=>	'news',
		'annoucement'=>	'news',
		'annouvements'=>'news',
		'message'	=>	'news',
		'messages'	=>	'news'
	);
	
	private static $display_class_mapping_plugin = array(
		'menus'					=>	null,
		'customize'				=>	null,
		'clinicalannotation'	=>	null,
		'inventorymanagement'	=>	null,
		'datamart'				=>	null,
		'administrate'			=>	null,
		'drug'					=>	null,
		'rtbform'				=>	null,
		'order'					=>	null,
		'protocol'				=>	null,
		'material'				=>	null,
		'sop'					=>	null,
		'storagelayout'			=>	null,
		'study'					=>	null,
		'pricing'				=>	null,
		'provider'				=>	null,
		'underdevelopment'		=>	null,
		'labbook'				=>  null
	);

	function __construct(){
		parent::__construct();
		App::import('Model', 'StructureValueDomain');
		$this->StructureValueDomain = new StructureValueDomain();
	}

	function hook($hook_extension=''){
		if($hook_extension){
			$hook_extension = '_'.$hook_extension;
		}
		
		$hook_file = APP . 'plugins' . DS . $this->params['plugin'] . DS . 'views' . DS . $this->params['controller'] . DS . 'hooks' . DS . $this->params['action'].$hook_extension.'.php';
		if(!file_exists($hook_file)){
			$hook_file=false;
		}
		
		return $hook_file;
	}
	
	private function updateDataWithAccuracy(array &$data, array &$structure){
		if(!empty($structure['Accuracy']) && !empty($data)){
			$single_node = false;
			if(!is_array(current(current($data)))){
				$single_node = true;
				$data = array($data);
			}

			foreach($data as &$data_line){
				foreach($structure['Accuracy'] as $model => $fields){
					foreach($fields as $date_field => $accuracy_field){
						if(isset($data_line[$model][$accuracy_field])){
							$accuracy = $data_line[$model][$accuracy_field];
							if($accuracy != 'c'){
								if($accuracy == 'd'){
									$data_line[$model][$date_field] = substr($data_line[$model][$date_field], 0, 7);
								}else if($accuracy == 'm'){
									$data_line[$model][$date_field] = substr($data_line[$model][$date_field], 0, 4);
								}else if($accuracy == 'y'){
									$data_line[$model][$date_field] = '±'.substr($data_line[$model][$date_field], 0, 4);
								}else if($accuracy == 'h'){
									$data_line[$model][$date_field] = substr($data_line[$model][$date_field], 0, 10);
								}else if($accuracy == 'i'){
									$data_line[$model][$date_field] = substr($data_line[$model][$date_field], 0, 13);
								}
							}
						}
					}
				}
			}
			
			if($single_node){
				$data = $data[0];
			}
			
		}
	}

	/**
	 * Builds a structure
	 * @param array $atim_structure The structure to build
	 * @param array $options The various options indicating how to build the structures. refer to self::$default for all options
	 * @return depending on the return option, echoes the structure and returns true or returns the string
	 */
	function build(array $atim_structure = array(), array $options = array()){
		if(Configure::read('debug') > 0){
			$tmp = array();
			if(isset($atim_structure['Structure'][0])){
				foreach($atim_structure['Structure'] as $struct){
					$tmp[] = $struct['alias'];
				}
			}else if(isset($atim_structure['Structure'])){
				$tmp[] = $atim_structure['Structure']['alias'];
			}
			echo "<code>Structure alias: ", implode(", ", $tmp), "</code>";
		}
		
		// DEFAULT set of options, overridden by PASSED options
		$options = $this->arrayMergeRecursiveDistinct(self::$defaults,$options);
		if(!isset($options['type'])){
			$options['type'] = $this->params['action'];//no type, default to action
		}
		
		//print warning when unknown stuff and debug is on
		if(Configure::read('debug') > 0){
			if(is_array($options)){
				foreach($options as $k => $foo){
					if(!array_key_exists($k, self::$defaults)){
						AppController::addWarningMsg(sprintf(__("unknown function [%s] in structure build", true), $k));
					}
				}
				
				if(is_array($options['settings'])){
					foreach($options['settings'] as $k => $foo){
						if(!array_key_exists($k, self::$defaults['settings'])){
							AppController::addWarningMsg(sprintf(__("unknown setting [%s] in structure build", true), $k));
						}
					}
				}else{
					AppController::addWarningMsg(__("settings should be an array", true));
				}
				
				if(is_array($options['links'])){
					foreach($options['links'] as $k => $foo){
						if(!array_key_exists($k, self::$defaults['links'])){
							AppController::addWarningMsg(sprintf(__("unknown link [%s] in structure build", true), $k));
						}
					}
				}else{
					AppController::addWarningMsg(__("links should be an array", true));
				}
			}else{
				AppController::addWarningMsg(__("settings be an array", true));
			}
		}
		
		if(!is_array($options['extras'])){
			$options['extras'] = array('end' => $options['extras']);
		}
		
		$options['CodingIcdCheck'] = isset($atim_structure['Structure']['CodingIcdCheck']) && $atim_structure['Structure']['CodingIcdCheck'];
		
		if($options['settings']['return']){
			//the result needs to be returned as a string, turn output buffering on
			ob_start();
		}
		
		if($options['links']['top'] && $options['settings']['form_top']){
			if(isset($options['links']['ajax']['top']) && $options['links']['ajax']['top']){
				echo($this->Ajax->form(
					array(
						'type'		=> 'post',    
						'options'	=> array(
							'update'		=> $options['links']['ajax']['top'],
							'url'			=> $options['links']['top']
						)
					)
				));
			}else{
				echo('
					<form action="'.$this->generateLinksList($this->data, $options['links'], 'top').'" method="post" enctype="multipart/form-data">
				');
			}
		}
		
		// display grey-box HEADING with descriptive form info
		if($options['settings']['header']){
			if (!is_array($options['settings']['header'])){
				$options['settings']['header'] = array(
					'title'			=> $options['settings']['header'],
					'description'	=> ''
				);
			}
			
			echo('<div class="descriptive_heading">
					<h4>'.$options['settings']['header']['title'].'</h4>
					<p>'.$options['settings']['header']['description'].'</p>
				</div>
			');
		}
		
		if(isset($options['extras']['start'])){
			echo('
				<div class="extra">'.$options['extras']['start'].'</div>
			');
		}
		
		$data = &$this->data;
		if(is_array($options['data'])){
			$data = $options['data'];
		}
		if($data == null){
			$data = array();
		}
		
		$this->updateDataWithAccuracy($data, $atim_structure);
		
		// run specific TYPE function to build structure (ordered by frequence for performance)
		$type = $options['type'];
		if(count($this->validationErrors) > 0 
		&& ($type == "add"
		|| $type == "edit"
		|| $type == "search"
		|| $type == "addgrid"
		|| $type == "editgrid"
		|| $type == "batchedit")){
			//editable types, convert validation errors
			$this->my_validation_errors = array();
			foreach($this->validationErrors as $validation_error_arr){
				$this->my_validation_errors = array_merge($validation_error_arr, $this->my_validation_errors);	
			}
		}
		
		if($type == 'summary'){
			$this->buildSummary($atim_structure, $options, $data);
		
		}else if($type == 'index'
		|| $type == 'addgrid'
		|| $type == 'editgrid'){
			if($type == 'addgrid'
			|| $type == 'editgrid'){
				$options['settings']['pagination'] = false;
			}
			$this->buildTable( $atim_structure, $options, $data);

		}else if($type == 'detail'
		|| $type == 'add'
		|| $type == 'edit'
		|| $type == 'search'
		|| $type == 'batchedit'){
			$this->buildDetail( $atim_structure, $options, $data);
			
		}else if($type == 'tree'){
			$options['type'] = 'index';
			$this->buildTree( $atim_structure, $options, $data);
			
		}else if($type == 'csv'){
			$this->buildCsv( $atim_structure, $options, $data);
			$options['settings']['actions'] = false;
		}else{
			if(Configure::read('debug') > 0){
				AppController::addWarningMsg(sprintf(__("warning: unknown build type [%s]", true), $type)); 
			}
			//build detail anyway
			$options['type'] = 'detail';
			$this->buildDetail($atim_structure, $options, $data);
		}
		
		if(isset($options['extras']['end'])){
			echo('
				<div class="extra">'.$options['extras']['end'].'</div>
			');
		}
		

		if ( $options['links']['top'] && $options['settings']['form_bottom'] ) {
			if($options['type'] == 'search'){	//search mode
				$link_class = "search";
				$link_label = __("search", null);
				$exact_search = __("exact search", true).'<input type="checkbox" name="data[exact_search]"/>';
			}else{								//other mode
				$link_class = "submit";
				$link_label = __("submit", null);
				$exact_search = "";
			}
			echo('
				<div class="submitBar">
					<div class="flyOverSubmit">
						'.$exact_search.'
						<div class="bottom_button">
							<input id="submit_button" class="submit" type="submit" value="Submit" style="display: none;"/>
							<a href="#n" onclick="$(\'#submit_button\').click();" class="form '.$link_class.'" tabindex="'.(StructuresHelper::$last_tabindex + 1).'">'.$link_label.'</a>
						</div>
					</div>
				</div>
			');
		}
		
		if($options['links']['top'] && $options['settings']['form_bottom']){
			echo('
				</form>
			');
		}
				
		if($options['settings']['actions']){
			echo $this->generateLinksList($this->data, $options['links'], 'bottom');
		}
		
		$result = null;
		if ($options['settings']['return']){
			//the result needs to be returned as a string, take the output buffer
			$result = ob_get_contents();
			ob_end_clean();
		}else{
			$result = true;
		}
		return $result;
				
	} // end FUNCTION build()


	/**
	 * Reorganizes a structure in a single column
	 * @param array $structure
	 */
	private function flattenStructure(array &$structure){
		$first_column = null;
		foreach($structure as $table_column_key => $table_column){
			if(is_array($table_column)){
				if($first_column === null){
					$first_column = $table_column_key;
					continue;
				}
				$structure[$first_column] = array_merge($structure[$first_column], $table_column);
				unset($structure[$table_column_key]);
			}
		}
	}
	
	/**
	 * Build a structure in a detail format
	 * @param array $atim_structure
	 * @param array $options
	 * @param array $data_unit
	 */
	private function buildDetail(array $atim_structure, array $options, $data_unit){
		$table_index = $this->buildStack($atim_structure, $options);
		// display table...
		$stretch = $options['settings']['stretch'] ? '' : ' style="width: auto;" '; 
		echo '
			<table class="structure" cellspacing="0"'.$stretch.'>
			<tbody>
				<tr>
		';
		
		// each column in table 
		$count_columns = 0;
		if($options['type'] == 'search'){
			//put every structure fields in the same column
			self::flattenStructure($table_index);
		}
		
		$many_columns = !empty($options['settings']['columns_names']) && $options['type'] == 'detail';
		 
		foreach($table_index as $table_column_key => $table_column){
			$count_columns ++;
			
			// for each FORM/DETAIL element...
			if(is_array($table_column)){
				echo('<td class="this_column_'.$count_columns.' total_columns_'.count($table_index).'"> 
						<table class="columns detail" cellspacing="0">
							<tbody>
								<tr>');
				
				if($many_columns){
					echo '<td></td><td class="label center">', implode('</td><td class="label center">', $options['settings']['columns_names']), '</td></tr><tr>';
				}
				// each row in column 
				$table_row_count = 0;
				$new_line = true;
				$end_of_line = "";
				$display = "";
				foreach($table_column as $table_row){
					foreach($table_row as $table_row_part){
						if($table_row_part['heading']){
							if(!$new_line){
								echo('<td class="content">'.implode('</td><td class="content">', $display)."</td>".$end_of_line."</tr><tr>");
								$display = array();
								$end_of_line = "";
							}
							echo('<td class="heading no_border" colspan="'.( show_help ? '3' : '2' ).'">
										<h4>'.$table_row_part['heading'].'</h4>
									</td>
								</tr><tr>
							');
							$new_line = true;
						}
						
						if($table_row_part['label']){
							if(!$new_line){
								echo('<td class="content">'.implode('</td><td class="content">', $display)."</td>".$end_of_line."</tr><tr>");
								$display = array();
								$end_of_line = "";
							}
							echo('<td class="label">
										'.$table_row_part['label'].'
								</td>
							');
						}
						
						//value
						$current_value = null;
						$suffixes = $options['type'] == "search" && in_array($table_row_part['type'], StructuresComponent::$range_types) ? array("_start", "_end") : array("");
						foreach($suffixes as $suffix){
							$current_value = self::getCurrentValue($data_unit, $table_row_part, $suffix, $options);
							if($many_columns){
								if(is_array($current_value)){
									foreach($options['settings']['columns_names'] as $col_name){
										if(!isset($display[$col_name])){
											$display[$col_name] = "";
										}
										$display[$col_name] .= isset($current_value[$col_name]) ? $current_value[$col_name]." " : ""; 
									}
								}else{
									$display = array_fill(0, count($options['settings']['columns_names']), '');
								}
							}else{
								if(!isset($display[0])){
									$display[0] = "";
								}
								if($suffix == "_end"){
									$display[0] .= '<span class="tag"> To </span>';
								}
								if(strlen($suffix) > 0 && ($table_row_part['type'] == 'input'
									|| $table_row_part['type'] == 'integer'
									|| $table_row_part['type'] == 'integer_positive'
									|| $table_row_part['type'] == 'float'
									|| $table_row_part['type'] == 'float_positive')
								){
									//input type, add the sufix to the name
									$table_row_part['format_back'] = $table_row_part['format'];
									$table_row_part['format'] = preg_replace('/name="data\[((.)*)\]"/', 'name="data[$1'.$suffix.']"', $table_row_part['format']);
								}
								
								if($table_row_part['type'] == 'textarea'){
									$display[0] .= '<span>'.$this->getPrintableField($table_row_part,  $options, $current_value, null, $suffix);
								}else{
									$display[0] .= '<span><span class="nowrap">'.$this->getPrintableField($table_row_part,  $options, $current_value, null, $suffix).'</span>';
								}
								
								if(strlen($suffix) > 0 && ($table_row_part['type'] == 'input'
									|| $table_row_part['type'] == 'integer'
									|| $table_row_part['type'] == 'integer_positive'
									|| $table_row_part['type'] == 'float'
									|| $table_row_part['type'] == 'float_positive')
								){
									$table_row_part['format'] = $table_row_part['format_back'];
								}
								if($options['type'] == "search" && !in_array($table_row_part['type'], StructuresComponent::$range_types)){
									$display[0] .= '<a class="adv_ctrl btn_add_or add_10x10" href="#" onclick="return false;"></a>';
								}
								$display[0] .= '</span>';
							}
						}
						
						if(show_help){
							$end_of_line = '
									<td class="help">
										'.$table_row_part['help'].'
									</td>';
						}
						
						$new_line = false;
					}
					$table_row_count++;
				} // end ROW 
				echo('<td class="content">'.implode('</td><td class="content">', $display).'</td>'.$end_of_line.'</tr>
						</tbody>
						</table>
						
					</td>
				');
				
			}else{
				$this->printExtras($count_columns, count($table_index), $table_column);
			}
				
		} // end COLUMN 
		
		echo('
				</tr>
			</tbody>
			</table>
		');
	}

	/**
	 * Echoes a structure in a summary format
	 * @param array $atim_structure
	 * @param array $options
	 * @param array $data_unit
	 */
	private function buildSummary(array $atim_structure, array $options, array $data_unit){
		$table_index = $this->buildStack($atim_structure, $options);
		self::flattenStructure($table_index);
		echo("<dl>");
		foreach($table_index as $table_column_key => $table_column){
			$first_line = true;
			foreach($table_column as $table_row){
				foreach($table_row as $table_row_part){
					if(strlen($table_row_part['label']) > 0 || $first_line){
						if(!$first_line){
							echo "</dd>";
						}
						echo "<dt>",$table_row_part['label'],"</dt><dd>";
						$first_line = false;
					}
					if(array_key_exists($table_row_part['model'], $data_unit) && array_key_exists($table_row_part['field'], $data_unit[$table_row_part['model']])){
						echo $this->getPrintableField($table_row_part, $options, $data_unit[$table_row_part['model']][$table_row_part['field']], null, null), " ";
					}else if(Configure::read('debug') > 0 && $options['settings']['data_miss_warn']){
						AppController::addWarningMsg(sprintf(__("no data for [%s.%s]", true), $table_row_part['model'], $table_row_part['field']));
					}
				}
			}
			if(!$first_line){
				echo "</dd>";
			}
		}
		echo("</dl>");
	}
	
	/**
	 * Echoes a structure field
	 * @param array $table_row_part The field settings
	 * @param array $options The structure settings
	 * @param string $current_value The value to use/lookup for the field
	 * @param int $key A numeric key used when there is multiple instances of the same field (like grids)
	 * @param string $field_name_suffix A name suffix to use on active non input fields
	 * @return string The built field
	 */
	private function getPrintableField(array $table_row_part, array $options, $current_value, $key, $field_name_suffix){
		$display = null;
		$field_name = $table_row_part['name'].$field_name_suffix;
		if($table_row_part['flag_confidential'] && !$_SESSION['Auth']['User']['flag_show_confidential']){
				$display = CONFIDENTIAL_MARKER;
				if($options['links']['top'] && $options['settings']['form_inputs'] && $options['type'] != "search"){
					AppController::getInstance()->redirect("/pages/err_confidential");
				}
		}else if($options['links']['top'] && $options['settings']['form_inputs'] && !$table_row_part['readonly']){
			if($table_row_part['type'] == "date"){
				$display = "";
				if($options['type'] != "search" && isset(AppModel::$accuracy_config[$table_row_part['tablename']][$table_row_part['field']])){
					$display = "<div class='accuracy_target_blue'></div>";
				}
				$display .= self::getDateInputs($field_name, $current_value, $table_row_part['settings']);
			}else if($table_row_part['type'] == "datetime"){
				$date = $time = null;
				if(is_array($current_value)){
					$date = $current_value;
					$time = $current_value;
				}else if(strlen($current_value) > 0 && $current_value != "NULL"){
					if(strpos($current_value, " ") === false){
						$date = $current_value;
					}else{
						list($date, $time) = explode(" ", $current_value);
					}
				}
				
				$display = "";
				if($options['type'] != "search" && isset(AppModel::$accuracy_config[$table_row_part['tablename']][$table_row_part['field']])){
					$display = "<div class='accuracy_target_blue'></div>";
				}
				$display .= self::getDateInputs($field_name, $date, $table_row_part['settings'])
					.self::getTimeInputs($field_name, $time, $table_row_part['settings']);
			}else if($table_row_part['type'] == "time"){
				$display = self::getTimeInputs($field_name, $current_value, $table_row_part['settings']);
			}else if($table_row_part['type'] == "select" 
			|| (($options['type'] == "search" || $options['type'] == "batchedit") && ($table_row_part['type'] == "radio" || $table_row_part['type'] == "checkbox" || $table_row_part['type'] == "yes_no"))){
				if(array_key_exists($current_value, $table_row_part['settings']['options']['previously_defined'])){
					$table_row_part['settings']['options']['previously_defined'] = array($current_value => $table_row_part['settings']['options']['previously_defined'][$current_value]);
					
				}else if(!array_key_exists($current_value, $table_row_part['settings']['options']['defined'])
					&& !array_key_exists($current_value, $table_row_part['settings']['options']['previously_defined'])
					&& count($table_row_part['settings']['options']) > 1
				){
					//add the unmatched value if there is more than a value
					if(($options['type'] == "search" || $options['type'] == "batchedit") && $current_value == ""){
						//this is a search or batchedit and the value is the empty one, not really an "unmatched" one
						$table_row_part['settings']['options'] = array_merge(array("" => ""), $table_row_part['settings']['options']); 
					}else{
						$table_row_part['settings']['options'] = array(
								__( 'unmatched value', true ) => array($current_value => $current_value),
								__( 'supported value', true ) => $table_row_part['settings']['options']['defined']
						);
					}
				}else if($options['type'] == "search" && !empty($table_row_part['settings']['options']['previously_defined'])){
					$tmp = $table_row_part['settings']['options']['defined'];
					unset($table_row_part['settings']['options']['defined']);
					$table_row_part['settings']['options'][__('defined', true)] = $tmp;
					$tmp = $table_row_part['settings']['options']['previously_defined'];
					unset($table_row_part['settings']['options']['previously_defined']); 
					$table_row_part['settings']['options'][__('previously defined', true)] = $tmp; 
				}else{
					$table_row_part['settings']['options'] = $table_row_part['settings']['options']['defined'];
				}
				
				$table_row_part['settings']['class'] = str_replace("%c ", isset($this->my_validation_errors[$table_row_part['field']]) ? "error " : "", $table_row_part['settings']['class']);
				$display = $this->Form->input($field_name, array_merge($table_row_part['settings'], array('type' => 'select', 'value' => $current_value)));
			}else if($table_row_part['type'] == "radio"){
				if(!array_key_exists($current_value, $table_row_part['settings']['options'])){
					$table_row_part['settings']['options'][$current_value] = "(".__( 'unmatched value', true ).") ".$current_value;
				}
				$display = $this->Form->input($field_name, array_merge($table_row_part['settings'], array('type' => $table_row_part['type'], 'value' => $current_value, 'checked' => $current_value ? true : false)));
			}else if($table_row_part['type'] == "checkbox"){
				$display = $this->Form->input($field_name, array_merge($table_row_part['settings'], array('type' => 'checkbox', 'value' => 1, 'checked' => $current_value ? true : false)));
			}else if($table_row_part['type'] == "yes_no"){
				$display =
					$this->Form->input($field_name, array_merge($table_row_part['settings'], array('type' => 'hidden', 'value' => "")))
					.__('yes', true).$this->Form->input($field_name, array_merge($table_row_part['settings'], array('type' => 'checkbox', 'value' => "y", 'hiddenField' => false, 'checked' => $current_value == "y" ? true : false)))
					.__('no', true). $this->Form->input($field_name, array_merge($table_row_part['settings'], array('type' => 'checkbox', 'value' => "n", 'hiddenField' => false, 'checked' => $current_value == "n" ? true : false)));
			}else if(($table_row_part['type'] == "float" || $table_row_part['type'] == "float_positive") && decimal_separator == ','){
				$current_value = str_replace('.', ',', $current_value);
			}
			$display .= $table_row_part['format'];//might contain hidden field if the current one is disabled
			
			$this->fieldDisplayFormat($display, $table_row_part, $key, $current_value);
			
			if(($options['type'] == "addgrid" || $options['type'] == "editgrid") 
				&& strpos($table_row_part['settings']['class'], "pasteDisabled") !== false
				&& $table_row_part['type'] != "hidden"
			){
				//displays the "no copy" icon on the left of the fields with disabled copy option
				$display = '<div class="pasteDisabled"></div>'.$display;
			} 
		}else if(strlen($current_value) > 0){
			$elligible_as_date = strlen($current_value) > 1;
			if($table_row_part['type'] == "date" && $elligible_as_date){
				$date = explode("-", $current_value);
				$year = $date[0];
				$month = null;
				$day = null;
				switch(count($date)){
					case 3:
						$day = $date[2];
					case 2:
						$month = $date[1];
						break;
				}
				list($day) = explode(" ", $day);//in case the current date is a datetime
				$display = AppController::getFormatedDateString($year, $month, $day, $options['type'] != 'csv');
			}else if($table_row_part['type'] == "datetime" && $elligible_as_date){
				$display = AppController::getFormatedDatetimeString($current_value, $options['type'] != 'csv');
			}else if($table_row_part['type'] == "time" && $elligible_as_date){
				list($hour, $minutes) = explode(":", $current_value);
				$display = AppController::getFormatedTimeString($hour, $minutes);
			}else if($table_row_part['type'] == "select" || $table_row_part['type'] == "radio" || $table_row_part['type'] == "checkbox" || $table_row_part['type'] == "yes_no"){
				if(isset($table_row_part['settings']['options']['defined'][$current_value])){
					$display = $table_row_part['settings']['options']['defined'][$current_value];
				}else if(isset($table_row_part['settings']['options']['previously_defined'][$current_value])){
					$display = $table_row_part['settings']['options']['previously_defined'][$current_value];
				}else{
					$display = $current_value;
					if(Configure::read('debug') > 0 && ($current_value != "-" || $options['settings']['data_miss_warn'])){
						AppController::addWarningMsg(sprintf(__("missing reference key [%s] for field [%s]", true), $current_value, $table_row_part['field']));
					}
				}
			}else if(($table_row_part['type'] == "float" || $table_row_part['type'] == "float_positive") && decimal_separator == ','){
				$display = str_replace('.', ',', $current_value);
			}else{
				$display = $current_value;
			}
		}
		
		if($table_row_part['readonly']){
			$tmp = $table_row_part['format'];
			
			if(isset($table_row_part['settings']['options'])){
				//merging with numerical keys
				$table_row_part['settings']['options'] = 
					$table_row_part['settings']['options']['defined'] + 
					$table_row_part['settings']['options']['previously_defined'];
			}
			
			if($table_row_part['type'] =='select' && !array_key_exists($current_value, $table_row_part['settings']['options'])){
				//disabled dropdown with unmatched value, pick the first one
				$arr_keys = array_keys($table_row_part['settings']['options']);
				$current_value = $arr_keys[0];
				$display = $table_row_part['settings']['options'][$current_value];
			}
			$this->fieldDisplayFormat($tmp, $table_row_part, $key, $current_value);
			$display .= $tmp;
		}
		
		$tag = "";
		if(strlen($table_row_part['tag']) > 0){
			if($options['type'] == 'csv'){
				$tag = $table_row_part['tag'].' ';
			}else{
				$tag = '<span class="tag">'.$table_row_part['tag'].'</span> ';
			}
		}
		return $tag.(strlen($display) > 0 ? $display : "-")." ";
	}
	
	/**
	 * Update the field display to insert in it its values and classes
	 * @param string &$display Pointer to the display string, which will be updated
	 * @param array $table_row_part The current field data/settings
	 * @param string $key The key, if any to use in the name
	 * @param string $current_value The current field value
	 */
	private function fieldDisplayFormat(&$display, array $table_row_part, $key, $current_value){
		$display = str_replace("%c ", isset($this->my_validation_errors[$table_row_part['field']]) ? "error " : "", $display);
			
		if(strlen($key)){
			$display = str_replace("[%d]", "[".$key."]", $display);
		}
		if(!is_array($current_value)){
			$display = str_replace("%s", $current_value, $display);
		}
			
		if(isset($table_row_part['tool'])){
			$display .= $table_row_part['tool'];
		}
	}
	
	/**
	 * Echoes a structure in a table format
	 * @param array $atim_structure
	 * @param array $options
	 * @param array $data
	 */
	private function buildTable(array $atim_structure, array $options, array $data){
		// attach PER PAGE pagination param to PASSED params array...
		if(isset($this->params['named']) && isset($this->params['named']['per'])){
			$this->params['pass']['per'] = $this->params['named']['per'];
		}
		
		$table_structure = $this->buildStack( $atim_structure, $options );
		
		$structure_count = 0;
		$structure_index = array(1 => $table_structure);
						
		$stretch = $options['settings']['stretch'] ? '' : ' style="width: auto;" '; 
		echo '
			<table class="structure" cellspacing="0"'.$stretch.'>
				<tbody>
					<tr>
		';
		foreach($structure_index as $table_key => $table_index){
			$structure_count++;
			if (is_array($table_index)){
				// start table...
				echo '
					<td class="this_column_',$structure_count,' total_columns_',count($structure_index),'">
						<table class="columns index" cellspacing="0">
				';
				$remove_line_ctrl = ($options['type'] == 'addgrid' || $options['type'] == 'editgrid') && $options['settings']['del_fields'];
				$add_line_ctrl = ($options['type'] == 'addgrid' || $options['type'] == 'editgrid') && $options['settings']['add_fields'];
				$options['remove_line_ctrl'] = $remove_line_ctrl;
				$header_data = $this->buildDisplayHeader($table_index, $options);
				echo "<thead>",$header_data['header'],"</thead>";
				
				if($options['type'] == "addgrid" && count($data) == 0){
					//display at least one line
					$data[0] = array();
				}
				
				if(count($data)){
					$data = array_merge(array(), $data);//make sure keys are starting from 0 and that none is being skipped
					echo "<tbody>";
					
					if($add_line_ctrl){
						//blank hidden line
						$data["%d"] = array();
					}
					$row_num = 1;
					$default_settings_wo_class = self::$default_settings_arr;
					unset($default_settings_wo_class['class']);
					foreach($data as $key => $data_unit){
						if($add_line_ctrl && $row_num == count($data)){
							echo "<tr class='hidden'>";
						}else{
							echo "<tr>";
						}
						
						//checklist
						if (count($options['links']['checklist'])){
							echo'
								<td class="checkbox">
							';
							foreach($options['links']['checklist'] as $checkbox_name => $checkbox_value){
								$checkbox_value = $this->strReplaceLink($checkbox_value, $data_unit);
								echo $this->Form->checkbox($checkbox_name, array_merge($default_settings_wo_class, array('value' => $checkbox_value)));
							}
							echo '
								</td>
							';
						}
					
						//radiolist
						if(count($options['links']['radiolist'])){
							echo '
								<td class="radiobutton">
							';
							foreach($options['links']['radiolist'] as $radiobutton_name => $radiobutton_value){
								list($tmp_model, $tmp_field) = split("\.", $radiobutton_name);
								$radiobutton_value = $this->strReplaceLink($radiobutton_value, $data_unit);
								$tmp_attributes = array('legend'=>false, 'value'=>false);
								if(isset($data_unit[$tmp_model][$tmp_field]) && $data_unit[$tmp_model][$tmp_field] == $radiobutton_value){
									$tmp_attributes['checked'] = 'checked';
								}
								echo $this->Form->radio($radiobutton_name, array($radiobutton_value=>''), array_merge($default_settings_wo_class, $tmp_attributes));
							}
							
							echo '
								</td>
							';
						}
		
						//index
						if(count($options['links']['index'])){
							$current_links = array();
							if(is_array($options['links']['index'])){
								foreach($options['links']['index'] as $name => &$link){
									$current_links[$name] = $this->strReplaceLink($link, $data_unit);
								}
							}else{
								$current_links[] = $this->strReplaceLink($options['links']['index'], $data_unit);
							}
							echo '
								<td class="id">',$this->generateLinksList(null, array('index' => $current_links), 'index'),'</td>
							';
						}
						
						$structure_count = 0;
						$structure_index = array(1 => $table_structure); 
						
						// add EXTRAS, if any
						$structure_index = $this->displayExtras( $structure_index, $options );
						
						//data
						$first_cell = true;
						$suffix = null;//used by the require inline
						foreach($table_index as $table_column){
							foreach($table_column as $table_row){
								foreach($table_row as $table_row_part){
									$current_value = self::getCurrentValue($data_unit, $table_row_part, "", $options);
									if(strlen($table_row_part['label']) || $first_cell){
										if($first_cell){
											echo "<td>";
											$first_cell = false;
										}else{
											echo "</td><td>";
										}
									}
									echo $this->getPrintableField($table_row_part, $options, $current_value, $key, null);
									
								}
							}
						}
						echo "</td>\n";
						
						//remove line ctrl
						if($remove_line_ctrl){
							echo '
									<td class="right">
										<a href="#" class="removeLineLink delete_10x10" title="',__( 'click to remove these elements', true ),'"></a>
									</td>
							';
						}
						
						
						echo "</td></tr>";
						$row_num ++;
					}
					echo "</tbody><tfoot>";
					if($options['settings']['pagination']){
						echo '
								<tr class="pagination">
									<th colspan="',$header_data['count'],'">
										
										<span class="results">
											',$this->Paginator->counter( array('format' => '%start%-%end% of %count%') ),'
										</span>
										
										<span class="links">
											',$this->Paginator->prev( __( 'prev',true ), NULL, __( 'prev',true ) ),'
											',$this->Paginator->numbers(),'
											',$this->Paginator->next( __( 'next',true ), NULL, __( 'next',true ) ),'
										</span>
										
										',$this->Paginator->link( '5',  array('page' => 1, 'limit' => 5)),' |
										',$this->Paginator->link( '10', array('page' => 1, 'limit' => 10)),' |
										',$this->Paginator->link( '20', array('page' => 1, 'limit' => 20)),' |
										',$this->Paginator->link( '50', array('page' => 1, 'limit' => 50)),'
										
									</th>
								</tr>
						';
					}
					
					if(count($options['links']['checklist'])){
						echo "<tr><td colspan='3'><a href='#' class='checkAll'>",__('check all', true),"</a> | <a href='#' class='uncheckAll'>",__('uncheck all', true),"</a></td></tr>";
					}
					
					if($add_line_ctrl){
						echo '<tr>
								<td class="right" colspan="',$header_data['count'],'">
									<a class="addLineLink add_10x10" href="#" title="',__( 'click to add a line', true ),'"></a>
									<input class="addLineCount" type="text" size="1" value="1" maxlength="2"/> line(s)
								</td>
							</tr>
						';
					}
					echo "</tfoot>";
				}else{
					echo '<tfoot>
							<tr>
									<td class="no_data_available" colspan="',$header_data['count'],'">',__( 'core_no_data_available', true ),'</td>
							</tr></tfoot>
					';
				}
				echo "</table></td>";
			}else{
				$this->printExtras($structure_count, count($structure_index), $table_index);
			}
		}
		echo "</tr></tbody></table>";
	}


	/**
	 * Builds a structure in a csv format
	 * @param unknown_type $atim_structure
	 * @param unknown_type $options
	 */
	private function buildCsv($atim_structure, $options, $data){
		$options['type'] = 'index';
		$table_structure = $this->buildStack($atim_structure, $options);
		$options['type'] = 'csv';//go back to csv
		
		if(is_array($table_structure) && count($data)){
			//header line
			$line = array();
			foreach($table_structure as $table_column){
				foreach($table_column as $fm => $table_row){
					foreach($table_row as $table_row_part){
						$line[] = $table_row_part['label'];
					}
				}
			}
			
			$this->Csv->addRow($line);

			//content
			foreach($data as $data_unit){
				$line = array();
				foreach($table_structure as $table_column){
					foreach ( $table_column as $fm => $table_row){
						foreach($table_row as $table_row_part){
							$line[] = trim($this->getPrintableField($table_row_part, $options, $data_unit[$table_row_part['model']][$table_row_part['field']], null, null));
						}
					}
				}
				$this->Csv->addRow($line);
			}
		}
		
		echo($this->Csv->render());
	}


	/**
	 * Echoes a structure in a tree format
	 * @param array $atim_structures Contains atim_strucures (yes, plural), one for each data model to display
	 * @param array $options
	 * @param array $data
	 */
	private function buildTree(array $atim_structures, array $options, array $data){
		//prebuild links
		if(count($data)){
			foreach($options['links']['tree'] as $model_name => $links){
				$tree_links = $options['links'];
				$tree_links['index'] = $options['links']['tree'][$model_name];
				$options['links']['tree'][$model_name] = $this->generateLinksList(null, $tree_links, 'index');
			}
		}
		$stretch = $options['settings']['stretch'] ? '' : ' style="width: auto;" '; 
		echo '
			<table class="structure" cellspacing="0"'.$stretch.'>
			<tbody>
				<tr>
		';
		
		$structure_count = 0;
		$structure_index = array( 1 => array() ); 
		
		// add EXTRAS, if any
		$structure_index = $this->displayExtras($structure_index, $options);
		
		foreach($structure_index as $column_key => $table_index){
			
			$structure_count++;
			
			// for each FORM/DETAIL element...
			if(is_array($table_index)){
			
				echo('
					<td class="this_column_'.$structure_count.' total_columns_'.count($structure_index).'" style="width: 30%;">
						<table class="columns tree" cellspacing="0">
							<tbody>
				');
				
				if(count($data)){
					// start root level of UL tree, and call NODE function
					echo('
						<tr><td>
							<ul id="tree_root">
					');
					
					$this->buildTreeNode($atim_structures, $options, $data);
					
					echo('
							</ul>
						</td></tr>
					');
				}else{
					// display something nice for NO ROWS msg...
					echo('
							<tr>
									<td class="no_data_available" colspan="1">'.__( 'core_no_data_available', true ).'</td>
							</tr>
					');
				}
					
				echo('
							</tbody>
						</table>
					</td>
				');
						
			}else{
				$this->printExtras($structure_count, count($structure_index), $table_index);
			}
		}
				
		echo'
				</tr>
			</tbody>
			</table>
			';
	}
	
	/**
	 * Echoes a tree node for the tree structure
	 * @param array $atim_structures
	 * @param array $options
	 * @param array $data
	 */
	private function buildTreeNode(array &$atim_structures, array $options, array $data){
		foreach($data as $data_key => $data_val){
			// unset CHILDREN from data, to not confuse STACK function
			$children = array();
			if (isset($data_val['children'])){
				$children = $data_val['children'];
				unset($data_val['children']);
			}
			
			echo'
				<li>
			';
				
			// collect LINKS and STACK to be added to LI, must do out of order, as need ID field to use as unique CSS ID in UL/A toggle
				
			// reveal sub ULs if sub ULs exist
			$links = "";
			$expand_key = "";
			if(count($options['links']['tree'])){
				echo '<div><span class="divider">|</span> ';	
				$i = 0;
				foreach($data_val as $model_name => $model_array){
					if(isset($options['links']['tree'][$model_name])){
						//apply prebuilt links
						$links = $this->strReplaceLink($options['links']['tree'][$model_name], $data_val);
						if(isset($model_array['id'])){
							$expand_key = $model_name;
							break;
						}
					}
				}
			}else if (count($options['links']['index'])){
				//apply prebuilt links
				$links = '<div><span class="divider">|</span> '.$this->strReplaceLink($options['links']['tree'][$expand_key], $data_val);
			}
			if(is_array($children)){
				if(empty($children)){
					echo '<a class="reveal not_allowed href="#" onclick="return false;">+</a> ';
				}else{
					echo '<a class="reveal activate" href="#" onclick="return false;">+</a> ';
				}
			}else if($children){
				echo '<a class="reveal notFetched {\'url\' : \'', (isset($options['links']['tree_expand'][$expand_key]) ? $this->strReplaceLink($options['links']['tree_expand'][$expand_key], $data_val) : ""), '\'}" href="#" onclick="return false;">+</a> ';
			}else{
				echo '<a class="reveal not_allowed" href="#" onclick="return false;">+</a> ';
			}
			echo $links;
		
			if(count($options['settings']['tree'])){
				foreach($data_val as $model_name => $model_array){
					if(isset($options['settings']['tree'][$model_name])){
						
						if(!isset($atim_structures[$options['settings']['tree'][$model_name]]['app_stack'])){
							$atim_structures[$options['settings']['tree'][$model_name]]['app_stack'] = $this->buildStack($atim_structures[$options['settings']['tree'][$model_name]], $options);
						}
						
						$table_index = $atim_structures[$options['settings']['tree'][$model_name]]['app_stack'];
						break;
					}
				}
			}
			
			$options['type'] = 'index';
			unset($options['stack']);
			$first = true;
			foreach($table_index as $table_column_key => $table_column){
				foreach($table_column as $table_row_key => $table_row){
					foreach($table_row as $table_row_part){
						//carefull with the white spaces as removing them the can break the display in IE
						echo '<span class="nowrap">';
						if(($table_row_part['type'] != 'hidden' && strlen($table_row_part['label'])) || $first){
							echo '<span class="divider">|</span> ';
							$first = false;
						}
						if(isset($data_val[$table_row_part['model']])){
							$to_prefix = $data_val[$table_row_part['model']]['id']."][";
							if(isset($table_row_part['format']) && strlen($table_row_part['format']) > 0){
								$table_row_part['format'] = preg_replace('/name="data\[/', 'name="data['.$to_prefix, $table_row_part['format']);
							}else{
								$table_row_part['name'] = $to_prefix.$table_row_part['name'];
							}
						}
						echo $this->getPrintableField(
								$table_row_part, 
								$options, 
								isset($data_val[$table_row_part['model']][$table_row_part['field']]) ? $data_val[$table_row_part['model']][$table_row_part['field']] : "", 
								null,
								null)
							,'</span>
						';
					}
				}
			}
				
			echo('</div>');
			
			// create sub-UL, calling this NODE function again, if model has any CHILDREN
			if(is_array($children) && !empty($children)){
				echo '
					<ul style="display:none;">
				';
				
				$this->buildTreeNode($atim_structures, $options, $children);
				echo'
					</ul>
				';
			}
			
			echo'
				</li>
			';
			
		}
	}


	/**
	 * Builds the display header
	 * @param array $table_index The structural information
	 * @param array $options The options
	 */
	private function buildDisplayHeader(array $table_structure, array $options){
		$column_count = 0;
		$return_string = '<tr>';
		if(count($options['links']['checklist'])){
			$return_string .= '
				<th class="checkbox">&nbsp;</th>
			';
			$column_count ++;
		}
		if(count($options['links']['radiolist'])){
			$return_string .= '
					<th class="radiobutton">&nbsp;</th>
			';
			$column_count ++;
		}
		if(count($options['links']['index'])){
			$return_string .= '
					<th class="id">&nbsp;</th>
			';
			$column_count ++;
		}
		
		// each column/row in table 
		if(count($table_structure)){
			$link_parts = explode('/', $_SERVER['REQUEST_URI']);
			$sort_on = "";
			$sort_asc = true;
			foreach($link_parts as $link_part){
				if(strpos($link_part, "sort:") === 0){
					$sort_on = substr($link_part, 5);
				}else if($link_part == "direction:desc"){
					$sort_asc = false;
				}
			}
			if(strlen($sort_on) == 0
			&& isset($this->Paginator->params['paging']) 
			&& ($part = current($this->Paginator->params['paging'])) 
			&& isset($part['defaults']['order'])){
					$sort_on = is_array($part['defaults']['order']) ? current($part['defaults']['order']) : $part['defaults']['order']; 
					list($sort_on) = explode(",", $sort_on);//discard any but the first order by clause
					$sort_on = explode(" ", $sort_on);
					$sort_asc = !isset($sort_on[1]) || strtoupper($sort_on[1]) != "DESC";
					$sort_on = $sort_on[0];
			}
			
			$content_columns_count = 0;
			foreach ($table_structure as $table_column){
				foreach ($table_column as $table_row){
					foreach($table_row as $table_row_part){
						if ($table_row_part['type'] != 'hidden' && strlen($table_row_part['label']) > 0){
							++ $content_columns_count;
						}
					}
				}
			}
			$column_count += $content_columns_count;
			$content_columns_count /= 2;
			$current_col_number = 0;
			$first_cell = true;
			foreach ($table_structure as $table_column){
				foreach ($table_column as $table_row){
					foreach($table_row as $table_row_part){
						if (($table_row_part['type'] != 'hidden' && strlen($table_row_part['label']) > 0) || $first_cell){
							$first_cell = false;

							// label and help/info marker, if available...
							$return_string .= '
								<th>
							';
							
							$default_sorting_direction = isset($_REQUEST['direction']) ? $_REQUEST['direction'] : 'asc';
							$default_sorting_direction = strtolower($default_sorting_direction);

							if($options['settings']['pagination'] || $options['settings']['sorting']){
								$sorted_on_current_column = $table_row_part['model'].'.'.$table_row_part['field'] == $sort_on;
								if($sorted_on_current_column){
									$return_string .= '<div style="display: inline-block;" class="ui-icon ui-icon-triangle-1-'.($sort_asc ? "s" : "n").'"></div>';
								}
								if($options['settings']['pagination']){
									$paginator_string = $this->Paginator->sort(html_entity_decode($table_row_part['label'], ENT_QUOTES, "UTF-8"), $table_row_part['model'].'.'.$table_row_part['field']);
									if($sorted_on_current_column && $sort_asc){
										$paginator_string = str_replace('/direction:asc">', '/direction:desc">', $paginator_string);
									}
									$return_string .= $paginator_string;
								}else{
									//sorting
									$url = array_merge(
										$this->Paginator->options['url'], 
										array(
											'sort' => $table_row_part['model'].'.'.$table_row_part['field'], 
											'direction' => $sorted_on_current_column && $sort_asc ? "desc" : "asc", 
											'order' => null
										)
									);
									$return_string .= $this->Html->link(html_entity_decode($table_row_part['label'], ENT_QUOTES, "UTF-8"), $url, array()); 
								}
							}else{
								$return_string .= $table_row_part['label'];
							}
							
							if(show_help){
								$return_string .= $current_col_number < $content_columns_count ? str_replace('<span class="help">', '<span class="help right">', $table_row_part['help']) : $table_row_part['help'];
							}
							
							++ $current_col_number;
							$return_string .= '
								</th>
							';
						}
					}	
				}
			}
			
		}
		
		if($options['remove_line_ctrl']) {
			$return_string .= '
				<th>&nbsp;</th>
			';
			$column_count ++;
		}
		
		// end header row...
		$return_string .= '
				</tr>
		';
		
		return array("header" => $return_string, "count" => $column_count);
		
	}

	private function displayExtras($return_array=array(), $options){
		if(count($options['extras'])){
			foreach($options['extras'] as $key=>$val){
				while(isset($return_array[$key])){
					$key++;
				}
				$return_array[ $key ] = $val;
			}
		}
		ksort($return_array);
		return $return_array;
	}

	private function printExtras($this_column, $total_columns, $content){
		echo('
			<td class="this_column_'.$this_column.' total_columns_'.$total_columns.'"> 
			
				<table class="columns extra" cellspacing="0">
				<tbody>
					<tr>
						<td>
							'.$content.'
						</td>
					</tr>
				</tbody>
				</table>
				
			</td>
		');
	}

	/**
	 * Builds the structure part that will contain data. Input types (inputs and numbers) are prebuilt 
	 * whereas other types still need to be generated 
	 * @param array $atim_structure
	 * @param array $options
	 * @return array The representation of the display where $result = arry(x => array(y => array(field data))
	 */
	private function buildStack(array $atim_structure, array $options){
		//TODO: WARNING ON paste_disabled if field mentioned in the view is not found here
		$stack = array();//the stack array represents the display x => array(y => array(field data))
		$empty_help_bullet = '<span class="help error">&nbsp;</span>';
		$help_bullet = '<span class="help">&nbsp;<div>%s</div></span> ';
		$independent_types = array("select" => null, "radio" => null, "checkbox" => null, "date" => null, "datetime" => null, "time" => null, "yes_no" => null);
		$my_default_settings_arr = self::$default_settings_arr;
		$my_default_settings_arr['value'] = "%s";
		self::$last_tabindex = max(self::$last_tabindex, $options['settings']['tabindex']);
		if(isset($atim_structure['Sfs'])){
			$paste_disabled = array();
			foreach($atim_structure['Sfs'] AS $sfs){
				if($sfs['flag_'.$options['type']] || $options['settings']['all_fields']){
					$current = array(
						"name" 				=> "",
						"model" 			=> $sfs['model'],
						"tablename"			=> $sfs['tablename'],
						"field" 			=> $sfs['field'],
						"heading" 			=> __($sfs['language_heading'], true),
						"label" 			=> __($sfs['language_label'], true),
						"tag" 				=> __($sfs['language_tag'], true),
						"type" 				=> $sfs['type'],
						"help" 				=> strlen($sfs['language_help']) > 0 ? sprintf($help_bullet, __($sfs['language_help'], true)) : $empty_help_bullet,
						"setting" 			=> $sfs['setting'],//required for icd10 magic
						"default"			=> $sfs['default'],
						"flag_confidential"	=> $sfs['flag_confidential'],
						"readonly"			=> isset($sfs["flag_".$options['type']."_readonly"]) && $sfs["flag_".$options['type']."_readonly"]
					);
					$settings = $my_default_settings_arr;
					
					$date_format_arr = str_split(date_format);
					if($options['links']['top'] && $options['settings']['form_inputs']){
						$settings['tabindex'] = self::$last_tabindex ++;
						
						//building all text fields (dropdowns, radios and checkboxes cannot be built here)
						$field_name = "";
						if(strlen($options['settings']['name_prefix'])){
							$field_name .= $options['settings']['name_prefix'].".";
						}
						if($options['type'] == 'addgrid' || $options['type'] == 'editgrid'){
							$field_name .= "%d.";
							if(in_array($sfs['model'].".".$sfs['field'], $options['settings']['paste_disabled_fields'])){
								$settings['class'] .= " pasteDisabled";
								$paste_disabled[] = $sfs['model'].".".$sfs['field']; 
							}
						}
						$field_name .= $sfs['model'].".".$sfs['field'];
						$field_name = str_replace(".", "][", $field_name);//manually replace . by ][ to counter cake bug
						$current['name'] = $field_name;
						if(strlen($sfs['setting']) > 0 && !$current['readonly']){
							// parse through FORM_FIELDS setting value, and add to helper array
							$tmp_setting = explode(',', $sfs['setting']);
							foreach($tmp_setting as $setting){
								$setting = explode('=', $setting);
								if($setting[0] == 'tool'){
									if($setting[1] == 'csv'){
										if($options['type'] == 'search'){
											$current['tool'] = $this->Form->input($field_name."_with_file_upload", array_merge($settings, array("type" => "file", "class" => null, "value" => null)));
										}
									}else{
										$current['tool'] = '<a href="'.$this->webroot.str_replace( ' ', '_', trim(str_replace( '.', ' ', $setting[1]))).'" class="tool_popup"></a>';
									}
								}else if($setting[0] == 'accuracy'){
									continue;
								}else{
									$settings[$setting[0]] = $setting[1];
								}
							}
						}
						
						//validation CSS classes
						if(count($sfs['StructureValidation']) > 0 && $options['type'] != "search"){
							
							foreach($sfs['StructureValidation'] as $validation){
								if($validation['rule'] == 'notEmpty'){
									$settings["class"] .= " required";
									$settings["required"] = "required";
									break;
								}
							}
							if($settings["class"] == "%c "){
								$settings["class"] .= "validation";
							}
						}
						
						
						if($current['readonly']){
							unset($settings['disabled']);
							$current["format"] = $this->Form->text($field_name, array("type" => "hidden", "id" => false, "value" => "%s"), $settings);
							$settings['disabled'] = "disabled";
						}else if($sfs['type'] == "input"){
							if($options['type'] != "search"){
								$settings['class'] = str_replace("range", "", $settings['class']);
							}
							$current["format"] = $this->Form->input($field_name, array_merge(array("type" => "text"), $settings));
						}else if(array_key_exists($sfs['type'], $independent_types)){
							//do nothing for independent types
							$current["format"] = "";
						}else if($sfs['type'] == "integer" || $sfs['type'] == "integer_positive"){
							if(!isset($settings['size'])){
								$settings['size'] = 4;
							}
							$current["format"] = $this->Form->text($field_name, array_merge(array("type" => "number"), $settings));
						}else if($sfs['type'] == "float" || $sfs['type'] == "float_positive"){
							if(!isset($settings['size'])){
								$settings['size'] = 4;
							}
							$current["format"] = $this->Form->text($field_name, array_merge(array("type" => "text"), $settings));
						}else if($sfs['type'] == "textarea"){
							//notice this is Form->input and not Form->text
							$current["format"] = $this->Form->input($field_name, array_merge(array("type" => "textarea"), $settings));
						}else if($sfs['type'] == "autocomplete"
						|| $sfs['type'] == "hidden"
						|| $sfs['type'] == "file"
						|| $sfs['type'] == "password"){
							if($sfs['type'] == "autocomplete" && isset($settings['url'])){
								$settings['class'] .= " jqueryAutocomplete";
							}
							$current["format"] = $this->Form->text($field_name, array_merge(array("type" => $sfs['type']), $settings));
							if($sfs['type'] == "hidden"){
								if(strlen($current['label'])){
									if(Configure::read('debug') > 0){
										AppController::addWarningMsg(sprintf(__("the hidden field [%s] label has been removed", true), $sfs['model'].".".$sfs['field']));
									}
									$current['label'] = "";
								}
								if(strlen($current['heading'])){
									if(Configure::read('debug') > 0){
										AppController::addWarningMsg(sprintf(__("the hidden field [%s] heading has been removed", true), $sfs['model'].".".$sfs['field']));
									}
									$current['heading'] = "";
								}
							}
						}else if($sfs['type'] == "display"){
							$current["format"] = "%s";
						}else{
							if(Configure::read('debug') > 0){
								AppController::addWarningMsg(sprintf(__("field type [%s] is unknown", true), $sfs['type']));
							}
							$current["format"] = $this->Form->input($field_name, array_merge(array("type" => "text"), $settings));
						}
						
						$current['default'] = $sfs['default'];
						$current['settings'] = $settings;
					}else{
						$current["format"] = "";
					}
					
					if(array_key_exists($sfs['type'], $independent_types)){
						$dropdown_result = array("defined" => array(), "previously_defined" => array());
						if($sfs['type'] == "select"){
							$add_blank = true;
							if(count($sfs['StructureValidation']) > 0 && ($options['type'] == "edit" || $options['type'] == "editgrid")){
								//check if the field can be empty or not
								foreach($sfs['StructureValidation'] as $validation){
									if($validation['rule'] == 'notEmpty'){
										$add_blank = false;
										break;
									}
								}
							}
							if($add_blank){
								$dropdown_result["defined"][""] = "";
							}
						}
								
						if(isset($options['dropdown_options'][$sfs['model'].".".$sfs['field']])){
							$dropdown_result['defined'] = $options['dropdown_options'][$sfs['model'].".".$sfs['field']]; 
						}else if(count($sfs['StructureValueDomain']) > 0){
							if(strlen($sfs['StructureValueDomain']['source']) > 0){
								//load source
								$tmp_dropdown_result = StructuresComponent::getPulldownFromSource($sfs['StructureValueDomain']['source']);
								if(array_key_exists('defined', $tmp_dropdown_result)){
									$dropdown_result['defined'] += $tmp_dropdown_result['defined'];
									if(array_key_exists('previously_defined', $tmp_dropdown_result)){
										$dropdown_result['previously_defined'] += $tmp_dropdown_result['previously_defined'];
									}
								}else{
									$dropdown_result['defined'] += $tmp_dropdown_result;
								}
							}else{
								$tmp_dropdown_result = $this->StructureValueDomain->find('first', array(
									'recursive' => 2,
									'conditions' => array('StructureValueDomain.id' => $sfs['StructureValueDomain']['id'])));
								if(count($tmp_dropdown_result['StructurePermissibleValue']) > 0){
									$tmp_result = array('defined' => array(), 'previously_defined' => array());
									//sort based on flag and on order
									foreach($tmp_dropdown_result['StructurePermissibleValue'] as $tmp_entry){
										if($tmp_entry['flag_active']){
											if($tmp_entry['use_as_input']){
												$tmp_result['defined'][$tmp_entry['value']] = sprintf("%04d", $tmp_entry['display_order']).__($tmp_entry['language_alias'], true);
											}else{
												$tmp_result['previously_defined'][$tmp_entry['value']] = sprintf("%04d", $tmp_entry['display_order']).__($tmp_entry['language_alias'], true);
											}
										}
									}
									asort($tmp_result['defined']);
									asort($tmp_result['previously_defined']);
									$substr4_func = create_function('$str', 'return substr($str, 4);');
									$tmp_result['defined'] = array_map($substr4_func, $tmp_result['defined']);
									$tmp_result['previously_defined'] = array_map($substr4_func, $tmp_result['previously_defined']);
		
									$dropdown_result['defined'] += $tmp_result['defined'];//merging arrays and keeping numeric keys intact
									$dropdown_result['previously_defined'] += $tmp_result['previously_defined'];
								}
							}
						}else if($sfs['type'] == "checkbox"){
							//provide yes/no as default for checkboxes
							$dropdown_result['defined'] = array(0 => __("no", true), 1 => __("yes", true));
						}else if($sfs['type'] == "yes_no"){
							//provide yes/no/? as default for yes_no
							$dropdown_result['defined'] = array("" => "", "n" => __("no", true), "y" => __("yes", true));
						}
						
						if($options['type'] == "search" && ($sfs['type'] == "checkbox" || $sfs['type'] == "radio")){
							//checkbox and radio buttons in search mode are dropdowns 
							$dropdown_result['defined'] = array_merge(array("" => ""), $dropdown_result['defined']);
						}
						
						if(count($dropdown_result['defined']) == 2 
						&& isset($sfs['flag_'.$options['type'].'_readonly']) 
						&& $sfs['flag_'.$options['type'].'_readonly'] 
						&& $add_blank){
							//unset the blank value, the single value for a disabled field should be default
							unset($dropdown_result['defined'][""]);
						}
						$current['settings']['options'] = $dropdown_result;
					}
					
					if(!isset($stack[$sfs['display_column']][$sfs['display_order']])){
						$stack[$sfs['display_column']][$sfs['display_order']] = array();
					}
					$stack[$sfs['display_column']][$sfs['display_order']][] = $current;
				}
				
			}
			
			if(Configure::read('debug') > 0){
				$paste_disabled = array_diff($options['settings']['paste_disabled_fields'], $paste_disabled);
				if(count($paste_disabled) > 0){
					AppController::addWarningMsg("DEBUG Paste disabled field(s) not found: ". implode(", ", $paste_disabled));
				}
			}
		}
		
		if(Configure::read('debug') > 0 && count($options['override']) > 0){
			$override = array_merge(array(), $options['override']);
			foreach($stack as $cell){
				foreach($cell as $fields){
					foreach($fields as $field){
						unset($override[$field['model'].".".$field['field']]);
					}
				}
			}
			if(count($override) > 0){
				if($options['type'] == 'index' || $options['type'] == 'detail'){
					AppController::addWarningMsg(__("you should not define overrides for index and detail views", true));
				}else{
					foreach($override as $key => $foo){
						AppController::addWarningMsg(sprintf(__("the override for [%s] couldn't be applied because the field was not found", true), $key));
					}
				}
			}
		}
		return $stack;
	}
	

	public function generateContentWrapper($atim_content = array(), $options = array()){
		$return_string = '';
			
		// display table...
		$return_string .= '
			<table class="structure" cellspacing="0">
			<tbody>
				<tr>
		';
				
		// each column in table 
		$count_columns = 0;
		foreach($atim_content as $content){
			$count_columns++;
			
			$return_string .= '
				<td class="this_column_'.$count_columns.' total_columns_'.count($atim_content).'"> 
					
					<table class="columns content" cellspacing="0">
					<tbody>
						<tr>
							<td>
								'.$content.'
							</td>
						</tr>
					</tbody>
					</table>
						
				</td>
			';
		} // end COLUMN 
				
		$return_string .= '
				</tr>
			</tbody>
			</table>
		';
			
		return $return_string.$this->generateLinksList(NULL, isset($options['links']) ? $options['links'] : array(), 'bottom');
	}


	private function generateLinksList($data, array $option_links, $state = 'index'){
		$aro_alias = 'Group::'.$this->Session->read('Auth.User.group_id');
		
		$return_string = '';
		
		$return_urls = array();
		$return_links = array();
		
		$links = isset($option_links[$state]) ? $option_links[$state] : array();
		$links = is_array($links) ? $links : array('detail' => $links);
		// parse through $LINKS array passed to function, make link for each
		foreach($links as $link_name => $link_array){
			if(empty($link_array)){
				continue;
			}
			if(!is_array($link_array)){
				$link_array = array( $link_name => $link_array );
			}
			
			$link_results = array();

			$icon = "";
			if(isset($link_array['link'])){
				if(isset($link_array['icon'])){
					$icon = $link_array['icon'];
				}
				$link_array = array($link_name => $link_array['link']);
			}
			$prev_icon = $icon;
			foreach($link_array as $link_label => &$link_location){
				$icon = $prev_icon;
				if(is_array($link_location)){
					if(isset($link_location['icon'])){
						//set requested custom icon
						$icon = $link_location['icon'];
					}
					$link_location = &$link_location['link'];
				}
					
				$parts = Router::parse($link_location);
				$aco_alias = 'controllers/'.($parts['plugin'] ? Inflector::camelize($parts['plugin']).'/' : '');
				$aco_alias .= ($parts['controller'] ? Inflector::camelize($parts['controller']).'/' : '');
				$aco_alias .= ($parts['action'] ? $parts['action'] : '');
				
				if ( !isset($Acl) ) {
					$Acl = new SessionAclComponent();
					$Acl->initialize($this);
				}
				
				// if ACO/ARO permissions check succeeds, create link
				if (strpos($aco_alias,'controllers/Users') !== false 
				|| strpos($aco_alias,'controllers/Pages') !== false
				|| $aco_alias == "controllers/Menus/index"
				|| $Acl->check($aro_alias, $aco_alias)){
					
					$display_class_name = $this->generateLinkClass($link_name, $link_location);
					$htmlAttributes['title'] = strip_tags( html_entity_decode(__($link_name, true), ENT_QUOTES, "UTF-8") ); 
					
					if(strlen($icon) > 0){
						$htmlAttributes['class'] = 'form '.$icon;
					}else{
						$htmlAttributes['class'] = 'form '.$display_class_name;
					}
					
					// set Javascript confirmation msg...
					$confirmation_msg = NULL;
					
					if($data != null){
						$link_location 		= $this->strReplaceLink($link_location, $data);
					}

					$return_urls[]		= $this->Html->url( $link_location );
					
					// check AJAX variable, and set link to be AJAX link if exists
					if(isset($option_links['ajax'][$state][$link_name])){
						
						// if ajax SETTING is an ARRAY, set helper's OPTIONS based on keys=>values
						if(is_array($option_links['ajax'][$state][$link_name])){
							foreach ($option_links['ajax'][$state][$link_name] as $html_attribute_key => $html_attribute_value){
								$htmlAttributes[$html_attribute_key] = $html_attribute_value;
							}
						}else{
						// otherwise if STRING set UPDATE option only
							$htmlAttributes['json']['update'] = $option_links['ajax'][$state][$link_name];
						}
						//stuff the ajax information in json format within the class attribute
						$htmlAttributes['class'] .= " ajax {";
						foreach($htmlAttributes['json'] as $key => $val){
							$htmlAttributes['class'] .= "'".$key."' : '".$val."', ";
						}
						$htmlAttributes['class'] = substr($htmlAttributes['class'], 0, strlen($htmlAttributes['class']) - 2)."}";
						unset($htmlAttributes['json']);
					}
						
					$htmlAttributes['escape'] = false; // inline option removed from LINK function and moved to Options array
			
					$link_results[$link_label]	= $this->Html->link( 
						($state=='index' ? '&nbsp;' : __($link_label, true)), // title
						$link_location, // url
						$htmlAttributes, // options
						$confirmation_msg // confirmation message
					);
					
				}else{
					// if ACO/ARO permission check fails, display NOt ALLOWED type link
					$return_urls[]		= $this->Html->url( '/menus' );
					$link_results[$link_label]	= '<a class="not_allowed">'.__($link_label, true).'</a>';
				} // end CHECKMENUPERMISSIONS
				
			}
			
			if ( count($link_results)==1 && isset($link_results[$link_name]) ) {
				$return_links[$link_name] = $link_results[$link_name];
			}else{
				$links_append = '
							<a class="form popup" href="javascript:return false;">'.__($link_name, TRUE).'</a>
							<!-- container DIV for JS functionality -->
							<div class="filter_menu'.( count($link_results)>7 ? ' scroll' : '' ).'">
								
								<div class="menuContent">
									<ul>
				';
				
				$count = 0;
				$tmpSize = sizeof($link_results) - 1;
				foreach($link_results as $link_label=>$link_location){
					$class_last_line = "";
					if($count == $tmpSize){
						$class_last_line = " count_last_line";
					}
					$links_append .= '
										<li class="count_'.$count.$class_last_line.'">
											'.$link_location.'
										</li>
					';
					
					$count++;
				}
				
				$links_append .= '
									</ul>
								</div>
				';
				
				if(count($link_results) > 7){
					$links_append .= '
								<span class="up"></span>
								<span class="down"></span>
								
								<a href="#" class="up">&uarr;</a>
								<a href="#" class="down">&darr;</a>
					
					';
				}
				
				$links_append .= '
								<div class="arrow"><span></span></div>
							</div>
				';
				
				$return_links[$link_name] = $links_append;
				
			}
			
		} // end FOREACH 
		
		// ADD title to links bar and wrap in H5
		if($state == 'bottom'){ 
			
			$return_string = '
				<div class="actions">
			';
			
			if(isset($_SESSION) && isset($_SESSION['Auth']) && isset($_SESSION['Auth']['User']) && count($_SESSION['Auth']['User'])){
				if (isset($_SESSION['ctrapp_core']['search']) 
					&& is_array($_SESSION['ctrapp_core']['search']) 
					&& !empty($_SESSION['ctrapp_core']['search']['results'])
					&& AppController::getInstance()->layout != 'ajax'
				){
					//
					$return_string .= '
						<div class="bottom_button"><a class="search_results" href="'.$this->Html->url($_SESSION['ctrapp_core']['search']['url']).'">
							'.$_SESSION['ctrapp_core']['search']['results'].'
						</a></div>
					';
				}
			}else{
				unset($_SESSION['ctrapp_core']['search']);
			}

			if(count($return_links)){
				$return_string .= '
						<div class="bottom_button">'.implode('</div><div class="bottom_button">',$return_links).'</div>
					';
			}
			
			
			$return_string .= '
				</div>
			';
			
			
			
		}else if($state=='top'){
			$return_string = $return_urls[0];
		}else if($state=='index'){
			if(count($return_links)){
				$return_string = implode(' ',$return_links);
			}
		}
		
		return $return_string;
	}


	public function generateLinkClass($link_name = NULL, $link_location = NULL){
		$display_class_name = '';
		$display_class_array = array();
		
		// CODE TO SET CLASS(ES) BASED ON URL GOES HERE!
			
		// determine TYPE of link, for styling and icon
		
		$use_string = $link_name ? $link_name : $link_location;
		
		if ( $link_name ) {
			$use_string = str_replace('core_','',$use_string);
		}
		
		$display_class_array = str_replace('/', ' ', $use_string);
		$display_class_array = str_replace('_', ' ', $display_class_array);
		$display_class_array = str_replace('-', ' ', $display_class_array);
		$display_class_array = str_replace('  ', ' ', $display_class_array);
		$display_class_array = explode( ' ', trim($display_class_array) );
		
		// if URL is passed but no NAME, reduce to words and get LAST word (which should be the action) and use that
		if(!$link_name && $link_location){
			foreach($display_class_array as $key=>$val){
				if(strpos($val,'%')!==false || strpos($val,'@')!==false || is_numeric($val)){
					unset($display_class_array[$key]);
				} else {
					$display_class_array[$key] = strtolower(trim($val));
				}
			}
		
			$display_class_array = array_reverse($display_class_array);
		}

		$display_class_array[1] = isset($display_class_array[1]) ? strtolower($display_class_array[1]) : ''; 
		$display_class_array[2] = isset($display_class_array[2]) ? strtolower($display_class_array[2]) : '';

		$display_class_name = null;
		if(isset(self::$display_class_mapping[$display_class_array[0]])){
			$display_class_name = self::$display_class_mapping[$display_class_array[0]];
		}else if($display_class_array[0] == "plugin"){
			if($display_class_array[1] == 'menus'){
				if($display_class_array[2] == 'tools'){
					$display_class_name = 'tools';
				}else if($display_class_array[2] == 'datamart'){
					
					$display_class_name = 'datamart';
				}else{
					$display_class_name = 'home';
				}
			}else if($display_class_array[1] == 'users' && $display_class_array[2] == 'logout'){
				$display_class_name = 'logout';
			}else if(array_key_exists($display_class_array[1], self::$display_class_mapping_plugin)){
				$display_class_name = $display_class_array[1];
				if($display_class_name == "datamart" && isset($display_class_array[2])){
					$display_class_name .= " ".$display_class_array[2];
				}
			}else{
				$display_class_name = 'default';
			}
			
			$display_class_name = 'plugin '.$display_class_name;
		}else if($link_name && $link_location){
			$display_class_name = $this->generateLinkClass(NULL, $link_location);
		}else{
			$display_class_name = 'default';
		}

		// return
		return $display_class_name;
		
	}

	
	/**
	 * FUNCTION to replace %%MODEL.FIELDNAME%% in link with MODEL.FIELDNAME value
	 */ 
	function strReplaceLink($link = '', $data = array()){
		if(is_array($data)){
			foreach($data as $model => $fields){
				if(is_array($fields)){
					foreach($fields as $field => $value){
						// avoid ONETOMANY or HASANDBELONGSOTMANY relationahips 
						if(!is_array($value)){
							// find text in LINK href in format of %%MODEL.FIELD%% and replace with that MODEL.FIELD value...
							$link = str_replace( '%%'.$model.'.'.$field.'%%', $value, $link );
							$link = str_replace( '@@'.$model.'.'.$field.'@@', $value, $link );
						}
					}
				}
			}
		}
		return $link;
	}

	
	function &arrayMergeRecursiveDistinct( &$array1, &$array2 = null) {
		$merged = $array1;
		if(is_array($array2)){
			foreach($array2 as $key => $val){
				if(is_array($array2[$key])){
					if(!isset($merged[$key])){
						$merged[$key] = array();
					}
					$merged[$key] = is_array($merged[$key]) ? $this->arrayMergeRecursiveDistinct($merged[$key], $array2[$key]) : $array2[$key];
				}else{
					$merged[$key] = $val;
				}
			
			}
		}
		return $merged;
	}
	
	
	/**
	 * Returns the date inputs
	 * @param string $name
	 * @param string $date YYYY-MM-DD
	 * @param array $attributes
	 */
	private function getDateInputs($name, $date, array $attributes){
		$pref_date = str_split(date_format);
		$year = $month = $day = null;
		if(is_array($date)){
			$year = $date['year'];
			$month = $date['month'];
			$day = $date['day'];
			if(isset($date['year_accuracy'])){
				$year = '±'.$year;
			}
		}else if(strlen($date) > 0 && $date != "NULL"){
			$date = explode("-", $date);
			$year = $date[0];
			switch(count($date)){
				case 3:
					$day = $date[2];
				case 2:
					$month = $date[1];
					break;
			}
		}
		$result = "";
		unset($attributes['options']);//fixes an IE js bug where $(select).val() returns an error if "options" is present as an attribute
		$year_attributes = $attributes; 
		if(strpos($year, "±") === 0){
			$year_attributes['class'] .= " year_accuracy ";
			$year = substr($year, 2);
		}
		
		if(datetime_input_type == "dropdown"){
			foreach($pref_date as $part){
				if($part == "Y"){
					$result .= $this->Form->year($name, 1900, 2100, $year, $year_attributes);
				}else if($part == "M"){
					$result .= $this->Form->month($name, $month, $attributes);
				}else{
					$result .= $this->Form->day($name, $day, $attributes);
				}
			}
		}else{
			foreach($pref_date as $part){
				if($part == "Y"){
					$result .= '<span class="tooltip">'.$this->Form->text($name.".year", array_merge($year_attributes, array('value' => $year, 'size' => 4)))."<div>".__('year', true)."</div></span>";
				}else if($part == "M"){
					$result .= '<span class="tooltip">'.$this->Form->text($name.".month", array_merge($attributes, array('value' => $month, 'size' => 2)))."<div>".__('month', true)."</div></span>";
				}else{
					$result .= '<span class="tooltip">'.$this->Form->text($name.".day", array_merge($attributes, array('value' => $day, 'size' => 2)))."<div>".__('day', true)."</div></span>";
				}
			}
		}
		if(!isset($attributes['disabled']) || (!$attributes['disabled'] && $attributes['disabled'] != "disabled")){
			//add the calendar icon + extra span to manage calendar javascript
			$result = 
				'<span>'.$result 
				.'<span style="position: relative;">
						<input type="button" class="datepicker" value=""/>
						<!-- <img src="'.$this->Html->Url('/img/cal.gif').'" alt="cal" class="fake_datepicker"/> -->
					</span>
				</span>';
		}
		return $result;
	}
	
	/**
	 * Returns the time inputs
	 * @param string $name
	 * @param string $time HH:mm (24h format)
	 * @param array $attributes
	 */
	private function getTimeInputs($name, $time, array $attributes){
		$result = "";
		$hour = $minutes = $meridian = null;
		if(is_array($time)){
			$hour = $time['hour'];
			$minutes = $time['min'];
			if(isset($time['meridian'])){
				$meridian = $time['meridian'];
			}
		}else if(strlen($time) > 0){
			if(strpos($time, ":") === false){
				$hour = $time;
			}else{
				list($hour, $minutes, ) = explode(":", $time);
			}
			if(time_format == 12){
				if($hour >= 12){
					$meridian = 'pm';
					if($hour > 12){
						$hour %= 12;
					}
				}else{
					$meridian = 'am';
					if($hour == 0){
						$hour = 12;
					}
				}
			}
		}
		if(datetime_input_type == "dropdown"){
			$result .= $this->Form->hour($name, time_format == 24, $hour, $attributes);
			$result .= $this->Form->minute($name, $minutes, $attributes);
		}else{
			$result .= '<span class="tooltip">'.$this->Form->text($name.".hour", array_merge($attributes, array('value' => $hour, 'size' => 2)))."<div>".__('hour', true)."</div></span>";
			$result .= '<span class="tooltip">'.$this->Form->text($name.".min", array_merge($attributes, array('value' => $minutes, 'size' => 2)))."<div>".__('minutes', true)."</div></span>";
		}
		if(time_format == 12){
			$result .= $this->Form->meridian($name, $meridian, $attributes, array('value' => $meridian));
		}
		return $result;
	}

	private static function getCurrentValue($data_unit, array $table_row_part, $suffix, $options){
		$warning = false;
		if(is_array($data_unit) 
		&& array_key_exists($table_row_part['model'], $data_unit) 
		&& is_array($data_unit[$table_row_part['model']])
		&& array_key_exists($table_row_part['field'].$suffix, $data_unit[$table_row_part['model']])){
			//priority 1, data
			$current_value = $data_unit[$table_row_part['model']][$table_row_part['field'].$suffix];
		}else if($options['type'] != 'index' && $options['type'] != 'detail'){
			if(isset($options['override'][$table_row_part['model'].".".$table_row_part['field']])){
				//priority 2, override
				$current_value = $options['override'][$table_row_part['model'].".".$table_row_part['field'].$suffix];
				if(is_array($current_value)){
					if(Configure::read('debug') > 0){
						AppController::addWarningMsg(sprintf(__("invalid override for model.field [%s.%s]", true), $table_row_part['model'], $table_row_part['field'].$suffix));
					}
					$current_value = "";
				}
			}else if(!empty($table_row_part['default'])){
				//priority 3, default
				$current_value = $table_row_part['default']; 
			}else{
				$current_value = "";
				if($table_row_part['readonly'] && $table_row_part['field'] != 'CopyCtrl'){
					$warning = true;
				}
			}
		}else{
			$warning = true;
			$current_value = "-";
		}
		
		if($warning && Configure::read('debug') > 0 && $options['settings']['data_miss_warn']){
			AppController::addWarningMsg(sprintf(__("no data for [%s.%s]", true), $table_row_part['model'], $table_row_part['field']));
		}
		
		if($options['CodingIcdCheck'] && ($options['type'] == 'index' || $options['type'] == 'detail')){
			foreach(AppModel::getMagicCodingIcdTriggerArray() as $key => $trigger){
				if(strpos($table_row_part['setting'], $trigger) !== false){
					eval('$instance = '.$key.'::getInstance();');
					$current_value .= " - ".$instance->getDescription($current_value);
				}
			}
		}
		return $current_value;
	}
}
	
?>