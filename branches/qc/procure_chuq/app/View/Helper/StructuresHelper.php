<?php
class StructuresHelper extends Helper {
		
	var $helpers = array( 'Csv', 'Html', 'Form', 'Javascript', 'Ajax', 'Paginator','Session' );
	
	//an hidden field will be printed for the following field types if they are in readonly mode
	private static $hidden_on_disabled = array("input", "date", "datetime", "time", "integer", "interger_positive", "float", "float_positive", "tetarea", "autocomplete");
	
	private static $tree_node_id = 0;
	private static $last_tabindex = 1;
	
	private $my_validation_errors = null;
	
	private static $write_modes = array('add', 'edit', 'search', 'addgrid', 'editgrid', 'batchedit');
	
	//default options
	private static $defaults = array(
			'type'		=>	NULL, 
			
			'data'	=> false, // override $this->request->data values, will not work properly for EDIT forms
			
			'settings'	=> array(
				'return'			=> false, // FALSE echos structure, TRUE returns it as string
				
				// show/hide various structure elements, useful for STACKING multiple structures (for example, to make one BIG form out of multiple smaller forms)
				'actions'		=> true, 
				'header'		=> '',
				'language_heading' => null,
				'form_top'		=> true, //will print the opening form tag
				'tabindex'		=> 0, // when setting TAB indexes, add this value to the number, useful for stacked forms
				'form_inputs'	=> true, // if TRUE, use inputs when supposed to, if FALSE use static display values regardless
				'form_bottom'	=> true,
				'name_prefix'	=> NULL,
				'pagination'	=> true,
				'sorting'		=> false, //if pagination is false, sorting can still be turned on (if pagination is on, sorting is ignored). Consists of an array with sorting URL parameters
				'columns_names' => array(), // columns names - usefull for reports. only works in detail views
				'stretch'		=> true, //the structure will take full page width
				
				'all_fields'	=> false, // FALSE acts on structures datatable settings, TRUE ignores them and displays ALL FIELDS in a form regardless
				'add_fields'	=> false, // if TRUE, adds an "add another" link after form to allow another row to be appended
				'del_fields'	=> false, // if TRUE, add a "remove" link after each row, to allow it to be removed from the form
				
				'tree'			=> array(), // indicates MULTIPLE atim_structures passed to this class, and which ones to use for which MODEL in each tree ROW
				'data_miss_warn'=> true, //in debug mode, prints a warning if data is not found for a field
				
				'paste_disabled_fields' => array(),//pasting on those fields will be disabled
				
				'csv_header' => true, //in a csv file, if true, will print the header line
				
				'no_sanitization'	=> array(),//model => fields to avoid sanitizing
				
				'section_start'	=> false,
				'section_end'	=> false,
					
				'confirmation_msg'	=> null,
				
				'batchset'		=> null
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
		'tools'					=>	null,
		'pricing'				=>	null,
		'provider'				=>	null,
		'underdevelopment'		=>	null,
		'labbook'				=>  null
	);

	function __construct(View $View, $settings = array()) {
		parent::__construct($View, $settings);
		
		App::uses('StructureValueDomain', 'Model');
		$this->StructureValueDomain = new StructureValueDomain();
	}

	function hook($hook_extension=''){
		if($hook_extension){
			$hook_extension = '_'.$hook_extension;
		}
		
		$hook_file = APP . ($this->params['plugin'] ? 'Plugin' . DS . $this->params['plugin'] . DS : '') . 'View' . DS . $this->params['controller'] . DS . 'Hook' . DS . $this->params['action'].$hook_extension.'.php';
		if(!file_exists($hook_file)){
			$hook_file=false;
		}
		
		return $hook_file;
	}
	
	private function updateDataWithAccuracy(array &$data, array &$structure){
		if(!empty($structure['Accuracy']) && !empty($data)){
			$single_node = false;
			$goto_end = false;
			foreach($data as $data_l1){
				foreach($data_l1 as $data_l2){
					if(!is_array($data_l2)){
						$single_node = true;
						$data = array($data);
					}
					$goto_end = true;
					break;
				}
				if($goto_end){
					break;
				}
			}
			
			//Fix for issue #2622 : Date accuracy won't be considered for display of Databrowser Nodes merge 
			//Note: Don't have to add a fix too for csv export on 'same line' because we work on db date format for csv export
			$model_synonyms = array();
			foreach($structure['Sfs'] as $new_field) {				
				if(preg_match('/^([0-9]+\-)(.+)$/', $new_field['model'], $matches)) {
					$main_model = $matches[2];
					$model_synonymous = $matches[0];
					if(!isset($structure['Accuracy'][$model_synonymous]) && isset($structure['Accuracy'][$main_model])) $structure['Accuracy'][$model_synonymous] = $structure['Accuracy'][$main_model];
				}
			}
			
			foreach($data as &$data_line){
				foreach($structure['Accuracy'] as $model => $fields){
					foreach($fields as $date_field => $accuracy_field){
						if(is_array($accuracy_field)) {
							// Fixe issue #2517: Duplicated date field in same structure: accuracy issue
							$accuracy_field = array_shift($accuracy_field);
						}					
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
	
	private function updateUnsanitizeList(&$options, $atim_structure){
    	if(isset($atim_structure['Sfs'])){
    	    //no sanitization on select
    	    $flag = 'flag_'.$options['type'];
    	    foreach($atim_structure['Sfs'] as $sfs){
    	        if($sfs[$flag] && $sfs['type'] == 'select'){
    	            $options['settings']['no_sanitization'][$sfs['model']][] = $sfs['field'];
    	        }
    	    }
    	}else if($options['type'] == "tree"){
    	    foreach($atim_structure as $structure){
    	        //no sanitization on select
    	        foreach($structure['Sfs'] as $sfs){
    	            if($sfs['flag_index'] && $sfs['type'] == 'select'){
    	                $options['settings']['no_sanitization'][$sfs['model']][] = $sfs['field'];
    	            }
    	        }
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
		if(Configure::read('debug')){
			$tmp = array();
			if(isset($atim_structure['Structure'][0])){
				foreach($atim_structure['Structure'] as $struct){
					if(isset($struct['alias'])){
						$tmp[] = $struct['alias'];
					}
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
		
		$data = $this->request->data;
		if(is_array($options['data'])){
			$data = $options['data'];
		}
		if($data == null){
			$data = array();
		}
		
		$args = AppController::getInstance()->passedArgs;
		if(isset($args['noHeader'])){
			$options['settings']['header'] = '';
		}
		if(isset($args['noActions'])){
			$options['settings']['actions'] = false;
		}
		if(isset($args['type'])){
			if($args['type'] == 'index' && $options['type'] == 'detail'){
				$options['type'] = 'index';
				$options['settings']['pagination'] = false;
				$data = array($data);
			}
		}
		if(isset($args['forSelection'])){
			$options['links']['index'] = array('detail' => $options['links']['index']['detail']); 
		}
		
		//print warning when unknown stuff and debug is on
		if(Configure::read('debug') > 0){
			if(is_array($options)){
				foreach($options as $k => $foo){
					if(!array_key_exists($k, self::$defaults)){
						AppController::addWarningMsg(__("unknown function [%s] in structure build", $k));
					}
				}
				
				if(is_array($options['settings'])){
					foreach($options['settings'] as $k => $foo){
						if(!array_key_exists($k, self::$defaults['settings'])){
							AppController::addWarningMsg(__("unknown setting [%s] in structure build", $k));
						}
					}
				}else{
					AppController::addWarningMsg(__("settings should be an array", true));
				}
				
				if(is_array($options['links'])){
					foreach($options['links'] as $k => $foo){
						if(!array_key_exists($k, self::$defaults['links'])){
							AppController::addWarningMsg(__("unknown link [%s] in structure build", $k));
						}
					}
				}else{
					AppController::addWarningMsg(__("links should be an array", true));
				}
			}else{
				AppController::addWarningMsg(__("settings must be an array", true));
			}
		}
		
		if(!is_array($options['extras'])){
			$options['extras'] = array('end' => $options['extras']);
		}
		
		if(isset($atim_structure['Structure'])){
			reset($atim_structure['Structure']);
			if(is_array(current($atim_structure['Structure']))){
				//iterate over sub structures
				foreach($atim_structure['Structure'] as $sub_structure){
					if(isset($sub_structure['CodingIcdCheck']) && $sub_structure['CodingIcdCheck']){
						$options['CodingIcdCheck'] = true;
						break;
					}
				}
				if(!isset($options['CodingIcdCheck'])){
					$options['CodingIcdCheck'] = false;
				}
			}else{
				$options['CodingIcdCheck'] = isset($atim_structure['Structure']['CodingIcdCheck']) && $atim_structure['Structure']['CodingIcdCheck'];
			}
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
					<form action="'.$this->generateLinksList($this->request->data, $options['links'], 'top').'" method="post" enctype="multipart/form-data">
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

			echo '<div class="descriptive_heading">
					<h4>',$options['settings']['header']['title'],($options['settings']['section_start'] ? "<a class='icon16 delete noPrompt sectionCtrl' href='#'></a>" : ""),'</h4>
					<p>',$options['settings']['header']['description'],'</p>
				</div>
			';
		}
		
		if($options['settings']['section_start']){
			echo '<div class="section">';
		}	
			
		if($options['settings']['language_heading']){
			echo '<div class="heading_mimic"><h4>'.$options['settings']['language_heading'].'</h4></div>';
		}
		
		if(isset($options['extras']['start'])){
			echo('
				<div class="extra">'.$options['extras']['start'].'</div>
			');
		}

		if($options['type'] != 'csv') {
	        $this->updateUnsanitizeList($options, $atim_structure);
			$sanitized_data = Sanitize::clean($data);
			if($options['settings']['no_sanitization']){
				$this->unsanitize($sanitized_data, $data, $options['settings']['no_sanitization']);
			}
			$data = $sanitized_data;
			unset($sanitized_data);
		}
		
		$this->updateDataWithAccuracy($data, $atim_structure);//will not update tree view data
		
		// run specific TYPE function to build structure (ordered by frequence for performance)
		$type = $options['type'];
		if(in_array($type, self::$write_modes)){
			//editable types, convert validation errors
			$this->my_validation_errors = array();
			foreach($this->Form->validationErrors as $validation_error_arr){
				$this->my_validation_errors = array_merge($validation_error_arr, $this->my_validation_errors);	
			}
		}
		
		if($type == 'summary'){
			$this->buildSummary($atim_structure, $options, $data);
		
		}else if(in_array($type, array('index', 'addgrid', 'editgrid'))){
			if($type == 'addgrid' || $type == 'editgrid'){
				$options['settings']['pagination'] = false;
			}
			$this->buildTable( $atim_structure, $options, $data);

		}else if(in_array($type, array('detail', 'add', 'edit', 'search', 'batchedit'))){
			$this->buildDetail( $atim_structure, $options, $data);
			
		}else if($type == 'tree'){
			$options['type'] = 'index';
			$this->buildTree( $atim_structure, $options, $data);
			
		}else if($type == 'csv'){
			$this->buildCsv( $atim_structure, $options, $data);
			$options['settings']['actions'] = false;
		}else{
			if(Configure::read('debug') > 0){
				AppController::addWarningMsg(__("warning: unknown build type [%s]", $type)); 
			}
			//build detail anyway
			$options['type'] = 'detail';
			$this->buildDetail($atim_structure, $options, $data);
		}
		
		if(isset($options['extras']['end'])){
			echo'
				<div class="extra">'.$options['extras']['end'].'</div>
			';
		}
		
		if($options['settings']['section_end']){
			echo '</div>';
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
			$link_params = array('tabindex' => StructuresHelper::$last_tabindex + 1, 'escape' => false, 'class' => 'submit');
			$confirmation_msg = '';
			if($options['settings']['confirmation_msg']){
				$link_params['data-confirmation-msg'] = 1;
				$confirmation_msg = '<span class="confirmationMsg hidden">'.$options['settings']['confirmation_msg'].'</span>';
			}
			echo('
				<div class="submitBar">
					<div class="flyOverSubmit">
						'.$exact_search.'
						<div class="bottom_button">
							<input class="submit" type="submit" value="Submit" style="display: none;"/>'
							.$confirmation_msg
							.$this->Html->link('<span class="icon16 '.$link_class.'"></span>'.$link_label, "", $link_params)
						.'</div>
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
			echo $this->generateLinksList($this->request->data, $options['links'], 'bottom');
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
					echo '<td></td><td class="label">', implode('</td><td class="label">', $options['settings']['columns_names']), '</td></tr><tr>';
				}
				// each row in column 
				$table_row_count = 0;
				$new_line = true;
				$end_of_line = "";
				$display = "";
				$help = null;//keeps the help if hidden fields are in the way
				foreach($table_column as $table_row){
					foreach($table_row as $table_row_part){
						if(trim($table_row_part['heading'])){
							if(!$new_line){
								echo '<td class="content">'.implode('</td><td class="content">', $display)."</td>".$end_of_line."</tr><tr>";
								$display = array();
								$end_of_line = "";
							}
							echo'<td class="heading no_border" colspan="'.( show_help ? '3' : '2' ).'">
										<h4>'.$table_row_part['heading'].'</h4>
									</td>
								</tr><tr>
							';
							$new_line = true;
						}
						
						if($table_row_part['label']){
							if(!$new_line){
								echo '<td class="content">'.implode('</td><td class="content">', $display)."</td>".$end_of_line."</tr><tr>";
								$display = array();
								$end_of_line = "";
							}
							$help = null;
							$margin = '';
							if($table_row_part['margin'] > 0){
								$margin = 'style="padding-left: '.($table_row_part['margin'] * 10 + 10).'px"';
							}
							echo '<td class="label" '.$margin.'>
										'.$table_row_part['label'].'
								</td>
							';
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
								if($options['type'] == "search" && !in_array($table_row_part['type'], StructuresComponent::$range_types) && !isset($table_row_part['settings']['noCtrl'])){
									$display[0] .= '<a class="adv_ctrl btn_add_or icon16 add_mini" href="#" onclick="return false;"></a>';
								}
								$display[0] .= '</span>';
							}
							
							if($table_row_part['type'] == 'hidden'){
								$table_row_part['help'] = $help;
							}else{
								$help = $table_row_part['help'];
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
				echo '<td class="content">'.implode('</td><td class="content">', $display).'</td>'.$end_of_line.'</tr>
						</tbody>
						</table>
						
					</td>
				';
				
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
						$value = $data_unit[$table_row_part['model']][$table_row_part['field']];
						if($table_row_part['type'] == 'textarea'){
							$value = str_replace('\n', '<br/>', $value);
						}
						echo $this->getPrintableField($table_row_part, $options, $value, null, null), " ";
					}else if(Configure::read('debug') > 0 && $options['settings']['data_miss_warn']){
						AppController::addWarningMsg(__("no data for [%s.%s]", $table_row_part['model'], $table_row_part['field']));
					}
				}
			}
			if(!$first_line){
				echo "</dd>";
			}
		}
		echo("</dl>");
	}

        private function get_open_file_link($current_value) {
            return '<a href="?file='.$current_value.'">'.__("open file").'</a>';
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
		if($table_row_part['flag_confidential'] && !$this->Session->read('flag_show_confidential')){
				$display = CONFIDENTIAL_MARKER;
				if($options['links']['top'] && $options['settings']['form_inputs'] && $options['type'] != "search"){
					AppController::getInstance()->redirect("/Pages/err_confidential");
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
				
				if($options['type'] != "search" && isset(AppModel::$accuracy_config[$table_row_part['tablename']][$table_row_part['field']])){
					$display = "<div class='accuracy_target_blue'></div>";
				}
				
				$display .= self::getDateInputs($field_name, $date, $table_row_part['settings']);
				unset($table_row_part['settings']['required']);
				$display .= self::getTimeInputs($field_name, $time, $table_row_part['settings']);
			}else if($table_row_part['type'] == "time"){
				$display = self::getTimeInputs($field_name, $current_value, $table_row_part['settings']);
			}else if($table_row_part['type'] == "select" ||
				(($options['type'] == "search" || $options['type'] == "batchedit") && 
					($table_row_part['type'] == "radio" || $table_row_part['type'] == "checkbox" || $table_row_part['type'] == "yes_no" || $table_row_part['type'] == "y_n_u")
				)
			){
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
						if(empty($table_row_part['settings']['options']['previously_defined'])){
							$defined = $table_row_part['settings']['options']['defined'];
							unset($table_row_part['settings']['options']['defined']);
							unset($table_row_part['settings']['options']['previously_defined']);
							$table_row_part['settings']['options'] = array_merge($table_row_part['settings']['options'], $defined);
						}
						
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
				unset($table_row_part['settings']['options']);
				$display = $this->Form->input($field_name, array_merge($table_row_part['settings'], array('type' => 'checkbox', 'value' => 1, 'checked' => $current_value ? true : false)));
			}else if($table_row_part['type'] == "yes_no" || $table_row_part['type'] == "y_n_u"){
				unset($table_row_part['settings']['options']);
				$display =
					$this->Form->input($field_name, array_merge($table_row_part['settings'], array('type' => 'hidden', 'value' => "")))
					.__('yes', true).$this->Form->input($field_name, array_merge($table_row_part['settings'], array('type' => 'checkbox', 'value' => "y", 'hiddenField' => false, 'checked' => $current_value == "y" ? true : false)))
					.__('no', true). $this->Form->input($field_name, array_merge($table_row_part['settings'], array('type' => 'checkbox', 'value' => "n", 'hiddenField' => false, 'checked' => $current_value == "n" ? true : false)));
				if($table_row_part['type'] == "y_n_u"){
					$display .= __('unknown', true). $this->Form->input($field_name, array_merge($table_row_part['settings'], array('type' => 'checkbox', 'value' => "u", 'hiddenField' => false, 'checked' => $current_value == "u" ? true : false))); 
				}
			}else if(($table_row_part['type'] == "float" || $table_row_part['type'] == "float_positive") && decimal_separator == ','){
				$current_value = str_replace('.', ',', $current_value);
			} else if($table_row_part['type'] == "textarea") {
				$current_value = str_replace('\n', "\n", $current_value);	
                        }else if($table_row_part['type'] == 'file'){
                            if ($current_value) {
                                $display = $this->get_open_file_link($current_value);
                                $display .= '<input type="radio" class="fileOption" name="data['.$field_name.'][option]" value="" checked="checked"><span>'._('keep').'</span>';
                                $display .= '<input type="radio" class="fileOption" name="data['.$field_name.'][option]" value="delete"><span>'._('delete').'</span>';
                                $display .= '<input type="radio" class="fileOption" name="data['.$field_name.'][option]" value="replace"><span>'._('replace').'</span>';
                                $display .= ' ';
                            }
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
			}else if(in_array($table_row_part['type'], array("select", "radio", "checkbox", "yes_no", "y_n_u"))){
				if(isset($table_row_part['settings']['options']['defined'][$current_value])){
					$display = $table_row_part['settings']['options']['defined'][$current_value];
				}else if(isset($table_row_part['settings']['options']['previously_defined'][$current_value])){
					$display = $table_row_part['settings']['options']['previously_defined'][$current_value];
				}else{
					$display = $current_value;
					if(Configure::read('debug') > 0 && ($current_value != "-" || $options['settings']['data_miss_warn'])){
						AppController::addWarningMsg(__("missing reference key [%s] for field [%s]", $current_value, $table_row_part['field']));
					}
				}
			}else if(($table_row_part['type'] == "float" || $table_row_part['type'] == "float_positive") && decimal_separator == ','){
				$display = str_replace('.', ',', $current_value);
			}else if($table_row_part['type'] == 'textarea'){
				$current_value = htmlspecialchars($current_value);
				$current_value = str_replace('\\\\', '&dbs;', $current_value);
				$current_value = str_replace('\n', in_array($options['type'], self::$write_modes) ? "\n" : '<br/>', $current_value);
				$current_value = str_replace('&dbs;', '\\', $current_value);
				$display = html_entity_decode($current_value);
			}else if($table_row_part['type'] == 'file'){
                            $display = $this->get_open_file_link($current_value);
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
				$tag = $table_row_part['tag'] == '-' ? '' : $table_row_part['tag'].' ';
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
		$class = 'structure '.$options['type'];
		if($options['type'] == 'index'){
			$class .= ' lineHighlight';
		} 
		echo '
			<table class="'.$class.'" cellspacing="0"'.$stretch.'>
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
				echo '<thead>',$header_data['header'],'</thead>';
				
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
								<td class="checkbox">',$this->getChecklist($options['links']['checklist'], $data_unit),'</td>
							';
						}
					
						//radiolist
						if(count($options['links']['radiolist'])){
							echo '
								<td class="radiobutton">',$this->getRadiolist($options['links']['radiolist'], $data_unit),'</td>
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
							$current_links = array('index' => $current_links);
							if(isset($options['links']['ajax']['index'])){
								$current_links['ajax']['index'] = $options['links']['ajax']['index'];
							}
							echo '
								<td class="id">',$this->generateLinksList(null, $current_links, 'index'),'</td>
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
										<a href="#" class="removeLineLink icon16 delete_mini" title="',__( 'click to remove these elements', true ),'"></a>
									</td>
							';
						}
						
						
						echo "</td></tr>";
						$row_num ++;
					}
					echo "</tbody><tfoot>";
					if($options['settings']['pagination']){
						echo '<pre>';
						echo '</pre>';
						echo '
								<tr class="pagination">
									<th colspan="',$header_data['count'],'">
										
										<span class="results">
											',$this->Paginator->counter( array('format' => '%start%-%end%'.__(' of ').'%count%') ),'
										</span>
										
										<span class="links">
											',$this->Paginator->prev( __( 'prev',true ), NULL, __( 'prev',true ) ),'
											',$this->Paginator->numbers(),'
											',$this->Paginator->next( __( 'next',true ), NULL, __( 'next',true ) ),'
										</span>';
										$limits = array(5, 10, 20, 50);
										$current_limit = $this->Paginator->params['paging'];
										$current_limit = current($current_limit);
										$current_limit = $current_limit['limit']; 
										while($limit = array_shift($limits)){
											echo ($current_limit == $limit ? '<span class="current">' : ''), 
												$this->Paginator->link( $limit,  array('page' => 1, 'limit' => $limit)), 
												($current_limit == $limit ? '</span>' : ''),
												(count($limits) ? ' | ' : '');
										}
						echo '			</th>
								</tr>
						';
					}
					
					if(count($options['links']['checklist'])){
						echo "<tr><td colspan='3'><a href='#' class='checkAll'>",__('check all', true),"</a> | <a href='#' class='uncheckAll'>",__('uncheck all', true),"</a></td></tr>";
					}
					
					if($add_line_ctrl){
						echo '<tr>
								<td class="right" colspan="',$header_data['count'],'">
									<a class="addLineLink icon16 add_mini" href="#" title="',__( 'click to add a line', true ),'"></a>
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
		$csv = $this->Csv;
		if(isset(AppController::getInstance()->csv_config)){
			$this->Csv->csv_separator = AppController::getInstance()->csv_config['define_csv_separator']; 
		}
		
		if(isset($csv::$nodes_info)){
			//same line mode
			$this->Csv->current = array();
			$tmp_CodingIcdCheck = false;	//$options['CodingIcdCheck'] has not been set by previous functions
			if($options['settings']['csv_header']){
				//first call, build all structures
				$options['type'] = 'index';
				$node_name_line = array();
				$heading_line = array();
				$display_heading = false;
				$lines = array();			
				foreach($csv::$nodes_info as $node_id => $node_info){
					$heading_sub_line = array();
					$sub_line = array();
					$csv::$structures[$node_id] = $structure = $this->buildStack($csv::$structures[$node_id], $options);
					$csv::$structures[$node_id] = $this->titleHtmlSpecialCharsDecode($csv::$structures[$node_id], isset(AppController::getInstance()->csv_config) ? AppController::getInstance()->csv_config['define_csv_encoding'] : csv_encoding);
					foreach($csv::$structures[$node_id] as $table_column){
						$last_heading = '';
						foreach($table_column as $fm => $table_row){
							foreach($table_row as $table_row_part){							
								if(strlen($table_row_part['heading'])) {
									$display_heading = true;
									$last_heading = $table_row_part['heading'];
								}						
								$heading_sub_line[] = $last_heading;
								$sub_line[] = $table_row_part['label'];
								if(in_array($table_row_part['type'], array('date', 'datetime'))) {
									$sub_line[] = __('accuracy');
									$heading_sub_line[] = $last_heading;
								}
								if(!isset($options['CodingIcdCheck'])){
									foreach(AppModel::getMagicCodingIcdTriggerArray() as $key => $trigger){
										if(strpos($table_row_part['setting'], $trigger) !== false){
											$tmp_CodingIcdCheck = true;
										}
									}
								}								
							}
						}
						
					}
					$csv::$nodes_info[$node_id]['cols_count'] = count($sub_line);
					for($i = 1; $i <= $node_info['max_length']; ++ $i){
						foreach($sub_line as $sub_line_key => $sub_line_part){
							$node_name_line[] = $node_info['display_name']." $i";
							$heading_line[] = $heading_sub_line[$sub_line_key];
							$line[] = $sub_line_part;
						}
					}
				}
				$options['type'] = 'csv';//go back to csv	
				$this->Csv->addRow($node_name_line);
				if($display_heading) $this->Csv->addRow($heading_line);
				$this->Csv->addRow($line);
			}
			
			$lines = array();
			//data = array(node => pkey => data rows => data line

			if(!isset($options['CodingIcdCheck'])){
				$options['CodingIcdCheck'] = $tmp_CodingIcdCheck;
			}
			
			foreach($csv::$nodes_info as $node_id => $node_info){
				//fill the node section of the lines array. the index is the pkey of the line
				foreach($data[$node_id] as $pkey => $data_row){
					if(!isset($lines[$pkey])){
						$lines[$pkey] = array();
					}
					$instances = 0;
					foreach($data_row as $model_data){
						//node_data is all data of a node linked to a pkey
						foreach($csv::$structures[$node_id] as $table_column){
							foreach($table_column as $table_row){
								foreach($table_row as $table_row_part){
									if(isset($model_data[$table_row_part['model']][$table_row_part['field']])){
										if(in_array($table_row_part['type'], array('date', 'datetime'))) {
											$lines[$pkey] = array_merge($lines[$pkey], $this->getDateValuesFormattedForExcel($model_data[$table_row_part['model']], $table_row_part['field'], $table_row_part['type']));
										} else {
											$current_value = self::getCurrentValue($model_data, $table_row_part, "", $options);	
											$lines[$pkey][] = trim($this->getPrintableField($table_row_part, $options, $current_value, null, null));
										}	
									}else{
										$lines[$pkey][] = '';
										if(in_array($table_row_part['type'], array('date', 'datetime'))) $lines[$pkey][] = "";
									}
								}
							}
						}
						++ $instances;
					}
					if($instances < $csv::$nodes_info[$node_id]['max_length']){
						//padding
						$lines[$pkey] = array_merge($lines[$pkey], array_fill(0, $csv::$nodes_info[$node_id]['cols_count'], ""));
					}
				}
			}

			foreach($lines as &$line){
				$this->Csv->addRow($line);
			}
			echo $this->Csv->render($options['settings']['csv_header'], isset(AppController::getInstance()->csv_config) ? AppController::getInstance()->csv_config['define_csv_encoding'] : csv_encoding);
		}else{
			//default mode, multi lines
			$options['type'] = 'index';
			$table_structure = $this->buildStack($atim_structure, $options);
			$table_structure = $this->titleHtmlSpecialCharsDecode($table_structure, isset(AppController::getInstance()->csv_config) ? AppController::getInstance()->csv_config['define_csv_encoding'] : csv_encoding);
			$options['type'] = 'csv';//go back to csv
			
			if(is_array($table_structure) && count($data)){
				//header line
				if($options['settings']['csv_header']){					
					$node_name_line = array();
					$language_node_list = array();
					$heading_line = array();
					$display_heading = false;
					$line = array();
					if(empty($options['settings']['columns_names'])){
						foreach($table_structure as $table_column){
							$last_heading = '';
							foreach($table_column as $fm => $table_row){
								foreach($table_row as $table_row_part){	
									$structure_group_name = isset($table_row_part['structure_group_name'])? $table_row_part['structure_group_name'] : '';
									$node_name_line[] = $structure_group_name;
									$language_node_list[$structure_group_name] = '-1';
									if(strlen($table_row_part['heading'])) {
										$last_heading = $table_row_part['heading'];
										$display_heading = true;
									}
									$heading_line[] = $last_heading;
									$line[] = $table_row_part['label'];							
									if(in_array($table_row_part['type'], array('date', 'datetime'))) {
										$node_name_line[] = $structure_group_name;
										$heading_line[] = $last_heading;
										$line[] = __('accuracy');
									}
								}
							}
						}
					}else{
						// Multi-Lines and Multi Column Report Display: Date format for excel not supported
						// No heading to manage
						$line = array_merge(array(''), $options['settings']['columns_names']);
					}
					if(!empty($node_name_line) && sizeof($language_node_list) > 1) $this->Csv->addRow($node_name_line);
					if($display_heading) $this->Csv->addRow($heading_line);
					$this->Csv->addRow($line);
				}
				
				//content
				if(empty($options['settings']['columns_names'])){
					foreach($data as $data_unit){
						$line = array();
						foreach($table_structure as $table_column){
							foreach ( $table_column as $fm => $table_row){
								foreach($table_row as $table_row_part){
									if(isset($data_unit[$table_row_part['model']][$table_row_part['field']])){
										if(in_array($table_row_part['type'], array('date', 'datetime'))) {
											$line = array_merge($line, $this->getDateValuesFormattedForExcel($data_unit[$table_row_part['model']], $table_row_part['field'], $table_row_part['type']));
										} else {	
											$current_value = self::getCurrentValue($data_unit, $table_row_part, "", $options);										
											$line[] = trim($this->getPrintableField($table_row_part, $options, $current_value, null, null));
										}
									}else{
										$line[] = "";
										if(in_array($table_row_part['type'], array('date', 'datetime'))) $line[] = "";
									}
								}
							}
						}
						$this->Csv->addRow($line);
					}
				}else{
					// Multi-Lines and Multi Column Report Display: Date format for excel not supported + no ICD description generated
					foreach($table_structure as $table_column){
						foreach($table_column as $fm => $table_row){
							foreach($table_row as $table_row_part){
								$line = array($table_row_part['label']);
								$current_data = $data[0][0][$table_row_part['field']];
								foreach($options['settings']['columns_names'] as $column_name){
									if(array_key_exists($column_name, $current_data)){
										$line[] = trim($this->getPrintableField($table_row_part, $options, $current_data[$column_name], null, null));
									}else{
										$line[] = '';
									}
								}
								$this->Csv->addRow($line);
							}
						}
					}
				}
			}
			
			echo $this->Csv->render($options['settings']['csv_header'], isset(AppController::getInstance()->csv_config) ? AppController::getInstance()->csv_config['define_csv_encoding'] : csv_encoding);
		}
	}
	
	/**
	 * Convert all HTML entities to their applicable characters for all headings, labels and tags of the structure
	 * @param array $table_structure Structure to work on
	 * @param string $encoding Enconding
	 * @return array $table_structure Processed structrue
	 */
	function titleHtmlSpecialCharsDecode($table_structure, $encoding) {
		foreach($table_structure as &$table_column){
			foreach($table_column as &$table_row){
				foreach($table_row as &$table_row_part){
					$table_row_part['heading'] = html_entity_decode($table_row_part['heading'], ENT_NOQUOTES, $encoding);
					$table_row_part['label'] = html_entity_decode($table_row_part['label'], ENT_NOQUOTES, $encoding);
					$table_row_part['tag'] = html_entity_decode($table_row_part['tag'], ENT_NOQUOTES, $encoding);
				}
			}
		}
		return $table_structure;
	}
	
	/**
	 * Rebuild date that has been formated by function updateDataWithAccuracy() to be formated for CSV export
	 * @param array $model_data
	 * @param array $field
	 * @param array $field_type date or datetime
	 */
	function getDateValuesFormattedForExcel($model_data, $field, $field_type) {	
		$reformatted_date = array();
		if(isset($model_data[$field])) {
			if(!empty($model_data[$field])) {	
				$accuracy =  isset($model_data[$field.'_accuracy'])? $model_data[$field.'_accuracy'] : 'c';
				$reformatted_date  = $model_data[$field];
				if(($field_type == 'date' && !preg_match('/^[0-9]{4}\-[0-9]{2}\-[0-9]{2}$/', $reformatted_date)) || ($field_type == 'datetime' && !preg_match('/^[0-9]{4}\-[0-9]{2}\-[0-9]{2}\ [0-9]{2}\:[0-9]{2}(\:[0-9][0-9]){0,1}$/', $reformatted_date))) {				
					//Add regular expression on date to be sure date has been first formated by updateDataWithAccuracy() (not done when exproting data on same line from databrowser)
					switch($accuracy) {
						case 'y':
							$reformatted_date = str_replace('±','',  $reformatted_date);
						case 'm':
							 $reformatted_date = str_replace('%s',  $reformatted_date, '%s-01-01'.($field_type == 'date'? '' : ' 00:00'));
							break;
						case 'd':
							 $reformatted_date = str_replace('%s',  $reformatted_date, '%s-01'.($field_type == 'date'? '' : ' 00:00'));
							break;
						case 'h':
							 $reformatted_date = str_replace('%s',  $reformatted_date, '%s 00:00');
							break;
						case 'i':
							$reformatted_date = str_replace('%s',  $reformatted_date, '%s:00');
							break;
						default:
					}
				}
				$date_values[] = $reformatted_date;
				$date_values[] = __('date_accuracy_value_'.$accuracy);
			} else {
				$date_values =  array('-','-');
			}
		} 
		return $date_values;
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
				$tmp = $options['links']['tree'][$model_name];
				unset($options['links']['tree'][$model_name]);
				$options['links']['tree'][$model_name]['index'] = $tmp;
				unset($tmp);
				foreach(array('radiolist', 'checklist') as $type){
					if(isset($options['links']['tree'][$model_name]['index'][$type])){
						$options['links']['tree'][$model_name][$type] = $options['links']['tree'][$model_name]['index'][$type]; 
						unset($options['links']['tree'][$model_name]['index'][$type]);
					}	
				}
				
				//index links
				$tree_links = $options['links'];
				$tree_links['index'] = $options['links']['tree'][$model_name]['index'];
				$options['links']['tree'][$model_name]['index'] = $this->generateLinksList(null, $tree_links, 'index');
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
							<ul class="tree_root">
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
		$accuracy_updated = array();
		foreach($data as $data_key => &$data_val){
			// unset CHILDREN from data, to not confuse STACK function
			$children = array();
			if (isset($data_val['children'])){
				$children = $data_val['children'];
				unset($data_val['children']);
			}
			echo '
				<li>
			';
				
			// collect LINKS and STACK to be added to LI, must do out of order, as need ID field to use as unique CSS ID in UL/A toggle
				
			// reveal sub ULs if sub ULs exist
			$links = "";
			$expand_key = "";
			echo '<div class="nodeBlock"><div class="leftPart">- ';	
			if(count($options['links']['tree'])){
				$i = 0;
				foreach($data_val as $model_name => $model_array){
					if(isset($options['links']['tree'][$model_name])){
						//apply prebuilt links
						if(isset($options['links']['tree'][$model_name]['radiolist'])){
							$links .= $this->getRadiolist($options['links']['tree'][$model_name]['radiolist'], $data_val);
						}
						
						if(isset($options['links']['tree'][$model_name]['checklist'])){
							$links .= $this->getCheckist($options['links']['tree'][$model_name]['check'], $data_val);
						}
						
						$links .= $this->strReplaceLink($options['links']['tree'][$model_name]['index'], $data_val);
						
						if(isset($model_array['id'])){
							$expand_key = $model_name;
							break;
						}
					}
				}
			}else if (count($options['links']['index'])){
				//apply prebuilt links
				$links = $this->strReplaceLink($options['links']['tree'][$expand_key], $data_val);
			}
			if(is_array($children)){
				if(empty($children)){
					echo '<a class="icon16 reveal not_allowed href="#" onclick="return false;">+</a> | ';
				}else{
					echo '<a class="icon16 reveal activate" href="#" onclick="return false;">+</a> | ';
				}
			}else if($children){
				$data_json = array('url' => isset($options['links']['tree_expand'][$expand_key]) ? $this->strReplaceLink($options['links']['tree_expand'][$expand_key], $data_val) : "");
				if($data_json['url'][0] == '/'){
					$data_json['url'] = substr($data_json['url'], 1);
				}
				$data_json = htmlentities(json_encode($data_json));
				echo '<a class="icon16 reveal notFetched" data-json="'.$data_json.'" href="#" onclick="return false;">+</a> | ';
			}else{
				echo '<a class="icon16 reveal not_allowed" href="#" onclick="return false;">+</a> | ';
			}
			
			$data_val['css'][] = 'rightPart';
			echo '</div><div class="'.implode(' ', $data_val['css']).'"><span class="nowrap">',$links,'</span>';
		
			if(count($options['settings']['tree'])){
				foreach($data_val as $model_name => $model_array){
					if(isset($options['settings']['tree'][$model_name])){
						
						if(!isset($atim_structures[$options['settings']['tree'][$model_name]]['app_stack'])){
							$atim_structures[$options['settings']['tree'][$model_name]]['app_stack'] = $this->buildStack($atim_structures[$options['settings']['tree'][$model_name]], $options);
						}
						
						$table_index = $atim_structures[$options['settings']['tree'][$model_name]]['app_stack'];
						
						if(!array_key_exists($options['settings']['tree'][$model_name], $accuracy_updated)){
							//update accuracy, only once per structure binding per level. 
							$this->updateDataWithAccuracy($data, $atim_structures[$options['settings']['tree'][$model_name]]);
							$accuracy_updated[$options['settings']['tree'][$model_name]] = true;
						}
						
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

						if(isset($data_val[$table_row_part['model']]['id'])){
							//prepends model.pkey to the beginning of the name (used by permission tree)
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
				
			echo '</div>
				<div class="treeArrow">
				</div>
			</div>';
			
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
		$language_node = '';
		$language_node_string = "";
		$language_node_count = 0;
		$language_node_list = array();
		$language_header = '';
		$language_header_string = "";
		$language_header_count = 0;
		$colspan = 0;
		
		foreach(array('checklist', 'radiolist', 'index') as $key){
			if(count($options['links'][$key])){
				++ $colspan;
				$column_count ++;
				$language_node_count++;
				$language_header_count ++;
			}
		}
		
		$batchset = '';
		if($options['settings']['batchset'] && $options['settings']['batchset']['link'] && $options['settings']['batchset']['var'] && AppController::checkLinkPermission('/Datamart/BatchSets/add/')){
			$link = preg_replace('#(/){2,}#', '/', $this->request->webroot.$options['settings']['batchset']['link'].'/batchsetVar:'.$options['settings']['batchset']['var']);
			if(isset($options['settings']['batchset']['ctrl'])){
				$link .= '/batchsetCtrl:'.$options['settings']['batchset']['ctrl'];
			}
			$batchset = '<a href="'.$link.'" title="'.__('add to temporary batchset').'" class="icon16 batchset"></a>';
		}
		
		if($colspan){
			$return_string .= $colspan > 1 ? ('<th colspan="'.$colspan.'">'.$batchset.'</th>') : '<th>'.$batchset.'</th>';
			$batchset = '';
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
			
			$paging = $this->Paginator->params['paging'];
			if(strlen($sort_on) == 0
			&& isset($this->Paginator->params['paging']) 
			&& ($part = current($paging)) 
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
			$previous_structure_group = null;
			$structure_group_change = false;
			foreach ($table_structure as $table_column){	
				$new_column = true;
				foreach ($table_column as $table_row){
					foreach($table_row as $table_row_part){
						if (($table_row_part['type'] != 'hidden' && strlen($table_row_part['label']) > 0) || $first_cell){
						    if(isset($table_row_part['structure_group'])){
						        if($previous_structure_group != $table_row_part['structure_group']){
						            $structure_group_change = true;
						            $previous_structure_group = $table_row_part['structure_group'];
						        }else{
						            $structure_group_change = false;
						        }
						    }else if($previous_structure_group){
						        $structure_group_change = true;
						        $previous_structure_group = null;
						    }else{
						        $structure_group_change = false;
						    }
							$first_cell = false;

							// label and help/info marker, if available...
							if($table_row_part['flag_float']){
								$return_string .= '
									<th class="floatingCell">
								'.$batchset;
							}else{
								$return_string .= '
									<th>
								'.$batchset;
							}
							$batchset = '';

							if($structure_group_change) {
								if($language_node_count > 0){
									$language_node .= '<th colspan="'.$language_node_count.'">'.(trim($language_node_string) ? '<div class="indexLangHeader">'.$language_node_string.'</div>' : '').'</th>';
								}
								$language_node_count = 0;
								$language_node_string = isset($table_row_part['structure_group_name'])? $table_row_part['structure_group_name'] : '';
								$language_node_list[$language_node_string] = '-1';
							}
							++ $language_node_count;
							if($table_row_part['heading'] || $structure_group_change || $new_column){
								if($language_header_count > 0){
									$language_header .= '<th colspan="'.$language_header_count.'">'.(trim($language_header_string) ? '<div class="indexLangHeader">'.$language_header_string.'</div>' : '').'</th>';
								} 
								$language_header_count = 0;
								$language_header_string = $table_row_part['heading']; 
							}
							++ $language_header_count;
							$new_column = false;
							
							$default_sorting_direction = isset($_REQUEST['direction']) ? $_REQUEST['direction'] : 'asc';
							$default_sorting_direction = strtolower($default_sorting_direction);

							if($options['settings']['pagination'] || $options['settings']['sorting']){
								$sorted_on_current_column = $table_row_part['model'].'.'.$table_row_part['field'] == $sort_on;
								if($sorted_on_current_column){
									$return_string .= '<div style="display: inline-block;" class="ui-icon ui-icon-triangle-1-'.($sort_asc ? "s" : "n").'"></div>';
								}
								if($options['settings']['pagination']){
									$paginator_string = $this->Paginator->sort($table_row_part['model'].'.'.$table_row_part['field'], html_entity_decode($table_row_part['label'], ENT_QUOTES, "UTF-8"));
									if($sorted_on_current_column && $sort_asc){
										$paginator_string = str_replace('/direction:asc">', '/direction:desc">', $paginator_string);
									}
									$return_string .= $paginator_string;
								}else{
									//sorting
									$url = array_merge(
										$options['settings']['sorting'],
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
								$return_string .= $current_col_number < $content_columns_count ? str_replace('<span class="icon16 help">', '<span class="icon16 help right">', $table_row_part['help']) : $table_row_part['help'];
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
			$language_node_count++;
			$language_header_count ++;
		}
		
		// end header row...
		$return_string .= '
				</tr>
		';
		
		if(sizeof($language_node_list) > 1) {
			if($language_node_string){
				$language_node = '<tr>'.$language_node.'<th colspan="'.$language_node_count.'">'.(trim($language_node_string) ? '<div class="indexLangHeader">'.$language_node_string.'</div>' : '').'</th></tr>';
			}
			if($language_node) $language_node .= '<th>&nbsp;</th>';
		} else {
			$language_node = '';
		}
		if($language_header_count){
			$language_header = '<tr>'.$language_header.'<th colspan="'.$language_header_count.'">'.(trim($language_header_string) ? '<div class="indexLangHeader">'.$language_header_string.'</div>' : '').'</th></tr>';
		}
		
		return array("header" => $language_node.$language_header.$return_string, "count" => $column_count);
		
	}

	private function displayExtras($return_array = array(), $options){
		if(count($options['extras'])){
			foreach($options['extras'] as $key => $val){
				if($key == 'start' || $key == 'end'){
					continue;
				}
				while(isset($return_array[$key])){
					$key ++;
				}
				$return_array[$key] = $val;
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
		$empty_help_bullet = '<span class="icon16 help error">&nbsp;&nbsp;&nbsp;&nbsp;</span>';
		$help_bullet = '<span class="icon16 help">&nbsp;&nbsp;&nbsp;&nbsp;<div>%s</div></span> ';
		$independent_types = array("select" => null, "radio" => null, "checkbox" => null, "date" => null, "datetime" => null, "time" => null, "yes_no" => null, "y_n_u" => null);
		$my_default_settings_arr = self::$default_settings_arr;
		$my_default_settings_arr['value'] = "%s";
		self::$last_tabindex = max(self::$last_tabindex, $options['settings']['tabindex']);
		
		if(isset($atim_structure['Sfs'])){
			//float fields must bear the column number of the first real field
			$column = null;
			foreach($atim_structure['Sfs'] as $sfs){
				if($sfs['flag_float'] == 0){
					$column = $sfs['display_column'];
					break;
				}
			}
			if($column != null){
				foreach($atim_structure['Sfs'] as &$sfs){
					if($sfs['flag_float']){
						$sfs['display_column'] = $column;
					}else{
						break;
					}
				}
				unset($sfs);
			}
			
			$paste_disabled = array();
			foreach($atim_structure['Sfs'] AS $sfs){
				$model_dot_field = $sfs['model'].'.'.$sfs['field'];
				if($sfs['flag_'.$options['type']] || ($options['settings']['all_fields'] && ($sfs['flag_detail'] || $sfs['flag_index']))){
					$current = array(
						"name" 				=> "",
						"model" 			=> $sfs['model'],
						"tablename"			=> $sfs['tablename'],
						"field" 			=> $sfs['field'],
						"heading" 			=> trim($sfs['language_heading']) ? __($sfs['language_heading'], true) : $sfs['language_heading'],
						"label" 			=> __($sfs['language_label'], true),
						"tag" 				=> __($sfs['language_tag'], true),
						"type" 				=> $sfs['type'],
						"help" 				=> strlen($sfs['language_help']) > 0 ? sprintf($help_bullet, __($sfs['language_help'], true)) : $empty_help_bullet,
						"setting" 			=> $sfs['setting'],//required for icd10 magic
						"default"			=> $sfs['default'],
						"flag_confidential"	=> $sfs['flag_confidential'],
						"flag_float"		=> $sfs['flag_float'],
						"readonly"			=> isset($sfs["flag_".$options['type']."_readonly"]) && $sfs["flag_".$options['type']."_readonly"],
						"margin"			=> $sfs['margin'],
					    "structure_group"   => isset($sfs['structure_group']) ? $sfs['structure_group'] : null,
					    "structure_group_name"   => isset($sfs['structure_group_name']) ? $sfs['structure_group_name'] : null
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
							if(in_array($model_dot_field, $options['settings']['paste_disabled_fields'])){
								$settings['class'] .= " pasteDisabled";
								$paste_disabled[] = $model_dot_field; 
							}
						}
						$field_name .= $model_dot_field;
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
										$href = preg_replace("#(\/){2,}#", "/", $this->request->webroot.str_replace( ' ', '_', trim(str_replace( '.', ' ', $setting[1]))));//webroot bug otherwise
										$current['tool'] = '<a href="'.$href.'" class="tool_popup"></a>';
									}
								}else{
									if($setting[0] == 'class' && isset($settings['class'])) {
										$settings['class'] .=  ' '.$setting[1];
									} else {
										$settings[$setting[0]] = $setting[1];
									}
								}
							}
						}
						
						//validation CSS classes
						if(count($sfs['StructureValidation']) > 0 && $options['type'] != "search"){
							
							foreach($sfs['StructureValidation'] as $validation){
								if($validation['rule'] == 'notEmpty'){
									if($options['type'] != 'batchedit'){
										$settings["class"] .= " required";
										$settings["required"] = "required";
									}
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
							$tmp_settings = array();
							if($options['type'] == 'add' || $options['type'] == 'edit' || $options == 'search'){
								//default textarea size in add/edit/search
								if(!array_key_exists('rows', $settings)){
									$settings['rows'] = 3;
								}
								if(!array_key_exists('cols', $settings)){
									$settings['cols'] = 30;
								}
							}else if($options['type'] == 'addgrid' || $options['type'] == 'editgrid'){
								//default textarea size in grids
								if(!array_key_exists('rows', $settings)){
									$settings['rows'] = 2;
								}
								if(!array_key_exists('cols', $settings)){
									$settings['cols'] = 15;
								}
							}
							$current["format"] = $this->Form->input($field_name, array_merge(array("type" => "textarea"), array_merge($settings, $tmp_settings)));
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
//										AppController::addWarningMsg(__("the hidden field [%s] label has been removed", $model_dot_field));
									}
									$current['label'] = "";
								}
								if(strlen($current['heading'])){
									if(Configure::read('debug') > 0){
//										AppController::addWarningMsg(__("the hidden field [%s] heading has been removed", $model_dot_field));
									}
									$current['heading'] = "";
								}
							}
						}else if($sfs['type'] == "display"){
							$current["format"] = "%s";
						}else{
							if(Configure::read('debug') > 0){
								AppController::addWarningMsg(__("field type [%s] is unknown", $sfs['type']));
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
							if(count($sfs['StructureValidation']) > 0 && (in_array($options['type'], array('edit', 'editgrid', 'add', 'addgrid')))){
								//check if the field can be empty or not
								foreach($sfs['StructureValidation'] as $validation){
									if($validation['rule'] == 'notEmpty'){
										if(in_array($options['type'], array('edit', 'editgrid')) || 
											!empty($sfs['default']) || 
											(isset($options['override'][$model_dot_field]) && !empty($options['override'][$model_dot_field]))
										){
											$add_blank = false;
										}
										break;
									}
								}
							}
							if($add_blank){
								$dropdown_result["defined"][""] = "";
							}
						}
						
						if(isset($options['dropdown_options'][$model_dot_field])){
							$dropdown_result['defined'] = $options['dropdown_options'][$model_dot_field]; 
						}else if(count($sfs['StructureValueDomain']) > 0){
							$this->StructureValueDomain->updateDropdownResult($sfs['StructureValueDomain'],$dropdown_result);
						}else if($sfs['type'] == "checkbox"){
							//provide yes/no as default for checkboxes
							$dropdown_result['defined'] = array(0 => __("no", true), 1 => __("yes", true));
						}else if($sfs['type'] == "yes_no" || $sfs['type'] == "y_n_u"){
							//provide yes/no/? as default for yes_no
							$dropdown_result['defined'] = array("" => "", "n" => __("no", true), "y" => __("yes", true));
							if($sfs['type'] == "y_n_u"){
								$dropdown_result['defined']["u"] = __('unknown', true);	
							}
						}
					
						if($options['type'] == "search" && ($sfs['type'] == "checkbox" || $sfs['type'] == "radio")){
							//checkbox and radio buttons in search mode are dropdowns 
							$dropdown_result['defined'] = array_merge(array("" => ""), $dropdown_result['defined']);
						}
						
						if(count($dropdown_result['defined']) == 2 
							&& isset($sfs['flag_'.$options['type'].'_readonly']) 
							&& $sfs['flag_'.$options['type'].'_readonly'] 
							&& isset($add_blank) && $add_blank
						){
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
					AppController::addWarningMsg("Paste disabled field(s) not found: ". implode(", ", $paste_disabled), true);
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
						AppController::addWarningMsg(__("the override for [%s] couldn't be applied because the field was not found", $key));
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
			$json = "";
			if(isset($link_array['link'])){
				if(isset($link_array['icon'])){
					$icon = $link_array['icon'];
				}
				if(isset($link_array['json'])){
					$json = $link_array['json'];
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
				
				// if ACO/ARO permissions check succeeds or if it's a js command, create link
				if (AppController::checkLinkPermission($link_location)
					|| strpos($link_location, "javascript:") === 0
				){
					
					$display_class_name = $this->generateLinkClass($link_name, $link_location);
					$html_attributes = array('title' => strip_tags( html_entity_decode(__($link_name, true), ENT_QUOTES, "UTF-8")) );
					 
					$class = strlen($icon) > 0 ? $icon : $display_class_name;
					
					// set Javascript confirmation msg...
					$confirmation_msg = NULL;
					
					if($data != null){
						$link_location 		= $this->strReplaceLink($link_location, $data);
					}

					$return_urls[]		= $this->Html->url( $link_location );
					
					// check AJAX variable, and set link to be AJAX link if exists
					$html_attributes['class'] = '';
					if(isset($option_links['ajax'][$state][$link_name])){
						$html_attributes['class'] = 'ajax ';
						// if ajax SETTING is an ARRAY, set helper's OPTIONS based on keys=>values
						if(is_array($option_links['ajax'][$state][$link_name])){
							foreach ($option_links['ajax'][$state][$link_name] as $html_attribute_key => $html_attribute_value){
								$html_attributes[$html_attribute_key] = $html_attribute_value;
							}
							if(isset($html_attributes['json'])){
								$html_attributes['data-json'] = htmlentities((json_encode($html_attributes['json'])));
								unset($html_attributes['json']);
							}
						}else{
							// otherwise if STRING set UPDATE option only
							$html_attributes['data-json'] = htmlentities(json_encode(array('update' => $option_links['ajax'][$state][$link_name])));
						}
					}else if($json){
						$html_attributes['data-json'] = $json;
					}
					
					$html_attributes['escape'] = false; // inline option removed from LINK function and moved to Options array
					$html_attributes['class'] .= $class;
					if($state =='index'){
						$html_attributes['class'] .= ' icon16';
						$link_results[$link_label]	= $this->Html->link(
								'&nbsp;',
								$link_location, // url
								$html_attributes, // options
								$confirmation_msg // confirmation message
						);
					}else{
						$link_results[$link_label]	= $this->Html->link( 
							'<span class="icon16 '.$class.'"></span>'. __($link_label, true), // title
							$link_location, // url
							$html_attributes, // options
							$confirmation_msg // confirmation message
						);
					}
				}else{
					// if ACO/ARO permission check fails, display NOt ALLOWED type link
					$return_urls[]		= $this->Html->url( '/menus' );
					if($state == 'index'){
						$link_results[$link_label]	= '<a class="icon16 not_allowed"></a>';
					}else{
						$link_results[$link_label]	= '<a class="not_allowed">'.__($link_label, true).'</a>';
					}
				} // end CHECKMENUPERMISSIONS
				
			}
			
			if (count($link_results) == 1 && isset($link_results[$link_name])) {
				$return_links[$link_name] = $link_results[$link_name];
			}else{
				$links_append = '
							<a href="javascript:return false;"><span class="icon16 popup"></span>'.__($link_name, TRUE).'</a>
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
			
			if(count($return_links)){
				$links_array = array();
				foreach($return_links as $return_link){
					if(strpos($return_link, ' class="not_allowed"')){
						$links_array[] = '<div class="bottom_button not_allowed">'.$return_link.'</div>';
					}else{
						$links_array[] = '<div class="bottom_button">'.$return_link.'</div>'; 
					}
				}
					
				$return_string .= implode("", $links_array);
				
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
				array_shift($display_class_array);
				$display_class_name = implode(' ', $display_class_array);
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
						}
					}
				}
			}
		}
		$to_check = is_array($link) ? $link['link'] : $link;
		if(preg_match('/%%[\w.]+%%/', $to_check) && Configure::read('debug')){
			AppController::addWarningMsg('DEBUG: bad link detected ['.$to_check.']');
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
		if(isset($attributes['required'])){
			$year_attributes['required'] = $attributes['required'];
			unset($attributes['required']);
		}
		if(datetime_input_type == "dropdown"){
			foreach($pref_date as $part){
				if($part == "Y"){
					$result .= $this->Form->year($name, 1900, 2100, array_merge($year_attributes, array('value' => $year)));
				}else if($part == "M"){
					$result .= $this->Form->month($name, array_merge($attributes, array('value' => $month)));
				}else{
					$result .= $this->Form->day($name, array_merge($attributes, array('value' => $day)));
				}
			}
		}else{
			foreach($pref_date as $part){
				if($part == "Y"){
					$result .= '<span class="tooltip">'.$this->Form->text($name.".year", array_merge($year_attributes, array('type' => 'number', 'min' => 1900, 'max' => 2100,  'value' => $year, 'size' => 6, 'maxlength' => 4, 'class' => 'year')))."<div>".__('year', true)."</div></span>";
				}else if($part == "M"){
					$result .= '<span class="tooltip">'.$this->Form->text($name.".month", array_merge($attributes, array('type' => 'number', 'min' => 1, 'max' => 12, 'value' => $month, 'size' => 3, 'maxlength' => 2, 'class' => 'month')))."<div>".__('month', true)."</div></span>";
				}else{
					$result .= '<span class="tooltip">'.$this->Form->text($name.".day", array_merge($attributes, array('type' => 'number', 'min' => 1, 'max' => 31, 'value' => $day, 'size' => 3, 'maxlength' => 2, 'class' => 'month')))."<div>".__('day', true)."</div></span>";
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
			unset($attributes['options']);//Fixes an IE8 issue with $.serialize
			$result .= $this->Form->hour($name, time_format == 24, array_merge($attributes, array('value' => $hour)));
			$result .= $this->Form->minute($name, array_merge($attributes, array('value' => $minutes)));
		}else{
			unset($attributes['options']);
			$result .= '<span class="tooltip">'.$this->Form->text($name.".hour", array_merge($attributes, array('type' => 'number', 'value' => $hour, 'size' => 3, 'min' => time_format == 12 ? 1 : 0, 'max' => time_format == 12 ? 12 : 23)))."<div>".__('hour', true)."</div></span>";
			$result .= '<span class="tooltip">'.$this->Form->text($name.".min", array_merge($attributes, array('type' => 'number', 'value' => $minutes, 'size' => 3, 'min' => 0, 'max' => 59)))."<div>".__('minutes', true)."</div></span>";
		}
		if(time_format == 12){
			$result .= $this->Form->meridian($name, array_merge($attributes, array('value' => $meridian)));
		}
		return $result;
	}

	private static function getCurrentValue($data_unit, array $table_row_part, $suffix, $options){
		$warning = false;
		if(is_array($data_unit) 
			&& array_key_exists($table_row_part['model'], $data_unit) 
			&& is_array($data_unit[$table_row_part['model']])
			&& array_key_exists($table_row_part['field'].$suffix, $data_unit[$table_row_part['model']])
		){
			//priority 1, data
			$current_value = $data_unit[$table_row_part['model']][$table_row_part['field'].$suffix];
		}else if($options['type'] != 'index' && $options['type'] != 'detail' && $options['type'] != 'csv'){
			if(isset($options['override'][$table_row_part['model'].".".$table_row_part['field']])){
				//priority 2, override
				$current_value = $options['override'][$table_row_part['model'].".".$table_row_part['field'].$suffix];
				if(is_array($current_value)){
					if(Configure::read('debug') > 0){
						AppController::addWarningMsg(__("invalid override for model.field [%s.%s]", $table_row_part['model'], $table_row_part['field'].$suffix));
					}
					$current_value = "";
				}else if(Configure::read('debug') > 0 && $table_row_part['type'] == 'select' && !array_key_exists($current_value, $table_row_part['settings']['options']['defined'])){
					AppController::addWarningMsg(__('unsupported override value for model.field [%s.%s]', $table_row_part['model'], $table_row_part['field'].$suffix));
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
			AppController::addWarningMsg(__("no data for [%s.%s]" , $table_row_part['model'], $table_row_part['field']));
		}
		
		if($options['CodingIcdCheck'] && ($options['type'] == 'index' || $options['type'] == 'detail' || $options['type'] == 'csv') && $current_value){
			foreach(AppModel::getMagicCodingIcdTriggerArray() as $key => $trigger){
				if(strpos($table_row_part['setting'], $trigger) !== false){
					eval('$instance = '.$key.'::getSingleton();');
					$current_value .= " - ".$instance->getDescription($current_value);
				}
			}
		}
		return $current_value;
	}
	
	private function getRadiolist(array $raw_radiolist, array $data){
		$result = '';
		$default_settings_wo_class = self::$default_settings_arr;
		unset($default_settings_wo_class['class']);
		foreach($raw_radiolist as $radiobutton_name => $radiobutton_value){
			list($tmp_model, $tmp_field) = split("\.", $radiobutton_name);
			$radiobutton_value = $this->strReplaceLink($radiobutton_value, $data);
			$tmp_attributes = array('legend' => false, 'value' => false, 'id' => $radiobutton_name);
			if(isset($data[$tmp_model][$tmp_field]) && $data[$tmp_model][$tmp_field] == $radiobutton_value){
				$tmp_attributes['checked'] = 'checked';
			}
			$result .= $this->Form->radio($radiobutton_name, array($radiobutton_value=>''), array_merge($default_settings_wo_class, $tmp_attributes));
		}
		
		return $result;
	}
	
	function getChecklist(array $raw_checklist, array $data){
		$result = '';
		$default_settings_wo_class = self::$default_settings_arr;
		unset($default_settings_wo_class['class']);
		foreach($raw_checklist as $checkbox_name => $checkbox_value){
			$checkbox_value = $this->strReplaceLink($checkbox_value, $data);
			$result .= $this->Form->checkbox($checkbox_name, array_merge($default_settings_wo_class, array('value' => $checkbox_value)));
		}
		
		return $result;
	}
	
	private function unsanitize(array &$sanitized_data, array $org_data, array $unsanitize){
		foreach($org_data as $index => $row){
			foreach($unsanitize as $model => $fields){
				if($index == $model){
					//flat
					foreach($fields as $field){
						if(isset($row[$field])){
							$sanitized_data[$model][$field] = $row[$field];
						}
					}
				}
				if(isset($row[$model])){
					//row
					foreach($fields as $field){
						if(isset($row[$model][$field])){
							$sanitized_data[$index][$model][$field] = $row[$model][$field];
						}
					}
				}
			}
		}
	}
	
	function generateSelectItem($search_url, $name){
		return '
		<div class="selectItemZone">
			<div class="selectedItem"></div>
			<span class="button" data-url="'.$search_url.'" data-name="'.$name.'"><a href="#">'.__('search').'</a></span>
		</div>
		';
	}
	
	function ajaxIndex($index_url){
		return AppController::checkLinkPermission($index_url) ? '
		<div class="indexZone" data-url="'.$index_url.'">
		</div>
		' : '<div>'.__('You are not authorized to access that location.').'</div>';
	}
	
}
	
