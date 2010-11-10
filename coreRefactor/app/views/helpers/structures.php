<?php
	
App::import('Component','SessionAcl');

class StructuresHelper extends Helper {
		
	var $helpers = array( 'Csv', 'Html', 'Form', 'Javascript', 'Ajax', 'Paginator','Session' );
	private static $last_tabindex = 1; 
	private static $defaults = array(
			'type'		=>	NULL, 
			
			'data'	=> false, // override $this->data values, will not work properly for EDIT forms
			
			'settings'	=> array(
				'return'			=> false, // FALSE echos structure, TRUE returns it as string
				
				// show/hide various structure elements, useful for STACKING multiple structures (for example, to make one BIG form out of multiple smaller forms)
				'actions'		=> true, 
				'header'			=> '',
				'form_top'		=> true, 
				'tabindex'		=> 0, // when setting TAB indexes, add this value to the number, useful for stacked forms
				'form_inputs'	=> true, // if TRUE, use inputs when supposed to, if FALSE use static display values regardless
				'form_bottom'	=> true,
				'name_prefix'	=> NULL,
				'separator'		=> false,
				'pagination'	=> true,
				'columns_names' => array(), // columns names - usefull for reports. only works in detail views
				
				'all_fields'	=> false, // FALSE acts on structures datatable settings, TRUE ignores them and displays ALL FIELDS in a form regardless
				'add_fields'	=> false, // if TRUE, adds an "add another" link after form to allow another row to be appended
				'del_fields'	=> false, // if TRUE, add a "remove" link after each row, to allow it to be removed from the form
				
				'columns'		=> array(), // pass inline CSS to any structure COLUMNS
				
				'tree'			=> array() // indicates MULTIPLE atim_structures passed to this class, and which ones to use for which MODEL in each tree ROW
				
			),
			
			'links'		=> array(
				'top'				=> false, // if present, will turn structure into a FORM and this url is used as the FORM action attribute
				'index'			=> array(),
				'bottom'			=> array(),
				
				'tree'			=> array(),
				
				'checklist'		=> array(), // keys are checkbox NAMES (model.field) and values are checkbox VALUES
				'radiolist'		=> array(), // keys are radio button NAMES (model.field) and values are radio button VALUES
				
				'ajax'	=> array( // change any of the above LINKS into AJAX calls instead
					'top'			=> false,
					'index'		=> array(),
					'bottom'		=> array()
				)
			),
			
			'override'	=> array(),
			
			'extras'		=> array() // HTML added to structure blindly, each in own COLUMN
		);
	private static $default_settings_arr = array(
			"label" => false, 
			"div" => false, 
			"class" => "",
			"id" => false,
			"legend" => false,
		);

	function __construct(){
		parent::__construct();
		App::import('Model', 'StructureValueDomain');
		$this->StructureValueDomain = new StructureValueDomain();
	}

	function hook( $hook_extension='' ) {
		if ( $hook_extension ) $hook_extension = '_'.$hook_extension;
		
		$hook_file = APP . 'plugins' . DS . $this->params['plugin'] . DS . 'views' . DS . $this->params['controller'] . DS . 'hooks' . DS . $this->params['action'].$hook_extension.'.php';
		if ( !file_exists($hook_file) ) $hook_file=false;
		
		return $hook_file;
	}


