<?php
class FindCustomsShell extends AppShell{
	public function main(){
		
		$to_do = array(getcwd());
		
		if(!is_dir($to_do[0])){
			die("Invalid directory\n");
		}
		
		echo "*** Program start ***\n";
		echo "Parsing directory ",$to_do[0],"\n";
		while($to_do){
			$parent_dir = array_pop($to_do);
			$d = dir($parent_dir);
			while(false !== ($current = $d->read())){
				if($current == '.' || $current == '..'){
					continue;
				}
				$val = $parent_dir.'/'.$current;
				if(is_dir($val)){
					$to_do[] = $val;
				}
				
				$lower = strtolower($current); 
				if($lower == 'hooks' || $lower == 'customs'){
					echo $val,"\n";
				}
			}
		}
		echo "*** Program terminated ***\n";
	}
}