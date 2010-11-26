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
				'columns_names' => array(), // columns names - usefull for reports. only works in detail views
				
				'all_fields'	=> false, // FALSE acts on structures datatable settings, TRUE ignores them and displays ALL FIELDS in a form regardless
				'add_fields'	=> false, // if TRUE, adds an "add another" link after form to allow another row to be appended
				'del_fields'	=> false, // if TRUE, add a "remove" link after each row, to allow it to be removed from the form
				
				'tree'			=> array() // indicates MULTIPLE atim_structures passed to this class, and which ones to use for which MODEL in each tree ROW
			),
			
			'links'		=> array(
				'top'			=> false, // if present, will turn structure into a FORM and this url is used as the FORM action attribute
				'index'			=> array(),
				'bottom'		=> array(),
				
				'tree'			=> array(),
				
				'checklist'		=> array(), // keys are checkbox NAMES (model.field) and values are checkbox VALUES
				'radiolist'		=> array(), // keys are radio button NAMES (model.field) and values are radio button VALUES
				
				'ajax'	=> array( // change any of the above LINKS into AJAX calls instead
					'top'		=> false,
					'index'		=> array(),
					'bottom'	=> array()
				)
			),
			
			'override'	=> array(),
			
			'extras'		=> array() // HTML added to structure blindly, each in own COLUMN
		);

	private static $default_settings_arr = array(
			"label" => false, 
			"div" => false, 
			"class" => "%c ",
			"id" => false,
			"legend" => false,
		);
		
	private static $range_types = array("date", "datetime", "time", "integer", "integer_positive", "float", "float_positive");
	
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

	/**
	 * Builds a structure
	 * @param array $atim_structure The structure to build
	 * @param array $options The various options indicating how to build the structures. refer to self::$default for all options
	 * @return depending on the return option, echoes the structure and returns true or returns the string
	 */
	function build(array $atim_structure = array(), array $options = array()){
		// DEFAULT set of options, overridden by PASSED options
		$options = $this->arrayMergeRecursiveDistinct(self::$defaults,$options);
		if(!isset($options['type'])){
			$options['type'] = $this->params['action'];//no type, default to action
		}
		
		//print warning when unknown stuff and debug is on
		if(Configure::read('debug') > 0){
			foreach($options as $k => $foo){
				if(!array_key_exists($k, self::$defaults)){
					AppController::addWarningMsg(sprintf(__("unknown function [%s] in structure build", true), $k));
				}
			}
			foreach($options['settings'] as $k => $foo){
				if(!array_key_exists($k, self::$defaults['settings'])){
					AppController::addWarningMsg(sprintf(__("unknown setting [%s] in structure build", true), $k));
				}
			}
			foreach($options['links'] as $k => $foo){
				if(!array_key_exists($k, self::$defaults['links'])){
					AppController::addWarningMsg(sprintf(__("unknown link [%s] in structure build", true), $k));
				}
			}
		}
		
		if(!is_array($options['extras'])){
			$options['extras'] = array('end' => $options['extras']);
		}
		
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
		if(isset($options['stack']['key'])){
			$tab_key = $options['stack']['key'];
			$model_prefix = $options['stack']['key'].'.';

			// use DATA passed in through OPTIONS from VIEW
			// OR use DATA juggled in STACKS in this class' BUILD TREE functions
			if(is_array($options['data'])){
				$data = &$options['data'][$options['stack']['key']];
			}else{
				// use THIS->DATA by default
				$data = &$this->data[$options['stack']['key']];
			}
		}else{
			if(is_array($options['data'])){
				$data = $options['data'];
			}
		}
		if($data == null){
			$data = array();
		}
		
		// run specific TYPE function to build structure (ordered by frequence for performance)
		$type = $options['type'];
		if(count($this->validationErrors) > 0 
		&& ($type == "add"
		|| $type == "edit"
		|| $type == "search"
		|| $type == "addgrid"
		|| $type == "editgrid")){
			//editable types, convert validation errors
			$this->my_validation_errors = array();
			foreach($this->validationErrors as $validation_error_arr){
				$this->my_validation_errors = array_merge($validation_error_arr, $this->my_validation_errors);	
			}
		}
		
		if($type == 'summary'){
			$this->buildSummary($atim_structure, $options, $data);
		
		}else if($type == 'index'
		||$type == 'addgrid'
		|| $type == 'editgrid'
		|| $type == 'datagrid'){
			if($type == 'datagrid'){
				$options['type'] = 'addgrid';
				if(Configure::read('debug') > 0){
					//TODO: remove datagrid for ATiM 2.3
					AppController::addWarningMsg(sprintf(__("datagrid is deprecated, use addgrid or editgrid instead", true), $type));
				}
			}	
			$this->buildTable( $atim_structure, $options, $data);

		}else if($type == 'detail'
		|| $type == 'add'
		|| $type == 'edit'
		|| $type == 'search'){
			$this->buildDetail( $atim_structure, $options, $data);
			
		}else if($type == 'tree'){
			$options['type'] = 'index';
			$this->buildTree( $atim_structure, $options, $data);
			
		}else if($type == 'csv'){
			$options['type'] = 'index';
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
				$exact_search = '<input type="checkbox" name="data[exact_search]"/>'.__("exact search", true);
			}else{								//other mode
				$link_class = "submit";
				$link_label = __("submit", null);
				$exact_search = "";
			}
			echo('
				<div class="submitBar">
					<div class="bottom_button">
						<input id="submit_button" class="submit" type="submit" value="Submit" style="display: none;"/>
						<a href="#n" onclick="$(\'#submit_button\').click();" class="form '.$link_class.'" tabindex="'.(StructuresHelper::$last_tabindex + 1).'">'.$link_label.'</a>
					</div>
					'.$exact_search.'
				</div>
			');
		}
		
		if($options['links']['top'] && $options['settings']['form_bottom']){
			echo('
				</form>
			');
		}
				
		if($options['settings']['actions']){
			echo($this->generateLinksList($this->data, $options['links'], 'bottom'));
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
		echo('
			<table class="structure" cellspacing="0">
			<tbody>
				<tr>
		');
		
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
						$suffixes = $options['type'] == "search" && in_array($table_row_part['type'], self::$range_types) ? array("_start", "_end") : array("");
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
									|| $table_row_part['type'] == 'foat_positive')
								){
									//input type, add the sufix to the name
									$table_row_part['format_back'] = $table_row_part['format'];
									$table_row_part['format'] = preg_replace('/name="data\[((.)*)\]"/', 'name="data[$1'.$suffix.']"', $table_row_part['format']);
								}
								$display[0] .= '<span><span class="nowrap">'.$this->getPrintableField($table_row_part, $table_row_part['model'].".".$table_row_part['field'].$suffix, $options, $current_value, null).'</span>';
								if(strlen($suffix) > 0 && ($table_row_part['type'] == 'input'
									|| $table_row_part['type'] == 'integer'
									|| $table_row_part['type'] == 'integer_positive'
									|| $table_row_part['type'] == 'float'
									|| $table_row_part['type'] == 'foat_positive')
								){
									$table_row_part['format'] = $table_row_part['format_back'];
								}
								if($options['type'] == "search" && !in_array($table_row_part['type'], self::$range_types)){
									$display[0] .= '<a class="adv_ctrl btn_add_or" href="#" onclick="return false;">(+)</a>';
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
					if(isset($data_unit[$table_row_part['model']]) && isset($data_unit[$table_row_part['model']][$table_row_part['field']])){
						echo $this->getPrintableField($table_row_part, $table_row_part['model'].".".$table_row_part['field'], $options, $data_unit[$table_row_part['model']][$table_row_part['field']], null), " ";
					}else if(Configure::read('debug') > 0){
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
	 * @param string $field_name
	 * @param array $options The structure settings
	 * @param string $current_value The value to use/lookup for the field
	 * @param int $key A numeric key used when there is multiple instances of the same field (like grids)
	 * @return string The built field
	 */
	private function getPrintableField(array $table_row_part, $field_name, array $options, $current_value, $key){
		$display = null;
		$field_name = $options['settings']['name_prefix'].$field_name;
		if(strlen($key)){
			$field_name = "%d.".$field_name;
		}
		if($options['links']['top'] && $options['settings']['form_inputs']){
			if($table_row_part['type'] == "date"){
				$display = self::getDateInputs($field_name, $current_value, $table_row_part['settings']);
			}else if($table_row_part['type'] == "datetime"){
				$date = $time = null;
				if(is_array($current_value)){
					$date = $current_value;
					$time = $current_value;
				}else if(strlen($current_value) > 0 && $current_value != "NULL"){
					list($date, $time) = explode(" ", $current_value);
				}
				$display = self::getDateInputs($field_name, $date, $table_row_part['settings']);
				$display .= self::getTimeInputs($field_name, $time, $table_row_part['settings']);
			}else if($table_row_part['type'] == "time"){
				$display = self::getTimeInputs($field_name, $current_value, $table_row_part['settings']);
			}else if($table_row_part['type'] == "select" 
			|| ($options['type'] == "search" && ($table_row_part['type'] == "radio" || $table_row_part['type'] == "checkbox"))){
				if(!array_key_exists($current_value, $table_row_part['settings']['options'])
				&& (count($table_row_part['settings']['options']) > 1 || !isset($table_row_part['settings']['disabled']) || $table_row_part['settings']['disabled'] != 'disabled')){
					//add the unmatched value if there is more than a value or if the dropdown is not disabled (otherwise we want the single value to be default)
					$table_row_part['settings']['options'] = array(
						__( 'unmatched value', true ) => array($current_value => $current_value),
						__( 'supported value', true ) => $table_row_part['settings']['options']
					);
				}
				$table_row_part['settings']['class'] = str_replace("%c ", isset($this->my_validation_errors[$table_row_part['field']]) ? "error " : "", $table_row_part['settings']['class']);
				$display = $this->Form->input($field_name, array_merge($table_row_part['settings'], array('type' => 'select', 'value' => $current_value)));
			}else if($table_row_part['type'] == "radio"){
				if(!array_key_exists($current_value, $table_row_part['settings']['options'])){
					$table_row_part['settings']['options'][$current_value] = "(".__( 'unmatched value', true ).") ".$current_value;
				}
				$display = $this->Form->input($field_name, array_merge($table_row_part['settings'], array('type' => $table_row_part['type'], 'value' => $current_value)));
			}else if($table_row_part['type'] == "checkbox"){
				$display = $this->Form->input($field_name, array_merge($table_row_part['settings'], array('type' => 'checkbox', 'value' => $current_value)));
			}else{
				$display = $table_row_part['format'];
			}
			
			
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
		}else if(strlen($current_value) > 0){
			if($table_row_part['type'] == "date"){
				list($year, $month, $day) = explode("-", $current_value);
				$display = AppController::getFormatedDateString($year, $month, $day);
			}else if($table_row_part['type'] == "datetime"){
				$display = AppController::getFormatedDatetimeString($current_value);
			}else if($table_row_part['type'] == "time"){
				list($hour, $minutes) = explode(":", $current_value);
				$display = AppController::getFormatedTimeString($hour, $minutes);
			}else if($table_row_part['type'] == "select" || $table_row_part['type'] == "radio" || $table_row_part['type'] == "checkbox"){
				if(isset($table_row_part['settings']['options'][$current_value])){
					$display = $table_row_part['settings']['options'][$current_value];
				}else{
					$display = $current_value;
					if(Configure::read('debug') > 0){
						AppController::addWarningMsg(sprintf(__("missing reference key [%s] for field [%s]", true), $current_value, $table_row_part['field']));
					}
				}
			}else{
				$display = $current_value;
			}
		}
		
		return (strlen($table_row_part['tag']) > 0 ? '<span class="tag">'.$table_row_part['tag'].'</span> ' : "")
			.(strlen($display) > 0 ? $display : "-")." ";
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
		
		$this->Paginator->options(array('url' => $this->params['pass']));
		$table_structure = $this->buildStack( $atim_structure, $options );
		
		$structure_count = 0;
		$structure_index = array(1 => $table_structure);
						
		echo('
			<table class="structure" cellspacing="0">
				<tbody>
					<tr>
		');
		
		foreach($structure_index as $table_key => $table_index){
			$structure_count++;
			if (is_array($table_index)){
				// start table...
				echo ('
					<td class="this_column_'.$structure_count.' total_columns_'.count($structure_index).'">
						<table class="columns index" cellspacing="0">
				');
				$remove_line_ctrl = ($options['type'] == 'addgrid' || $options['type'] == 'editgrid') && $options['settings']['del_fields'];
				$add_line_ctrl = ($options['type'] == 'addgrid' || $options['type'] == 'editgrid') && $options['settings']['add_fields'];
				$options['remove_line_ctrl'] = $remove_line_ctrl;
				$header_data = $this->buildDisplayHeader($table_index, $options);
				echo("<thead>".$header_data['header']."</thead>");
				
				if($options['type'] == "addgrid" && count($data) == 0){
					//display at least one line
					$data[0] = array();
				}
				
				if(count($data)){
					$data = array_merge(array(), $data);//make sure keys are starting from 0 and that none is being skipped
					echo("<tbody>");
					
					if($add_line_ctrl){
						//blank hidden line
						$data["%d"] = array();
					}
					$row_num = 1;
					$link_location = $this->generateLinksList(null, $options['links'], 'index');//raw links
					$default_settings_wo_class = self::$default_settings_arr;
					unset($default_settings_wo_class['class']);
					foreach($data as $key => $data_unit){
						if($add_line_ctrl && $row_num == count($data)){
							echo("<tr class='hidden'>");
						}else{
							echo("<tr>");
						}
						
						//checklist
						if (count($options['links']['checklist'])){
							echo('
								<td class="checkbox">
							');
							foreach($options['links']['checklist'] as $checkbox_name => $checkbox_value){
								$checkbox_value = $this->strReplaceLink($checkbox_value, $data_unit);
								echo($this->Form->checkbox($checkbox_name, array_merge($default_settings_wo_class, array('value' => $checkbox_value))));
							}
							echo('
								</td>
							');
						}
					
						//radiolist
						if(count($options['links']['radiolist'])){
							echo('
								<td class="radiobutton">
							');
							foreach($options['links']['radiolist'] as $radiobutton_name => $radiobutton_value){
								list($tmp_model, $tmp_field) = split("\.", $radiobutton_name);
								$radiobutton_value = $this->strReplaceLink($radiobutton_value, $data_unit);
								$tmp_attributes = array('legend'=>false, 'value'=>false);
								if(isset($data_unit[$tmp_model][$tmp_field]) && $data_unit[$tmp_model][$tmp_field] == $radiobutton_value){
									$tmp_attributes['checked'] = 'checked';
								}
								echo($this->Form->radio($radiobutton_name, array($radiobutton_value=>''), array_merge($default_settings_wo_class, $tmp_attributes)));
							}
							
							echo('
								</td>
							');
						}
		
						//index
						if(count($options['links']['index'])){
							echo('
								<td class="id">'.$this->strReplaceLink($link_location, $data_unit).'</td>
							');
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
									if(strlen($table_row_part['label'])){
										if($first_cell){
											echo("<td>");
										}else{
											echo("</td><td>");
										}
									}
									echo($this->getPrintableField($table_row_part, $table_row_part['model'].".".$table_row_part['field'], $options, $current_value, $key));
									
								}
							}
						}
						echo("</td>\n");
						
						//remove line ctrl
						if($remove_line_ctrl){
							echo('
									<td class="right">
										<a href="#" class="removeLineLink" title="'.__( 'click to remove these elements', true ).'">(-)</a>
									</td>
							');
						}
						
						
						echo("</td></tr>");
						$row_num ++;
					}
					echo("</tbody><tfoot>");
					if($options['settings']['pagination']){
						echo('
								<tr class="pagination">
									<th colspan="'.$header_data['count'].'">
										
										<span class="results">
											'.$this->Paginator->counter( array('format' => '%start%-%end% of %count%') ).'
										</span>
										
										<span class="links">
											'.$this->Paginator->prev( __( 'Prev',true ), NULL, __( 'Prev',true ) ).'
											'.$this->Paginator->numbers().'
											'.$this->Paginator->next( __( 'Next',true ), NULL, __( 'Next',true ) ).'
										</span>
										
										'.$this->Paginator->link( '5',  array('page' => 1, 'limit' => 5)).' |
										'.$this->Paginator->link( '10', array('page' => 1, 'limit' => 10)).' |
										'.$this->Paginator->link( '20', array('page' => 1, 'limit' => 20)).' |
										'.$this->Paginator->link( '50', array('page' => 1, 'limit' => 50)).'
										
									</th>
								</tr>
						');
					}
					
					if(count($options['links']['checklist'])){
						echo("<tr><td colspan='3'><a href='#' class='checkAll'>".__('check all', true)."</a> | <a href='#' class='uncheckAll'>".__('uncheck all', true)."</a></td></tr>");
					}
					
					if($add_line_ctrl){
						echo('<tr>
								<td class="right" colspan="'.$header_data['count'].'">
									<a class="addLineLink" href="#" title="'.__( 'click to add a line', true ).'">(+)</a>
									<input class="addLineCount" type="text" size="1" value="1" maxlength="2"/> line(s)
								</td>
							</tr>
						');
					}
					echo("</tfoot>");
				}else{
					echo('<tfoot>
							<tr>
									<td class="no_data_available" colspan="'.$header_data['count'].'">'.__( 'core_no_data_available', true ).'</td>
							</tr></tfoot>
					');
				}
				echo("</table></td>");
			}else{
				$this->printExtras($structure_count, count($structure_index), $table_index);
			}
		}
		echo("</tr></tbody></table>");
	}


	/**
	 * Builds a structure in a csv format
	 * @param unknown_type $atim_structure
	 * @param unknown_type $options
	 */
	private function buildCsv($atim_structure, $options, $data){
		$table_structure = $this->buildStack($atim_structure, $options);

		if(is_array($table_structure) && count($data)){
			//header line
			$line = array();
			foreach($table_structure as $table_column){
				foreach ( $table_column as $fm => $table_row){
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
							$line[] = $data_unit[$table_row_part['model']][$table_row_part['field']];
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
		echo('
			<table class="structure" cellspacing="0">
			<tbody>
				<tr>
		');
		
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
				
		echo('
				</tr>
			</tbody>
			</table>
		'); 
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
			
			echo('
				<li>
			');
				
			// collect LINKS and STACK to be added to LI, must do out of order, as need ID field to use as unique CSS ID in UL/A toggle
				
			$unique_id = self::$tree_node_id ++;
			// reveal sub ULs if sub ULs exist
			if(count($children)){
				echo('<a class="reveal {\'tree\' : \''.$unique_id.'\'}" href="#" onclick="return false;">+</a> ');
			} else {
				echo('<a class="reveal not_allowed" onclick="return false;">+</a> ');
			}
			
			echo('<div><span class="divider">|</span> ');	
			if(count($options['links']['tree'])){
				$i = 0;
				foreach($data_val as $model_name => $model_array){
					if(isset($options['links']['tree'][$model_name])){
						//apply prebuilt links
						echo($this->strReplaceLink($options['links']['tree'][$model_name], $data_val));
					}
				}
			}else if (count($options['links']['index'])){
				//apply prebuilt links
				echo($this->strReplaceLink($options['links']['tree'][$model_name], $data_val));
			}
		
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
			foreach($table_index as $table_column_key => $table_column){
				foreach($table_column as $table_row_key => $table_row){
					foreach($table_row as $table_row_part){
						//carefull with the white spaces as removing them the can break the display in IE
						echo('<span class="nowrap"><span class="divider">|</span> '
							.$this->getPrintableField(
								$table_row_part, 
								$table_row_part['model'].".".$table_row_part['field'],
								$options, 
								isset($data_val[$table_row_part['model']][$table_row_part['field']]) ? $data_val[$table_row_part['model']][$table_row_part['field']] : "", 
								null)
							.'</span>
						');
					}
				}
			}
				
			echo('</div>');
			
			// create sub-UL, calling this NODE function again, if model has any CHILDREN
			if(count($children)){
				echo('
					<ul id="tree_'.$unique_id.'" style="display:none;">
				');
				
				$this->buildTreeNode($atim_structures, $options, $children);
				echo('
					</ul>
				');
			}
			
			echo('
				</li>
			');
			
		}
	}


	/**
	 * Builds the display header
	 * @param array $table_index The structural inforamtion
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
			foreach ($table_structure as $table_column){
				foreach ($table_column as $table_row){
					foreach($table_row as $table_row_part){
						if ($table_row_part['type'] != 'hidden' && strlen($table_row_part['label']) > 0){

							// label and help/info marker, if available...
							$return_string .= '
								<th>
							';
							$sorting_link = $_SERVER['REQUEST_URI'];
							$sorting_link = explode('?', $sorting_link);
							$sorting_link = $sorting_link[0];
							
							$default_sorting_direction = isset($_REQUEST['direction']) ? $_REQUEST['direction'] : 'asc';
							$default_sorting_direction = strtolower($default_sorting_direction);
							
							$sorting_link .= '?sortBy='.$table_row_part['field'];
							$sorting_link .= '&amp;direction='.( $default_sorting_direction=='asc' ? 'desc' : 'asc' );
							$sorting_link .= isset($_REQUEST['page']) ? '&amp;page='.$_REQUEST['page'] : '';
							if($options['settings']['pagination']){
								if($table_row_part['model'].'.'.$table_row_part['field'] == $sort_on){
									$return_string .= '<div style="display: inline-block;" class="ui-icon ui-icon-triangle-1-'.($sort_asc ? "s" : "n").'"></div>';
								}
								$return_string .= $this->Paginator->sort(html_entity_decode($table_row_part['label'], ENT_QUOTES, "UTF-8"), $table_row_part['model'].'.'.$table_row_part['field']);
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
		$stack = array();//the stack array represents the display x => array(y => array(field data))
		$empty_help_bullet = '<span class="help error">&nbsp;</span>';
		$help_bullet = '<span class="help">&nbsp;<div>%s</div></span> ';
		$independent_types = array("select" => null, "radio" => null, "checkbox" => null, "date" => null, "datetime" => null, "time" => null);
		$my_default_settings_arr = self::$default_settings_arr;
		$my_default_settings_arr['value'] = "%s";
		self::$last_tabindex = max(self::$last_tabindex, $options['settings']['tabindex']);
		if(isset($atim_structure['Sfs'])){
			foreach($atim_structure['Sfs'] AS $sfs){
				if($sfs['flag_'.$options['type']] || $options['settings']['all_fields']){
					$current = array(
						"model" => $sfs['model'],
						"field" => $sfs['field'],
						"heading" => __($sfs['language_heading'], true),
						"label" => __($sfs['language_label'], true),
						"tag" => __($sfs['language_tag'], true),
						"type" => $sfs['type'],
						"help" => strlen($sfs['language_help']) > 0 ? sprintf($help_bullet, __($sfs['language_help'], true)) : $empty_help_bullet
					);
					$append_field_tool = "";
					$settings = $my_default_settings_arr;
					
					$date_format_arr = str_split(date_format);
					if($options['type'] == "add"
					|| $options['type'] == "edit"
					|| $options['type'] == "addgrid"
					|| $options['type'] == "editgrid"
					|| $options['type'] == "search"){
						
						$settings['tabindex'] = self::$last_tabindex ++;
						
						if($sfs["flag_".$options['type']."_readonly"]){
							$settings['disabled'] = "disabled";
						}
						
						//building all text fields (dropdowns, radios and checkboxes cannot be built here)
						$field_name = $options['settings']['name_prefix'].$sfs['model'].".".$sfs['field'];
						if($options['type'] == 'addgrid' || $options['type'] == 'editgrid'){
							$field_name = "%d.".$field_name;	
						}
						
						if(strlen($sfs['setting']) > 0){
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
								}else{
									$settings[$setting[0]] = $setting[1];
								}
							}
						}
						
						//validation CSS classes
						if(count($sfs['StructureValidation']) > 0 && $options['type'] != "search"){
							
							foreach($sfs['StructureValidation'] as $validation){
								if($validation['flag_not_empty'] || $validation['flag_required']){
									$settings["class"] .= " required";
									$settings["required"] = "required";
									break;
								}
							}
							if($settings["class"] == "%c "){
								$settings["class"] .= "validation";
							}
						}
						
						if($sfs['type'] == "input"){
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
						}else if($sfs['type'] == "display"){
							$current["format"] = "%s";
						}else{
							if(Configure::read('debug') > 0){
								AppController::addWarningMsg(sprintf(__("field type [%s] is unknown", true), $sfs['type']));
							}
							$current["format"] = $this->Form->input($field_name, array_merge(array("type" => "text"), $settings));
						}
						
						if(isset($settings['disabled']) && ($settings['disabled'] || $settings['disabled'] == "disabled") && in_array($sfs['type'], self::$hidden_on_disabled)){
							unset($settings['disabled']);
							$current["format"] .= $this->Form->text($field_name, array("type" => "hidden"), $settings);
							$settings['disabled'] = "disabled";
						}
						
						$current['default'] = $sfs['default'];
						$current['settings'] = $settings;
					}
					
					if(array_key_exists($sfs['type'], $independent_types)){
						$dropdown_result = array();
						if($sfs['type'] == "select"){
							$add_blank = true;
							if(count($sfs['StructureValidation']) > 0 && ($options['type'] == "edit" || $options['type'] == "editgrid")){
								//check if the field can be empty or not
								foreach($sfs['StructureValidation'] as $validation){
									if($validation['flag_not_empty']){
										$add_blank = false;
										break;
									}
								}
							}
							if($add_blank){
								$dropdown_result = array("" => "");
							}
						}
								
						if(count($sfs['StructureValueDomain']) > 0){
							if(strlen($sfs['StructureValueDomain']['source']) > 0){
								//load source
								$tmp_dropdown_result = StructuresComponent::getPulldownFromSource($sfs['StructureValueDomain']['source']);
								$is_old_version = false;
								foreach($tmp_dropdown_result as $k => $v){
									//foreach only used to fetch the first value
									if(is_array($v)){
										$is_old_version = true;
									}
									break;
								}

								if($is_old_version){
									//old version, convert
									//TODO: Remove this conversion in ATiM 2.3
									if(Configure::read('debug') > 0){
										AppController::addWarningMsg(sprintf(__("the source function of StructureValueDomain with id [%d] uses a deprecated return array", true), $sfs['StructureValueDomain']['id']));
									}
									$tmp = array();
									foreach($tmp_dropdown_result as $v){
										$tmp[$v['value']] = $v['default'];
									}
									$dropdown_result += $tmp;
								}else{
									$dropdown_result += $tmp_dropdown_result;
								}
							}else{
								$tmp_pulldown_result = $this->StructureValueDomain->find('first', array(
									'conditions' => 
										array('StructureValueDomain.id' => $sfs['StructureValueDomain']['id'])));
								if(count($tmp_pulldown_result['StructurePermissibleValue']) > 0){
									$tmp_result = array();
									$current_order = $tmp_pulldown_result['StructurePermissibleValue'][0]['Svdpv']['display_order'];
									$current_element = 1;
									foreach($tmp_pulldown_result['StructurePermissibleValue'] as $tmp_entry){
										if($tmp_entry['Svdpv']['display_order'] != $current_order){
											if(count($tmp_result) > 1){
												asort($tmp_result);
											}
											$dropdown_result += $tmp_result;//merging arrays and keeping numeric keys intact
											$tmp_result = array();
											$current_order = $tmp_entry['Svdpv']['display_order']; 
										}
										$tmp_result[$tmp_entry['value']] = __($tmp_entry['language_alias'], true);
										$current_element ++;
									}
		
									$dropdown_result += $tmp_result;//merging arrays and keeping numeric keys intact
								}
							}
						}else if($sfs['type'] == "checkbox"){
							//provide yes/no as default for checkboxes
							$dropdown_result = array(0 => __("no", true), 1 => __("yes", true));
						}
						
						if($options['type'] == "search" && ($sfs['type'] == "checkbox" || $sfs['type'] == "radio")){
							//checkbox and radio buttons in search mode are dropdowns 
							$dropdown_result = array_merge(array("" => ""), $dropdown_result);
						}
						
						if(count($dropdown_result) == 2 
						&& isset($sfs['flag_'.$options['type'].'_readonly']) 
						&& $sfs['flag_'.$options['type'].'_readonly'] 
						&& $add_blank){
							//unset the blank value, the single value for a disabled field should be default
							unset($dropdown_result[""]);
						}
						$current['settings']['options'] = $dropdown_result;
					}
					
					if(!isset($stack[$sfs['display_column']][$sfs['display_order']])){
						$stack[$sfs['display_column']][$sfs['display_order']] = array();
					}
					$stack[$sfs['display_column']][$sfs['display_order']][] = $current;
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
						AppController::addWarningMsg(sprintf(__("the override for [%s] couldn't be applied because the field was not foud", true), $key));
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
		$links = !is_array($links) ? array('detail' => $links) : $links;
		// parse through $LINKS array passed to function, make link for each 
		foreach($links as $link_name => $link_array){
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
				<div class="actionsOuter"><div class="actions">&nbsp;
			';
			
			// display SEARCH RESULTS, if any
			if(isset($_SESSION) && isset($_SESSION['Auth']) && isset($_SESSION['Auth']['User']) && count($_SESSION['Auth']['User'])){
				if ( isset($_SESSION['ctrapp_core']['search']) && is_array($_SESSION['ctrapp_core']['search']) ) {
					$return_string .= '
						<div class="leftCell">
							<div class="bottom_button"><a class="search_results" href="'.$this->Html->url($_SESSION['ctrapp_core']['search']['url']).'">
								'.$_SESSION['ctrapp_core']['search']['results'].'
							</a></div>
						</div>
					';
				}
			}else{
				unset($_SESSION['ctrapp_core']['search']);
			}
			
			if(count($return_links)){
				$return_string .= '
					<div class="rightCell">
						<div class="bottom_button">'.implode('</div><div class="bottom_button">',$return_links).'</div>
					</div>';
			}
			
			$return_string .= '
				</div></div>
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
			if($display_class_array[1] == 'menus' && $display_class_array[2] == 'tools'){
				$display_class_name = 'tools';
			}else if($display_class_array[1] == 'users' && $display_class_array[2] == 'logout'){
				$display_class_name = 'logout';
			}else if($display_class_array[1] == 'menus'){
				$display_class_name = 'home';
			}else if(array_key_exists($display_class_array[1], self::$display_class_mapping_plugin)){
				$display_class_name = $display_class_array[1];
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

	
	// FUNCTION to replace %%MODEL.FIELDNAME%% in link with MODEL.FIELDNAME value 
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
		}else if(strlen($date) > 0 && $date != "NULL"){
			list($year, $month, $day) = explode("-", $date);
		}
		$result = "";
		if(datetime_input_type == "dropdown"){
			foreach($pref_date as $part){
				if($part == "Y"){
					$result .= $this->Form->year($name, 1900, 2100, $year, $attributes);
				}else if($part == "M"){
					$result .= $this->Form->month($name, $month, $attributes);
				}else{
					$result .= $this->Form->day($name, $day, $attributes);
				}
			}
		}else{
			foreach($pref_date as $part){
				if($part == "Y"){
					$result .= '<span class="tooltip">'.$this->Form->text($name.".year", array_merge($attributes, array('value' => $year, 'size' => 4)))."<div>".__('year', true)."</div></span>";
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
						<img src="'.$this->Html->Url('/img/cal.gif').'" alt="cal" class="fake_datepicker"/>
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
			list($hour, $minutes, ) = explode(":", $time);
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
		if(is_array($data_unit)
		&& array_key_exists($table_row_part['model'], $data_unit) 
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
			}else{
				//priority 3, default
				$current_value = $table_row_part['default']; 
			}
		}else{
			if(Configure::read('debug') > 0){
				AppController::addWarningMsg(sprintf(__("no data for [%s.%s]", true), $table_row_part['model'], $table_row_part['field']));
			}
			$current_value = "-";
		}
		return $current_value;
	}
}
	
?>