	function build($atim_structure=array(), $options=array()){
		// DEFAULT set of options, overridden by PASSED options
		$options = $this->array_merge_recursive_distinct(self::$defaults,$options);
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
		
		if ($options['settings']['return']){
			//the result needs to be returned as a string, turn output buffering on
			ob_start();
		}
		
		
		if ( count($options['settings']['tree']) ) {
			foreach ( $atim_structure as $key=>$val ) {
				$atim_structure[$key] = $this->sort_structure( $val );
			}
		} else {
			$atim_structure = $this->sort_structure( $atim_structure );
		}
			
		if ($options['links']['top'] && $options['settings']['form_top']) {
			if ( isset($options['links']['ajax']['top']) && $options['links']['ajax']['top'] ) {
				echo($this->Ajax->form(
					array(
						'type'		=> 'post',    
						'options'	=> array(
							'update'		=> $options['links']['ajax']['top'],
							'url'			=> $options['links']['top']
						)
					)
				));
			}else {
				echo('
					<form action="'.$this->generate_links_list( $this->data, $options, 'top' ).'" method="post" enctype="multipart/form-data">
						<fieldset>
				');
			}
		}
		
		// display grey-box HEADING with descriptive form info
		if( $options['settings']['header'] ){
			if ( !is_array($options['settings']['header']) ) {
				$options['settings']['header'] = array(
					'title'			=> $options['settings']['header'],
					'description'	=> ''
				);
			}
			
			echo('<table class="structure" cellspacing="0">
				<tbody class="descriptive_heading">
					<tr>
						<td>
							<h4>'.$options['settings']['header']['title'].'</h4>
							<p>'.$options['settings']['header']['description'].'</p>
						</td>
					</tr>
				</tbody>
				</table>
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
		
		// run specific TYPE function to build structure
		$type = $options['type'];
		if($type == "add" || $type == "edit" || $type == "addgrid" || $type == "editgrid"){
		}
		if($type == 'index'){
			$options['type'] = 'index';		
			$this->build_table( $atim_structure, $options, $data);
			
		}else if($type == 'addgrid'
		|| $type == 'editgrid'){
			$options['type'] = 'datagrid';	
			$this->build_table( $atim_structure, $options, $data);
			
		}else if($type == 'csv'){
			$options['type'] = 'index';
			$this->build_csv( $atim_structure, $options, $data);
			$options['settings']['actions'] = false;
			
		}else if($type == 'add'
		|| $type == 'edit'
		|| $type == 'search'){
			$this->build_detail( $atim_structure, $options, $data);
			
		}else if($type == 'tree'){
			$this->build_tree( $atim_structure, $options, $data);
			
		}else{
			if($type != 'detail'){
				AppController::addWarningMsg(sprintf(__("warning: unknown build type [%s]", true), $type)); 
			}
			$options['type'] = 'detail';
			$this->build_detail( $atim_structure, $options, $data);
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
				</fieldset>
				
				<fieldset class="submit">
					<div>
						<span class="button large">
							<input id="submit_button" class="submit" type="submit" value="Submit" style="display: none;"/>
							<a href="#" onclick="$(\'#submit_button\').click();" class="form '.$link_class.'" tabindex="'.(StructuresHelper::$last_tabindex + 1).'">'.$link_label.'</a>
						</span>
						'.$exact_search.'
					</div>
			');
		}
		
		if ( $options['links']['top'] && $options['settings']['form_bottom'] ) {
			echo('
					</fieldset>
				</form>
			');
		}
				
		if ( $options['settings']['actions'] ) {
			echo($this->generate_links_list(  $this->data, $options, 'bottom' ));
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


	function sort_structure( $atim_structure ) {
		if ( count($atim_structure['Sfs']) ) {
			// Sort the data with ORDER descending, FIELD ascending 
				foreach ( $atim_structure['Sfs'] as $key=>$row ) {
					$sort_order_0[$key] = $row['display_column'];
					$sort_order_1[$key] = $row['display_order'];
					$sort_order_2[$key] = $row['model'];
				}
			
			// multisort, PHP array 
				array_multisort( $sort_order_0, SORT_ASC, $sort_order_1, SORT_ASC, $sort_order_2, SORT_ASC, $atim_structure['Sfs'] );
		}
		return $atim_structure;
	}
	
//TODO: check unknown values in drop down
	function build_detail($atim_structure, $options, $data){
		$table_index = $this->build_stack( $atim_structure, $options );
		// display table...
		echo('
			<table class="structure" cellspacing="0">
			<tbody>
				<tr>
		');
		
		// each column in table 
		$count_columns = 0;
		foreach($table_index as $table_column_key => $table_column){
			$count_columns ++;
			
			// for each FORM/DETAIL element...
			if(is_array($table_column)){
				echo('<td class="this_column_'.$count_columns.' total_columns_'.count($table_index).'"> 
					
						<table class="columns detail" cellspacing="0">');

				if(!empty($options['settings']['columns_names'])){
					echo('<thead><tr><td></td><th>'.implode("</th><th>", $options['settings']['columns_names']).'</th></tr></thead>');
				}
				echo('<tbody>');
			
				// each row in column 
				$table_row_count = 0;
				echo("<tr>");
				$new_line = true;
				$end_of_line = "";
				$display = "";
				foreach ( $table_column as $table_row ) {
					foreach($table_row as $table_row_part){
						if($table_row_part['heading']){
							if(!$new_line){
								echo('<td class="content">'.$display."</td>".$end_of_line."</tr><tr>");
								$display = "";
								$end_of_line = "";
							}
							echo('<td class="heading no_border" colspan="'.( show_help ? '3' : '2' ).'">
										<h4>'.$table_row_part['heading'].'</h4>
									</td>
								</tr><tr>
							');
						}
						
						if($table_row_part['label']){
							if(!$new_line){
								echo('<td class="content">'.$display."</td>".$end_of_line."</tr><tr>");
								$display = "";
								$end_of_line = "";
							}
							echo('<td class="label">
										'.$table_row_part['label'].'
								</td>
							');
						}
						
						//value
						$current_value = null;
						if(is_array($data)
						&& array_key_exists($table_row_part['model'], $data) 
						&& array_key_exists($table_row_part['field'], $data[$table_row_part['model']])){
							//priority 1, data
							$current_value = $data[$table_row_part['model']][$table_row_part['field']];
						}else if(isset($options['override'][$table_row_part['model'].".".$table_row_part['field']])){
							//priority 2, override
							$current_value = $options['override'][$table_row_part['model'].".".$table_row_part['field']];
						}else{
							//priority 3, default
							$current_value = $table_row_part['default']; 
						}
						
						if(!empty($options['settings']['columns_names'])){
							//TODO
							if(is_array($table_row_part['content'])){
								foreach($options['settings']['columns_names'] as $col_name){
									echo($td_open.(isset($table_row_part['content'][$col_name]) ? $table_row_part['content'][$col_name] : "")."</td>"); 
								}
							}else{
								echo(str_repeat($td_open."</td>", count($options['settings']['columns_names'])));
							}
						}else{
							if($options['links']['top'] && $options['settings']['form_inputs']){
								if($table_row_part['type'] == "date"){
									$display .= self::getDateInputs($table_row_part['model'].".".$table_row_part['field'], $current_value, $table_row_part['settings']);
								}else if($table_row_part['type'] == "datetime"){
									if(is_array($current_value)){
										$date = $current_value;
										$time = $current_value;
									}else{
										list($date, $time) = explode(" ", $current_value);
									}
									$display .= self::getDateInputs($table_row_part['model'].".".$table_row_part['field'], $date, $table_row_part['settings']);
									$display .= self::getTimeInputs($table_row_part['model'].".".$table_row_part['field'], $time, $table_row_part['settings']);
								}else if($table_row_part['type'] == "time"){
									$display .= self::getTimeInputs($table_row_part['model'].".".$table_row_part['field'], $table_row_part['settings']);
								}else if($table_row_part['type'] == "select" 
								|| ($options['type'] == "search" && ($table_row_part['type'] == "radio" || $table_row_part['type'] == "checkbox"))){
									$display .= $this->Form->input($table_row_part['model'].".".$table_row_part['field'], array_merge($table_row_part['settings'], array('type' => 'select', 'value' => $current_value)));
								}else if($table_row_part['type'] == "radio"){
									$display .= $this->Form->input($table_row_part['model'].".".$table_row_part['field'], array_merge($table_row_part['settings'], array('type' => $table_row_part['type'], 'value' => $current_value)));
								}else if($table_row_part['type'] == "checkbox"){
									$display .= $this->Form->input($table_row_part['model'].".".$table_row_part['field'], array_merge($table_row_part['settings'], array('type' => 'checkbox', 'value' => $current_value)));
								}else{
									$display .= str_replace("%s", $current_value, $table_row_part['format']);
								} 
								
								if(isset($table_row_part['tool'])){
									$display .= $table_row_part['tool'];
								}
							}else if(strlen($data[$table_row_part['model']][$table_row_part['field']]) > 0){
								if($table_row_part['type'] == "date"){
									list($year, $month, $day) = explode("-", $current_value);
									$display .= AppController::getFormatedDateString($year, $month, $day);
								}else if($table_row_part['type'] == "datetime"){
									$display .= AppController::getFormatedDatetimeString($current_value);
								}else if($table_row_part['type'] == "time"){
									list($hour, $minutes) = explode(":", $current_value);
									$display .= AppController::getFormatedTimeString($hour, $minutes);
								}else if($table_row_part['type'] == "select" || $table_row_part['type'] == "radio" || $table_row_part['type'] == "checkbox"){
									if(isset($table_row_part['settings']['options'][$current_value])){
										$display .= $table_row_part['settings']['options'][$current_value];
									}else{
										$display .= $current_value;
										if(Configure::read('debug') > 0){
											AppController::addWarningMsg(sprintf(__("missing reference key [%s] for field [%s]", true), $current_value, $table_row_part['field']));
										}
									}
								}else{
									$display .= $current_value." ";
								}
							}
						}
						
						
						if(show_help) {
							$end_of_line = '
									<td class="help">
										'.$table_row_part['help'].'
									</td>';
						}
						
						$new_line = false;
					}
					$table_row_count++;
				} // end ROW 
				echo('<td class="content">'.$display.'</td>'.$end_of_line.'</tr>
						</tbody>
						</table>
						
					</td>
				');
				
			}else {
				// 	otherwise display EXTRAs...
				echo('
					<td class="this_column_'.$count_columns.' total_columns_'.count($table_index).'"> 
					
						<table class="columns extra" cellspacing="0">
						<tbody>
							<tr>
								<td>
									'.$table_column.'
								</td>
							</tr>
						</tbody>
						</table>
						
					</td>
				');
			}
				
		} // end COLUMN 
		
	echo('
			</tr>
		</tbody>
		</table>
	');
	}


/********************************************************************************************************************************************************************************/


	function build_table( $atim_structure, $options ) {
		echo('
			<table class="structure" cellspacing="0">
			<tbody>
				<tr>
		');
			
		// attach PER PAGE pagination param to PASSED params array...
		if(isset($this->params['named']) && isset($this->params['named']['per'])){
			$this->params['pass']['per'] = $this->params['named']['per'];
		}
		
		$this->Paginator->options(array('url' => $this->params['pass']));
			
		if(is_array($options['data'])){
			$data=$options['data']; 
		}else{
			$data=$this->data; 
		}
		
		$table_structure = array();
		foreach($data as $key => $val){
			$options['stack']['key'] = $key.($options['settings']['name_prefix'] ? ".".$options['settings']['name_prefix'] : "");
			$table_structure[$key] = $this->build_stack( $atim_structure, $options );
			unset($options['stack']);
		}
		$structure_count = 0;
		$structure_index = array( 1 => $table_structure ); 
		
		// add EXTRAS, if any
		$structure_index = $this->display_extras( $structure_index, $options );
				
				foreach ( $structure_index as $table_key=>$table_index ) {				
					
					$structure_count++;
					
					// for each FORM/DETAIL element...
					if ( is_array($table_index) ) {
					
						// start table...
						echo('
							<td class="this_column_'.$structure_count.' total_columns_'.count($structure_index).'">
								
								<table class="columns index" cellspacing="0">
								<tbody>
						');
						
						// header row
						echo($this->display_header( $table_index, $options ));
						
						$column_count = 0;
						if ( count($data) ) {
						
							// each column in table 
							foreach ( $data as $key=>$val ) {
								
								echo('
									<tr id="table'.$table_key.'row'.$key.'">
								');
									
								$column_count = 0;
								
								if ( count($options['links']['checklist']) ) {
									echo('
										<td class="checkbox">
									');
									
									foreach ( $options['links']['checklist'] as $checkbox_name=>$checkbox_value ) {
										$checkbox_value = $this->str_replace_link( $checkbox_value, $val );
											$checkbox_form_element = $this->Form->checkbox($checkbox_name, array('value'=>$checkbox_value)); // have to do it TWICE, due to double-model-name error that we couldn't figure out...
 											$checkbox_form_element = $this->Form->checkbox($checkbox_name, array('value'=>$checkbox_value));
										echo($checkbox_form_element);
									}
									
									echo('
										</td>
									');
									
									$column_count++;
								}
								
								if ( count($options['links']['radiolist']) ) {
									echo('
										<td class="radiobutton">
									');
									foreach ( $options['links']['radiolist'] as $radiobutton_name=>$radiobutton_value ) {
										list($tmp_model, $tmp_field) = split("\.", $radiobutton_name);
										$radiobutton_value = $this->str_replace_link( $radiobutton_value, $val );
										$tmp_attributes = array('legend'=>false, 'value'=>false);
										if(isset($val[$tmp_model][$tmp_field]) && $val[$tmp_model][$tmp_field] == $radiobutton_value){
											$tmp_attributes['checked'] = 'checked';
										}
										echo($this->Form->radio($radiobutton_name, array($radiobutton_value=>''), $tmp_attributes));
									}
									
									echo('
										</td>
									');
									
									$column_count++;
								}
								
								if ( count($options['links']['index']) ) {
									echo('
										<td class="id">'.$this->generate_links_list(  $data[$key], $options, 'index' ).'</td>
									');
									
									$column_count++;
								}
								
								// each column/row in table 
								foreach ( $table_index[$key] as $table_column ) {
									foreach ( $table_column as $table_row ) {
										echo('
											<td>'.( $options['links']['top'] && $options['settings']['form_inputs'] ? $table_row['input'] : $table_row['content'] ).'</td>
										');
										
										$column_count++;
									}
								}
								
								// if OPTIONS set to allow rows to be removed from a GRID, provide link
								if ( $options['type']=='datagrid' && $options['settings']['del_fields'] ) {
									echo('
											<td class="right">
												<a style="color:red;" href="#" onclick="getElementById(\'table'.$table_key.'row'.$key.'\').parentNode.removeChild(getElementById(\'table'.$table_key.'row'.$key.'\')); return false;" title="'.__( 'click to remove these elements', true ).'">x</a>
											</td>
									');
									
									$column_count++;
								}
								
								echo('
									</tr>
								');
								
							} // end FOREACH
							
							// if OPTIONS set to allow rows to be added to a GRID, provide link
							if ( $options['type']=='datagrid' && $options['settings']['add_fields'] ) {
								
								$add_another_row_template = '';
								
								$add_another_row_template .= '
									<tr id="table'.$table_key.'row#{id}">
								';
									
								$column_count = 0;
								
								if ( count($options['links']['checklist']) ) {
									$add_another_row_template .= '
										<td class="checkbox">
									';
									
									foreach ( $options['links']['checklist'] as $checkbox_name=>$checkbox_value ) {
										$checkbox_value = $this->str_replace_link( $checkbox_value, '0' );
											$checkbox_form_element = $this->Form->checkbox($checkbox_name, array('value'=>$checkbox_value)); // have to do it TWICE, due to double-model-name error that we couldn't figure out...
 											$checkbox_form_element = $this->Form->checkbox($checkbox_name, array('value'=>$checkbox_value));
										$add_another_row_template .= $checkbox_form_element;
									}
									
									$add_another_row_template .= '
										</td>
									';
									
									$column_count++;
								}
								
								if ( count($options['links']['radiolist']) ) {
									$add_another_row_template .= '
										<td class="radiobutton">
									';
									
									foreach ( $options['links']['radiolist'] as $radiobutton_name=>$radiobutton_value ) {
										$radiobutton_value = $this->str_replace_link( $radiobutton_value, '0' );
										$add_another_row_template .= $this->Form->radio ($radiobutton_name, array($radiobutton_value=>''), array('legend'=>false) );
									}
									
									$add_another_row_template .= '
										</td>
									';
									
									$column_count++;
								}
								
								if ( count($options['links']['index']) ) {
									$add_another_row_template .= '
										<td class="id">'.$this->generate_links_list(  $data['#{id}'], $options, 'index' ).'</td>
									';
									
									$column_count++;
								}
								
								// each column/row in table 
								foreach ( $table_index[ (count($table_index)-1) ] as $table_column ) {
									foreach ( $table_column as $table_row ) {
										
										$table_row['input'] = str_replace('data['.(count($table_index)-1).']','data[#{id}]',$table_row['input']);
										$table_row['input'] = str_replace('id="row'.(count($table_index)-1),'id="row#{id}',$table_row['input']);
										
										$add_another_row_template .= '
											<td>'.( $options['links']['top'] && $options['settings']['form_inputs'] ? $table_row['input'] : $table_row['content'] ).'</td>
										';
										
										$column_count++;
									}
								}
								
								// if OPTIONS set to allow rows to be removed from a GRID, provide link
								if ( $options['type']=='datagrid' && $options['settings']['del_fields'] ) {
									$add_another_row_template .= '
											<td class="right">
												<a style="color:red;" href="#" onclick="getElementById(\'table'.$table_key.'row#{id}\').parentNode.removeChild(getElementById(\'table'.$table_key.'row#{id}\')); return false;" title="'.__( 'click to remove these elements', true ).'">x</a>
											</td>
									';
									
									$column_count++;
								}
								
								$add_another_row_template .= '
									</tr>
								';
								
							}
							
						}
						
						// display something nice for NO ROWS msg...
						else {
							echo('
									<tr>
											<td class="no_data_available"'.( $column_count ? ' colspan="'.$column_count.'"' : '' ).'>'.__( 'core_no_data_available', true ).'</td>
									</tr>
							');
						}
		
						// if OPTIONS set to allow rows to be added to a GRID, provide link
						if ( $options['type']=='datagrid' && $options['settings']['add_fields'] ) {
							
							$add_another_row_template = preg_replace('/\'/','&quot;',$add_another_row_template);
							$add_another_row_template = preg_replace('/"/',"'",$add_another_row_template);
							$add_another_row_template = str_replace("\n",'',$add_another_row_template);
							$add_another_row_template = str_replace("\r",'',$add_another_row_template);
							$add_another_row_template = preg_replace('/script>/', 's" + "cript>',$add_another_row_template);
							
							$add_another_unique = md5(microtime());
							$add_another_unique_function_name = 'repeat_function_'.$add_another_unique;
							$add_another_unique_next_variable = 'next_'.$add_another_unique;
							$add_another_unique_link_id = 'add_'.$add_another_unique;
							
							echo('
							</tbody><tfoot>
								<tr id="'.$add_another_unique_link_id.'">
									<td class="right" colspan="'.$column_count.'">
										<a class="addLineLink" style="color:#090; font-weight:bold;" href="#" onclick="'.$add_another_unique_function_name.'(this); return false;" title="'.__( 'click to add a line', true ).'">(+)</a>
										<input class="addLineCount" type="text" size="1" value="1" maxlength="2"/> line(s)
									</td>
								</tr>
								</tfoot>
								<script type="text/javascript">
									if( typeof('.$add_another_unique_next_variable.') == "undefined" ){
										var '.$add_another_unique_next_variable.' = "'.count($data).'";
									}else{
										'.$add_another_unique_next_variable.' = "'.count($data).'";
									}
									
									function '.$add_another_unique_function_name.'(me){
										var templateLine = "'.$add_another_row_template.'";
										var tbody = $("#'.$add_another_unique_link_id.'").parent().parent().children("tbody:first");
										var addLineCount = parseInt($(me).parent().find(".addLineCount").val(), 10);
										if(isNaN(addLineCount)){
											addLineCount = 1;
										}
										do{ 
											$(tbody).append(templateLine.replace(/#{id}/g, '.$add_another_unique_next_variable.')); 
											initTooltips();
											'.$add_another_unique_next_variable.'++;
											debug("incr: " + '.$add_another_unique_next_variable.');
											$(tbody).children("tr:last").find(".datepicker").each(function(){
												debug(this.id);
												initDatepicker(this);
											});
											addLineCount --;
										}while(addLineCount > 0);
										$("form").highlight("td");
										if(window.enableCopyCtrl){
											//if copy control exists, call it
											enableCopyCtrl("table1row" + ('.$add_another_unique_next_variable.'  - 1));
										}
										return false;
									}
								</script>
							');
							
						}
						
						if ( $options['settings']['pagination'] ) {
							echo('
									<tr class="pagination">
										<th'.( $column_count ? ' colspan="'.$column_count.'"' : '' ).'>
											
											<span class="results">
												'.$this->Paginator->counter( array('format' => '%start%-%end% of %count%') ).'
											</span>
											
											<span class="links">
												'.$this->Paginator->prev( __( 'Prev',true ), NULL, __( 'Prev',true ) ).'
												'.$this->Paginator->numbers().'
												'.$this->Paginator->next( __( 'Next',true ), NULL, __( 'Next',true ) ).'
											</span>
											
											'.$this->Paginator->link( '5', array('page'=>1, 'limit'=>5)).' |
											'.$this->Paginator->link( '10', array('page'=>1, 'limit'=>10)).' |
											'.$this->Paginator->link( '20', array('page'=>1, 'limit'=>20)).' |
											'.$this->Paginator->link( '50', array('page'=>1, 'limit'=>50)).'
											
										</th>
									</tr>
							');
						}
						
						if ( count($options['links']['checklist']) ) {
							echo("<tr><td colspan='3'><a href='#' class='checkAll'>".__('check all', true)."</a> | <a href='#' class='uncheckAll'>".__('uncheck all', true)."</a></td></tr>");
						}
						
						echo('
								</tfoot>
								</table>
								
							</td>
						');
						
					}
					
					// otherwise display EXTRAs...
					else {
						
						echo('
							<td class="this_column_'.$structure_count.' total_columns_'.count($structure_index).'"> 
							
								<table class="columns extra" cellspacing="0">
								<tbody>
									<tr>
										<td>
											'.$table_index.'
										</td>
									</tr>
								</tbody>
								</table>
								
							</td>
						');
						
					}
					
				} // end FOREACH
				
		echo('		</tr>
				</tbody>
			</table>
		');
	}


/********************************************************************************************************************************************************************************/


	function build_csv( $atim_structure, $options ) {
		if ( is_array($options['data']) ){
			$data=$options['data']; 
		}else{
			$data=$this->data; 
		}

		$table_structure = array();
		foreach ( $data as $key=>$val ) {
			$options['stack']['key'] = $key;
			$table_structure[$key] = $this->build_stack( $atim_structure, $options );
			unset($options['stack']);
		}

		if(is_array($table_structure) && count($data)){
			if(isset($options['settings']['columns_names']) && count($options['settings']['columns_names']) > 0){
				//reformat the data array for structures with columns_names
				$tmp = $table_structure;
				$table_structure = array();
				foreach($options['settings']['columns_names'] as $column_index => $column_name){
					$table_structure[$column_index][0][0] = array('label' => '', 'plain' => str_replace("&nbsp;", " ", $column_name));//column name is used a a row name here
					foreach($tmp[0][0] as $unit_index => $unit){
						$table_structure[$column_index][0][$unit_index] = array('label' => $unit['label'], 'plain' => $unit['content'][$column_name]);
					}
				}
			}

			//header line
			$line = array();
			foreach ( $table_structure[0] as $table_column ) {
				foreach ( $table_column as $fm => $table_row ) {
					$line[] = $table_row['label'];
				}
			}
			$this->Csv->addRow($line);

			//content
			foreach ( $table_structure as $table_column ) {
				$line = array();
				foreach ( $table_column[0] as $fm => $table_row ) {
					$line[] = $table_row['plain'];
				}
				$this->Csv->addRow($line);
			}
		}
		echo($this->Csv->render());
	}


/********************************************************************************************************************************************************************************/


	function build_tree( $atim_structure, $options ) {
		if ( is_array($options['data']) ){ 
			$data=$options['data']; 
		}else{
			$data=$this->data; 
		}
		
		// display table...
		echo('
			<table class="structure" cellspacing="0">
			<tbody>
				<tr>
		');
		
		$structure_count = 0;
		$structure_index = array( 1 => array() ); 
		
		// add EXTRAS, if any
		$structure_index = $this->display_extras( $structure_index, $options );
		
		foreach ( $structure_index as $column_key=>$table_index ) {
			
			$structure_count++;
			
			$column_inline_styles = '';
			if ( isset($options['settings']['columns'][$column_key]) ) {
				$column_inline_styles .= 'style="';
				foreach ( $options['settings']['columns'][$column_key] as $style_name=>$style_value ) {
					$column_inline_styles .= $style_name.':'.$style_value.';';
				}
				$column_inline_styles .= '"';
			}
			
			// for each FORM/DETAIL element...
			if ( is_array($table_index) ) {
			
				echo('
					<td column_key="'.$column_key.'" '.$column_inline_styles.' class="this_column_'.$structure_count.' total_columns_'.count($structure_index).'">
				');
				
					// start table...
					echo('
						<table class="columns tree" cellspacing="0">
						<tbody>
					');
					
					if ( count($data) ) {
						
						// start root level of UL tree, and call NODE function
						echo('
							<tr><td>
								<ul id="tree_root">
						');
						
						$this->build_tree_node( $atim_structure, $options, $data );
						
						echo('
								</ul>
							</td></tr>
						');
						
					}
					
					// display something nice for NO ROWS msg...
					else {
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
						
			}
			
			// otherwise display EXTRAs...
			else {
				echo('
					<td column_key="'.$column_key.'" class="this_column_'.$structure_count.' total_columns_'.count($structure_index).'"> 
					
						<table class="columns extra" cellspacing="0">
						<tbody>
							<tr>
								<td>
									'.$table_index.'
								</td>
							</tr>
						</tbody>
						</table>
						
					</td>
				');
				
			}
			
		} // end FOREACH
				
		echo('
				</tr>
			</tbody>
			</table>
		');   
	}
	
	function build_tree_node( $atim_structure, $options, $data=array()) {
		foreach ( $data as $data_key=>$data_val ) { 
			
			// unset CHILDREN from data, to not confuse STACK function
			$children = array();
			if ( isset($data_val['children']) ) {
				$children = $data_val['children'];
				unset($data_val['children']);
			}
			
			echo('
				<li>
			');
				
				// collect LINKS and STACK to be added to LI, must do out of order, as need ID field to use as unique CSS ID in UL/A toggle
				
			$unique_id = mt_rand(1000000, 9999999);//TODO WTH RANDOM UNIQUE???
				// reveal sub ULs if sub ULs exist
	
				if ( count($children) ) {
					echo('<a class="reveal {\'tree\' : \''.$unique_id.'\'}" href="#" onclick="return false;">+</a> ');
				} else {
					echo('<a class="reveal not_allowed" onclick="return false;">+</a> ');
				}
				
				echo('<div><span class="divider">|</span> ');	
					if ( count($options['links']['tree']) ) {
						foreach ( $data_val as $model_name=>$model_array ) {
							if ( isset($options['links']['tree'][$model_name]) ) {
								$tree_options = $options;
								$tree_options['links']['index'] = $options['links']['tree'][$model_name];
								
								echo($this->generate_links_list(  $data_val, $tree_options, 'index' ));
							}
						}
					}else if ( count($options['links']['index']) ) {
						echo($this->generate_links_list(  $data_val, $options, 'index' ));
					}
				
					$tree_node_structure = $atim_structure;
					if ( count($options['settings']['tree']) ) {
						foreach ( $data_val as $model_name=>$model_array ) {
							if ( isset($options['settings']['tree'][$model_name]) ) {
								$tree_node_structure = $atim_structure[ $options['settings']['tree'][$model_name] ];
								
								$data_key = $model_array['id']; // so set a UNIQUE id for each set of form elements
							}
						}
					}
					
					$options['type'] = 'index';
					$options['data'] = array( $data_key => $data_val );
					$options['stack']['key'] = $data_key; // required for multiple data submits from TREE
					
					$table_index = $this->build_stack( $tree_node_structure, $options );
					unset($options['stack']);
					
					foreach ( $table_index as $table_column_key=>$table_column ) {
						foreach ( $table_column as $table_row_key=>$table_row ) {
							//carefull with the white spaces as removing them the can break the display in IE
							echo(' <span class="nowrap"><span class="divider">|</span> '.( $options['links']['top'] && $options['settings']['form_inputs'] ? $table_row['input'] : $table_row['content'] )."</span>&nbsp;");
						}
					}
					
				echo('</div>');
				
				// create sub-UL, calling this NODE function again, if model has any CHILDREN
				if ( count($children) ) { 
					echo('
						<ul id="tree_'.$unique_id.'" style="display:none;">
					');
					
					$this->build_tree_node( $atim_structure, $options, $children );
					
					echo('
						</ul>
					');
				}
			
			echo('
				</li>
			');
			
		}
	}


	function display_header( $table_index=array(), $options=array() ) {
		
		$return_string = '';
		
		// start header row...
		$return_string .= '
				<tr>
		';
			
		if ( count($options['links']['checklist']) ) {
			$return_string .= '
					<th class="column_0 checkbox">&nbsp;</th>
			';
		}
		
		if ( count($options['links']['radiolist']) ) {
			$return_string .= '
					<th class="column_0 radiobutton">&nbsp;</th>
			';
		}
		
		if ( count($options['links']['index']) ) {
			$return_string .= '
					<th class="column_0 id">&nbsp;</th>
			';
		}
		
		// each column/row in table 
		if ( count($table_index) ) {
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
			$column_count = 1;
			foreach ( $table_index[0] as $table_column ) {
				foreach ( $table_column as $table_row ) {
				
					if (  $table_row['type']!='hidden' ) {
						
						$return_string .= '
							<th class="column_'.$column_count.' '.$table_row['field'].'">
						';
						
						// label and help/info marker, if available...
						if ( $table_row['label'] ) {
							
							$sorting_link = $_SERVER['REQUEST_URI'];
							$sorting_link = explode('?', $sorting_link);
							$sorting_link = $sorting_link[0];
							
							$default_sorting_direction = isset($_REQUEST['direction']) ? $_REQUEST['direction'] : 'asc';
							$default_sorting_direction = strtolower($default_sorting_direction);
							
							$sorting_link .= '?sortBy='.$table_row['field'];
							$sorting_link .= '&amp;direction='.( $default_sorting_direction=='asc' ? 'desc' : 'asc' );
							$sorting_link .= isset($_REQUEST['page']) ? '&amp;page='.$_REQUEST['page'] : '';
							if ( $options['settings']['pagination'] ) {
								if($table_row['model'].'.'.$table_row['field'] == $sort_on){
									$return_string .= '<div style="display: inline-block;" class="ui-icon ui-icon-triangle-1-'.($sort_asc ? "s" : "n").'"></div>';
								}
								$return_string .= $this->Paginator->sort(html_entity_decode($table_row['label'], ENT_QUOTES, "UTF-8"), $table_row['model'].'.'.$table_row['field']);
							} else {
								$return_string .= $table_row['label'];
							}
							
							if ( show_help ) {
								$return_string .= $table_row['help'];
							}
							
							$column_count++;
						}
						
						
						$return_string .= '
							</th>
						';
						
					} // end NOT HIDDEN
					
				} // end FOREACH
			} // end FOREACH
			
		}
		
		if ( $options['type']=='datagrid' && $options['settings']['add_fields'] ) {
			$return_string .= '
				<th>&nbsp;</th>
			';
		}
		
		// end header row...
		$return_string .= '
				</tr>
		';
		
		return $return_string;
		
	}

	function display_extras( $return_array=array(), $options ) {
		if(count($options['extras'])){
			foreach($options['extras'] as $key=>$val){
				while(isset($return_array[$key])){
					$key = $key+1;
				}
				$return_array[ $key ] = $val;
			}
		}
		ksort($return_array);
		return $return_array;
	}


	/**
	 * Builds the structure part containing the data
	 * @param array $atim_structure
	 * @param array $options
	 * @param boolean $use_data If true, data is placed directly into the stack, othewise replacable strings are placed
	 */
	//TODO: complete description
	function build_stack(array $atim_structure, array $options){
		$stack = array();//the stack array represents the display x => array(y => array(field data))
		$empty_help_bullet = '<span class="help error">&nbsp;</span>';
		$help_bullet = '<span class="help">&nbsp;<div>%s</div></span> ';
		$independent_types = array("select" => null, "radio" => null, "checkbox" => null);
		$my_default_settings_arr = self::$default_settings_arr;
		$my_default_settings_arr['value'] = "%s";
		
		self::$last_tabindex = max(self::$last_tabindex, $options['settings']['tabindex']);
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
					
					if(strlen($sfs['setting']) > 0){
						// parse through FORM_FIELDS setting value, and add to helper array
						$tmp_setting = explode(',', $sfs['setting']);
						foreach($tmp_setting as $setting){
							$setting = explode('=', $setting);
							if($setting[0] == 'tool'){
								$current['tool'] = $this->getTool($setting[1]);
							}else{
								$settings[$setting[0]] = $setting[1];
							}
						}
					}
					
					//validation CSS classes
					if(count($sfs['StructureValidation']) > 0){
						foreach($sfs['StructureValidation'] as $validation){
							if($validation['flag_not_empty'] || $validation['flag_required']){
								$settings["class"] = "required";
								$settings["required"] = "required";
								break;
							}
						}
						if(strlen($settings["class"]) == 0){
							$settings["class"] = "validation";
						}
					}
					
					$settings['tabindex'] = self::$last_tabindex ++;
					
					if($sfs["flag_".$options['type']."_readonly"]){
						$settings['disabled'] = "disabled";
					}
					
					//building all text fields (dropdowns, radios and checkboxes cannot be built here)
					$field_name = $sfs['model'].".".$sfs['field'];
					if($sfs['type'] == "input"){
						$current["format"] = $this->Form->input($field_name, array_merge(array("type" => "text"), $settings));
					}else if($sfs['type'] == "date" || $sfs['type'] == "datetime" || $sfs['type'] == "time"){
						//do nothing for dates
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
						$current["format"] = $this->Form->text($field_name, array_merge(array("type" => $sfs['type']), $settings));
					}else if($sfs['type'] == "display"){
						$current["format"] = "%s";
					}else if(!array_key_exists($sfs['type'], $independent_types)){
						if(Configure::read('debug') > 0){
							AppController::addWarningMsg(sprintf(__("field type [%s] is unknown", true), $sfs['type']));
						}
						$current["format"] = $this->Form->input($field_name, array_merge(array("type" => "text"), $settings));
					}
					$current['default'] = $sfs['default'];
					$current['settings'] = $settings;
				}
				//TODO: check readonly post submit
				if(array_key_exists($sfs['type'], $independent_types)){
					$dropdown_result = array();
					if(count($sfs['StructureValueDomain']) > 0){
						if(strlen($sfs['StructureValueDomain']['source']) > 0){
							//load source
							$dropdown_result = StructuresComponent::getPulldownFromSource($sfs['StructureValueDomain']['source']);
						}else{
							if($sfs['type'] == "select"){
								$dropdown_result = array("" => "");
							}
							$tmp_pulldown_result = $this->StructureValueDomain->find('first', array(
								'conditions' => 
									array('StructureValueDomain.id' => $sfs['StructureValueDomain']['id'])));
							$tmp_result = array();
							$current_order = null;
							$current_element = 1;
							foreach($tmp_pulldown_result['StructurePermissibleValue'] as $tmp_entry){
								if($tmp_entry['Svdpv']['display_order'] != $current_order || $current_index = count($tmp_pulldown_result['StructurePermissibleValue'])){
									if(count($tmp_result) > 1){
										asort($tmp_result);
									}
									$dropdown_result = array_merge($dropdown_result, $tmp_result);
									$tmp_result = array();
									$current_order = $tmp_entry['Svdpv']['display_order']; 
								}
								$tmp_result[$tmp_entry['value']] = __($tmp_entry['language_alias'], true);
								$current_element ++;
							}
							asort($tmp_result);
							$dropdown_result = array_merge($dropdown_result, $tmp_result);
						}
					}else if($sfs['type'] == "checkbox"){
						//provide yes/no as default for checkboxes
						$dropdown_result = array(0 => __("no", true), 1 => __("yes", true));
					}
					
					if($options['type'] == "search" && ($sfs['type'] == "checkbox" || $sfs['type'] == "radio")){
						//checkbox and radio buttons in search mode are dropdowns 
						$dropdown_result = array_merge(array("" => ""), $dropdown_result);
					}
					
					$current['settings']['options'] = $dropdown_result;
				}
				
				if(!isset($stack[$sfs['display_column']][$sfs['display_order']])){
					$stack[$sfs['display_column']][$sfs['display_order']] = array();
				}
				$stack[$sfs['display_column']][$sfs['display_order']][] = $current;
			}
			
		}
		return $stack;
	}
	

	function generate_content_wrapper( $atim_content=array(), $options=array() ) {
		
		$return_string = '';
			
			// display table...
			$return_string .= '
				<table class="structure" cellspacing="0">
				<tbody>
					<tr>
			';
				
				// each column in table 
				$count_columns = 0;
				foreach ( $atim_content as $content ) {
					
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
			
			$return_string .= $this->generate_links_list( NULL, $options, 'bottom' );
			
		return $return_string;
		
	}


	
	// FUNCTION to build one OR more links...
	// MODEL data, LINKS array, LANG array, ADD array list to INCLUDE, SKIP list to NOT include, and ID value to attach, if any 
	// function generate_links_list( $links=array(), $lang=array(), $add=array(), $skip=array(), $id=NULL, $title='', $in_table=0 ) {
	function generate_links_list( $data=array(), $options=array(), $state='index' ) {
		$aro_alias = 'Group::'.$this->Session->read('Auth.User.group_id');
		
		$return_string = '';
		
		$return_urls = array();
		$return_links = array();
		
		$links = isset($options['links'][$state]) ? $options['links'][$state] : array();
		$links = !is_array($links) ? array('detail'=>$links) : $links;
		
		// parse through $LINKS array passed to function, make link for each 
		foreach ( $links as $link_name => $link_array ) {
				
			if ( !is_array($link_array) ) {
				$link_array = array( $link_name => $link_array );
			}
			
			$link_results = array();

			$icon = "";
			if(isset($link_array['link'])){
				if(isset($link_array['icon'])){
					$icon = $link_array['icon'];
				}
				$link_array = array( $link_name => $link_array['link'] );
			}
			$prev_icon = $icon;
			foreach ( $link_array as $link_label => &$link_location ) {
				$icon = $prev_icon;
				if(is_array($link_location)){
					if(isset($link_location['icon'])){
						//set requested custom icon
						$icon = $link_location['icon'];
					}
					$link_location = &$link_location['link'];
				}
					
				// if ( !Configure::read("debug") ) {
					// check on EDIT only
					
					$parts = Router::parse($link_location);
					$aco_alias = 'controllers/'.($parts['plugin'] ? Inflector::camelize($parts['plugin']).'/' : '');
					$aco_alias .= ($parts['controller'] ? Inflector::camelize($parts['controller']).'/' : '');
					$aco_alias .= ($parts['action'] ? $parts['action'] : '');
					
					if ( !isset($Acl) ) {
						$Acl = new SessionAclComponent();
						$Acl->initialize($this);
					}
				// }	
				
				// if ACO/ARO permissions check succeeds, create link
				// if ( Configure::read("debug") || strpos($aco_alias,'controllers/Users')!==false || strpos($aco_alias,'controllers/Pages')!==false || $Acl->check($aro_alias, $aco_alias) ) {
				if ( strpos($aco_alias,'controllers/Users')!==false 
				|| strpos($aco_alias,'controllers/Pages')!==false
				|| $aco_alias == "controllers/Menus/index"
				|| $Acl->check($aro_alias, $aco_alias) ) {
					
					$display_class_name = $this->generate_link_class($link_name, $link_location);
					$htmlAttributes['title'] = strip_tags( html_entity_decode(__($link_name, true), ENT_QUOTES, "UTF-8") ); 
					
					if(strlen($icon) > 0){
						$htmlAttributes['class'] = 'form '.$icon;
					}else{
						$htmlAttributes['class'] = 'form '.$display_class_name;
					}
					
					// set Javascript confirmation msg...
					$confirmation_msg = NULL;
					
					// replace %%MODEL.FIELDNAME%% 
					$link_location = $this->str_replace_link( $link_location, $data );
					
					$return_urls[]		= $this->Html->url( $link_location );
					
					// check AJAX variable, and set link to be AJAX link if exists
						if ( isset($options['links']['ajax'][$state][$link_name]) ) {
							
							// if ajax SETTING is an ARRAY, set helper's OPTIONS based on keys=>values
							if ( is_array($options['links']['ajax'][$state][$link_name]) ) {
								foreach ( $options['links']['ajax'][$state][$link_name] as $html_attribute_key=>$html_attribute_value ) {
									$htmlAttributes[$html_attribute_key] = $html_attribute_value;
								}
							} 
							
							// otherwise if STRING set UPDATE option only
							else {
								$htmlAttributes['json']['update'] = $options['links']['ajax'][$state][$link_name];
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
							( $state=='index' ? '&nbsp;' : __($link_label, true) ), // title
							$link_location, // url
							$htmlAttributes, // options
							$confirmation_msg // confirmation message
						);
					
				}
				
				// if ACO/ARO permission check fails, display NOt ALLOWED type link
				else {
					$return_urls[]		= $this->Html->url( '/menus' );
					$link_results[$link_label]	= '<a class="not_allowed">'.__($link_label, true).'</a>';
				} // end CHECKMENUPERMISSIONS
				
			}
			
			if ( count($link_results)==1 && isset($link_results[$link_name]) ) {
				$return_links[$link_name] = $link_results[$link_name];
			}
			
			else {
				
				$links_append = '
							<a class="form popup" href="javascript:return false;">'.__($link_name, TRUE).'</a>
							<!-- container DIV for JS functionality -->
							<div class="filter_menu'.( count($link_results)>7 ? ' scroll' : '' ).'">
								
								<div>
									<ul>
				';
				
				$count = 0;
				$tmpSize = sizeof($link_results) - 1;
				foreach ( $link_results as $link_label=>$link_location ) {
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
				
				if ( count($link_results)>7 ) {
					$links_append .= '
								<span class="up"></span>
								<span class="down"></span>
								
								<a href="#" class="up">&uarr;</a>
								<a href="#" class="down">&darr;</a>
					
					';
				}
				
				$links_append .= '
								<span class="arrow"></span>
							</div>
				';
				
				$return_links[$link_name] = $links_append;
				
			}
			
		} // end FOREACH 
		
		// ADD title to links bar and wrap in H5
		if ( $state=='bottom' ) { 
			
			$return_string = '
				<div class="actions">
			';
			
			// display SEARCH RESULTS, if any
			if ( isset($_SESSION) && isset($_SESSION['Auth']) && isset($_SESSION['Auth']['User']) && count($_SESSION['Auth']['User']) ) {
				if ( isset($_SESSION['ctrapp_core']['search']) && is_array($_SESSION['ctrapp_core']['search']) ) {
					$return_string .= '
							<div class="search-result-div"><a class="search_results" href="'.$this->Html->url($_SESSION['ctrapp_core']['search']['url']).'">
								'.$_SESSION['ctrapp_core']['search']['results'].'
							</a></div>
					';
				}
			} else {
				unset($_SESSION['ctrapp_core']['search']);
			}
			
			if ( count($return_links) ) {
				$return_string .= '
					<ul><li><ul class="filter">
						<li><div class="bottom_button">'.implode('</div></li><li><div class="bottom_button">',$return_links).'</div></li>
					</ul></li></ul>
				';
			}
			
			$return_string .= '
				</div>
			';
			
			
			
		} else if ( $state=='top' ) {
		
			$return_string = $return_urls[0];
			
		} else if ( $state=='index' ) {
			
			if ( count($return_links) ) {
				$return_string = implode(' ',$return_links);
			}
			
		}
		
		// return
		return $return_string;
		
	} // end FUNCTION generate_links_list()


	function generate_link_class( $link_name=NULL, $link_location=NULL ) {
			
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
					if ( !$link_name && $link_location ) {
						foreach ( $display_class_array as $key=>$val ) {
							if ( strpos($val,'%')!==false || strpos($val,'@')!==false || is_numeric($val) ) {
								unset($display_class_array[$key]);
							} else {
								$display_class_array[$key] = strtolower(trim($val));
							}
						}
					
						$display_class_array = array_reverse($display_class_array);
					}
					
					if ( isset($display_class_array[1]) ) { $display_class_array[1] = strtolower($display_class_array[1]); }
					else { $display_class_array[1] = ''; }
					
					if ( isset($display_class_array[2]) ) { $display_class_array[2] = strtolower($display_class_array[2]); }
					else { $display_class_array[2] = ''; }
				
				// folder (open)
				if ( $display_class_array[0]=='index' )			$display_class_name = 'list';
				if ( $display_class_array[0]=='table' )			$display_class_name = 'list';
				if ( $display_class_array[0]=='tables' )			$display_class_name = 'list';
				if ( $display_class_array[0]=='list' )				$display_class_name = 'list';
				if ( $display_class_array[0]=='lists' )			$display_class_name = 'list';
				if ( $display_class_array[0]=='listall' )			$display_class_name = 'list';
				if ( $display_class_array[0]=='editgrid' )		$display_class_name = 'list';
				if ( $display_class_array[0]=='datagrid' )		$display_class_name = 'list';
				if ( $display_class_array[0]=='grid' )				$display_class_name = 'list';
				if ( $display_class_array[0]=='grids' )			$display_class_name = 'list';
				
				// preview
				if ( $display_class_array[0]=='search' )			$display_class_name = 'search';
				if ( $display_class_array[0]=='look' )				$display_class_name = 'search';
				
				// add
				if ( $display_class_array[0]=='add' )				$display_class_name = 'add';
				if ( $display_class_array[0]=='new' )				$display_class_name = 'add';
				if ( $display_class_array[0]=='create' )			$display_class_name = 'add';
				
				// edit
				if ( $display_class_array[0]=='edit' )				$display_class_name = 'edit';
				if ( $display_class_array[0]=='edits' )			$display_class_name = 'edit';
				if ( $display_class_array[0]=='change' )			$display_class_name = 'edit';
				if ( $display_class_array[0]=='changes' )			$display_class_name = 'edit';
				if ( $display_class_array[0]=='update' )			$display_class_name = 'edit';
				if ( $display_class_array[0]=='updates' )			$display_class_name = 'edit';
				
				// document
				if ( $display_class_array[0]=='detail' )			$display_class_name = 'detail';
				if ( $display_class_array[0]=='details' )			$display_class_name = 'detail';
				if ( $display_class_array[0]=='profile' )			$display_class_name = 'detail';
				if ( $display_class_array[0]=='profiles' )		$display_class_name = 'detail';
				if ( $display_class_array[0]=='view' )				$display_class_name = 'detail';
				if ( $display_class_array[0]=='views' )			$display_class_name = 'detail';
				if ( $display_class_array[0]=='see' )				$display_class_name = 'detail';
				
				// table
				if ( $display_class_array[0]=='grid' )				$display_class_name = 'grid';
				if ( $display_class_array[0]=='datagrid' )		$display_class_name = 'grid';
				if ( $display_class_array[0]=='editgrid' )		$display_class_name = 'grid';
				if ( $display_class_array[0]=='addgrid' )			$display_class_name = 'grid';
				
				// close
				if ( $display_class_array[0]=='delete' )			$display_class_name = 'delete';
				if ( $display_class_array[0]=='remove' )			$display_class_name = 'delete';
				
				// control (rewind)
				if ( $display_class_array[0]=='cancel' )			$display_class_name = 'cancel';
				if ( $display_class_array[0]=='back' )				$display_class_name = 'cancel';
				if ( $display_class_array[0]=='return' )			$display_class_name = 'cancel';
				
				// documents (x3)
				if ( $display_class_array[0]=='duplicate' )		$display_class_name = 'duplicate';
				if ( $display_class_array[0]=='duplicates' )		$display_class_name = 'duplicate';
				if ( $display_class_array[0]=='copy' )				$display_class_name = 'duplicate';
				if ( $display_class_array[0]=='copies' )			$display_class_name = 'duplicate';
				if ( $display_class_array[0]=='return' )			$display_class_name = 'duplicate';
				
				// refresh
				if ( $display_class_array[0]=='undo' )				$display_class_name = 'redo';
				if ( $display_class_array[0]=='redo' )				$display_class_name = 'redo';
				if ( $display_class_array[0]=='switch' )			$display_class_name = 'redo';
				if ( $display_class_array[0]=='switches' )		$display_class_name = 'redo';
				
				// shopping cart
				if ( $display_class_array[0]=='order' )			$display_class_name = 'order';
				if ( $display_class_array[0]=='orders' )			$display_class_name = 'order';
				if ( $display_class_array[0]=='shop' )				$display_class_name = 'order';
				if ( $display_class_array[0]=='shops' )			$display_class_name = 'order';
				if ( $display_class_array[0]=='ship' )				$display_class_name = 'order';
				if ( $display_class_array[0]=='buy' )				$display_class_name = 'order';
				if ( $display_class_array[0]=='cart' )				$display_class_name = 'order';
				if ( $display_class_array[0]=='carts' )			$display_class_name = 'order';
				
				// flag (green)
				if ( $display_class_array[0]=='favourite' )		$display_class_name = 'thumbsup';
				if ( $display_class_array[0]=='favourites' )		$display_class_name = 'thumbsup';
				if ( $display_class_array[0]=='mark' )				$display_class_name = 'thumbsup';
				if ( $display_class_array[0]=='label' )			$display_class_name = 'thumbsup';
				if ( $display_class_array[0]=='labels' )			$display_class_name = 'thumbsup';
				if ( $display_class_array[0]=='thumbsup' )		$display_class_name = 'thumbsup';
				if ( $display_class_array[0]=='thumbup' )			$display_class_name = 'thumbsup';
				if ( $display_class_array[0]=='approve' )			$display_class_name = 'thumbsup';
				
				// flag (black)
				if ( $display_class_array[0]=='unfavourite' )	$display_class_name = 'thumbsdown';
				if ( $display_class_array[0]=='unmark' )			$display_class_name = 'thumbsdown';
				if ( $display_class_array[0]=='unlabel' )			$display_class_name = 'thumbsdown';
				if ( $display_class_array[0]=='thumbsdown' )		$display_class_name = 'thumbsdown';
				if ( $display_class_array[0]=='thumbdown' )		$display_class_name = 'thumbsdown';
				if ( $display_class_array[0]=='unapprove' )		$display_class_name = 'thumbsdown';
				if ( $display_class_array[0]=='disapprove' )		$display_class_name = 'thumbsdown';
				
				// data relationship
				if ( $display_class_array[0]=='tree' )				$display_class_name = 'reveal';
				if ( $display_class_array[0]=='trees' )			$display_class_name = 'reveal';
				if ( $display_class_array[0]=='reveal' )			$display_class_name = 'reveal';
				if ( $display_class_array[0]=='menu' )				$display_class_name = 'reveal';
				if ( $display_class_array[0]=='menus' )			$display_class_name = 'reveal';
				
				// paste
				if ( $display_class_array[0]=='summary' )			$display_class_name = 'summary';
				if ( $display_class_array[0]=='summarize' )		$display_class_name = 'summary';
				if ( $display_class_array[0]=='brief' )			$display_class_name = 'summary';
				if ( $display_class_array[0]=='briefs' )			$display_class_name = 'summary';
				if ( $display_class_array[0]=='abbrev' )			$display_class_name = 'summary';
				
				// tag
				if ( $display_class_array[0]=='filter' )			$display_class_name = 'filter';
				if ( $display_class_array[0]=='filters' )			$display_class_name = 'filter';
				if ( $display_class_array[0]=='restrict' )		$display_class_name = 'filter';
				
				// group
				if ( $display_class_array[0]=='user' )				$display_class_name = 'users';
				if ( $display_class_array[0]=='users' )			$display_class_name = 'users';
				if ( $display_class_array[0]=='group' )			$display_class_name = 'users';
				if ( $display_class_array[0]=='groups' )			$display_class_name = 'users';
				
				// newspaper
				if ( $display_class_array[0]=='news' )				$display_class_name = 'news';
				if ( $display_class_array[0]=='announcement' )	$display_class_name = 'news';
				if ( $display_class_array[0]=='announcements' )	$display_class_name = 'news';
				if ( $display_class_array[0]=='message' )			$display_class_name = 'news';
				if ( $display_class_array[0]=='messages' )		$display_class_name = 'news';
				
				// the following criteria are looking for the plugins
				// they populate the right hand toolbar for the app
				// specific names are needed if you want specific icons - julian / wil - Aug.12'09
				if ( $display_class_array[0]=='plugin' ) {
					if ( $display_class_array[1]=='menus' )													$display_class_name = 'plugin home';
					if ( $display_class_array[1]=='menus' && $display_class_array[2]=='tools' )	$display_class_name = 'plugin tools';
					if ( $display_class_array[1]=='users' && $display_class_array[2]=='logout' )	$display_class_name = 'plugin logout';
					
					if ( $display_class_array[1]=='customize' )												$display_class_name = 'plugin customize';
					
					if ( $display_class_array[1]=='clinicalannotation' )									$display_class_name = 'plugin clinicalannotation';
					if ( $display_class_array[1]=='inventorymanagement' )									$display_class_name = 'plugin inventorymanagement';
					if ( $display_class_array[1]=='datamart' )												$display_class_name = 'plugin datamart';
				
					if ( $display_class_array[1]=='administrate' )											$display_class_name = 'plugin administrate';
					if ( $display_class_array[1]=='drug' )														$display_class_name = 'plugin drug';
					if ( $display_class_array[1]=='rtbform' )													$display_class_name = 'plugin rtbform';
					if ( $display_class_array[1]=='order' )													$display_class_name = 'plugin order';
					if ( $display_class_array[1]=='protocol' )												$display_class_name = 'plugin protocol';
					if ( $display_class_array[1]=='material' )												$display_class_name = 'plugin material';
					if ( $display_class_array[1]=='sop' )														$display_class_name = 'plugin sop';
					if ( $display_class_array[1]=='storagelayout' )											$display_class_name = 'plugin storagelayout';
					if ( $display_class_array[1]=='study' )													$display_class_name = 'plugin study';
					if ( $display_class_array[1]=='pricing' )													$display_class_name = 'plugin pricing';
					if ( $display_class_array[1]=='provider' )													$display_class_name = 'plugin provider';
					if ( $display_class_array[1]=='underdevelopment')	$display_class_name = 'plugin underdev';
					$display_class_name = $display_class_name ?												$display_class_name : 'plugin default';
				}
				
				// document (blank)
				$display_class_name = $display_class_name ?		$display_class_name : 'default';
				
				// if set to DEFAULT but URL has been provided, try again using URL instead!
				if ( $display_class_name=='default' && $link_name && $link_location ) {
					$display_class_name = $this->generate_link_class( NULL, $link_location );
				}

		// return
		return $display_class_name;
		
	}

	
	// FUNCTION to replace %%MODEL.FIELDNAME%% in link with MODEL.FIELDNAME value 
	function str_replace_link( $link='', $data=array() ) {
		
		if ( is_array($data) ) {
			foreach ( $data as $model=>$fields ) {
				if ( is_array($fields) ) {
					foreach ( $fields as $field=>$value ) {
						
						// avoid ONETOMANY or HASANDBELONGSOTMANY relationahips 
						if ( !is_array($value) ) {
							
							// find text in LINK href in format of %%MODEL.FIELD%% and replace with that MODEL.FIELD value...
							$link = str_replace( '%%'.$model.'.'.$field.'%%', $value, $link );
							$link = str_replace( '@@'.$model.'.'.$field.'@@', $value, $link );
		
						} // end !IS_ARRAY 
						
					}
				}
			} // end FOREACH
		}
		
		// return
		return $link;
		
	} // end FUNCTION str_replace_link()
	
	
/********************************************************************************************************************************************************************************/
	
	
	function &array_merge_recursive_distinct( &$array1, &$array2 = null) {
	
		$merged = $array1;
		
		if (is_array($array2)) {
		
			foreach ($array2 as $key => $val) {
			
			if (is_array($array2[$key])) {
				if ( !isset($merged[$key]) ) $merged[$key] = array();
				$merged[$key] = is_array($merged[$key]) ? $this->array_merge_recursive_distinct($merged[$key], $array2[$key]) : $array2[$key];
			} else {
				$merged[$key] = $val;
			} // end IF/ELSE
			
			} // end FOREACH
		
		} // end IF array
		
		return $merged;
	
	}
	
	/**
	 * @deprecated
	 */
	private function get_date_fields($model_prefix, $model_suffix, $structure_field, $html_element_array, $model_prefix_css, $model_suffix_css, $search_suffix, $datetime_array){
		$tmp_datetime_array = array('year' => null, 'month' => null, 'day' => null, 'hour' => "", 'min' => null, 'meridian' => null);
		if(empty($datetime_array)){
			$value = $this->value($model_prefix.$structure_field['model'].$model_suffix.$structure_field['field'].$search_suffix);
			if(is_array($value)){
				$datetime_array = $value;
			}else if(strlen($value) > 0){
				$datetime_array = $this->datetime_to_array($value);
			}
		}
		$datetime_array = array_merge($tmp_datetime_array, $datetime_array);
		$date = "";
		$my_model_prefix = strlen($model_prefix) > 0 ? str_replace(".", "][", $model_prefix) : "";
		$date_name_prefix = "data[".$my_model_prefix.$structure_field['model']."][".$structure_field['field'].$search_suffix."]";
		unset($html_element_array['id']);
		unset($html_element_array['name']);
		if(!isset($html_element_array['empty'])){
			$html_element_array['empty'] = null;
		}
		for($i = 0; $i < 3; ++ $i){
			$tmp_current = substr(date_format, $i, 1);
			if($tmp_current == "Y"){
				if(datetime_input_type == "dropdown"){
					$date .= 
						$this->Form->year($model_prefix.$structure_field['model'].$model_suffix.$structure_field['field'].$search_suffix, 
						1900, 
						2100, 
						$datetime_array['year'], 
						am(array('name'=>$date_name_prefix."[year]", 'id' => $model_prefix_css.$structure_field['model'].$model_suffix_css.$structure_field['field'].$search_suffix), $html_element_array), 
						$html_element_array['empty']);
				}else{
					$date .= 
						'<span class="tooltip">'
						.$this->Form->text("", 
							array(
								'id' => $model_prefix_css.$structure_field['model'].$model_suffix_css.$structure_field['field'].$search_suffix, 
								'name' => $date_name_prefix."[year]",
								'size' => 4, 
								'tabindex' => $html_element_array['tabindex'], 
								'maxlength' => 4,
								'value' => $datetime_array['year']))
						."<div>".__('year', true)."</div></span> ";
				}
			}else if($tmp_current == "M"){
				if(datetime_input_type == "dropdown"){
					$date .= 
						$this->Form->month($model_prefix.$structure_field['model'].$model_suffix.$structure_field['field'].$search_suffix, 
						$datetime_array['month'], am(array('name'=>$date_name_prefix."[month]", 'id' => $model_prefix_css.$structure_field['model'].$model_suffix_css.$structure_field['field'].$search_suffix.'-mm'), $html_element_array), 
						$html_element_array['empty']);
				}else{
					$date .= 
						'<span class="tooltip">'
						.$this->Form->text("", 
							array(
								'id' => $model_prefix_css.$structure_field['model'].$model_suffix_css.$structure_field['field'].$search_suffix."-mm", 
								'name' => $date_name_prefix."[month]",
								'size' => 2, 
								'tabindex' => $html_element_array['tabindex'], 
								'maxlength' => 2,
								'value' => $datetime_array['month']))
						."<div>".__('month', true)."</div></span> ";
				}
			}else if($tmp_current == "D"){
				if(datetime_input_type == "dropdown"){
					$date .= 
						$this->Form->day($model_prefix.$structure_field['model'].$model_suffix.$structure_field['field'].$search_suffix, 
						$datetime_array['day'], am(array('name'=>$date_name_prefix."[day]", 'id' => $model_prefix_css.$structure_field['model'].$model_suffix_css.$structure_field['field'].$search_suffix.'-dd'), $html_element_array), 
						$html_element_array['empty']);
				}else{
					$date .= 
						'<span class="tooltip">'
						.$this->Form->text("", 
							array(
								'id' => $model_prefix_css.$structure_field['model'].$model_suffix_css.$structure_field['field'].$search_suffix."-dd",
								'name' => $date_name_prefix."[day]",
								'size' => 2, 
								'tabindex' => $html_element_array['tabindex'], 
								'maxlength' => 2,
								'value' => $datetime_array['day']))
						."<div>".__('day', true)."</div></span> ";
				}
			}else{
				$date .= "UNKNOWN date_format ".date_format;
			}
		}
		
		$date .= '<span style="position: relative;">
				<input type="button" id="'.$model_prefix_css.$structure_field['model'].$model_suffix_css.$structure_field['field'].$search_suffix.'_button" class="datepicker" value=""/>
				<img src="'.$this->Html->Url('/img/cal.gif').'" alt="cal" class="fake_datepicker"/>
			</span>';
		
		if ( $structure_field['type']=='datetime' ) {
			if(time_format == 24 && isset($datetime_array['meridian'])){
				$datetime_array['hour'] = $datetime_array['hour'] % 12;
				if($datetime_array['meridian'] == "pm"){
					$datetime_array['hour'] += 12;
				}
			}
			if(datetime_input_type == "dropdown"){
				$date .= $this->Form->hour($model_prefix.$structure_field['model'].$model_suffix.$structure_field['field'].$search_suffix, time_format == 24, $datetime_array['hour'], am(array('name'=>$date_name_prefix."[hour]", 'id' => $model_prefix_css.$structure_field['model'].$model_suffix_css.$structure_field['field'].$search_suffix.'Hour'), $html_element_array));
				$date .= $this->Form->minute($model_prefix.$structure_field['model'].$model_suffix.$structure_field['field'].$search_suffix, $datetime_array['min'], am(array('name'=>$date_name_prefix."[min]", 'id' => $model_prefix_css.$structure_field['model'].$model_suffix_css.$structure_field['field'].$search_suffix.'Min'), $html_element_array));
			}else{
				$date .= 
					'<span class="tooltip">'
					.$this->Form->text("", 
						array(
							'id' => $model_prefix_css.$structure_field['model'].$model_suffix_css.$structure_field['field'].$search_suffix."Hour",
							'name' => $date_name_prefix."[hour]", 
							'size' => 2, 
							'tabindex' => $html_element_array['tabindex'], 
							'maxlength' => 2,
							'value' => $datetime_array['hour']))
					."<div>".__('hour', true)."</div></span> ";
				$date .= 
					'<span class="tooltip">'
					.$this->Form->text("", 
						array(
							'id' => $model_prefix_css.$structure_field['model'].$model_suffix_css.$structure_field['field'].$search_suffix."Min",
							'name' => $date_name_prefix."[min]",
							'size' => 2, 
							'tabindex' => $html_element_array['tabindex'], 
							'maxlength' => 2,
							'value' => $datetime_array['min']))
					."<div>".__('minutes', true)."</div></span> ";
			}

			if(time_format == 12){
				$date .= $this->Form->meridian($model_prefix.$structure_field['model'].$model_suffix.$structure_field['field'].$search_suffix, $datetime_array['meridian'], am(array('name'=>$date_name_prefix."[meridian]", 'id' => $model_prefix_css.$structure_field['model'].$model_suffix_css.$structure_field['field'].$search_suffix.'Meridian'), $html_element_array));
			}
		}
		
		return $date;
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
		}else if(strlen($date) > 0){
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
					$result .= $this->Form->text($name.".year", array_merge($attributes, array('value' => $year)));
				}else if($part == "M"){
					$result .= $this->Form->text($name.".month", array_merge($attributes, array('value' => $month)));
				}else{
					$result .= $this->Form->text($name.".day", array_merge($attributes, array('value' => $day)));
				}
			}
		}
		$result .= '<span style="position: relative;">
			<input type="button" class="datepicker" value=""/>
			<img src="'.$this->Html->Url('/img/cal.gif').'" alt="cal" class="fake_datepicker"/>
		</span>';
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
		$hour = $minutes = $meridan = null;
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
					$median = 'pm';
					if($hour > 12){
						$hour %= 12;
					}
				}else{
					$median = 'am';
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
			$result .= $this->Form->text($name.".hour", array_merge($attributes, array('value' => $hour)));
			$result .= $this->Form->text($name.".min", array_merge($attributes, array('value' => $minutes)));
		}
		if(time_format == 12){
			$result .= $this->Form->meridian($name, array_merge($attributes, array('value' => $meridian)));
		}
		return $result;
	}

	/*
	 * Converts a string like yyyy-MM-dd hh:mm:ss to a date array
	 */
	public static function datetime_to_array($datetime, $format_24 = false){
		$result = array();
		if(strlen($datetime) != 0){
			$date = explode('-', substr($datetime, 0, 10));
			$result['year']		= $date[0];
			$result['month']	= $date[1];
			$result['day']		= $date[2];
			if(strlen($datetime) > 10){
				$time = explode(':', substr($datetime, 11));
				$result['min'] = $time[1];	
				if($format_24){
					$result['hour']	= $time[0];
				}else{
					$result['hour']			= $time[0] > 12 ? $time[0] - 12 : $time[0] + !($time[0] * 1) * 12;	
					$result['meridian']		= $time[0] > 12 ? 'pm' : 'am';
				}
			}
		}
		return $result;
	}
	
	public static function format_number($number){
		return decimal_separator == "," ? str_replace(".", ",", $number) : $number;
	}
	
	private function getTool($append_field_tool){
		$result = "";
		// multiple INPUT entries, using uploaded CSV file
		//TODO: reenable this
		if($append_field_tool == 'csv'){
//				if($options['type']=='search'){
//					// replace NAME of input with ARRAY format name
//					// $display_value = preg_replace('/name\=\"data\[([A-Za-z0-9]+)\]\[([A-Za-z0-9]+)\]\"/i','name="data[$1][$2][]"',$display_value);
//					$display_value = str_replace(']"','][]"',$display_value);
//
//					// wrap FIELD in DIV/P and add JS links to clone/remove P tags
//					$display_value = '
//									<div id="'.strtolower($field['StructureField']['model'].'_'.$field['StructureField']['field']).'_with_file_upload">
//										'.$display_value.'
//										<input class="file" type="file" name="data['.$field['StructureField']['model'].']['.$field['StructureField']['field'].'_with_file_upload]" />
//									</div>
//								';
//
//				}
		}else{
			$append_field_tool_id = '';
			$append_field_tool_id = str_replace( '.', ' ', $append_field_tool );
			$append_field_tool_id = trim($append_field_tool_id);
			$append_field_tool_id = str_replace( ' ', '_', $append_field_tool_id );

			$result = '<a href="'.$this->Html->Url( $append_field_tool ).'" class="tool_popup"></a>';
		}
		return $result;	
	}
}
	
?>