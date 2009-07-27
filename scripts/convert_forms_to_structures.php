<?php
	set_time_limit(100000000000);
	
	$connection = @mysql_connect("localhost", "root", "1qaz1qaz") or die("MySQL connection could not be established");
	
	@mysql_select_db("atim") or die("ATiM database could not be found");
	
	$query = "SELECT `id`, `alias`, `language_title`, `language_help`, `flag_add_columns`, `flag_edit_columns`, `flag_search_columns`, `flag_detail_columns` FROM `forms`;";

	$result = @mysql_query($query) or die ("ATiM forms table could not be queried");
	
	for( $i = 1; $i <= mysql_num_rows($result); $i++ ){
		$id = mysql_result($result, $i-1, 'id');
		$alias = mysql_result($result, $i-1, 'alias');
		$title = mysql_result($result, $i-1, 'language_title');
		$help = mysql_result($result, $i-1, 'language_help');
		$add = mysql_result($result, $i-1, 'flag_add_columns');
		$edit = mysql_result($result, $i-1, 'flag_edit_columns');
		$search = mysql_result($result, $i-1, 'flag_search_columns');
		$detail = mysql_result($result, $i-1, 'flag_detail_columns');
		
		$query = "INSERT INTO `structures` (`id`, `old_id`, `alias`, `language_title`, `language_help`, `flag_add_columns`, `flag_edit_columns`, `flag_search_columns`, `flag_detail_columns` ) VALUES
					($i, '$id', '$alias', '$title', '$help', $add, $edit, $search, $detail);";
		mysql_query($query);
	}
	
	$query = "SELECT `id`, `model`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `language_help` FROM `form_fields`;";
	
	$result = @mysql_query($query) or die ("ATiM form_fields table could not be found");
	
	for( $j = 1; $j <= mysql_num_rows($result); $j++ ){
		$id = mysql_result($result, $j-1, 'id');
		$model = mysql_result($result, $j-1, 'model');
		$field = mysql_result($result, $j-1, 'field');
		$label = mysql_result($result, $j-1, 'language_label');
		$tag = mysql_result($result, $j-1, 'language_tag');
		$type = mysql_result($result, $j-1, 'type');
		$setting = mysql_result($result, $j-1, 'setting');
		$default = mysql_result($result, $j-1, 'default');
		$help = mysql_result($result, $j-1, 'language_help');
		
		$query = "INSERT INTO `structure_fields` ( `id`, `old_id`, `model`, `field`, `language_label`, `language_tag`, `type`, `setting`, `default`, `language_help` ) 
				VALUES ( $j, '$id', '$model', '$field', '$label', '$tag', '$type', '$setting', '$default', '$help' );";
		mysql_query($query);
	}
	
	
	$query = 	"SELECT s.id AS SID, s.old_id, ff.id, ff.form_id, ff.field_id, ff.display_column, ff.display_order, ff.language_heading, ff.flag_override_label, ff.language_label, ff.flag_override_tag, ff.language_tag, ff.flag_override_help, ff.language_help,
				ff.flag_override_type, ff.type, ff.flag_override_setting, ff.setting, ff.flag_override_default, ff.default, ff.flag_add, ff.flag_add_readonly, ff.flag_edit, ff.flag_edit_readonly, ff.flag_search, ff.flag_search_readonly, ff.flag_datagrid,
				ff.flag_datagrid_readonly, ff.flag_index, ff.flag_detail, f.old_id, f.id AS FID FROM `form_formats` ff, `structures` s, `structure_fields` f WHERE s.old_id = ff.form_id AND ff.field_id = f.old_id;";
	$result = @mysql_query($query) or die("ATiM form_formats table could not be found");
	
	for( $t = 1; $t <= mysql_num_rows($result); $t++ ){
		$id = mysql_result($result, $t-1, 'ff.id');
		$form_id = mysql_result($result, $t-1, 'ff.form_id');
		$field_id = mysql_result($result, $t-1, 'ff.field_id');
		$dcolumn = mysql_result($result, $t-1, 'ff.display_column');
		$dorder = mysql_result($result, $t-1, 'ff.display_order');
		$heading = mysql_result($result, $t-1, 'ff.language_heading');
		$olabel = mysql_result($result, $t-1, 'ff.flag_override_label');
		$label = mysql_result($result, $t-1, 'ff.language_label');
		$otag = mysql_result($result, $t-1, 'ff.flag_override_tag');
		$tag = mysql_result($result, $t-1, 'ff.language_tag');
		$ohelp = mysql_result($result, $t-1, 'ff.flag_override_help');
		$help = mysql_result($result, $t-1, 'ff.language_help');
		$otype = mysql_result($result, $t-1, 'ff.flag_override_type');
		$type = mysql_result($result, $t-1, 'ff.type');
		$osetting = mysql_result($result, $t-1, 'ff.flag_override_setting');
		$setting = mysql_result($result, $t-1, 'ff.setting');
		$odefault = mysql_result($result, $t-1, 'ff.flag_override_default');
		$default = mysql_result($result, $t-1, 'ff.default');
		$add = mysql_result($result, $t-1, 'ff.flag_add');
		$radd = mysql_result($result, $t-1, 'ff.flag_add_readonly');
		$edit = mysql_result($result, $t-1, 'ff.flag_edit');
		$redit = mysql_result($result, $t-1, 'ff.flag_edit_readonly');
		$search = mysql_result($result, $t-1, 'ff.flag_search');
		$rsearch = mysql_result($result, $t-1, 'ff.flag_search_readonly');
		$datagrid = mysql_result($result, $t-1, 'ff.flag_datagrid');
		$rdatagrid = mysql_result($result, $t-1, 'ff.flag_datagrid_readonly');
		$index = mysql_result($result, $t-1, 'ff.flag_index');
		$detail = mysql_result($result, $t-1, 'ff.flag_detail');
		$sid = mysql_result($result, $t-1, 'SID');
		$fid = mysql_result($result, $t-1, 'FID');
		
		$query = "INSERT INTO `structure_formats` ( `id`, `old_id`, `structure_id`, `structure_old_id`, `structure_field_id`, `structure_field_old_id`, `display_column`, `display_order`, `language_heading`, `flag_override_label`, `language_label`,
			`flag_override_tag`, `language_tag`, `flag_override_help`, `language_help`, `flag_override_type`, `type`, `flag_override_setting`, `setting`, `flag_override_default`, `default`, `flag_add`, `flag_add_readonly`, `flag_edit`, `flag_edit_readonly`,
			`flag_search`, `flag_search_readonly`, `flag_datagrid`, `flag_datagrid_readonly`, `flag_index`, `flag_detail`) VALUES
			( $t, '$id', $sid, '$form_id', $fid, '$field_id', $dcolumn, $dorder, '$heading', '$olabel', '$label', '$otag', '$tag', '$ohelp', '$help', '$otype', '$type', '$osetting', '$setting', '$odefault', '$default', '$add', '$radd', '$edit', '$redit', '$search', '$rsearch', '$datagrid', '$rdatagrid', '$index', '$detail');";
		mysql_query($query);
	}
	
	mysql_query("DROP TABLE `forms`;");
	mysql_query("DROP TABLE `form_formats`;");
	
?>